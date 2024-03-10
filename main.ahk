#Requires AutoHotkey v2.0

#Include "topics.ahk"

#SingleInstance force
SetTitleMatchMode 3


; activateTopic() {
;     if WinActive(newTopic) {
;         WinMinimize()
;     } else {
;         try {
;             WinActivate(newTopic)
;         } catch {
;             MsgBox newTopic, "TOPICS", "T2"
;         }
;     }
; }

; nextTopic() {
;     global
;     loop {
;         local i := Random(1, topicsLen)
;         newTopic := topics[i]
;     } until (newTopic != prevTopic)
;     prevTopic := newTopic
;     activateTopic()
; }

; clearTopic() {
;     global
;     newTopic := ''
;     prevTopic := ''
;     nextTopic()

; }

workableData := { data: unworkableData, length: unworkableData.Length }

for index, value in workableData.data
{
    if (IsObject(value)) {
        value.len := value.data.Length
    }
}

MsgBox(workableData.data[4].len)

; NumpadPgdn:: clearTopic()
; NumpadEnter:: nextTopic()
; NumpadDel:: activateTopic()
