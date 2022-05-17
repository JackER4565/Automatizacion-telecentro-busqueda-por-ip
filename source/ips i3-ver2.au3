#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=extras\program.ico
#AutoIt3Wrapper_Res_Comment=Creado por Fabrizio
#AutoIt3Wrapper_Res_Fileversion=0.0.0.8
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_ProductName=IPS i3
#AutoIt3Wrapper_Res_ProductVersion=0
#AutoIt3Wrapper_Res_CompanyName=Telecentro
#AutoIt3Wrapper_Res_LegalCopyright=Telecentro
#AutoIt3Wrapper_Res_LegalTradeMarks=Telecentro
#AutoIt3Wrapper_Res_Language=11274
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
DirCreate ( @ScriptDir & "\Update" )
DirCreate ( @ScriptDir & "\extras" )
DirCreate ( @ScriptDir & "\screens" )
FileInstall("D:\bkaup win 10\trabajo\IPS\ips-do.exe", @ScriptDir & "\ips-do.exe")
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\busy.ani", @ScriptDir & "\busy.ani")
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\chromedriver.exe", @ScriptDir & "\chromedriver.exe")
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\clock.ico", @ScriptDir & "\clock.ico")
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\download.ico", @ScriptDir & "\download.ico")
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\folder.ico", @ScriptDir & "\folder.ico")
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\fullfolder.ico", @ScriptDir & "\fullfolder.ico")
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\not.cur", @ScriptDir & "\not.cur")
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\program.ico", @ScriptDir & "\program.ico")
FileInstall("D:\bkaup win 10\trabajo\IPS\extras\toolbox.ico", @ScriptDir & "\toolbox.ico")



Global $retoorn = 0
#Region File init

If Not FileExists(@ScriptDir & "\extra\config.ini") Then
	IniWrite(@ScriptDir & "\extra\config.ini", "config", "Version", "0.0")
EndIf
If IniRead(@ScriptDir & "\extra\config.ini", "config", "Username", "0") == 0 Then
	Do
		$user = InputBox("Usuario", "Aca es donde deberias poner el usuario.","", "", "", "135")
	Until Not @error
	IniWrite(@ScriptDir & "\extra\config.ini", "config", "Username", $user)
EndIf

If IniRead(@ScriptDir & "\extra\config.ini", "config", "NoeslaPassword", "0") == 0 Then
	Do
		$Pass = InputBox("Password", "Aca es donde deberias poner la contraseña.", "", "?", "", "135")
	Until Not @error
			Local $dEncrypted = StringEncrypt(True, $Pass, 'securepassword')
			IniWrite(@ScriptDir & "\extra\config.ini", "config", "NoeslaPassword", $dEncrypted)
EndIf
#EndRegion File init


#Region ### START Koda GUI section ### Form=
$ladocli = GUICreate("Ips:", 1160, 350, 30, 149,BitOR($WS_CAPTION, $WS_POPUP,$WS_SYSMENU, $WS_BORDER))
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
$boton_add = GUICtrlCreateButton("PEGAR", 		8, 316, 90, 25)
GUICtrlSetTip ( -1, "Pega la información desde el portapapeles." )
$boton_clean = GUICtrlCreateButton("Limpiar", 	100, 316, 90, 25)
GUICtrlSetTip ( -1, "Limpia la información pegada." )
GUICtrlSetState(-1, $GUI_DISABLE)
Global $restantes = GUICtrlCreateLabel("", 250, 324,90,25)
Global $lbl_estado = GUICtrlCreateLabel("Stand By", 350, 324, 90, 25)
global $lbl_ico = GUICtrlCreateIcon(@ScriptDir & '\extra\not.cur', -1, 450, 316, 32, 32)
$boton_go = GUICtrlCreateButton("G0", 			500, 316, 90, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip ( -1, "Empieza a buscar." )
$boton_copy = GUICtrlCreateButton("Copiar", 	600, 316, 90, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip ( -1, "Te abre una ventana de chrome donde podes copiar la info. "&@CRLF&"Para continuar cerra la ventana/pestaña." & @CRLF & "También tenes disponibles screenshots por ip en la carpeta del programa o un ZIP con todas las fotos" )
$boton_skip = GUICtrlCreateButton("Skip", 		700, 316, 90, 25)
GUICtrlSetTip ( -1, "Saltea una búsqueda y pasa a la siguiente." & @CRLF & "Esto es por si no funciona automáticamente." )
GUICtrlSetState(-1, $GUI_DISABLE)
$boton_abort = GUICtrlCreateButton("Abortar", 	800, 316, 90, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip ( -1, "Deja la busqueda. Se puede compartir el archivo 'ips.txt' para seguir en otro lado." )
$boton_show = GUICtrlCreateButton("Mostrar ", 	900, 316, 90, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip ( -1, "Muestra u Oculta la ventana de chrome donde se busca." )
$boton_salir = GUICtrlCreateButton("Salir", 	1000, 316, 90, 25) ; left, top [, width [, height
GUICtrlSetTip ( -1, "Sale del programa." )

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
			$file_to_array = FileReadToArray ( "ips.txt" )
			if not @error Then
			$result_last = StringInStr($file_to_array[@extended-1], "|", 0, 2)
			$result = StringInStr($file_to_array[0], "|", 0, 2) ; si da 0 hay un solo |, si da otra cosa hay mas de un |

			if $result <> 0 and $result_last = 0 Then
					; si hay un solo | es ip y fecha, la primera vez
					; si hay mas de un | es por que ya paso y no tengo que agregar columnas o si

				$msgbox_response = MsgBox(4, "Atencion!", "Parece que falta terminar el ultimo trabajo." & @CRLF & "¿Queres continuar?" & @CRLF & "(Si pones q no se va a borrar la lista)")
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
					GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\extra\fullfolder.ico' )
					GUICtrlSetData($lbl_estado, "Stand By")
				Else
					FileClose(FileOpen("ips.txt",2))
				EndIf
			EndIf
			EndIf
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $boton_salir
			Exit
		Case $boton_add
			GUICtrlSetData($lbl_estado, "Agregando")
			stringero(ClipGet( ))
			if _GUICtrlListView_GetItemCount($listado) <> 0 Then
				GUICtrlSetState($boton_add, $GUI_DISABLE)
				GUICtrlSetState($boton_clean, $GUI_ENABLE)
				GUICtrlSetState($boton_go, $GUI_ENABLE)
				GUICtrlSetData($restantes, _GUICtrlListView_GetItemCount($listado))
				GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\extra\fullfolder.ico' )
			EndIf
			GUICtrlSetData($lbl_estado, "Stand By")
		Case $boton_clean
			GUICtrlSetState($boton_add, $GUI_ENABLE)
			GUICtrlSetState($boton_clean, $GUI_DISABLE)
			GUICtrlSetData($lbl_estado, "Limpiando")
			_GUICtrlListView_DeleteAllItems($listado)
			GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\extra\not.cur' )
			GUICtrlSetData($lbl_estado, "Stand By")
			GUICtrlSetData($restantes, "")
		Case $boton_abort
			GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\extra\clock.ico' )
			GUICtrlSetData($lbl_estado, "Abortando")
		Case $boton_go
			GUICtrlSetData($lbl_estado, "Buscando")
			GUICtrlSetState($boton_add, $GUI_DISABLE)
			GUICtrlSetState($boton_go, $GUI_DISABLE)
			GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\extra\busy.ani' )
			GUICtrlSetState($boton_abort, $GUI_ENABLE)
			GUICtrlSetState($boton_skip, $GUI_ENABLE)
			GUICtrlSetState($boton_show, $GUI_ENABLE)


			$restan_lv = _GUICtrlListView_GetItemCount($listado)
			$index1 = 0
			if $retoorn = 0 Then
				$fileips = FileOpen ( "ips.txt" ,2)

				Do
				$inputarray = _GUICtrlListView_GetItemTextArray($listado, $index1)
				$inpt_ip = $inputarray[1]
				$inpt_fecha = $inputarray[2]
				FileWrite($fileips, $inpt_ip &"|"& $inpt_fecha & @CRLF)
				$index1 = $index1 + 1
				until $index1 = $restan_lv
				FileClose($fileips)
			EndIf

			$filegettime = FileGetTime ( "ips.txt" , 0  , 1 ) ;   $FT_STRING (1) = return a string YYYYMMDDHHMMSS
				Run("ips-do.exe")
					while 1
					$nMsg = GUIGetMsg()
					if $nMsg = $boton_skip then
						GUICtrlSetData($lbl_estado, "Skipeando")
					EndIf
					if $nMsg = $boton_abort then
						GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\extra\clock.ico' )
						GUICtrlSetData($lbl_estado, "Abortando")
					EndIf
					if $nMsg = $boton_show Then
						MsgBox(0, "show", ">"&GUICtrlRead($boton_show)&"<")
						if GUICtrlRead($boton_show) = "Mostrar" Then
							$showw = IniRead(@ScriptDir & "\extra\config.ini", "Chrome","chrome_handle", 0)
							MsgBox(0, "asd1", $showw)
							if $showw = 0 Then
								MsgBox(0, "Error", "no se pudo mostrar ventana")
							Else
								$chrome_handle = HWnd($showw)
								GUICtrlSetData($boton_show, "Ocultar")
								WinSetState($chrome_handle, "", @SW_SHOW)
							EndIf
						Else
							$showw = IniRead(@ScriptDir & "\extra\config.ini", "Chrome","chrome_handle", 0)
							MsgBox(0, "asd2", $showw)
							if $showw = 0 Then
								MsgBox(0, "Error", "no se pudo ocultar ventana")
							Else
								$chrome_handle = HWnd($showw)
								GUICtrlSetData($boton_show, "Mostrar")
								WinSetState($chrome_handle, "", @SW_HIDE)
							EndIf
						EndIf
					EndIf
					if FileGetTime ( "ips.txt" , 0  , 1 ) <> $filegettime then ;   $FT_STRING (1) = return a string YYYYMMDDHHMMSS
						importarips()
						$filegettime = FileGetTime ( "ips.txt" , 0  , 1 )
					EndIf
					$ipdoexit = GUICtrlRead($lbl_estado) ; #####################
					if $ipdoexit = "Finalizado" or $ipdoexit = "Abortando" Then
						ExitLoop
					EndIf
					WEnd
			FileClose($fileips)
			GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\extra\fullfolder.ico' )
			GUICtrlSetState($boton_copy, $GUI_ENABLE)
			GUICtrlSetState($boton_go, $GUI_DISABLE)
			GUICtrlSetState($boton_abort, $GUI_DISABLE)
			GUICtrlSetState($boton_skip, $GUI_DISABLE)
			GUICtrlSetState($boton_clean, $GUI_ENABLE)
			GUICtrlSetState($boton_show, $GUI_DISABLE)
		Case $boton_copy
				GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\extra\download.ico' )
				ShellExecuteWait(@ScriptDir & "\table.html")
				Sleep(100)

				GUICtrlSetImage ( $lbl_ico, @ScriptDir & '\extra\folder.ico' )
	EndSwitch
WEnd


Func importarips()
	_GUICtrlListView_DeleteAllItems($listado)
	$file_to_array = FileReadToArray ( "ips.txt" )
	$eofile = @extended - 1

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

			#Region hora mal
			$hora1digreg = "^\d{1}:\d{2}:\d{2}$"
			$hora2digreg = "^\d{2}:\d{2}$"
			$horapunto1 = "(\d{2}\.\d{2}:\d{2})|(\d{2}:\d{2}\.\d{2})|(\d{2}\.\d{2}\.\d{2})$"
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
			while StringRegExp ( $array1[$i], $horapunto1) <> 0
				$array1[$i] = StringReplace ($array1[$i], ".", ":")
			WEnd
;~ 			MsgBox(0, "despues horapunto", $array1[$i])
			if StringRegExp ( $array1[$i], $fechamashorareg) = 1 Then
				$array1[$i] = StringSplit($array1[$i] , " ", 2)[0] & " 0" & StringSplit($array1[$i] , " ", 2)[1]
			EndIf
;~ 			MsgBox(0, "despues fechamashorareg", $array1[$i])
			if StringRegExp ( $array1[$i], $ipv4horamal) = 1 or StringRegExp ( $array1[$i], $ipv6horamal) = 1 Then
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
			do

					if StringRegExp ( $array1[$i], $horareg ) = 0 and StringRegExp ( $array1[$i], $fechareg ) = 0 and StringRegExp ( $array1[$i], $ipv4reg ) = 0 and StringRegExp ( $array1[$i], $ipv6reg ) = 0 and StringRegExp ( $array1[$i], $ipv4fechahorareg ) = 0 and StringRegExp ( $array1[$i], $ipv6fechahorareg ) = 0 Then
						$array1[$i] = InputBox("", "Acomodame esto" &@CRLF& "O pone cancelar para borrar", $array1[$i])
						if @error = 1 then
							_ArrayDelete($array1, $i)
							$j = $j - 1
							ContinueLoop
						EndIf
					EndIf

;~ 				_ArrayDisplay($array1, "despues del for")
;~ 								MsgBox(0, "debug", "Array[$i]: " & $array1[$i] & @CRLF & _
;~ 								   "$i: " & $i & @CRLF )
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
				ConsoleWrite("I: " & $i & @CRLF)
				ConsoleWrite("J: " & $j & @CRLF)
			until $i > $j


		for $i = 0 to UBound($array1) -1
			$string = $array1[$i]
			$string = StringRegExpReplace($string, @TAB, " ")
			$string = StringRegExpReplace($string, "/", "-")
				if StringRegExp ( $string, $ipv4reg ) = 1 Or StringRegExp ( $string, $ipv6reg ) = 1 Then ; es una IP sola, o sea el array tiene un row por dato
					$ip = $string
					$i = $i + 1
					if StringRegExp ( $array1[$i], "^\d{4}\-\d{2}\-\d{2}$" ) = 1 Then ; fecha
						$fecha = $array1[$i]
						$i = $i + 1
						If StringRegExp ( $array1[$i], "^\d{2}\:\d{2}\:\d{2}$" ) = 1 Then ; hora
							$hora = $array1[$i]
						Else
							$hora = InputBox("HORA", "No puedo identificar esto: " & @CRLF & $array1[$i] & @CRLF & @CRLF & "Pega la hora aca")
						EndIf
					Else
						$fecha = InputBox("FECHA", "No puedo identificar esto: " & @CRLF & $array1[$i] & @CRLF & @CRLF & "Pega la fecha aca")
						$i = $i +1
					EndIf
				Elseif StringRegExp ( $string, "^\d{4}\-\d{2}\-\d{2}$" ) = 1 Then ; fecha
					$fecha = $string
					if $ip = 0 Then
						$ip = InputBox("IP", "No puedo identificar esto: " & @CRLF & $array1[$i] & @CRLF & @CRLF & "Pega la IP aca")
					EndIf
				Elseif StringRegExp ( $string, "^\d{4}(\:|\-)\d{2}(\:|\-)\d{2}$" ) = 1 Then ; fecha XXXX:XX:XX
					$string = StringReplace($string, ":", "-")
					$fecha = $string
					if $ip = 0 Then
						$ip = InputBox("IP", "No puedo identificar esto: " & @CRLF & $array1[$i] & @CRLF & @CRLF & "Pega la IP aca")
					EndIf
				Elseif StringRegExp ( $string, "^\d{2}(\:|\-)\d{2}(\:|\-)\d{4}$" ) = 1 Then
					$string = StringReplace($string, ":", "-")
					$str_arr = StringSplit($string, "-")
					$string = StringFormat("%04i-%02i-%02i", $str_arr[3], $str_arr[2], $str_arr[1])
					$fecha = $string
					if $ip = 0 Then
						$ip = InputBox("IP", "No puedo identificar esto: " & @CRLF & $array1[$i] & @CRLF & @CRLF & "Pega la IP aca")
					EndIf
				Elseif StringRegExp ( $string, "^\d{2}\:\d{2}\:\d{2}$" ) = 1 Then ; hora
					$hora = $string
					if $ip = 0 Then
						$ip = InputBox("IP", "No puedo identificar esto: " & @CRLF & $array1[$i] & @CRLF & @CRLF & "Pega la IP aca")
					EndIf
					if $fecha = 0 Then
						$fecha = InputBox("FECHA", "No puedo identificar esto: " & @CRLF & $array1[$i] & @CRLF & @CRLF & "Pega la fecha aca")
					EndIf
				Elseif StringRegExp ( $string, "^\d{1}\:\d{2}\:\d{2}$" ) = 1 Then ;hora con 1 digito adelante
					$string = "0" & $string
					$hora = $string
					if $ip = 0 Then
						$ip = InputBox("IP", "No puedo identificar esto: " & @CRLF & $array1[$i] & @CRLF & @CRLF & "Pega la IP aca")
					EndIf
					if $fecha = 0 Then
						$fecha = InputBox("FECHA", "No puedo identificar esto: " & @CRLF & $array1[$i] & @CRLF & @CRLF & "Pega la fecha aca")
					EndIf
				Elseif StringInStr($string, "-") Then
		$stringsplit = StringSplit($string," ",2)
				for $x = UBound($stringsplit) -1 to 0 Step -1
					if $stringsplit[$x] = "" Then
						_ArrayDelete($stringsplit, $x)
					elseif $stringsplit[$x] = " " Then
						_ArrayDelete($stringsplit, $x)
					elseif $stringsplit[$x] = @TAB Then
						_ArrayDelete($stringsplit, $x)
					EndIf
				Next


		Switch UBound($stringsplit)
			Case 1
				If StringRegExp ( $stringsplit[0], "^\d{1}\:\d{2}\:\d{2}$" ) = 1 Then ; hora
							$hora = "0" & $stringsplit[0]
						Else
							$hora = $stringsplit[0]
				EndIf

			Case 2
				$fecha = $stringsplit[0]
				if StringInStr($fecha, ":") Then
									$fecha = StringReplace($fecha, ":", "-")
				EndIf
				if StringRegExp ( $fecha, "^\d{2}(\:|\-)\d{2}(\:|\-)\d{4}$" ) = 1 Then

					$str_arr = StringSplit($fecha, "-")
					$fecha = StringFormat("%04i-%02i-%02i", $str_arr[3], $str_arr[2], $str_arr[1])
				EndIf
								If StringRegExp ( $stringsplit[1], "^\d{1}\:\d{2}\:\d{2}$" ) = 1 Then ; hora
							$hora = "0" & $stringsplit[1]
						Else
							$hora = $stringsplit[1]
				EndIf
			Case 3
				$ip = $stringsplit[0]
				$fecha = $stringsplit[1]
				if StringInStr($fecha, ":") Then
									$fecha = StringReplace($fecha, ":", "-")
				EndIf
				if StringRegExp ( $fecha, "^\d{2}(\:|\-)\d{2}(\:|\-)\d{4}$" ) = 1 Then

					$str_arr = StringSplit($fecha, "-")
					$fecha = StringFormat("%04i-%02i-%02i", $str_arr[3], $str_arr[2], $str_arr[1])
				EndIf
								If StringRegExp ( $stringsplit[2], "^\d{1}\:\d{2}\:\d{2}$" ) = 1 Then ; hora
							$hora = "0" & $stringsplit[2]
						Else
							$hora = $stringsplit[2]
				EndIf
			Case Else
				$string = StringStripWS($string, 8)
				$iPosition = StringInStr($string, "-") ; me dice la posicion del primer -
				if $iPosition = 0 then MsgBox(0, "error", "")


			$else_ip = StringMid($string, 1, $iPosition -5) ; para la hora

;~ 					MsgBox(0, "asdasdadsaad", $else_ip)
;~ 					MsgBox(0, "stringtegexp", StringRegExp ( $else_ip, $ipv6reg ) & @CRLF & @extended)
				if StringRegExp ( $else_ip, $ipv4reg ) = 0 Then
					if StringRegExp ( $else_ip, $ipv6reg ) = 0 Then
						$ip = InputBox("IP erronea:", "No puedo identificar esta ip, ponela abajo: " & @CRLF & ">" & $else_ip &"<")
					Else
						$ip = $else_ip
					EndIf
				Else
					$ip = $else_ip
				EndIf

			$else_fecha = StringMid($string, $iPosition -4, 10) ; le resto 4 a la posicion de arriba y me da la fecha
				if StringRegExp ( $else_fecha, "^\d{4}\-\d{2}\-\d{2}$" ) = 0 Then
					$fecha = InputBox("Fecha erronea:", "No puedo identificar esta fecha, ponela abajo: " & @CRLF & ">" &  $else_fecha&"<")
				Else
					$fecha = $else_fecha
				EndIf

			$else_hora = StringMid($string, $iPosition -4 + 10, 8) ; para la hora
				if StringRegExp ( $else_hora, "^\d{2}\:\d{2}\:\d{2}$" ) = 0 Then
					$hora = InputBox("Hora erronea:", "No puedo identificar esta hora, ponela abajo: " & @CRLF & ">" &  $else_hora&"<")
				Else
						If StringRegExp ( $else_hora, "^\d{1}\:\d{2}\:\d{2}$" ) = 1 Then ; hora
							$hora = "0" & $else_hora
						Else
							$hora = $else_hora
						EndIf
				EndIf



		EndSwitch
;~ 			MsgBox(0, "asdtest", "ip: "& $ip & @CRLF & "fecha: "& $fecha & @CRLF & "hora: "&$hora)

				Else
					msgBox(0, "Cadena erronea:", "No puedo identificar esto: " & @CRLF & $string & @CRLF & @CRLF & "Probemos copiando de nuevo")
					$ip = InputBox("IP", "Pega la ip aca")
					$fecha = InputBox("FECHA", "Pega la fecha aca")
					$hora = InputBox("HORA", "Pega la hora aca")
				EndIf

		GUICtrlCreateListViewItem($ip & "|" & $fecha &" "& $hora , $listado)
;~ 		GUICtrlSetData($label2, "ip: "& $ip & @CRLF & "fecha: "& $fecha & @CRLF & "hora: "&$hora)
		Next
EndFunc


