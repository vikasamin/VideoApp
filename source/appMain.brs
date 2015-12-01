'********************************************************************
'**  Video App 
'**  Nov 21
'**  Vikas Amin
'********************************************************************

'************************************************************
'** Application startup
'************************************************************
Sub Main()

	DbgPrint(2,"Main()")

    'initialize theme attributes like titles, logos and overhang color
    initTheme()

    'prepare the screen for display and get ready to begin
    screen=preShowLandingScreen("Video App", "")
    if screen=invalid then
        print "unexpected error in preShowLandingScreen"
        return
    end if

'DeleteRegistry("json")    ' ToDo : this should be configurable based on response from data-base
'DeleteRegistry("History") ' ToDo : Ideally create a screen with delete history button


    'showIntroScreen(screen)
	showLandingScreen(screen)



End Sub


'*************************************************************
'** Set the configurable theme attributes for the application
'** In this example app, we just use the SDK default artwork
'** 
'** Configure the custom overhang and Logo attributes
'*************************************************************

Sub initTheme()

	DbgPrint(2,"initTheme()")

    app = CreateObject("roAppManager")
    theme = CreateObject("roAssociativeArray")

    theme.OverhangOffsetSD_X = "72"
    theme.OverhangOffsetSD_Y = "25"
    theme.OverhangSliceSD = "pkg:/images/Overhang_BackgroundSlice_Blue_SD43.png"
    theme.OverhangLogoSD  = "pkg:/images/Logo_Overhang_Roku_SDK_SD43.png"

    theme.OverhangOffsetHD_X = "123"
    theme.OverhangOffsetHD_Y = "48"
    theme.OverhangSliceHD = "pkg:/images/Overhang_BackgroundSlice_Blue_HD.png"
    theme.OverhangLogoHD  = "pkg:/images/Logo_Overhang_Roku_SDK_HD.png"

    app.SetTheme(theme)

End Sub

