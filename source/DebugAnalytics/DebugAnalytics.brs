
'*************************************************************
'** Print helper method
'** Configure what should print on your debug screen 
'** 1=High level , 2=Mid level , 3=low level, 4=very low level
'*************************************************************
Function DbgPrint(priority As Integer,debugMsg As String) 

	printPriority=2

	if priority < printPriority or priority = printPriority
	 Print debugMsg
	end if

End Function


'*************************************************************
'** Print or Send to your Analytics system
'** For not we are just printing to Telnet 
'*************************************************************
Function PrintOrAnalytics(debugMsg As String) 

	Print debugMsg

End Function
