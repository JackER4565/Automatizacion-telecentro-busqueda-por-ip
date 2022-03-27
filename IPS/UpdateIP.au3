#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
$dir = StringRegExpReplace(@ScriptDir, '\\[^\\]*$', '')
Sleep(3000)

$rta = FileDelete($dir & '\ips i3.exe')
if $rta = 0 Then
	MsgBox(0, "Error", "no se pudo borrar 'ips i3.exe'")
	Exit
EndIf
$rta = FileMove(@ScriptDir & '\ips i3.exe', $dir & '\ips i3.exe', 1)
if $rta = 0 Then
	MsgBox(0, "Error", "no se pudo mover el update.")
	Exit
EndIf
Run($dir & '\ips i3.exe')
if @error Then
	MsgBox(0, "Error", "no se pudo abrir 'ips i3.exe' despues del update.")
	Exit
EndIf