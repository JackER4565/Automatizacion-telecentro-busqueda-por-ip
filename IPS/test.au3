; TEST EXPRESIONES REGULARES DE IP

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <array.au3>

stringero()

func stringero()
$ip = 0
$fecha = 0
$hora = 0
			$ipv6reg = "/^([[:xdigit:]]{1,4}(?::[[:xdigit:]]{1,4}){7}|::|:(?::[[:xdigit:]]{1,4}){1,6}|[[:xdigit:]]{1,4}:(?::[[:xdigit:]]{1,4}){1,5}|(?:[[:xdigit:]]{1,4}:){2}(?::[[:xdigit:]]{1,4}){1,4}|(?:[[:xdigit:]]{1,4}:){3}(?::[[:xdigit:]]{1,4}){1,3}|(?:[[:xdigit:]]{1,4}:){4}(?::[[:xdigit:]]{1,4}){1,2}|(?:[[:xdigit:]]{1,4}:){5}:[[:xdigit:]]{1,4}|(?:[[:xdigit:]]{1,4}:){1,6}:)$/gm"
			$ipv4reg = "^(?:25[0-5]|2[0-4]\d|[0-1]?\d{1,2})(?:\.(?:25[0-5]|2[0-4]\d|[0-1]?\d{1,2})){3}$"
    ; Create a GUI with various controls.
    Local $hGUI = GUICreate("Example", 1000,500)

	$label = GUICtrlCreateLabel("",1,1,500,100)

	$label2 = GUICtrlCreateLabel("", 1, 101,500,100)
    GUISetState(@SW_SHOW)

		$clip = ClipGet()
GUICtrlSetData($label, $clip)

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
		$clip = StringStripWS($clip, 7)
		_ArrayDelete($array1, 0)
		;----- chequeo si es ipv4 o ipv6


		for $i = 0 to UBound($array1) -1
			MsgBox(0, "$i del for", $i)
			$string = $array1[$i]
			$string = StringRegExpReplace($string, @TAB, " ")

	if StringInStr($string, "-") Then
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
				$hora = $stringsplit[0]
			Case 2
				$fecha = $stringsplit[0]
				$hora = $stringsplit[1]
			Case 3
				$ip = $stringsplit[0]
				$fecha = $stringsplit[1]
				$hora = $stringsplit[2]
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
					$hora = $else_hora
				EndIf



		EndSwitch
;~ 			MsgBox(0, "asdtest", "ip: "& $ip & @CRLF & "fecha: "& $fecha & @CRLF & "hora: "&$hora)
	Else ; esto es por que SI es una ip sola
				if StringRegExp ( $string, $ipv4reg ) = 1 Or StringRegExp ( $string, $ipv6reg ) = 1 Then ; ip
					$ip = $string
				Elseif StringRegExp ( $string, "^\d{4}\-\d{2}\-\d{2}$" ) = 1 Then ; fecha
					$fecha = $string
				Elseif StringRegExp ( $string, "^\d{2}\:\d{2}\:\d{2}$" ) = 1 Then ; hora
					$hora = $string
				Else
					msgBox(0, "Cadena erronea:", "No puedo identificar esto: " & @CRLF & $string & @CRLF & @CRLF & "Probemos copiando de nuevo")
					$ip = InputBox("IP", "Pega la ip aca")
					$fecha = InputBox("FECHA", "Pega la fecha aca")
					$hora = InputBox("HORA", "Pega la hora aca")
				EndIf

	EndIf

		GUICtrlSetData($label2, "ip: "& $ip & @CRLF & "fecha: "& $fecha & @CRLF & "hora: "&$hora)
		Next
EndFunc
