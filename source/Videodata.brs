'***************************************************
'** Set up the screen in advance before its shown
'** Do any pre-display setup work here
'***************************************************
Function VideoListScreen() 
    port=CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)
    return screen
End Function


'*************************************************************
'** GetPlaylistData
'** Check if data was already fetch from rest base webservice
'** If data exist in cache then get cache data 
'** We probably want to put a cache time to keep the data 
'*************************************************************
Function GetPlaylistData() As Object

	DbgPrint(2,"GetPlaylistData()")

	json = RegRead1("VideoAppHistory","json")  ' ToDo , Not good to hardcode put it in config file

    if(json=invalid)
 		return GetVideoDataFromWeb()
    else
       return GetVideoDataFromReg()
	endif

End Function


'*************************************************************
'** GetVideoData from the REST webservice 
'*************************************************************
Function GetVideoDataFromWeb () As Object

	DbgPrint(2,"GetVideoDataFromWeb()")

	response = getPlaylist()
	if response <> invalid
		playlist = CreateObject("roArray", 10, true)
			for each kind in response.entries
				entry = GetEntryData(kind)
			playlist.push(entry)
		end for
	    return playlist
	endif
           
End Function 

'*************************************************************
'** GetVideoData from the REST webservice 
'*************************************************************
Function GetVideoDataFromReg () As Object

	DbgPrint(2,"GetVideoDataFromReg()")

	jsonFromReg = RegRead1("VideoAppHistory","json")  ' ToDo , Not good to hardcode put it in config file

	json = ParseJSON(jsonFromReg)
	response = {
                 entries: json.entries
                 totalCount: json.totalCount
               }

	if response <> invalid
		playlist = CreateObject("roArray", 10, true)
			for each kind in response.entries
				entry = GetEntryData(kind)
			playlist.push(entry)
		end for
	    return playlist
	endif
           
End Function 


'***************************************************
'** Get Video Ureturn invalidRL
'***************************************************
function getVideoURL(fromConfig as Boolean) as Object 

	DbgPrint(2,"getVideoURL()")
    
    if fromConfig
        return "http://demo2697834.mockable.io/movies"  'We should not hardcode any urls, they have to be dynamic and also based on the Environmet
    endif
		return Invalid 

end function


'***************************************************
'** Get Video Data from server
'***************************************************
Function getPlaylist() as object
	DbgPrint(2,"getPlaylist()")

    request = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    request.SetMessagePort(port)
    videoURL = getVideoURL(true)
    request.SetUrl(videoURL)
    if (request.AsyncGetToString())
        while (true)
            msg = wait(0, port)
            if (type(msg) = "roUrlEvent")
                code = msg.GetResponseCode()
                if (code = 200)
                    playlist = CreateObject("roArray", 50, true)
                    json = ParseJSON(msg.GetString())
addJsonToReg(msg.GetString())                  
                        response = {
                            entries: json.entries
                            totalCount: json.totalCount
                        }
                    return response
                endif
            else if (event = invalid)
                request.AsyncCancel()
            endif
        end while
    endif

    return invalid
End Function


'***************************************************
'** Set last watch timestamp in the registry
'***************************************************
function addJsonToReg(json)

    'ToDo Check if the registery exist delete and then write
    RegWrite1("VideoAppHistory",json,"json")

end function


'***************************************************
'** Set last watch timestamp in the registry
'***************************************************
function addLastWatchedToHistory(contentItem)

	DbgPrint(2,"addLastWatchedToHistory()")

    historyListString = getHistoryFromReg()

	if type(historyListString)<> "roInvalid"
   		history = historyListString + ","
		RegDelete1("VideoAppHistory","History")
		history = history + tostr(contentItem)
    else
		history = tostr(contentItem)
	endif		

    RegWrite1("VideoAppHistory",history,"History")

end function


'***************************************************
'** Set last watch timestamp in the registry
'***************************************************
function getHistoryFromReg() as Object

	return RegRead1("VideoAppHistory","History")     ' ToDo , Not good to hardcode put it in config file
 
end function

'***************************************************
'** Set last watch timestamp in the registry
'***************************************************
function getHistoryAsList() as Object

	DbgPrint(2,"getHistoryAsList()")

	historyListString = RegRead1("VideoAppHistory","History")     ' ToDo , Not good to hardcode put it in config file
 
	if type(historyListString)<> "invalid"
   		'Convert the strig to list
        return historyListString.tokenize(",")
	endif

end function

'***************************************************
'** Set last watch timestamp in the registry
'***************************************************
function setLastWatched(contentItem)

    now = createObject("roDateTime").asSeconds().toStr()
    RegWrite(contentItem.id, now, "recent")

    return now.toInt()

end function

'***************************************************
'** Get the timestamp the  video was last watched
'***************************************************
function getLastWatched(contentItem)

    lastWatched = RegRead(contentItem.id, "recent")
    
    if lastWatched = invalid
        return invalid
    end if
    
    return lastWatched.toInt()

end function

'***************************************************
'** Mark a video watched in the registry
'***************************************************
function markAsFinished(contentItem)

    RegWrite(contentItem.id, "true", "watched")

end function

'***************************************************
'** Check the registry to see if a feed item has been watched
'***************************************************
function isFinished(contentItem) as Boolean

    read = RegRead(contentItem.id, "watched")

    return read = "true"

end function


'***************************************************
'**Save playback position
'***************************************************
Function savePlayBackPosition(contentItem, position)

    RegWrite(contentItem.id, position.toStr(), "position")

End Function

'***************************************************
'**Load playback position
'***************************************************
Function loadPlayBackPosition(contentItem) as Integer

    position = RegRead(contentItem.id, "position")
    
    if position = invalid then
        return 0
    end if

    return position.toInt()

End Function


'***r************************************************
'** Delete all Registry
'***************************************************
Function DeleteRegistry(section as String)

    print "Starting Delete Registry"
    Registry = CreateObject("roRegistry")
    i = 0
    'for each section in Registry.GetSectionList()
        RegistrySection = CreateObject("roRegistrySection", section)
        for each key in RegistrySection.GetKeyList()
            i = i+1
            print "Deleting " section + ":" key
            RegistrySection.Delete(key)
        end for
        RegistrySection.flush()
    'end for
    print i.toStr() " Registry Keys Deleted"

End Function
