$string = InputBox("asd", "asd")
if StringRegExp ( $string, "^\d{2}(\:|\-)\d{2}(\:|\-)\d{4}$" ) = 1 Then
	MsgBox(0, "1", "1")
					$string = StringReplace($string, ":", "-")
					MsgBox(0, $string, $string)
					$str_arr = StringSplit($string, "-")
    $string = StringFormat("%04i-%02i-%02i", $str_arr[3], $str_arr[2], $str_arr[1])
MsgBox(0, $string, $string)
EndIf

