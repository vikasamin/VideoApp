
'***************************************************
'** Set up the screen in advance before its shown
'** Do any pre-display setup work here
'**************************************************	
Function preShowIntroScreen(breadA=invalid, breadB=invalid) As Object

	DbgPrint(2,"preShowIntroScreen()")

    port=CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)
    return screen

End Function

'********************************************************************
'** selecting close exits the application
'********************************************************************
Function showIntroScreen(screen) As Integer

	DbgPrint(2,"showIntroScreen()")

	' borrow some pictures from the monitor setup program
    '	host = "http://rokudev.roku.com/rokudev/testpatterns/"

	Print "Start -->  showIntroScreen()"   

	screen.SetTitle("Introduction")
    	screen.AddHeaderText("I am Vikas Amin")
        screen.AddParagraph("Hi everyone my name is Vikas Amin, I consider my self a work in progress.")

    	'adUrl = host + "1280x720" + "/SMPTE_bars_setup_labels_lg.jpg"
	'print "adUrl=" + adUrl
	'screen.AddGraphic(adURL,"scale-to-fit")

	screen.AddButton(1,"Close")
	screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())

	print "got message"

        if type(msg) = "roParagraphScreenEvent"
            if msg.isScreenClosed()
                print "Screen closed"
                exit while                
            else if msg.isButtonPressed()
                print "Button pressed: "; msg.GetIndex(); " " msg.GetData()

                exit while
            else
                print "Unknown event: "; msg.GetType(); " msg: "; msg.GetMessage()
                exit while
            endif
        endif
    end while

End Function
