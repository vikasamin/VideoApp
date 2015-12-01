'*************************************************************
'** showSpringboardScreen()
'*************************************************************

Function showSpringboardScreen(item as object) As Boolean

	DbgPrint(2,"showSpringboardScreen()")

    port = CreateObject("roMessagePort")
    screen = CreateObject("roSpringboardScreen")    
    screen.SetMessagePort(port)
    screen.AllowUpdates(false)
    if item <> invalid and type(item) = "roAssociativeArray"
        screen.SetContent(item)
    endif

    screen.SetDescriptionStyle("generic") 
    screen.ClearButtons()
    screen.AddButton(1,"Play")
    screen.AddButton(2,"Go Back")
    screen.SetStaticRatingEnabled(false)
    screen.AllowUpdates(true)
    screen.Show()

    downKey=3
    selectKey=6
    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roSpringboardScreenEvent"
            if msg.isScreenClosed()
                DbgPrint(2,"screen closed")
                exit while                
            else if msg.isButtonPressed()
                    'print "Button pressed: "; msg.GetIndex(); " " msg.GetData()
                    if msg.GetIndex() = 1
                         displayVideo(item)
                    else if msg.GetIndex() = 2
                         return true
                    endif
            else
                print "Unknown event: "; msg.GetType(); " msg: "; msg.GetMessage()
            endif
        else 
            print "wrong type.... type=";msg.GetType(); " msg: "; msg.GetMessage()
        endif
    end while


    return true
End Function


'*************************************************************
'** Get Video data from the entry data 
'*************************************************************
Function getVideoClipData(args As Dynamic) As Object 

	DbgPrint(2,"getVideoClipData()")

    'bitrates  = [0]      ' 0 = no dots, adaptive bitrate
    'bitrates  = [348]    ' <500 Kbps = 1 dot
    'bitrates  = [664]    ' <800 Kbps = 2 dots
    'bitrates  = [996]    ' <1.1Mbps  = 3 dots
    'bitrates  = [2048]   ' >=1.1Mbps = 4 dots
    bitrates  = [0]    
    
'ToDo
'Create an array for URL
'Create an corresponding array of quality
'Create an array for streamFormat

    videoclip = CreateObject("roAssociativeArray")
    videoclip.StreamBitrates = bitrates
    videoclip.StreamUrls = args.contents[0].url
    videoclip.StreamQualities = ["SD"]
    videoclip.StreamFormat = args.contents[0].format
    videoclip.Title = args.title
    return videoclip

End Function


'*************************************************************
'** displayVideo()
'*************************************************************
Function displayVideo(args As Dynamic)

    DbgPrint(2,"displayVideo()")

    p = CreateObject("roMessagePort")
    video = CreateObject("roVideoScreen")
    video.setMessagePort(p)

    videoclip = getVideoClipData(args)
    
    video.SetContent(videoclip)
    video.show()

    lastSavedPos   = 0
    statusInterval = 10 'position must change by more than this number of seconds before saving

    while true
        msg = wait(0, video.GetMessagePort())
        if type(msg) = "roVideoScreenEvent"
            if msg.isScreenClosed() then 'ScreenClosed event
                DbgPrint(2,"Closing video screen")
                exit while
            else if msg.isPlaybackPosition() then
                nowpos = msg.GetIndex()
                if nowpos > 10000
                    
                end if
                if nowpos > 0
                    if abs(nowpos - lastSavedPos) > statusInterval
                        lastSavedPos = nowpos
                    end if
                end if
            else if msg.isRequestFailed()
                print "play failed: "; msg.GetMessage()
            else
                print "Unknown event: "; msg.GetType(); " msg: "; msg.GetMessage()
            endif
        end if
    end while
End Function

