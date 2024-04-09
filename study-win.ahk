#Requires AutoHotkey v2.0

#Include "topics.ahk"

#SingleInstance force
SetTitleMatchMode 3

A_ScriptName := "Study"
A_IconTip := "Study"

iconPath := "C:\Users\aless\Desktop\projects\personal\ahk\study-win\tray-icon.ico"
TraySetIcon iconPath


hooks := {
    hook1: { category: "", topic: "" },
    hook2: { category: "", topic: "" }
}

loadPrevious()
loadHooks()

activateTopic(topicName) {
    if WinExist(topicName)
        WinActivate(topicName)
    if topicName == hooks.hook1.topic || topicName == hooks.hook2.topic
        MsgBox topicName "  [HOOKED]", , "T2"
    else
        MsgBox topicName, , "T2"
}

savePrevious(topic, category) {
    IniWrite topic, "data.ini", "previous", "topic"
    IniWrite category, "data.ini", "previous", "category"
}

saveHooks(hook, topic, category) {
    IniWrite category, "data.ini", hook, "category"
    IniWrite topic, "data.ini", hook, "topic"
}

loadHooks() {
    global hooks
    hooks.hook1.category := IniRead("data.ini", "hook1", "category")
    hooks.hook1.topic := IniRead("data.ini", "hook1", "topic")
    hooks.hook2.category := IniRead("data.ini", "hook2", "category")
    hooks.hook2.topic := IniRead("data.ini", "hook2", "topic")
}

loadPrevious() {
    global prevCategory, prevTopic
    prevCategory := IniRead("data.ini", "previous", "category")
    prevTopic := IniRead("data.ini", "previous", "topic")
}

; FUCKING HELL
hook() {
    global hooks
    loadPrevious()
    if prevTopic == hooks.hook1.topic {
        hooks.hook1.topic := ""
        hooks.hook1.category := ""
        saveHooks("hook1", "", "")
        MsgBox "`"" prevTopic "`" dehooked.", , "T2"
        return
    } else if prevTopic == hooks.hook2.topic {
        hooks.hook2.topic := ""
        hooks.hook2.category := ""
        saveHooks("hook2", "", "")
        MsgBox "`"" prevTopic "`" dehooked.", , "T2"
        return
    }
    if hooks.hook1.topic != "" {
        if hooks.hook2.topic != "" {
            MsgBox "no more hooks available bitch"
        } else {
            hooks.hook2.topic := prevTopic
            hooks.hook2.category := prevCategory
            saveHooks("hook2", prevTopic, prevCategory)
            MsgBox "`"" prevTopic "`" hooked", , "T2"
        }
    } else {
        hooks.hook1.topic := prevTopic
        hooks.hook1.category := prevCategory
        saveHooks("hook1", prevTopic, prevCategory)
        MsgBox "`"" prevTopic "`" hooked", , "T2"
    }
}

longHooks := []

NumpadClear:: {
    MsgBox prevTopic
    MsgBox hooks.hook1.topic
}

NumpadEnter:: {
    global prevCategory, prevTopic
    loadPrevious()
    loadHooks()
    ; FUCKING HELL
    if hooks.hook1.topic != "" && prevTopic != hooks.hook1.topic {
        ; MsgBox(prevTopic)
        ; MsgBox(hooks.hook1.topic)
        activateTopic(hooks.hook1.topic)
        savePrevious(hooks.hook1.topic, hooks.hook1.category)
        ; prevTopic := hooks.hook1.topic
        ; prevCategory := hooks.hook1.category
        return
    } else if hooks.hook2.topic != "" && prevTopic != hooks.hook2.topic {
        activateTopic(hooks.hook2.topic)
        savePrevious(hooks.hook2.topic, hooks.hook2.category)
        ; prevTopic := hooks.hook2.topic
        ; prevCategory := hooks.hook2.category

        return
    }

    for index, longHook in longHooks {
        longHook.timer -= 1
    }
    if longHooks.Length > 0 && longHooks[1].timer <= 0 {
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
                        savePrevious(randomTopic, randomCategory.name)
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

NumpadDel:: hook()

longHook(category, topic) {
    return longHook := { category: category, topic: topic, timer: 5 }
}

NumpadPgdn:: {
    longHook(prevCategory, prevTopic)
    MsgBox "`"" prevTopic "`" long hooked", , "T2"
}