
' *********************************************************
' **  Video App 
' **  Nov 21
' **  Vikas Amin
' **  Reuse Methods from Samples
' *********************************************************

'******************************************************
'** Perform any startup/initialization stuff prior to 
'** initially showing the screen.  
'******************************************************
Function preShowLandingScreen(breadA=invalid, breadB=invalid) As Object

	DbgPrint(2,"preShowLandingScreen()")

    port=CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
    if breadA<>invalid and breadB<>invalid then
        screen.SetBreadcrumbText(breadA, breadB)
    end if

    screen.SetListStyle("arced-landscape")
    return screen

End Function


'******************************************************
'** Display the poster screen and wait for events from 
'** the screen. The screen will show retreiving while
'** we fetch and parse the feeds for the show posters
'******************************************************
Function showLandingScreen(screen As Object) As Integer

	DbgPrint(2,"showLandingScreen()")

    categoryList = getCategoryList()
    screen.SetListNames(categoryList)
	screen.SetContentList(getShowsForCategoryAllVideo())
    screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roPosterScreenEvent" then
            print "showPosterScreen | msg = "; msg.GetMessage() " | index = "; msg.GetIndex()
            if msg.isListFocused() then
                'get the list of shows for the currently selected item

				if msg.GetIndex()=0
					screen.SetContentList(getShowsForCategoryAllVideo())
				elseif msg.GetIndex()=1
					screen.SetContentList(getShowsForCategoryHistory())
				elseif msg.GetIndex()=2
'Set Settings content		
				elseif msg.GetIndex()=3
'Set Help Content						
				endif

                print "list focused | current category = "; msg.GetIndex()
            else if msg.isListItemFocused() then
                print"list item focused | current show = "; msg.GetIndex()

            else if msg.isListItemSelected() then
                print "list item selected | current show = "; msg.GetIndex() 
                'if you had a list of shows, the index of the current item 
                'is probably the right show, so you'd do something like this
                'm.curShow = displayShowDetailScreen(showList[msg.GetIndex()])

 				playlist = GetPlaylistData()
				showSpringboardScreen(playlist[msg.GetIndex()])

addLastWatchedToHistory(msg.GetIndex())
                
            else if msg.isScreenClosed() then
                return -1
            end if
        end If
    end while


End Function

Function displayBase64()
    ba = CreateObject("roByteArray")
    str = "Aladdin:open sesame"
    ba.FromAsciiString(str)
    result = ba.ToBase64String() 
    print result

    ba2 = CreateObject("roByteArray")
    ba2.FromBase64String(result)
    result2 = ba2.ToAsciiString()
    print result2
End Function

'**********************************************************
'** When a poster on the home screen is selected, we call
'** this function passing an roAssociativeArray with the 
'** ContentMetaData for the selected show.  This data should 
'** be sufficient for the springboard to display
'**********************************************************
Function displayShowDetailScreen(category as Object, showIndex as Integer) As Integer

    'add code to create springboard, for now we do nothing
    return 1

End Function


'**************************************************************
'** Return the list of categories to display in the filter
'** banner. The result is an roArray containing the names of 
'** all of the categories. All just static data for the example.
'***************************************************************
Function getCategoryList() As Object

    categoryList = CreateObject("roArray", 10, true)
    categoryList = [ "All Videos", "History", "Settings", "Help" ]  ' ToDo : make this configurable based on the User or Environment 
    return categoryList

End Function


'********************************************************************
'** Given the category from the filter banner, return an array 
'** of ContentMetaData objects (roAssociativeArray's) representing 
'** the shows for the category. For this example, we just cheat and
'** create and return a static array with just the minimal items
'** set, but ideally, you'd go to a feed service, fetch and parse
'** this data dynamically, so content for each category is dynamic
'********************************************************************
Function getShowsForCategoryAllVideo() As Object

	DbgPrint(2,"getShowsForCategoryAllVideo()")
 
    playlist = GetPlaylistData()
	AllVideo = CreateObject("roArray", 10, true)

	for each data in playlist
		entry = {
			ShortDescriptionLine1:data.title
            ShortDescriptionLine2:data.description
            HDPosterUrl:data.images[0].url
            SDPosterUrl:data.images[0].url
		}
		AllVideo.push(entry)
	end for

   return AllVideo

End Function

Function getShowsForCategoryHistory() As Object

	DbgPrint(2,"getShowsForCategoryHistory()")

	playlist = GetPlaylistData()
	historyList = CreateObject("roArray", 10, true)

    IndexHistoryList = getHistoryAsList()
  	for each index in IndexHistoryList
        
        data = playlist[index.toInt()]
		entry = {
			ShortDescriptionLine1:data.title
            ShortDescriptionLine2:data.description
            HDPosterUrl:data.images[0].url
            SDPosterUrl:data.images[0].url
		}
		historyList.push(entry)

    end for

	return historyList

End Function
