#Requires AutoHotkey v2.0

#Include "topics.ahk"

#SingleInstance force
SetTitleMatchMode 3

A_ScriptName := "Study"
A_IconTip := "Study"

iconPath := "C:\Users\aless\Desktop\projects\personal\ahk\study-win\tray-icon.ico"
TraySetIcon iconPath


hooks := {
    hook1: "", hook2: "" }

loadPrevious()
loadHooks()

activateTopic(topicName) {

    try {
        WinActivate(topicName)
    } catch {
        if topicName == hooks.hook1 || topicName == hooks.hook2
            MsgBox topicName "  [HOOKED]", , "T2"
        else
            MsgBox topicName, , "T2"

    }

}

savePrevious(category, topic) {
    IniWrite category, "data.ini", "previous", "category"
    IniWrite topic, "data.ini", "previous", "topic"
}

saveHooks() {
    IniWrite hooks.hook1, "data.ini", "hook1", "topic"
    IniWrite hooks.hook2, "data.ini", "hook2", "topic"
}

loadHooks() {
    global hooks
    hooks.hook1 := IniRead("data.ini", "hook1", "topic")
    hooks.hook2 := IniRead("data.ini", "hook2", "topic")
}

loadPrevious() {
    global prevCategory, prevTopic
    prevCategory := IniRead("data.ini", "previous", "category")
    prevTopic := IniRead("data.ini", "previous", "topic")
}

; FUCKING HELL
hook(prevTopic) {
    global hooks
    if prevTopic == hooks.hook1 {
        hooks.hook1 := ""
        MsgBox "`"" prevTopic "`" dehooked.", , "T2"
        saveHooks()
        return
    } else if prevTopic == hooks.hook2 {
        hooks.hook2 := ""
        MsgBox "`"" prevTopic "`" dehooked.", , "T2"
        saveHooks()
        return
    }
    if hooks.hook1 != "" {
        if hooks.hook2 != "" {
            MsgBox "no more hooks available bitch"
        } else {
            hooks.hook2 := prevTopic
            saveHooks()
            MsgBox "`"" prevTopic "`" hooked", , "T2"
        }
    } else {
        hooks.hook1 := prevTopic
        saveHooks()
        MsgBox "`"" prevTopic "`" hooked", , "T2"
    }
}

longHooks := []

NumpadEnter:: {
    global prevCategory, prevTopic
    loadPrevious()
    ; FUCKING HELL
    if hooks.hook1 && prevTopic != hooks.hook1 {
        activateTopic(hooks.hook1)
        prevTopic := hooks.hook1
        return
    } else if hooks.hook2 && prevTopic != hooks.hook2 {
        activateTopic(hooks.hook2)
        prevTopic := hooks.hook2
        return
    }

    for index, longHook in longHooks {
        longHook.timer -= 1
    }
    if longHooks.Length() > 0 && longHooks[1].timer <= 0 {
        expiredLongHook := longHooks.RemoveAt(1)
        prevTopic := expiredLongHook.topic
        prevCategory := expiredLongHook.category
        activateTopic(expiredLongHook.topic)
        return
    }


outer:
    while (true) {
        rand := Random(1, workableData.weights[workableData.len])
        for index, cumulativeWeight in workableData.weights {
            if (rand <= cumulativeWeight) {
                randomCategory := workableData.data[index]
                if randomCategory.name == prevCategory
                    continue outer
                rand2 := Random(1, randomCategory.weights[randomCategory.len])
                for index2, cumulativeWeight2 in randomCategory.weights {
                    if (rand2 <= cumulativeWeight2) {
                        randomTopic := randomCategory.data[index2]
                        prevCategory := randomCategory.name
                        prevTopic := randomTopic
                        activateTopic(randomTopic)
                        savePrevious(randomCategory.name, randomTopic)
                        break outer
                    }
                }

            }
        }
    }

}

prevFocus := IniRead("data.ini", "previous", "focus")

NumpadRight:: activateTopic(prevTopic)
NumpadIns:: {
    ; shit
    prevFocus := IniRead("data.ini", "previous", "focus")
    if prevFocus == "ICDL" {
        WinActivate("SQL.PDF - Adobe Acrobat Reader (64-bit)")
        IniWrite "SQL.PDF - Adobe Acrobat Reader (64-bit)", "data.ini", "previous", "focus"

    }
    else {
        WinActivate("ICDL")
        IniWrite "ICDL", "data.ini", "previous", "focus"

    }
}

NumpadDel:: hook(prevTopic)

longHook(category, topic) {
    return longHook := { category: category, topic: topic, timer: 5 }
}

NumpadPgdn:: {
    longHook(prevCategory, prevTopic)
    MsgBox "`"" prevTopic "`" long hooked", , "T2"
}