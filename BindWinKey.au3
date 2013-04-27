
Global Const $WM_SYSCOmmand = 274
Global Const $SC_MonitorPower = 61808
Global Const $Power_Off = 2
Global Const $Power_On = -1

Global $MonitorIsOff = False

Func _IdleWaitCommit($idlesec)
	Local $iSave, $LastInputInfo = DllStructCreate ("uint;dword")
	DllStructSetData ($LastInputInfo, 1, DllStructGetSize ($LastInputInfo))
	DllCall ("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr ($LastInputInfo))
	Do
		$iSave = DllStructGetData ($LastInputInfo, 2)
		Sleep(60)
		DllCall ("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr ($LastInputInfo))
	Until (DllStructGetData ($LastInputInfo, 2)-$iSave) > $idlesec Or $MonitorIsOff = False
	Return DllStructGetData ($LastInputInfo, 2)-$iSave
EndFunc

Func _Monitor_ON()
	$MonitorIsOff = False
	Local $Progman_hwnd = WinGetHandle('[CLASS:Progman]')

	DllCall('user32.dll', 'int', 'SendMessage', _
		'hwnd', $Progman_hwnd, _
		'int', $WM_SYSCommand, _
		'int', $SC_MonitorPower, _
		'int', $Power_On)
EndFunc

Func _Monitor_OFF()
	$MonitorIsOff = True
	Local $Progman_hwnd = WinGetHandle('[CLASS:Progman]')

	While $MonitorIsOff = True
		DllCall('user32.dll', 'int', 'SendMessage', _
			'hwnd', $Progman_hwnd, _
			'int', $WM_SYSCommand, _
			'int', $SC_MonitorPower, _
			'int', $Power_Off)
		_IdleWaitCommit(0)
		Sleep(20)
	WEnd
EndFunc

Func _Monitor_Toggle()
	If $MonitorIsOff Then
		_Monitor_ON()
	Else
		_Monitor_OFF()
	EndIf
EndFunc

Func _Quit()
	_Monitor_ON()
	Exit
EndFunc

HotKeySet("#q", "_Monitor_Toggle")
HotKeySet("#s", "_Monitor_ON")
HotKeySet("#{Esc}", "_Quit")

While 1
	Sleep(100)
WEnd
