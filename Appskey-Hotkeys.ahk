#SingleInstance Force
#Include libs\VIEW.ahk

; Program Tools
AppsKey & x::ExitApp()
A_IconTip := 'AppsKey + x to exit'

; Development tools
AppsKey & r::Reload()
AppsKey & F1::Run(A_ProgramFiles '\AutoHotkey\AutoHotkey.chm') ; Opens AutoHotkey Help file

; Consts

; Globals
enabled := true

/******\
| Tray |
\******/

tray := A_TrayMenu
tray.Delete() ; Clear menu
;TraySetIcon('Icon.png')
;Menu, Tray, Tip, AppsKey + x To Exit
tray.Add('Enable app', toggle_app)
tray.Default := 'Enable App'
tray.Check('Enable app')
tray.Add('Reload', reload_app)
tray.Add('Exit', exit_app)

toggle_app(ItemName, ItemPos, MyMenu) {
  global enabled := !enabled

  if (enabled)
    MyMenu.Check(ItemName)
  else
    MyMenu.Uncheck(ItemName)
}

exit_app(_1, _2, _3) {
  ExitApp()
}

reload_app(_1, _2, _3) {
  Reload()
}

/**********\
| Disabled |
\**********/

#HotIf !enabled ; Can only be used when app is not Enabled
; Allows AppsKey to be used normally 
AppsKey::SendInput('{AppsKey}')
#HotIf ; End of If !Enabled

/*********\
| Hotkeys |
\*********/

#HotIf enabled ; App must be enabled to use these hotkeys

AppsKey & m:: {
  ih := InputHook()
  ih.KeyOpt('{All}', 'E')
  ih.Start()
  ih.Wait()
  if (ih.EndReason !== 'EndKey') {
    return
  }
  sendChar := ih.EndKey
  ih := InputHook('L2 T3', '{ESC}')
  ih.Start()
  ih.Wait()
  try 
    num := Integer(ih.Input)
  catch TypeError
    return
  Send('{' sendChar ' ' num '}')
}

; Testing
AppsKey & F2::return

; Mouse
; Move pixel-by-pixel
AppsKey & Numpad4:: {
  MouseMove(-1 * (GetKeyState("RAlt") ? 10 : 1) * (GetKeyState("Ctrl") ? 10 : 1), 0,, 'R')
}
AppsKey & Numpad8:: {
  MouseMove(0, -1 * (GetKeyState("RAlt") ? 10 : 1) * (GetKeyState("Ctrl") ? 10 : 1),, 'R')
}

AppsKey & Numpad6:: {
  MouseMove(1 * (GetKeyState("RAlt") ? 10 : 1) * (GetKeyState("Ctrl") ? 10 : 1), 0,, 'R')
}

AppsKey & Numpad2:: {
  MouseMove(0, 1 * (GetKeyState("RAlt") ? 10 : 1) * (GetKeyState("Ctrl") ? 10 : 1),, 'R')
}

; Click
AppsKey & Numpad1::MouseClick('Left')
AppsKey & Numpad3::MouseClick('Right')

; Hold down left click
AppsKey & Numpad7::MouseClick('Left',,,,,'D')
; Release left click
AppsKey & Numpad9::MouseClick('Left',,,,,'U')

; Left and right scroll
AppsKey & WheelUp::MouseClick('WheelLeft')
AppsKey & WheelDown::MouseClick('WheelRight')

/*
; Idle Timer
AppsKey & Numpad5:: ; Toggle No_Idle timer
SetTimer, No_Idle, % (idleTimer ? "OFF" : 1000)
idleTimer := !idleTimer
return
*/

; Volume controls
AppsKey & ,::SendInput('{Volume_Down}')
AppsKey & .::SendInput('{Volume_Up}')
AppsKey & /::SendInput('{Volume_Mute}')

; Music controls
AppsKey & `;::SendInput('{Media_Prev}')
AppsKey & '::SendInput('{Media_Next}')
AppsKey & Space:: {
  ; This is the more general one. It will stop YouTube videos as well.
  if (GetKeyState("RAlt")) {
    SendInput('{Media_Play_Pause}')
    return
  }
  ; Specific to Spotify. Will only play/pause spotify
  id := WinGetId('ahk_class Chrome_WidgetWin_0 ahk_exe Spotify.exe')
  ; DetectHiddenWindows On
  PostMessage(0x319,, 0xE0000,, 'ahk_id ' id) ; msg: WM_APPCOMMAND - lParam: 14 APPCOMMAND_MEDIA_PLAY_PAUSE
}

; Date
AppsKey & d::Send(A_YYYY "-" A_MM "-" A_DD)
AppsKey & t::Send(FormatTime(, 'hh:mm tt'))

; Files
AppsKey & e::Run('Explorer.exe ' A_ScriptDir)
AppsKey & s::Run('Explorer.exe G:\My Drive\BYU')
; AppsKey & c::Run('C:\Users\Caleb\AppData\Local\Programs\Microsoft VS Code\Code.exe ' A_ScriptDir '\' A_ScriptName)

/*
; Make new .txt file
AppsKey & t:: {
  if WinActive("ahk_exe Explorer.EXE ahk_class CabinetWClass") {
    Send('!h')
    Send('!w')
    Send('{down 6}')
    Send('{enter}')
  }
}
*/

/*
; Disable active window
AppsKey & d::WinSetEnabled(false, 'A')
AppsKey & e::WinSetEnabled(true, 'A')
*/

; Always on top
AppsKey & a::WinSetAlwaysOnTop((GetKeyState("Shift") ? false : true), 'A')

; Open Programs
; Browser
AppsKey & b::Run('Chrome.exe')
; Notepad++
Appskey & n::Run('Notepad++.exe')
; Python
Appskey & p::Run('Py')
; Ubuntu
Appskey & u::Run('ubuntu')


; Text shortcuts
AppsKey & [:: {
  IH := InputHook("L5T3",, "shrug")
  IH.Start()
  IH.Wait()
  if (IH.EndReason == "Match")
    Switch IH.Match {
      Case "shrug":
        Send('¯\_(ツ)_/¯')
  }
  else {
    ; ER := IH.EndReason
    ; ToolTip, %ER%,,, 10
    ; Sleep, 1000
    ; rm_tt(10)
  }
}

tgPath := 'C:\Users\Caleb\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Telegram Desktop\Telegram'
tgTitle := 'Telegram'
tgExtitle := 'Desktop'
#Numpad2::VIEW_toggle(tgPath, tgTitle, tgExtitle)
#NumpadDown::VIEW_toggle(tgPath, tgTitle, tgExtitle)

#HotIf ; End of If Enabled

; ******************************************** ;


; ******************************************** ;
/*
; Remove ToolTip
rm_tt(tn:=1, delay_:=0) { ; tn = tooltip number
  Sleep, %delay_%
  ToolTip,,,,%tn%
  return
}
 */