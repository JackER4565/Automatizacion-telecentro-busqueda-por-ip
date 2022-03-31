#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Comment=Creado por Fabrizio
#AutoIt3Wrapper_Res_Fileversion=0.0.0.5
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_ProductName=IPS i3
#AutoIt3Wrapper_Res_ProductVersion=0
#AutoIt3Wrapper_Res_CompanyName=Telecentro
#AutoIt3Wrapper_Res_LegalCopyright=Telecentro
#AutoIt3Wrapper_Res_LegalTradeMarks=Telecentro
#AutoIt3Wrapper_Res_Language=11274
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListView.au3>
#include <WindowsConstants.au3>
#include <D:\UDF\wd_core.au3> ; - https://github.com/Danp2/au3WebDriver ty dan2p
#include <D:\UDF\wd_helper.au3> ; - https://github.com/Danp2/au3WebDriver ty dan2p
#include <Crypt.au3>
#include <array.au3>
#include <zip.au3>
#include <INet.au3>
HotKeySet("{PAUSE}", "Abortar")
Global $abortar = 0

_WD_UpdateDriver('chrome')
_WD_GetWebDriverVersion(@ScriptDir,'chromedriver.exe')
_WD_GetBrowserVersion('chrome')
FileInstall(".\chromedriver.exe", @ScriptDir & "\chromedriver.exe")
DirCreate(@ScriptDir & "\Update")
FileInstall(".\UpdateIP.exe", @ScriptDir & "\Update\UpdateIP.exe")

Local $doDownload = InetGet("https://github.com/JackER4565/ips/raw/main/ips%20i3.exe", @ScriptDir & '\Update\ips i3.exe', 3, 0)

			if $doDownload = 0 then
				MsgBox(0, "error", "Fallo con la descarga del update", 2)
			EndIf
			Sleep(150)
            InetClose($doDownload)


		   If StringRegExpReplace(FileGetVersion(@ScriptDir & '\Update\ips i3.exe'), "\D|0", "") > StringRegExpReplace(FileGetVersion(@ScriptDir & '\ips i3.exe'), "\D|0", "") Then
				MsgBox(0, "updating", "updating")

				Run(@ScriptDir & "\Update\UpdateIP.exe")
				Exit
		   EndIf

filesfile()

	Global $Zip, $table

#Region chrome
Local $sDesiredCapabilities, $sSession,$inpt_clnt, $sElement, $sButton,$sValue, $sUser, $sPass, $chrome_handle, $hndl

Call(SetupChrome)
_WD_Startup()

If @error <> $_WD_ERROR_Success Then
	Exit -1
EndIf

#EndRegion chrome


If Not FileExists(@ScriptDir & "\config.ini") Then
	IniWrite(@ScriptDir & "\config.ini", "config", "Version", "0.0")
EndIf
If IniRead(@ScriptDir & "\config.ini", "config", "Username", "0") == 0 Then
	Do
		$user = InputBox("Usuario", "Aca es donde deberias poner el usuario.","", "", "", "135")
	Until Not @error
	IniWrite(@ScriptDir & "\config.ini", "config", "Username", $user)
EndIf

If IniRead(@ScriptDir & "\config.ini", "config", "NoeslaPassword", "0") == 0 Then
	Do
		$Pass = InputBox("Password", "Aca es donde deberias poner la contraseña.", "", "?", "", "135")
	Until Not @error
			Local $dEncrypted = StringEncrypt(True, $Pass, 'securepassword')
			IniWrite(@ScriptDir & "\config.ini", "config", "NoeslaPassword", $dEncrypted)
EndIf



#Region ### START Koda GUI section ### Form=
$ladocli = GUICreate("Ips:", 516, 614, 294, 149)
$botoni3 = GUICtrlCreateButton("Abrir CHROME", 418, 8, 90, 25)
GUICtrlCreateLabel("Estado:", 428, 38, 40, 17)
$estado = GUICtrlCreateLabel("Closed", 468, 38, 80, 17)
global $listado = GUICtrlCreateListView("ip|Fecha|Cliente|Nombre|Dirección|Teléfono|Macaddress CM|Fecha Entrega IP|Fecha Activación CM", 8, 272, 500, 302, BitOR($GUI_SS_DEFAULT_LISTVIEW, $WS_VSCROLL))
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
Global $clientes = GUICtrlCreateEdit("IP + fecha (con / o -): "&@CRLF&"ejemplo: 2800:810:530:80c5:d4a3:34c3:fb45:50f9 2020-10-23 09:36:26", 8, 8, 402, 253, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL))
$restantes = GUICtrlCreateLabel("Restantes: x/x", 428, 58, 73, 30)
$boton_add = GUICtrlCreateButton("ADD", 418, 157, 90, 25)

$boton_clean = GUICtrlCreateButton("Limpiar", 418, 90, 90, 25)
$boton_go = GUICtrlCreateButton("G0", 418, 237, 90, 25)
$boton_copy = GUICtrlCreateButton("Copiar", 8, 580, 90, 25)


$boton_salir = GUICtrlCreateButton("Salir", 418, 580, 90, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			_WD_DeleteSession($sSession)
			_WD_Shutdown()
			Exit
		Case $boton_salir
			_WD_DeleteSession($sSession)
			_WD_Shutdown()
			Exit
		Case $botoni3
			$dEncrypted = IniRead(@ScriptDir & "\config.ini", "config", "NoeslaPassword", "0")
					Local $sDecrypted = StringEncrypt(False, $dEncrypted, 'securepassword')
					Local $auxil = 0
					$Pass = $sDecrypted
					$username = IniRead(@ScriptDir & "\config.ini", "config", "Username", "0")
					Sleep(1000)
			GUICtrlSetData($estado, "UnHooked")
			$sSession = _WD_CreateSession($sDesiredCapabilities)

			$chrome_handle = WinWait("data:, - Google Chrome", "")
			WinSetState($chrome_handle, "", @SW_MAXIMIZE)
			WinSetState($chrome_handle, "", @SW_HIDE)
			_WD_LoadWait($sSession)
			WinSetTitle($ladocli, "",  "Ips: " & "Creando sesion chrome")
			; NAVEGA A USUARIOS ###
			_WD_Navigate($sSession, "https://usuarios.telecentro.net.ar/logIn.php")

			; Locate elements (inputs)
			$sUser = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '//*[@id="usuario"]')
			$sPass = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '//*[@id="password"]')

			; clear inputs
			_WD_ElementAction($sSession, $sUser, 'clear')
			_WD_ElementAction($sSession, $sPass, 'clear')
			WinSetTitle($ladocli, "",  "Ips: " & "Logeando")
			; Set element's contents (inputs y opt)
			_WD_ElementAction($sSession, $sUser, 'value', $username)
			_WD_ElementAction($sSession, $sPass, 'value', $Pass)
			_WD_ElementOptionSelect($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/div[1]/div[2]/form/select/option[1]')
			Sleep(500)

			; Click login button
			$sButton = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/div[1]/div[2]/form/input[4]')
			_WD_ElementAction($sSession, $sButton, 'click')
			Do
				$url = _WD_Action($sSession, "url")
				ConsoleWrite($url & @CRLF)
				Sleep(500)
			Until $url == "https://usuarios.telecentro.net.ar/home.php"
			WinSetTitle($ladocli, "",  "Ips: " & "loggin ok")
			; Navega a m5
			_WD_Navigate($sSession, "https://usuarios.telecentro.net.ar/scripts/postPerfilUrl.php?sistema=Infocall%203&perfil=OP-GGR-CEOP")
			_WD_LoadWait($sSession, 200)
			WinSetTitle($ladocli, "",  "Ips: " & "Navegando a i3")
			Do
				_WD_Navigate($sSession, "https://i3.telecentro.net.ar/leasesHistoricosFecha3.php")
				Sleep(500)
				$url = _WD_Action($sSession, "url")
			Until $url == "https://i3.telecentro.net.ar/leasesHistoricosFecha3.php"
			WinSetTitle($ladocli, "",  "Ips: " & "i3 ok")
			GUICtrlSetData($estado, "Hooked")


		Case $boton_add
			WinSetTitle($ladocli, "",  "Ips: " & "Agregando ips")
			_GUICtrlListView_DeleteAllItems($listado)
			$clientes_text = GUICtrlRead($clientes)
			stringero($clientes_text)
			WinSetTitle($ladocli, "",  "Ips: ")
;~ 						$clientes_text = StringStripWS($clientes_text,2)
;~ 			$clientes_array = StringSplit($clientes_text, @CRLF, 3)
;~ 			$s_array = _ArrayToString($clientes_array, "|")
;~ 			$s_array = StringReplace($s_array, "||", "|")
;~ 			$clientes_array = StringSplit($s_array, "|", 2)

			; -- auxiliar para ver si esta bien la fecha  -- 2021-01-26 23:40: 00          /[0-9]{4}|\/[0-9]{2}|\/[0-9]{2}|-[0-9]{2}|\:[0-9]{2}/
;			    5    10     15
;			300.315.329.333	2021-05-25 22:29
;			300.325.318.368	2021-05-29 5:24

;~ 			$str_fechaaux = StringRight($clientes_array[0], 19)
;~ 			if StringRegExp($str_fechaaux,"/[0-9]{4}|\/[0-9]{2}|\/[0-9]{2}|-[0-9]{2}|\:[0-9]{2}/") = 1 Then

			; end aux
;~ 			If $clientes_array[0] = "ips:" Then
;~ 				MsgBox(0, "Error", "Borra el 'ips:', ojo el formato")
;~ 			Else

;~ 				For $x In $clientes_array
;~ 					$str_ip = StringTrimRight($x, 17)
;~ 					$x = StringStripWS($x, 8)
;~ 					$x = StringReplace ($x, @TAB, " ")
;~ 					$array1 = StringSplit($x, " ")
;~ 					if StringLen($array1[3]) = 4 then $array1[3] = "0" & $array1[3]
;~ 					if StringLen($array1[3]) = 5 Then $array1[3] &= ":00"
;~ 					$array1[2] = $array1[2] & " " & $array1[3]

;~ 					_ArrayDisplay($array1)
;~ 					$str_fecha = StringRight($x, 19)


;~ 					$str_ip = $array1[1]
;~ 					$str_fecha = $array1[2]
;~ 					$digitos_ip = StringLen ( $str_ip )

;~ 					if StringMid($str_fecha,3,1) == "/" Then
;~ 						$str_hora = StringRight($str_fecha,8)
;~ 						$str_fecha = StringLeft($str_fecha,10)
;~ 						$aux_fecha = StringSplit($str_fecha,"/") ;-- [1] = dia; [2] = mes; [3] = año
;~ 						$str_fecha = $aux_fecha[3] & "-" & $aux_fecha[2] & "-" & $aux_fecha[1]
;~ 						$str_fecha = $str_fecha & " " & $str_hora
;~ 					EndIf
;~ 					if StringMid($str_fecha,5,1) == "/" Then
;~ 						StringReplace($str_fecha, "/", "-")
;~ 					EndIf
;~ 					$str_final = $str_ip & "|" & $str_fecha

;~ 				Next
;~ 			EndIf
;~ 			Else
;~ 			MsgBox(0, "Error en la fecha", "esta bien el formato? "& @CRLF &" AAAA-MM-DD HH:MM:SS" )
;~ 				EndIf

		Case $boton_clean
			WinSetTitle($ladocli, "",  "Ips: " & "Limpiando")
			GUICtrlSetData($clientes, "")
			filesfile()
			_GUICtrlListView_DeleteAllItems($listado)
			WinSetTitle($ladocli, "",  "Ips: ")
		Case $boton_go

			FileDelete(@ScriptDir & "\*.png")
			If GUICtrlRead($estado) = "Closed" Or GUICtrlRead($estado) = "UnHooked" Then
				MsgBox(0, "Error", "Abri el i3 primero")
			Else
				$restan_lv = _GUICtrlListView_GetItemCount($listado)
				If $restan_lv == 0 Then
					MsgBox(0, "Error", "Agrega clientes!")
				Else
					WinSetTitle($ladocli, "",  "Ips: " & "Empezando a buscar")
					$index1 = 0
					Do
							If $abortar = 1 Then
							; If it was then exit the function
							$abortar = 0
							MsgBox(0, "abortar", "saliendo",3)
							ExitLoop
						EndIf
					GUICtrlSetData($restantes, "Restantes: " & $index1 & "/" & $restan_lv)
;~ 					//*[@id="CM0"]/div[10]/div[1]/div/div[2]/div[8]/div[2]
;~ 						$i3_form = _IEFormGetCollection($oIE, 0)
;~ 						$i3_input = _IEFormElementGetObjByName($i3_form, "buscaCli")
;~ 						_IEFormElementSetValue($i3_input, _GUICtrlListView_GetItemText($listado, $index1, 0))
;~ 						_IEFormSubmit($i3_form)

						$inputarray = _GUICtrlListView_GetItemTextArray($listado, $index1)

						$inpt_ip = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/form/div/div/input[1]')
						_WD_ElementAction($sSession, $inpt_ip, 'value', $inputarray[1])

						$inpt_fecha = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/form/div/div/input[2]')
						_WD_ElementAction($sSession, $inpt_fecha, 'value', $inputarray[2])

							; Click buscar button
						$sButton = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/form/div/div/button')
						_WD_ElementAction($sSession, $sButton, 'click')			    ;/html/body/div[1]/form/div/div[1]/div/span/button    segunda vuelta
						_WD_LoadWait($sSession)
						#Region								ACA SACA EL LADO
						WinSetTitle($ladocli, "",  "Ips: " & "Buscando, puede tardar")
						_WD_LoadWaitDos($sSession, Default, 1000000000) ;; 10 000 = 10 segundos

						$ippublica = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/form/div/div/label[1]')
						Do
							$ippublica = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/form/div/div/label[1]')
						 $ippublicavalue = _WD_ElementAction($sSession, $ippublica, 'Text')
							ConsoleWrite(">"&$ippublicavalue&"<" & @CRLF)
							Sleep(500)
						Until $ippublicavalue == "    IP Publica          "

						WinSetTitle($ladocli, "",  "Ips: " & "Pegando resultado")
						Sleep(1000)
						Do
						$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/strong[1]') ;fecha mal
						if $sElement <> "" Then
							$sValue = _WD_ElementAction($sSession, $sElement, 'text')
							$LADO = StringStripWS($sValue, 1)
							ExitLoop
						EndIf
						$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/strong[2]') ;-- no se encontraron datos
						if $sElement <> "" Then
							$sValue = _WD_ElementAction($sSession, $sElement, 'text')
							$LADO = StringStripWS($sValue, 1)
							ExitLoop
						EndIf

						$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/table/tbody/tr[2]/td[1]')
						$sValue = _WD_ElementAction($sSession, $sElement, 'text')
									$LADO = StringStripWS($sValue, 1)
						$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/table/tbody/tr[2]/td[2]')
						$sValue = _WD_ElementAction($sSession, $sElement, 'text')
								$rsp_cliente = StringStripWS($sValue, 1)
						$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/table/tbody/tr[2]/td[3]')
						$sValue = _WD_ElementAction($sSession, $sElement, 'text')
								$rsp_direccion = StringStripWS($sValue, 1)
						$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/table/tbody/tr[2]/td[4]')
						$sValue = _WD_ElementAction($sSession, $sElement, 'text')
								$rsp_tel = StringStripWS($sValue, 1)
						$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/table/tbody/tr[2]/td[5]')
						$sValue = _WD_ElementAction($sSession, $sElement, 'text')
								$rsp_mac = StringStripWS($sValue, 1)
						$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/table/tbody/tr[2]/td[6]')
						$sValue = _WD_ElementAction($sSession, $sElement, 'text')
								$rsp_fechaent = StringStripWS($sValue, 1)
						$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/table/tbody/tr[2]/td[7]')
						$sValue = _WD_ElementAction($sSession, $sElement, 'text')
								$rsp_fechaact = $sValue
						WinSetTitle($ladocli, "",  "Ips: " & "Agregando a la lista")
						_GUICtrlListView_AddSubItem($listado, $index1, $rsp_cliente, 3)
						_GUICtrlListView_AddSubItem($listado, $index1, $rsp_direccion, 4)
						_GUICtrlListView_AddSubItem($listado, $index1, $rsp_tel, 5)
						_GUICtrlListView_AddSubItem($listado, $index1, $rsp_mac, 6)
						_GUICtrlListView_AddSubItem($listado, $index1, $rsp_fechaent, 7)
						_GUICtrlListView_AddSubItem($listado, $index1, $rsp_fechaact, 8)
						Until 1
						_GUICtrlListView_AddSubItem($listado, $index1, $LADO, 2)
						WinSetTitle($ladocli, "",  "Ips: " & "Sacando screenshot")
															; Take element screenshot
						$sResponse = _WD_Window($sSession, 'screenshot')
						$bDecode = __WD_Base64Decode($sResponse)

						$hFileOpen = FileOpen($index1&"_"&$LADO &".png", $FO_BINARY + $FO_OVERWRITE)
						FileWrite($hFileOpen, $bDecode)
						FileClose($hFileOpen)
						WinSetTitle($ladocli, "",  "Ips: " & "Agregando a zIP")
						_Zip_AddFile($Zip,@ScriptDir & "\"&$index1&"_"&$LADO &".png")

						$index1 = $index1 + 1
							_WD_Navigate($sSession, "https://i3.telecentro.net.ar/leasesHistoricosFecha3.php")
							_WD_LoadWait($sSession, 200)
					Until $index1 = $restan_lv
					#EndRegion ACA SACA EL LADO
					GUICtrlSetData($restantes, "Restantes: " & $restan_lv & "/" & $restan_lv)
					if $abortar = 1 Then
						MsgBox(0, "RDY", "Trabajo Abortado")
					Else
						MsgBox(0, "RDY", "El trabajo fue realizado.")
					EndIf
				EndIf
			EndIf
		Case $boton_copy
			;$sText &= "ip" & @TAB & "Fecha" & @TAB & "Cliente" & @TAB & "Nombre" & @TAB & "Dirección" & @TAB & "Teléfono" & @TAB & "Macaddress CM" & @TAB & "Fecha Entrega IP" & @TAB & "Fecha Activación CM" & @TAB & "" & @CRLF
			For $i = 0 To _GUICtrlListView_GetItemCount($listado) - 1
				FileWriteLine($table, "		<tr>		")
				for $j = 0 to 8
					FileWriteLine($table, "<td>" & _GUICtrlListView_GetItemText($listado, $i, $j) & "</td>")
				Next
				FileWriteLine($table, "		</tr>		")
			Next
			FileWriteLine($table, "	</table>			")
			FileWriteLine($table, "				")
			FileWriteLine($table, '	<input id="copy_btn" type="button" value="copy">			')
			FileWriteLine($table, "				")
			FileWriteLine($table, '	<script type="text/javascript">			')
			FileWriteLine($table, "		var copyBtn = document.querySelector('#copy_btn');		")
			FileWriteLine($table, "	copyBtn.addEventListener('click', function () {			")
			FileWriteLine($table, "	var urlField = document.querySelector('table');			")
			FileWriteLine($table, "				")
			FileWriteLine($table, "	// create a Range object			")
			FileWriteLine($table, "	var range = document.createRange();			")
			FileWriteLine($table, '	// set the Node to select the "range"			')
			FileWriteLine($table, "	range.selectNode(urlField);			")
			FileWriteLine($table, "	// add the Range to the set of window selections			")
			FileWriteLine($table, "	window.getSelection().addRange(range);			")
			FileWriteLine($table, "				")
			FileWriteLine($table, "	// execute 'copy', can't 'cut' in this case			")
			FileWriteLine($table, "	document.execCommand('copy');			")
			FileWriteLine($table, "	}, false);			")
			FileWriteLine($table, "	</script>			")
			FileWriteLine($table, "	</body>			")

				_WD_Navigate($sSession, "file:///" & StringReplace(@ScriptDir, "\", "/") & "/table.html")
				_WD_LoadWait($sSession, 200)
					WinSetState($chrome_handle, "", @SW_SHOW)
				$sButton = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/input')
						_WD_ElementAction($sSession, $sButton, 'click')
					WinSetState($chrome_handle, "", @SW_HIDE)
			MsgBox(0, "Copiado", "copia3")
			_WD_Navigate($sSession, "https://i3.telecentro.net.ar/leasesHistoricosFecha3.php")
							_WD_LoadWait($sSession, 200)
					FileClose($table)

	EndSwitch
WEnd


Func SetupChrome()
	Global $sDesiredCapabilities
;~ 	$_WD_DEBUG = $_WD_DEBUG_None
	$_WD_DEBUG = $_WD_DEBUG_Error
	_WD_Option('Driver', @ScriptDir & '\chromedriver.exe')
	_WD_Option('Port', 9515)
	_WD_Option('DriverParams', '--log-path="' & @ScriptDir & '\chromeIP.log"')
	$sDesiredCapabilities = '{"capabilities": {"alwaysMatch": {"goog:chromeOptions": {"w3c": true }}}}'
;~ 	$sDesiredCapabilities = '{"capabilities": {"alwaysMatch": {"goog:chromeOptions": {"w3c": true, "args": ["--headless", "--allow-running-insecure-content"] }}}}'
EndFunc   ;==>SetupChrome


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


func filesfile()

if FileExists(@ScriptDir & "\IPs.zip") Then
	FileDelete(@ScriptDir & "\IPs.zip")
	$Zip = _Zip_Create(@ScriptDir & "\IPs.zip")
Else
	$Zip = _Zip_Create(@ScriptDir & "\IPs.zip")
EndIf

Global $table = FileOpen(@ScriptDir & "\table.html", 2)

FileWriteLine($table, "	<html>			")
FileWriteLine($table, "	<head>			")
FileWriteLine($table, '	<style type="text/css">			')
FileWriteLine($table, "		table, th, td {		")
FileWriteLine($table, "	border: 2px solid black;			")
FileWriteLine($table, "	border-collapse: collapse;			")
FileWriteLine($table, '	font-family: "calibri";			')
FileWriteLine($table, "	font-size: 15px;			")
FileWriteLine($table, "	}			")
FileWriteLine($table, "	th, td {			")
FileWriteLine($table, "	padding: 2.5px;			")
FileWriteLine($table, "	text-align: center;			")
FileWriteLine($table, "	}			")
FileWriteLine($table, "	th {			")
FileWriteLine($table, "	background-color: #e6e6e6;			")
FileWriteLine($table, "	color: black;			")
FileWriteLine($table, "	}			")
FileWriteLine($table, "	</style>			")
FileWriteLine($table, "	</head>			")
FileWriteLine($table, "	<body>			")
FileWriteLine($table, '	<table cellspacing="0" cellpadding="0" border="1" style="table-layout: fixed; font-size: 10pt; font-family: arial; width: 0px; border-collapse: collapse; border: none;">	')
FileWriteLine($table, ' <colgroup>	')
FileWriteLine($table, ' <col width="305">	')
FileWriteLine($table, ' <col width="156">	')
FileWriteLine($table, ' <col width="173">	')
FileWriteLine($table, ' <col width="283">	')
FileWriteLine($table, ' <col width="416">	')
FileWriteLine($table, ' <col width="110">	')
FileWriteLine($table, ' <col width="142">	')
FileWriteLine($table, ' <col width="158">	')
FileWriteLine($table, ' <col width="158">	')
FileWriteLine($table, '	</colgroup>		')
FileWriteLine($table, "		<tr>		")
FileWriteLine($table, "			<th> IP </th>	")
FileWriteLine($table, "			<th> Fecha </th>	")
FileWriteLine($table, "			<th> Cliente </th>	")
FileWriteLine($table, "			<th> Nombre </th>	")
FileWriteLine($table, "			<th> Dirección </th>	")
FileWriteLine($table, "			<th> Teléfono </th>	")
FileWriteLine($table, "			<th> Macadress CM </th>	")
FileWriteLine($table, "			<th> Fecha Entrega IP </th>	")
FileWriteLine($table, "			<th> Fecha Activación CM </th>	")
FileWriteLine($table, "		</tr>		")
EndFunc

func stringero($clip)
$ip = 0
$fecha = 0
$hora = 0
			$ipv6reg = "^([[:xdigit:]]{1,4}(?::[[:xdigit:]]{1,4}){7}|::|:(?::[[:xdigit:]]{1,4}){1,6}|[[:xdigit:]]{1,4}:(?::[[:xdigit:]]{1,4}){1,5}|(?:[[:xdigit:]]{1,4}:){2}(?::[[:xdigit:]]{1,4}){1,4}|(?:[[:xdigit:]]{1,4}:){3}(?::[[:xdigit:]]{1,4}){1,3}|(?:[[:xdigit:]]{1,4}:){4}(?::[[:xdigit:]]{1,4}){1,2}|(?:[[:xdigit:]]{1,4}:){5}:[[:xdigit:]]{1,4}|(?:[[:xdigit:]]{1,4}:){1,6}:)$"
			$ipv4reg = "^(?:25[0-5]|2[0-4]\d|[0-1]?\d{1,2})(?:\.(?:25[0-5]|2[0-4]\d|[0-1]?\d{1,2})){3}$"
    ; Create a GUI with various controls.

;~ 		if StringRegExp( $clip, "[a-zA-Z]" ) = 1 Then
;~ 			MsgBox(0, "Error", "Error con las IPs puestas, parece que hay alguna letra que no tendria que estar" )
;~ 			Return 0
;~ 		EndIf

;~ $clip = StringRegExpReplace ( $clip, "[a-zA-Z]", "")
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
		;----- chequeo si es ipv4 o ipv6

;~ 		_ArrayDisplay($array1)
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

				if StringRegExp ( $else_ip, $ipv4reg ) = 0 Or StringRegExp ( $else_ip, $ipv6reg ) Then
					$ip = InputBox("IP erronea:", "No puedo identificar esta ip, ponela abajo: " & @CRLF & ">" & $else_ip &"<")
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

func Abortar()
	if $abortar = 1 Then
		$abortar = 0
	Else
		$abortar = 1
	EndIf
EndFunc


Func _WD_LoadWaitDos($sSession, $iDelay = Default, $iTimeout = Default, $sElement = Default)
	Local Const $sFuncName = "_WD_LoadWaitDos"
	Local $iErr, $sResponse, $oJSON, $sReadyState

	If $iDelay = Default Then $iDelay = 0
	If $iTimeout = Default Then $iTimeout = $_WD_DefaultTimeout
	If $sElement = Default Then $sElement = ""

	If $iDelay Then __WD_SleepDos($iDelay)

	If @error Then
		$iErr = $_WD_ERROR_UserAbort
	Else
		Local $hLoadWaitTimer = TimerInit()

		While True
			If $sElement <> '' Then
				_WD_ElementAction($sSession, $sElement, 'name')

				If $_WD_HTTPRESULT = $HTTP_STATUS_NOT_FOUND Then $sElement = ''
			Else
				$sResponse = _WD_ExecuteScript($sSession, 'return document.readyState', '')
				$iErr = @error

				If $iErr Then
					ExitLoop
				EndIf

				$oJSON = Json_Decode($sResponse)
				$sReadyState = Json_Get($oJSON, "[value]")

				If $sReadyState = 'complete' Then ExitLoop
			EndIf

			If (TimerDiff($hLoadWaitTimer) > $iTimeout) Then
				$iErr = $_WD_ERROR_Timeout
				ExitLoop
			EndIf

			__WD_SleepDos(100)

			If @error Then
				$iErr = $_WD_ERROR_UserAbort
				ExitLoop
			EndIf
		WEnd
	EndIf

	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $iErr, ""), 0, 0)
	EndIf

	Return SetError($_WD_ERROR_Success, 0, 1)
EndFunc   ;==>_WD_LoadWait

Func __WD_SleepDos($iPause)
$iPause = $iPause / 1000
For $auxsleep = 0 to $iPause
		Sleep(1000)
		ToolTip($auxsleep)
		if $abortar = 1 then ExitLoop
	Next
	If @error Then SetError($_WD_ERROR_Timeout)
EndFunc ;==>__WD_SleepDos
