#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Extras\program.ico
#AutoIt3Wrapper_Res_Comment=Creado por Fabrizio
#AutoIt3Wrapper_Res_Fileversion=0.0.1.8
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_ProductName=IPS i3
#AutoIt3Wrapper_Res_ProductVersion=0
#AutoIt3Wrapper_Res_CompanyName=Telecentro
#AutoIt3Wrapper_Res_LegalCopyright=Telecentro
#AutoIt3Wrapper_Res_LegalTradeMarks=Telecentro
#AutoIt3Wrapper_Res_Language=11274
#AutoIt3Wrapper_Run_After=move /Y "%out%" "%scriptdir%\Buscador IPs.exe"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;------ icons from https://iconarchive.com/show/rumax-icons-by-toma4025.2.html
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListView.au3>
#include <WindowsConstants.au3>
;~ #include <\UDF\wd_core.au3> ; - https://github.com/Danp2/au3WebDriver ty dan2p
;~ #include <\UDF\wd_helper.au3> ; - https://github.com/Danp2/au3WebDriver ty dan2p
#include <Crypt.au3>
#include <array.au3>


Opt("MustDeclareVars", 0)
DirCreate ( @ScriptDir & "\Extras" )
DirCreate ( @ScriptDir & "\Screens" )
FileInstall("D:\bkaup win 10\trabajo\IPS\ips-do.exe", @ScriptDir & "\ips-do.exe",1)
FileInstall("D:\bkaup win 10\trabajo\IPS\UpdateIP.exe", @ScriptDir & "\UpdateIP.exe",1)
FileInstall("D:\bkaup win 10\trabajo\IPS\Extras\busy.ani", @ScriptDir & "\extras\busy.ani",1)
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\chromedriver.exe", @ScriptDir & "\extras\chromedriver.exe",1)
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\clock.ico", @ScriptDir & "\extras\clock.ico",1)
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\download.ico", @ScriptDir & "\extras\download.ico",1)
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\folder.ico", @ScriptDir & "\extras\folder.ico",1)
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\fullfolder.ico", @ScriptDir & "\extras\fullfolder.ico",1)
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\not.cur", @ScriptDir & "\extras\not.cur",1)
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\program.ico", @ScriptDir & "\extras\program.ico",1)
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\toolbox.ico", @ScriptDir & "\extras\toolbox.ico",1)

local $runcodee = RunWait("UpdateIP.exe")
if $runcodee = 1 Then
	MsgBox(0, "!", "No se actualizo")
EndIf

Global $retoorn = 0
#Region File init
local $user, $Pass
If Not FileExists(@ScriptDir & "\Extras\config.ini") Then
	IniWrite(@ScriptDir & "\Extras\config.ini", "config", "Version", "0.0")
EndIf
If IniRead(@ScriptDir & "\Extras\config.ini", "config", "Username", "0") == 0 Then
	Do
		$user = InputBox("Usuario", "Aca es donde deberias poner el usuario.","", "", "", "135")
	Until Not @error
	IniWrite(@ScriptDir & "\Extras\config.ini", "config", "Username", $user)
EndIf

If IniRead(@ScriptDir & "\Extras\config.ini", "config", "NoeslaPassword", "0") == 0 Then
	Do
		$Pass = InputBox("Password", "Aca es donde deberias poner la contraseña.", "", "?", "", "135")
	Until Not @error
			Local $dEncrypted = StringEncrypt(True, $Pass, 'securepassword')
			IniWrite(@ScriptDir & "\Extras\config.ini", "config", "NoeslaPassword", $dEncrypted)
EndIf
#EndRegion File init


#Region ### START Koda GUI section ### Form=
local $ladocli = GUICreate("Ips:", 1160, 350, 30, 149,BitOR($WS_CAPTION, $WS_POPUP,$WS_SYSMENU, $WS_BORDER))
GUISetIcon("shell32.dll", 239)
global $listado = GUICtrlCreateListView("ip|Fecha|Cliente|Nombre|Dirección|Teléfono|Macaddress CM|Fecha Entrega IP|Fecha Activación CM", 8, 8, 1150, 302, BitOR($GUI_SS_DEFAULT_LISTVIEW, $WS_VSCROLL))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 240)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 6, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 7, 100)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($listado), 0, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($listado), 1, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($listado), 2, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($listado), 3, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($listado), 4, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($listado), 5, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($listado), 6, 2)
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($listado), 7, 2)
local $boton_add = GUICtrlCreateButton("PEGAR", 		8, 316, 90, 25)
GUICtrlSetTip ( -1, "Pega la información desde el portapapeles." )
local $boton_clean = GUICtrlCreateButton("Limpiar", 	100, 316, 90, 25)
GUICtrlSetTip ( -1, "Limpia la información pegada." )
GUICtrlSetState(-1, $GUI_DISABLE)
Global $restantes = GUICtrlCreateLabel("", 250, 324,90,25)
;~ 	Local $idStatuslabel = GUICtrlCreateLabel($sDefaultstatus, 0, 165, 300, 16, BitOR($SS_SIMPLE, $SS_SUNKEN))
Global $lbl_estado = GUICtrlCreateLabel("Stand By", 350, 325, 90, 25)
global $lbl_ico = GUICtrlCreateIcon(@ScriptDir & '\Extras\not.cur', -1, 450, 316, 32, 32)
local $boton_go = GUICtrlCreateButton("Empezar!", 			500, 316, 90, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip ( -1, "Empieza a buscar." )
local $boton_copy = GUICtrlCreateButton("Copiar", 	600, 316, 90, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip ( -1, "Te abre una ventana de chrome donde podes copiar la info. "&@CRLF&"Para continuar cerra la ventana/pestaña." & @CRLF & "También tenes disponibles screenshots por ip en la carpeta del programa o un ZIP con todas las fotos" )
local $boton_skip = GUICtrlCreateButton("Skip", 		700, 316, 90, 25)
GUICtrlSetTip ( -1, "Saltea una búsqueda y pasa a la siguiente." & @CRLF & "Esto es por si no funciona automáticamente." )
GUICtrlSetState(-1, $GUI_DISABLE)
local $boton_abort = GUICtrlCreateButton("Cancelar", 	800, 316, 90, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip ( -1, "Deja la busqueda. Se puede compartir el archivo 'ips.txt' para seguir en otro lado." )
;~ local $boton_show = GUICtrlCreateButton("Mostrar", 	900, 316, 90, 25)
;~ GUICtrlSetState(-1, $GUI_DISABLE)
;~ GUICtrlSetTip ( -1, "Muestra u Oculta la ventana de chrome donde se busca." )
local $boton_salir = GUICtrlCreateButton("Salir", 	1000, 316, 90, 25) ; left, top [, width [, height
GUICtrlSetTip ( -1, "Sale del programa." )
GUICtrlCreateLabel("V: "&FileGetVersion(@ScriptDir & "\Buscador IPs.exe"), 1100,318)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
			local $file_to_array = FileReadToArray ( "ips.txt" )
			if not @error Then
			local $result_last = StringInStr($file_to_array[@extended-1], "|", 0, 2)
			local $result = StringInStr($file_to_array[0], "|", 0, 2) ; si da 0 hay un solo |, si da otra cosa hay mas de un |

			if $result <> 0 and $result_last = 0 Then
					; si hay un solo | es ip y fecha, la primera vez
					; si hay mas de un | es por que ya paso y no tengo que agregar columnas o si

				local $msgbox_response = MsgBox(4, "Atencion!", "Parece que falta terminar el ultimo trabajo." & @CRLF & "¿Queres continuar?" & @CRLF & "(Si pones q no se va a borrar la lista)")
				; 6 YES 7 NO
				if $msgbox_response = 6 Then
					;tengo que agarrar las lineas que tienen mas de dos | y ponerlas en el gui
					; y los que tienen un solo | correrlos en el programa
					;pero en el listview se tienen que ver todos los ips

					GUICtrlSetData($lbl_estado, "Agregando")
					importarips()
					GUICtrlSetState($boton_add, $GUI_DISABLE)
					GUICtrlSetState($boton_clean, $GUI_ENABLE)
					GUICtrlSetState($boton_go, $GUI_ENABLE)
					GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\Extras\fullfolder.ico' )
					GUICtrlSetData($lbl_estado, "Stand By")
				Else
					FileClose(FileOpen("ips.txt",2))
				EndIf
			EndIf
			EndIf
While 1
	local $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $boton_salir
			Exit
		Case $boton_add
			$retoorn = 0
			GUICtrlSetData($lbl_estado, "Agregando")
			stringero(ClipGet( ))
			if _GUICtrlListView_GetItemCount($listado) <> 0 Then
				GUICtrlSetState($boton_add, $GUI_DISABLE)
				GUICtrlSetState($boton_clean, $GUI_ENABLE)
				GUICtrlSetState($boton_go, $GUI_ENABLE)
				GUICtrlSetData($restantes, _GUICtrlListView_GetItemCount($listado))
				GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\Extras\fullfolder.ico' )
			EndIf
			GUICtrlSetData($lbl_estado, "Stand By")
		Case $boton_clean
			$retoorn = 0
			GUICtrlSetState($boton_add, $GUI_ENABLE)
			GUICtrlSetState($boton_clean, $GUI_DISABLE)
			GUICtrlSetData($lbl_estado, "Limpiando")
			_GUICtrlListView_DeleteAllItems($listado)
			GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\Extras\not.cur' )
			GUICtrlSetData($lbl_estado, "Stand By")
			GUICtrlSetData($restantes, "")
;~ 		Case $boton_abort
;~ 			GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\Extras\clock.ico' )
;~ 			GUICtrlSetData($lbl_estado, "Cancelando")
		Case $boton_go
			GUICtrlSetData($lbl_estado, "Buscando")
			GUICtrlSetState($boton_add, $GUI_DISABLE)
			GUICtrlSetState($boton_go, $GUI_DISABLE)
			GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\Extras\busy.ani' )
			GUICtrlSetState($boton_abort, $GUI_ENABLE)
			GUICtrlSetState($boton_skip, $GUI_ENABLE)
;~ 			GUICtrlSetState($boton_show, $GUI_ENABLE)
			GUICtrlSetState($boton_salir, $GUI_DISABLE)

;~ 			local $ya_pase = 0
			local $restan_lv = _GUICtrlListView_GetItemCount($listado)
			local $index1 = 0
			if $retoorn = 0 Then
				local $fileips = FileOpen ( "ips.txt" ,2)

				Do
				local $inputarray = _GUICtrlListView_GetItemTextArray($listado, $index1)
				local $inpt_ip = $inputarray[1]
				local $inpt_fecha = $inputarray[2]
				FileWrite($fileips, $inpt_ip &"|"& $inpt_fecha & @CRLF)
				$index1 = $index1 + 1
				until $index1 = $restan_lv

				FileClose($fileips)
			EndIf

			local $filegettime = FileGetTime ( "ips.txt" , 0  , 1 ) ;   $FT_STRING (1) = return a string YYYYMMDDHHMMSS

				local $runreturn = Run("ips-do.exe")

					while 1
;~ 						if GUICtrlRead ( $lbl_estado) <> "Buscando" and $ya_pase = 0 Then
;~ 							local $chrome_handle = HWnd(GUICtrlRead ( $lbl_estado))
;~ 							GUICtrlSetData($lbl_estado, "OK")
;~ 							$ya_pase = 1
;~ 						EndIf
						if $runreturn = -1 Then
							GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\Extras\not.cur' )
						EndIf
					Local $nMsg2 = GUIGetMsg()
					Switch $nMsg2
						case $boton_skip
							GUICtrlSetData($lbl_estado, "Skipeando")
						case $boton_abort
							GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\Extras\clock.ico' )
							GUICtrlSetData($lbl_estado, "Cancelando")
;~ 						case $boton_show
;~ 							if GUICtrlRead($boton_show) = "Mostrar" Then
;~ 									GUICtrlSetData($boton_show, "Ocultar")
;~ 									WinSetState($chrome_handle, "", @SW_SHOW)
;~ 							ElseIf GUICtrlRead($boton_show) = "Ocultar" Then
;~ 									GUICtrlSetData($boton_show, "Mostrar")
;~ 									WinSetState($chrome_handle, "", @SW_HIDE)
;~ 							EndIf
					EndSwitch
					if FileGetTime ( "ips.txt" , 0  , 1 ) <> $filegettime then ;   $FT_STRING (1) = return a string YYYYMMDDHHMMSS
						_GUICtrlListView_BeginUpdate($listado)
						importarips()
						 _GUICtrlListView_EndUpdate($listado)
						$filegettime = FileGetTime ( "ips.txt" , 0  , 1 )
					EndIf
					local $ipdoexit = GUICtrlRead($lbl_estado) ; #####################
					if $ipdoexit = "Finalizado" or $ipdoexit = "Cancelando" Then
						ExitLoop
					EndIf

					WEnd
			GUICtrlSetData($lbl_estado, "Stand By")
			GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\Extras\fullfolder.ico' )
			GUICtrlSetState($boton_copy, $GUI_ENABLE)
			GUICtrlSetState($boton_go, $GUI_DISABLE)
			GUICtrlSetState($boton_abort, $GUI_DISABLE)
			GUICtrlSetState($boton_skip, $GUI_DISABLE)
			GUICtrlSetState($boton_clean, $GUI_ENABLE)
;~ 			GUICtrlSetState($boton_show, $GUI_DISABLE)
			GUICtrlSetState($boton_salir, $GUI_ENABLE)
		Case $boton_copy
				GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\Extras\download.ico' )
				ShellExecuteWait(@ScriptDir & "\table.html")
				Sleep(100)

				GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\Extras\folder.ico' )
	EndSwitch
WEnd


Func importarips()
	_GUICtrlListView_DeleteAllItems($listado)
	$file_to_array = FileReadToArray ( "ips.txt" )
	local $eofile = @extended - 1

			$file_to_array = FileReadToArray ( "ips.txt" )
			$result_last = StringInStr($file_to_array[@extended-1], "|", 0, 2)
			for $o = 0 to $eofile
					GUICtrlCreateListViewItem($file_to_array[$o] , $listado)
					if StringInStr($file_to_array[$o], "|", 0, 2) <> 0 Then
						$retoorn = $o
					EndIf
			next
			GUICtrlSetData($restantes, $retoorn +1 & " de " & _GUICtrlListView_GetItemCount($listado))
EndFunc

Func StringEncrypt($bEncrypt, $sData, $sPassword)
	_Crypt_Startup() ; Start the Crypt library.
	Local $vReturn = ''
	If $bEncrypt Then ; If the flag is set to True then encrypt, otherwise decrypt.
		$vReturn = _Crypt_EncryptData($sData, $sPassword, $CALG_RC4)
	Else
		$vReturn = BinaryToString(_Crypt_DecryptData($sData, $sPassword, $CALG_RC4))
	EndIf
	_Crypt_Shutdown() ; Shutdown the Crypt library.
	Return $vReturn
EndFunc   ;==>StringEncrypt


func stringero($clip)
$ip = 0
$fecha = 0
$hora = 0
			$ipv6reg = "^([[:xdigit:]]{1,4}(?::[[:xdigit:]]{1,4}){7}|::|:(?::[[:xdigit:]]{1,4}){1,6}|[[:xdigit:]]{1,4}:(?::[[:xdigit:]]{1,4}){1,5}|(?:[[:xdigit:]]{1,4}:){2}(?::[[:xdigit:]]{1,4}){1,4}|(?:[[:xdigit:]]{1,4}:){3}(?::[[:xdigit:]]{1,4}){1,3}|(?:[[:xdigit:]]{1,4}:){4}(?::[[:xdigit:]]{1,4}){1,2}|(?:[[:xdigit:]]{1,4}:){5}:[[:xdigit:]]{1,4}|(?:[[:xdigit:]]{1,4}:){1,6}:)$"
			$ipv4reg = "^(?:25[0-5]|2[0-4]\d|[0-1]?\d{1,2})(?:\.(?:25[0-5]|2[0-4]\d|[0-1]?\d{1,2})){3}$"
			$fechareg = "^(\d{4}-\d{2}-\d{2})$"
			$horareg = "^\d{2}:\d{2}:\d{2}$"
			$ipv4fechahorareg = "^(?:25[0-5]|2[0-4]\d|[0-1]?\d{1,2})(?:\.(?:25[0-5]|2[0-4]\d|[0-1]?\d{1,2})){3}[ \t]\d{4}-\d{2}-\d{2}[ \t]\d{2}:\d{2}:\d{2}$"
			$ipv6fechahorareg = "^([[:xdigit:]]{1,4}(?::[[:xdigit:]]{1,4}){7}|::|:(?::[[:xdigit:]]{1,4}){1,6}|[[:xdigit:]]{1,4}:(?::[[:xdigit:]]{1,4}){1,5}|(?:[[:xdigit:]]{1,4}:){2}(?::[[:xdigit:]]{1,4}){1,4}|(?:[[:xdigit:]]{1,4}:){3}(?::[[:xdigit:]]{1,4}){1,3}|(?:[[:xdigit:]]{1,4}:){4}(?::[[:xdigit:]]{1,4}){1,2}|(?:[[:xdigit:]]{1,4}:){5}:[[:xdigit:]]{1,4}|(?:[[:xdigit:]]{1,4}:){1,6}:)[ \t]\d{4}-\d{2}-\d{2}[ \t]\d{2}:\d{2}:\d{2}$"
			$fechamashora = "^\d{4}-\d{2}-\d{2}[ \t]\d{2}:\d{2}:\d{2}$"

			#Region hora mal
			$hora1digreg = "^\d{1}:\d{2}:\d{2}$"
			$hora2digreg = "^\d{2}:\d{2}$"
			$horapunto1 = "^(\d{2}\.\d{2}:\d{2})|(\d{2}:\d{2}\.\d{2})|(\d{2}\.\d{2}\.\d{2})$"
			$fechamashorareg = "^\d{4}-\d{2}-\d{2}[ \t]\d{1}:\d{2}:\d{2}$"
			$ipv4horamal = "^(?:25[0-5]|2[0-4]\d|[0-1]?\d{1,2})(?:\.(?:25[0-5]|2[0-4]\d|[0-1]?\d{1,2})){3}[ \t]\d{4}-\d{2}-\d{2}[ \t]\d{1}:\d{2}:\d{2}$"
			$ipv6horamal = "^([[:xdigit:]]{1,4}(?::[[:xdigit:]]{1,4}){7}|::|:(?::[[:xdigit:]]{1,4}){1,6}|[[:xdigit:]]{1,4}:(?::[[:xdigit:]]{1,4}){1,5}|(?:[[:xdigit:]]{1,4}:){2}(?::[[:xdigit:]]{1,4}){1,4}|(?:[[:xdigit:]]{1,4}:){3}(?::[[:xdigit:]]{1,4}){1,3}|(?:[[:xdigit:]]{1,4}:){4}(?::[[:xdigit:]]{1,4}){1,2}|(?:[[:xdigit:]]{1,4}:){5}:[[:xdigit:]]{1,4}|(?:[[:xdigit:]]{1,4}:){1,6}:)[ \t]\d{4}-\d{2}-\d{2}[ \t]\d{1}:\d{2}:\d{2}$"
			#EndRegion hora mal
			#cs
			casos:
			IP
			IP FECHA
			IP FECHA HORA
			FECHA HORA
			HORA
			#ce

		;------ splitteo por salto de linea y saco los vacios
		$array1 = StringSplit($clip, @CRLF)
		for $i = UBound($array1) -1 to 0 Step -1
			if $array1[$i] = "" Then
				_ArrayDelete($array1, $i)
			elseif $array1[$i] = " " Then
				_ArrayDelete($array1, $i)
			ElseIf $array1[$i] = @TAB Then
				_ArrayDelete($array1, $i)
			EndIf
		Next
		;---- saco los espacios
		_ArrayDelete($array1, 0)
;~ 		_ArrayDisplay($array1)
		;----- chequeo si es ipv4 o ipv6
		;--- si la hora tiene 1 digito agrego un 0
		for $i = UBound($array1) -1 to 0 Step -1
			;---- acomoda la hora
;~ 			MsgBox(0, "inicio del for", $array1[$i])
			$array1[$i] = StringReplace($array1[$i], @TAB, " ")
;~ 			MsgBox(0, "despues del replace", $array1[$i])
			if StringRegExp ( $array1[$i], $hora1digreg)  = 1 then
				$array1[$i] = "0" & $array1[$i]
			EndIf
;~ 			MsgBox(0, "despues hora 1 dig", $array1[$i])
;~ 			while StringRegExp ( $array1[$i], $horapunto1) = 0
;~ 				$array1[$i] = StringReplace ($array1[$i], ".", ":")
;~ 			WEnd
;~ 			MsgBox(0, "despues horapunto", $array1[$i])
			if StringRegExp ( $array1[$i], $fechamashorareg) = 1 Then  ;----- "2022-02-02        1:05:06"
				$array1[$i] = StringSplit($array1[$i] , " ", 2)[0] & " 0" & StringSplit($array1[$i] , " ", 2)[1]
			EndIf
;~ 			MsgBox(0, "despues fechamashorareg", $array1[$i])
			if StringRegExp ( $array1[$i], $ipv4horamal) = 1 or StringRegExp ( $array1[$i], $ipv6horamal) = 1 Then  ;-- ip + fecha + hora 1 digito 127.0.0.1 2022-02-02 1:05:05
				$array1[$i] = StringSplit($array1[$i] , " ", 2)[0] & " " & StringSplit($array1[$i] , " ", 2)[1] & " 0" & StringSplit($array1[$i] , " ", 2)[2]
			EndIf
;~ 			MsgBox(0, "despues horamal", $array1[$i])
			if StringRegExp ( $array1[$i], $hora2digreg)  = 1 Then
				$array1[$i] = $array1[$i] & ":00"
			EndIf
;~ 			MsgBox(0, "despues hora2digreg", $array1[$i])
			;------ saca los " :" y " ."
			While StringInStr ( $array1[$i], " :" ) <> 0
				$array1[$i] = StringReplace ($array1[$i], " :", ":")
			WEnd
			While StringInStr ( $array1[$i], ";" ) <> 0
				$array1[$i] = StringReplace ($array1[$i], ";", ":")
			WEnd
			While StringInStr ( $array1[$i], ": " ) <> 0
				$array1[$i] = StringReplace ($array1[$i], ": ", ":")
			WEnd
			While StringInStr ( $array1[$i], ". " ) <> 0
				$array1[$i] = StringReplace ($array1[$i], ". ", ".")
			WEnd
			$array1[$i] = StringStripWS ( $array1[$i], 7 )
			while StringInStr ( $array1[$i], " ." ) <> 0
				$array1[$i] = StringReplace ($array1[$i], " .", ".")
			WEnd
			while StringInStr ( $array1[$i], "  " ) <> 0
				$array1[$i] = StringReplace ($array1[$i], "  ", " ")
			WEnd
			if StringRegExp($array1[$i], "^([[:xdigit:]]{1,4}(?::[[:xdigit:]]{1,4}){7}|::|:(?::[[:xdigit:]]{1,4}){1,6}|[[:xdigit:]]{1,4}:(?::[[:xdigit:]]{1,4}){1,5}|(?:[[:xdigit:]]{1,4}:){2}(?::[[:xdigit:]]{1,4}){1,4}|(?:[[:xdigit:]]{1,4}:){3}(?::[[:xdigit:]]{1,4}){1,3}|(?:[[:xdigit:]]{1,4}:){4}(?::[[:xdigit:]]{1,4}){1,2}|(?:[[:xdigit:]]{1,4}:){5}:[[:xdigit:]]{1,4}|(?:[[:xdigit:]]{1,4}:){1,6}:)[ \t]\d{4}-\d{2}-\d{2}[ \t]\d{2}:\d{2}$")  = 1 Then

				$array1[$i] = $array1[$i] & ":00"
			EndIf
			if StringRegExp($array1[$i], "^(?:25[0-5]|2[0-4]\d|[0-1]?\d{1,2})(?:\.(?:25[0-5]|2[0-4]\d|[0-1]?\d{1,2})){3}[ \t]\d{4}-\d{2}-\d{2}[ \t]\d{2}:\d{2}$")  = 1 Then

				$array1[$i] = $array1[$i] & ":00"
			EndIf
		Next
		$j = UBound($array1) -1
		$i = 0
;~ 		_ArrayDisplay($array1, "antes de todo")
;~ 		MsgBox(0, "asd", $array1[$i])
			do

					if StringRegExp ( $array1[$i], $horareg ) = 0 and StringRegExp ( $array1[$i], $fechareg ) = 0 and StringRegExp ( $array1[$i], $ipv4reg ) = 0 and StringRegExp ( $array1[$i], $ipv6reg ) = 0 and StringRegExp ( $array1[$i], $ipv4fechahorareg ) = 0 and StringRegExp ( $array1[$i], $ipv6fechahorareg ) = 0 and StringRegExp ( $array1[$i], $fechamashora) = 0 Then
						$array1[$i] = InputBox("", "Acomodame esto" &@CRLF& "O pone cancelar para borrar"&@CRLF& "O escribi 'BASTA' para salir.", $array1[$i])
						if @error = 1 then
							_ArrayDelete($array1, $i)
							$j = $j - 1
							ContinueLoop
						EndIf
						if $array1[$i] = "BASTA" then Return
					EndIf


;~ 				_ArrayDisplay($array1, "despues del for")
;~ 								MsgBox(0, "debug", "Array[$i]: " & $array1[$i] & @CRLF & _
;~ 								   "$i: " & $i & @CRLF )
;----------------------######################################## si la primera linea tiene una ip + una fecha + una hora pero la segunda solo hora:
					if StringRegExp ( $array1[$i], $ipv4fechahorareg ) = 1 Or StringRegExp ( $array1[$i], $ipv6fechahorareg ) = 1 Then ;es una ip

						$arrayip = StringSplit($array1[$i]," ")[1]
						$arrayfecha = StringSplit($array1[$i]," ")[2]
;~ 						MsgBox(0, "ip", $array1[$i])
					EndIf

					if StringRegExp ( $array1[$i], $fechamashora ) = 1  Then ;es una ip

						$arrayfecha = StringSplit($array1[$i]," ")[1]
						$array1[$i] = $arrayip & " " & $arrayfecha & " " & StringSplit($array1[$i]," ")[2]
;~ 						MsgBox(0, "ip", $array1[$i])
					EndIf

					if StringRegExp ( $array1[$i], $ipv4reg ) = 1 Or StringRegExp ( $array1[$i], $ipv6reg ) = 1 Then ;es una ip
						$arrayip = $array1[$i]
						$arrayfecha = $array1[$i+1]
						$array1[$i] = $array1[$i] & " " & $array1[$i+1] & " " & $array1[$i+2]
						_ArrayDelete($array1, $i+1)
						_ArrayDelete($array1, $i+1)
						$j = $j - 2
;~ 						MsgBox(0, "ip", $array1[$i])
						ContinueLoop
					EndIf
					if StringRegExp ( $array1[$i], $fechareg ) = 1 Then ; o sea en el siguiente loop cambia la fecha y la hora PERO NO LA IP
						$arrayfecha = $array1[$i]
						$array1[$i] = $arrayip & " " & $array1[$i] & " " & $array1[$i+1]
						_ArrayDelete($array1, $i+1)
						$j = $j - 1
;~ 						_ArrayDisplay($array1, "despues de borrar FECHA")
;~ 						MsgBox(0, "fecha", $array1[$i])
						ContinueLoop
					EndIf
					if StringRegExp ( $array1[$i], $horareg ) = 1 Then ; o sea en el siguiente loop cambia SOLO LA HORA
						$array1[$i] = $arrayip & " " & $arrayfecha & " " & $array1[$i]
;~ 						MsgBox(0, "hora", $array1[$i])
;~ 						_ArrayDisplay($array1, "despues de borrar HORA")
						ContinueLoop
					EndIf
				$i = $i + 1
;~ 				ConsoleWrite("I: " & $i & @CRLF)
;~ 				ConsoleWrite("J: " & $j & @CRLF)
			until $i > $j

;~ _ArrayDisplay($array1, "asd")

		for $i = 0 to UBound($array1) -1
			$string = $array1[$i]
			$stringsplit = StringSplit($string," ",2)

				$ip = $stringsplit[0]
				$fecha = $stringsplit[1]
				$hora = $stringsplit[2]

		GUICtrlCreateListViewItem($ip & "|" & $fecha &" "& $hora , $listado)
;~ 		GUICtrlSetData($label2, "ip: "& $ip & @CRLF & "fecha: "& $fecha & @CRLF & "hora: "&$hora)
		Next
EndFunc


