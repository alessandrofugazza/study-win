#Requires AutoHotkey v2.0

#Include "topics.ahk"

#SingleInstance force
SetTitleMatchMode 3

A_ScriptName := "Study"
A_IconTip := "Study"

iconPath := "C:\Users\aless\Desktop\projects\personal\ahk\study-win\tray-icon.ico"
TraySetIcon iconPath

focusI := { topic: "ICDL", category: "office", customPath: "" }
focusII := { topic: "ITS", category: "its", customPath: "" }

hooks := {
    hookI: { category: "", topic: "" },
    hookII: { category: "", topic: "" }
}

longHooks := []


NumpadIns:: {
    if prevTopic == focusI.topic {
        activateTopic(focusII.topic, focusII.category, , focusII.customPath)
    }
    else {
        activateTopic(focusI.topic, focusI.category, , focusI.customPath)
    }
}

activateTopic(topic, category, addedStr := "", customPath := "") {
    global prevTopic, prevCategory
    prevTopic := topic
    prevCategory := category
    if customPath
        run customPath
    else if WinExist(topic)
        WinActivate(topic)
    msg := addedStr ? topic . "  " . addedStr : topic
    MsgBox msg, , "T2"
}

save() {
    IniWrite prevTopic, "data.ini", "previous", "topic"
    IniWrite prevCategory, "data.ini", "previous", "category"
    IniWrite hooks.hookI.category, "data.ini", "hookI", "category"
    IniWrite hooks.hookI.topic, "data.ini", "hookI", "topic"
    IniWrite hooks.hookII.category, "data.ini", "hookII", "category"
    IniWrite hooks.hookII.topic, "data.ini", "hookII", "topic"

    serializedData := ""
    for _, obj in longHooks
    {
        serializedData .= obj.category . "|" . obj.topic . "|" . obj.timer . "`n"
    }

    FileDelete "data.txt"
    FileAppend serializedData, "data.txt"

}

load() {
    global prevTopic, prevCategory, hooks, longHooks
    prevCategory := IniRead("data.ini", "previous", "category")
    prevTopic := IniRead("data.ini", "previous", "topic")
    hooks.hookI.category := IniRead("data.ini", "hookI", "category")
    hooks.hookI.topic := IniRead("data.ini", "hookI", "topic")
    hooks.hookII.category := IniRead("data.ini", "hookII", "category")
    hooks.hookII.topic := IniRead("data.ini", "hookII", "topic")

    ; Open the file for reading
    file := FileOpen("data.txt", "r")

    ; Check if the file was successfully opened
    if !IsObject(file)
    {
        MsgBox "Failed to open file."
        return
    }

    ; Read the entire content of the file
    fileContent := file.Read()

    ; Close the file
    file.Close()

    ; Split the file content into lines
    lines := StrSplit(fileContent, "`n", "`r")
    longHooks := []

    ; Iterate over each line to deserialize it back into objects
    for each, line in lines
    {
        if (line = "")  ; Skip empty lines
            continue
        parts := StrSplit(line, "|")
        longHooks.Push({ category: parts[1], topic: parts[2], timer: parts[3] })
    }

}

; FUCKING HELL
hookTopic() {
    global hooks
    if prevTopic == hooks.hookI.topic {
        hooks.hookI.topic := ""
        hooks.hookI.category := ""
        MsgBox "`"" prevTopic "`" dehooked.", , "T2"
        return
    } else if prevTopic == hooks.hookII.topic {
        hooks.hookII.topic := ""
        hooks.hookII.category := ""
        MsgBox "`"" prevTopic "`" dehooked.", , "T2"
        return
    }
    if hooks.hookI.topic != "" {
        if hooks.hookII.topic != "" {
            MsgBox "no more hooks available bitch"
        } else {
            hooks.hookII.topic := prevTopic
            hooks.hookII.category := prevCategory
            MsgBox "`"" prevTopic "`" hooked", , "T2"
        }
    } else {
        hooks.hookI.topic := prevTopic
        hooks.hookI.category := prevCategory
        MsgBox "`"" prevTopic "`" hooked", , "T2"
    }
}

NumpadEnter:: {
    ; FUCKING HELL
    if hooks.hookI.topic != "" && prevTopic != hooks.hookI.topic {
        activateTopic(hooks.hookI.topic, hooks.hookI.category, "[HOOKED]")
        return
    } else if hooks.hookII.topic != "" && prevTopic != hooks.hookII.topic {
        activateTopic(hooks.hookII.topic, hooks.hookII.category, "[HOOKED]")
        return
    }

    for index, longHook in longHooks {
        longHook.timer -= 1
    }
    if longHooks.Length > 0 && longHooks[1].timer <= 0 {
        expiredLongHook := longHooks.RemoveAt(1)
        activateTopic(expiredLongHook.topic, expiredLongHook.category, "[LONG HOOKED]")
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
                        activateTopic(randomTopic, randomCategory.name)
                        break outer
                    }
                }

            }
        }
    }

}

NumpadRight:: activateTopic(prevTopic, prevCategory)

NumpadDel:: hookTopic()

longHookTopic() {
    global hooks, longHooks
    if prevTopic == hooks.hookI.topic {
        hooks.hookI.topic := ""
        hooks.hookI.category := ""
    } else if prevTopic == hooks.hookII.topic {
        hooks.hookII.topic := ""
        hooks.hookII.category := ""
    }
    longHooks.Push({ category: prevCategory, topic: prevTopic, timer: 5 })
}

NumpadPgdn:: {
    longHookTopic()
    MsgBox "`"" prevTopic "`" long hooked", , "T2"
}

NumpadMult:: {
    choice := InputBox("1. Print hooks`n2. Print long hooks`n3. Save`n4. Reload", , "w100 h200")
    choice := choice.Value
    if choice == "1" {
        MsgBox "Hook I:`t`t" hooks.hookI.topic "`nHook II:`t`t" hooks.hookII.topic "`n`nCurrent topic:`t" prevTopic
    } else if choice == "2" {
        msg := ""
        for longHook in longHooks {
            msg := msg . longHook.topic . "`t" . longHook.timer "`n"
        }
        MsgBox msg
    } else if choice == "3" {
        save()
        MsgBox "Saved."
    } else if choice == "4" {
        save()
        MsgBox "Reloaded."
        Reload()
    }
    else
        MsgBox "idiot"
}

load()