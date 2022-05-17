;~ #include <\UDF\wd_helper.au3>
#include <D:\bkaup win 10\trabajo\UDF\wd_core.au3> ; - https://github.com/Danp2/au3WebDriver ty dan2p
#include <D:\bkaup win 10\trabajo\UDF\wd_helper.au3> ; - https://github.com/Danp2/au3WebDriver ty dan2p
#include <Inet.au3>


;~ _WD_UpdateDriver('chrome')

					$string = String(_INetGetSource("https://raw.githubusercontent.com/JackER4565/ips/main/version.txt"))
					$pos = StringInStr($string, "ips-ver: ")
					$ipsver = StringMid($string, $pos+9, 7)
					$pos = StringInStr($string, "ips-do: ")
					$dover = StringMid($string, $pos+8, 7)

					$exever = FileGetVersion(@ScriptDir & "\ips i3-ver2.exe")
					$exedo = FileGetVersion(@ScriptDir & "\ips-do.exe")

					MsgBox(0, "ver2", ">"&$ipsver &"<" & @CRLF &">"&$exever &"<" )
					MsgBox(0, "do2", ">"&$dover &"<" & @CRLF &">"&$exedo &"<" )
;~ 					if
					$sTempFileDos = _TempFile(@TempDir, "ipsupdateDO_", ".exe")
					$sTempFile = _TempFile(@TempDir, "ipsupdateVer_", ".exe")
					_WD_DownloadFile("https://github.com/JackER4565/ips/raw/main/ips%20i3-ver2.exe", $sTempFile)
					_WD_DownloadFile("https://github.com/JackER4565/ips/raw/main/ips-do.exe", $sTempFileDos)
					Local $oShell = ObjCreate("Shell.Application")
					$oNameSpace_Install = $oShell.NameSpace(@ScriptDir)
					FileDelete(@ScriptDir & "ips-do.exe")
					FileDelete(@ScriptDir & "ips i3-ver2.exe")

						$oNameSpace_Install.CopyHere($sTempFile, 20)     ; 20 = (4) Do not display a progress dialog box. + (16) Respond with "Yes to All" for any dialog box that is displayed.
						$oNameSpace_Install.CopyHere($sTempFileDos, 20)     ; 20 = (4) Do not display a progress dialog box. + (16) Respond with "Yes to All" for any dialog box that is displayed.