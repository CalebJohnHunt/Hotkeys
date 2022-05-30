#SingleInstance Force

_VIEW_runAndFocus(execPath, title, extitle) {
  foo := A_DetectHiddenWindows
  DetectHiddenWindows(false)
  Run(execPath)
  ; Make sure the window opened. If so, focus on it.
  ; If not, no stress. It was probably focused on by default anyway.
  if (WinWait(title,, 1, extitle))
    WinActivate(title,, extitle)
  else {
    ; setTempToolTip(title . " window not found")
    ; LOGGER.append('Could not find title: ' . title . '(A title)  after 1 second')
  }
  DetectHiddenWindows(foo)
}

VIEW_toggle(execPath, title, extitle := '') {
  if (WinExist(title,, extitle)) {
    WinClose(title,,, extitle)
    return
  }
  _VIEW_runAndFocus(execPath, title, extitle)
}

