#Requires AutoHotkey v2.0

#Include "topics.ahk"

#SingleInstance force
SetTitleMatchMode 3

A_ScriptName := "Study"
A_IconTip := "Study"

iconPath := "C:\Users\aless\Desktop\projects\personal\ahk\study-win\tray-icon.ico"
TraySetIcon iconPath

pComputerHardware := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\HWiNFO64\HWiNFO Manual.lnk"
pITS := ""

NumpadIns:: {
    ; shit
    prevFocus := IniRead("data.ini", "previous", "focus")
    if prevFocus == "ICDL" {
        if pITS
            run pITS
        else
            WinActivate("ITS")
        IniWrite "ITS", "data.ini", "previous", "focus"
    }
    else {
        WinActivate("ICDL")
        IniWrite "ICDL", "data.ini", "previous", "focus"
    }
}

hooks := {
    hook1: { category: "", topic: "" },
    hook2: { category: "", topic: "" }
}

loadPrevious()
loadHooks()

activateTopic(topicName, addedStr := "") {
    if WinExist(topicName)
        WinActivate(topicName)
    else if topicName == "HWiNFO"
        run pComputerHardware
    msg := addedStr ? topicName . "  " . addedStr : topicName
    MsgBox msg, , "T2"
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
        activateTopic(hooks.hook1.topic, "[HOOKED]")
        savePrevious(hooks.hook1.topic, hooks.hook1.category)
        ; prevTopic := hooks.hook1.topic
        ; prevCategory := hooks.hook1.category
        return
    } else if hooks.hook2.topic != "" && prevTopic != hooks.hook2.topic {
        activateTopic(hooks.hook2.topic, "[HOOKED]")
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
        activateTopic(expiredLongHook.topic, "[LONG HOOKED]")

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
                        for longHook in longHooks {
                            if randomTopic == longHook.topic
                                continue outer
                        }
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


NumpadDel:: hook()

longHook(category, topic) {
    global longHooks
    longHooks.Push({ category: category, topic: topic, timer: 5 })
}

NumpadPgdn:: {
    longHook(prevCategory, prevTopic)
    MsgBox "`"" prevTopic "`" long hooked", , "T2"
}

NumpadMult:: {
    choice := InputBox("1. Print hooks`n2. Print long hooks", , "w100 h200")
    choice := choice.Value
    if choice == "1" {
        MsgBox "Hook 1:`t`t" hooks.hook1.topic "`nHook 2:`t`t" hooks.hook2.topic "`n`nCurrent topic:`t" prevTopic
    }
    else if choice == "2" {
        msg := ""
        for longHook in longHooks {
            msg := msg . longHook.topic . "`t" . longHook.timer "`n"
        }
        MsgBox msg
    }
    else
        MsgBox "idiot"
}