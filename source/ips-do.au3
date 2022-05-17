#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=extras\toolbox.ico
#AutoIt3Wrapper_Res_Fileversion=0.0.0.8
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
;~ #include <_ErrorHandler.au3>
;~ #include <\UDF\wd_helper.au3> ; - https : / / github.com / Danp2 / au3WebDriver ty dan2p
#include <D:\bkaup win 10\trabajo\UDF\wd_core.au3> ; - https://github.com/Danp2/au3WebDriver ty dan2p
#include <D:\bkaup win 10\trabajo\UDF\wd_helper.au3> ; - https://github.com/Danp2/au3WebDriver ty dan2p
#include <zip.au3>
#include <INet.au3>
#include <Crypt.au3>

Global $Zip, $table, $abortar = ControlGetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]")
filesfile()

_WD_UpdateDriver('chrome')
_WD_GetWebDriverVersion(@ScriptDir, '\extras\chromedriver.exe')
_WD_GetBrowserVersion('chrome')

;~ 					$sTempFile = _TempFile(@TempDir, "ipsupdate_", ".exe")
;~ 					_WD_DownloadFile("https://github.com/JackER4565/ips/raw/main/ips%20i3.exe", $sTempFile)

;~ 					Local $oShell = ObjCreate("Shell.Application")
;~ 					$oNameSpace_Install = $oShell.NameSpace(@ScriptDir)
;~ 					FileDelete(@ScriptDir & $sDriverEXE)
;~ 						$oNameSpace_Install.CopyHere($sTempFile, 20)     ; 20 = (4) Do not display a progress dialog box. + (16) Respond with "Yes to All" for any dialog box that is displayed.

#Region chrome
Local $sDesiredCapabilities, $sSession, $inpt_clnt, $sElement, $sButton, $sValue, $sUser, $sPass, $chrome_handle, $hndl

Call(SetupChrome)
global $wd_pid = _WD_Startup()

If @error <> $_WD_ERROR_Success Then
	ControlSetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]", "Error al iniciar Chromedriver")
	Exit -1
EndIf

#EndRegion chrome
$index1 = 0


#Region	 ###### FILE READ
$file_to_array = FileReadToArray("ips.txt")
if @error Then
	ControlSetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]", "Error al iniciar Chromedriver")
	exit -1
EndIf
$restan_lv = UBound($file_to_array)
$result = StringInStr($file_to_array[0], "|", 0, 2) ; si da 0 hay un solo |, si da otra cosa hay mas de un |
_ArrayColInsert($file_to_array, 1)
_ArrayColInsert($file_to_array, 2)
_ArrayColInsert($file_to_array, 3)
_ArrayColInsert($file_to_array, 4)
_ArrayColInsert($file_to_array, 5)
_ArrayColInsert($file_to_array, 6)
_ArrayColInsert($file_to_array, 7)
_ArrayColInsert($file_to_array, 8)
If $result <> 0 Then
	; si hay un solo | es ip y fecha, la primera vez
	; si hay mas de un | es por que ya paso

	For $x = 0 To UBound($file_to_array) - 1
		If StringInStr($file_to_array[$x][0], "|", 0, 2) = 0 Then
			$index1 = $x
			ExitLoop
		Else
			_ArrayInsert($file_to_array, $x, $file_to_array[$x][0])
			_ArrayDelete($file_to_array, $x + 1)
		EndIf
	Next
EndIf

; aca tengo que ver si ya se hizo antes
#EndRegion	 ###### FILE READ
#Region Openchrome
$dEncrypted = IniRead(@ScriptDir & "\extra\config.ini", "config", "NoeslaPassword", "0")
if $dEncrypted = 0 Then
	ControlSetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]", "Error al leer la password")
	exit -1
EndIf
Local $sDecrypted = StringEncrypt(False, $dEncrypted, 'securepassword')
$Pass = $sDecrypted
$username = IniRead(@ScriptDir & "\extra\config.ini", "config", "Username", "0")
if $username = 0 Then
	ControlSetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]", "Error al leer el usuario")
	exit -1
EndIf
Sleep(1000)
$sSession = _WD_CreateSession($sDesiredCapabilities)
if @error <> $_WD_ERROR_Success Then
	ControlSetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]", "Error al crear session.")
	exit -1
EndIf
$chrome_handle = WinWait("data:, - Google Chrome", "")
IniWrite(@ScriptDir & "\extra\config.ini", "Chrome","chrome_handle", String($chrome_handle))
WinSetState($chrome_handle, "", @SW_MAXIMIZE)
			WinSetState($chrome_handle, "", @SW_HIDE)
_WD_LoadWait($sSession)
; NAVEGA A USUARIOS ###
_WD_Navigate($sSession, "https://usuarios.telecentro.net.ar/logIn.php")
if @error <> $_WD_ERROR_Success Then
	ControlSetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]", "Error al navegar a usuarios.")
	exit -1
EndIf
; Locate elements (inputs)
$sUser = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '//*[@id="usuario"]')
$sPass = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '//*[@id="password"]')

; clear inputs
_WD_ElementAction($sSession, $sUser, 'clear')
_WD_ElementAction($sSession, $sPass, 'clear')
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
_WD_Navigate($sSession, "https://usuarios.telecentro.net.ar/scripts/postPerfilUrl.php?sistema=Infocall%203&perfil=OP-GGR-CEOP")
_WD_LoadWait($sSession, 200)
Do
	_WD_Navigate($sSession, "https://i3.telecentro.net.ar/leasesHistoricosFecha3.php")
	if @error <> $_WD_ERROR_Success Then
	ControlSetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]", "Error al navegar a i3.")
	exit -1
EndIf
	Sleep(500)
	$url = _WD_Action($sSession, "url")
Until $url == "https://i3.telecentro.net.ar/leasesHistoricosFecha3.php"
#EndRegion Openchrome

#Region GOO

FileDelete(@ScriptDir & "\screens\*.png")

$salirr = 0
Do
	$abortar = ControlGetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]")
	If $abortar = "Abortando" Then
		; If it was then exit the function
		$abortar = 0
		MsgBox(0, "abortar", "saliendo", 3)
		ExitLoop
	EndIf
		if $abortar = "Skip" Then
			$salirr = 7
			ControlSetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]", "Buscando")
		EndIf
	;~ 					//*[@id="CM0"]/div[10]/div[1]/div/div[2]/div[8]/div[2]
;~ 						$i3_form = _IEFormGetCollection($oIE, 0)
;~ 						$i3_input = _IEFormElementGetObjByName($i3_form, "buscaCli")
;~ 						_IEFormElementSetValue($i3_input, _GUICtrlListView_GetItemText($listado, $index1, 0))
;~ 						_IEFormSubmit($i3_form)

	$inputarray = StringSplit($file_to_array[$index1][0], "|")
	$file_to_array[$index1][0] = $inputarray[1]
	$file_to_array[$index1][1] = $inputarray[2]
	$inpt_ip = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/form/div/div/input[1]')
	_WD_ElementAction($sSession, $inpt_ip, 'value', $inputarray[1])

	$inpt_fecha = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/form/div/div/input[2]')
	_WD_ElementAction($sSession, $inpt_fecha, 'value', $inputarray[2])


	#Region								ACA SACA EL LADO
;~ 						_WD_LoadWaitDos($sSession, Default, 1000000000) ;; 10 000 = 10 segundos

	Do
		$abortar = ControlGetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]")
		If $abortar = "Abortando" Then
			; If it was then exit the function
			$abortar = 0
			MsgBox(0, "abortar", "saliendo", 3)
			ExitLoop 1
		EndIf
		if $abortar = "Skip" Then
			$salirr = 7
			ControlSetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]", "Buscando")
		EndIf
		$salirr = $salirr + 1
		; Click buscar button
		$sButton = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/form/div/div/button')
		_WD_ElementAction($sSession, $sButton, 'click')                                ;/html/body/div[1]/form/div/div[1]/div/span/button    segunda vuelta
		While 1
			$sResponse = _WD_ExecuteScript($sSession, 'return document.readyState', '')
			$iErr = @error
			ConsoleWrite("############################# ERROR: " & @error & @CRLF & "Response: " & $sResponse & " #############################" & @CRLF)
;~ 							$_WD_ERROR_Success
;~ 							If $iErr = $_WD_ERROR_Success Then
;~ 							ExitLoop
;~ 							EndIf
			$abortar = ControlGetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]")
			If $abortar = "Abortando" Then
				; If it was then exit the function
				$abortar = 0
				MsgBox(0, "abortar", "saliendo", 3)
				ExitLoop 2
			EndIf
					if $abortar = "Skip" Then
						$salirr = 7
						ControlSetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]", "Buscando")
						ExitLoop
					EndIf
			$oJSON = Json_Decode($sResponse)
			$sReadyState = Json_Get($oJSON, "[value]")
			Sleep(100)
			If $sReadyState = 'complete' Then ExitLoop
		WEnd
		Sleep(1000)
		$noseencuentrandatos = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/strong')                 ;-- este es no se encuentran datos o fecha incorrecta
		$tablacorrecta = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/table')                 ; si hay tabla, hay resultado
		Sleep(500)
		If $salirr > 6 Then
			ExitLoop
		EndIf
	Until $noseencuentrandatos <> "" Or $tablacorrecta <> ""

	Sleep(1000)
	Do
		If $salirr > 6 Then
			$LADO = "Se busco ip 5 veces sin traer info, probar manualmente"
			ExitLoop
		EndIf
		$sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, '/html/body/div/strong')                 ;fecha mal // no se encuentran datos
		If $sElement <> "" Then
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
		$file_to_array[$index1][3] = $rsp_cliente
		$file_to_array[$index1][4] = $rsp_direccion
		$file_to_array[$index1][5] = $rsp_tel
		$file_to_array[$index1][6] = $rsp_mac
		$file_to_array[$index1][7] = $rsp_fechaent
		$file_to_array[$index1][8] = $rsp_fechaact
	Until 1
	$file_to_array[$index1][2] = $LADO
	$filearraywrite = $file_to_array[$index1][0] & "|" & $file_to_array[$index1][1] & "|" & $file_to_array[$index1][2] & "|" & $file_to_array[$index1][3] & "|" & $file_to_array[$index1][4] & "|" & $file_to_array[$index1][5] & "|" & $file_to_array[$index1][6] & "|" & $file_to_array[$index1][7] & "|" & $file_to_array[$index1][8]
	;------ llena las ips del txt
	$filearraybackup = FileReadToArray("ips.txt")
	$fileopen = FileOpen("ips.txt", 2)
	For $j = 0 To UBound($filearraybackup) - 1
		If $j = $index1 Then
			FileWriteLine($fileopen, $filearraywrite)
		Else
			FileWriteLine($fileopen, $filearraybackup[$j])
		EndIf
	Next

	FileClose($fileopen)
	; Take element screenshot
	$sResponse = _WD_Window($sSession, 'screenshot')
	$bDecode = __WD_Base64Decode($sResponse)

	$hFileOpen = FileOpen(@ScriptDir & "\screens\" & $index1 & "_" & $LADO & ".png", $FO_BINARY + $FO_OVERWRITE)
	FileWrite($hFileOpen, $bDecode)
	FileClose($hFileOpen)

	_Zip_AddFile($Zip, @ScriptDir & "\screens\" & $index1 & "_" & $LADO & ".png")
	#Region tabla.html #############
	FileWriteLine($table, "		<tr>		")
	For $j = 0 To 8
		FileWriteLine($table, "<td>" & $file_to_array[$index1][$j] & "</td>")
	Next
	FileWriteLine($table, "		</tr>		")

	#EndRegion tabla.html #############
	$index1 = $index1 + 1
	_WD_Navigate($sSession, "https://i3.telecentro.net.ar/leasesHistoricosFecha3.php")
	_WD_LoadWait($sSession, 200)
	$salirr = 0
Until $index1 = $restan_lv
#EndRegion								ACA SACA EL LADO
$abortar = ControlGetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]")
If $abortar = "Abortando" Then
	FileWriteLine($table, "	</table>			")
	FileWriteLine($table, "				")
	FileWriteLine($table, '	<input id="copy_btn" type="button" value="C O P I A R  y  C E R R A R" style="width:100%;height:25%;position:absolute;bottom:3px;background-color: #0c6460;">		')
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
	FileWriteLine($table, "	window.close();				")
	FileWriteLine($table, "	}, false);			")
	FileWriteLine($table, "	</script>			")
	FileWriteLine($table, "	</body>			")
	MsgBox(0, "RDY", "Trabajo Abortado")
Else
	FileWriteLine($table, "	</table>			")
	FileWriteLine($table, "				")
	FileWriteLine($table, '	<input id="copy_btn" type="button" value="C O P I A R  y  C E R R A R" style="width:100%;height:25%;position:absolute;bottom:3px;background-color: #0c6460;">			')
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
	FileWriteLine($table, "	window.close();				")
	FileWriteLine($table, "	}, false);			")
	FileWriteLine($table, "	</script>			")
	FileWriteLine($table, "	</body>			")
	MsgBox(0, "RDY", "El trabajo fue realizado.")
EndIf
#EndRegion GOO
ControlSetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]", "Finalizado")

_WD_DeleteSession($sSession)
_WD_Shutdown($wd_pid)
Exit


Func SetupChrome()
	Global $sDesiredCapabilities
;~ 	$_WD_DEBUG = $_WD_DEBUG_None
	$_WD_DEBUG = $_WD_DEBUG_Error
	_WD_Option('Driver', @ScriptDir & '\extras\chromedriver.exe')
	_WD_Option('Port', 9515)
	 _WD_Option('DriverDetect', False)
	_WD_Option('DriverParams', '--log-path="' & @ScriptDir & '\extras\chromeIP.log"')
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


Func filesfile()

	If FileExists(@ScriptDir & "\screens\IPs.zip") Then
		FileDelete(@ScriptDir & "\screens\IPs.zip")
		$Zip = _Zip_Create(@ScriptDir & "\screens\IPs.zip")
	Else
		$Zip = _Zip_Create(@ScriptDir & "\screens\IPs.zip")
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
EndFunc   ;==>filesfile


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
EndFunc   ;==>_WD_LoadWaitDos

Func __WD_SleepDos($iPause)
	$iPause = $iPause / 1000
	For $auxsleep = 0 To $iPause
		Sleep(1000)
		ToolTip($auxsleep)
		$abortar = ControlGetText("Ips:", "G0", "[CLASS:Static; INSTANCE:2]")
		If $abortar = "Abortando" Then ExitLoop
	Next
	If @error Then SetError($_WD_ERROR_Timeout)
EndFunc   ;==>__WD_SleepDos

