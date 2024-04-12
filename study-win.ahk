#Requires AutoHotkey v2.0

#Include "Topics.ahk"

#SingleInstance force
SetTitleMatchMode 3

A_ScriptName := "Study"
A_IconTip := "Study"

IconPath := "C:\Users\aless\Desktop\projects\personal\ahk\study-win\tray-icon.ico"
TraySetIcon IconPath

FocusI := { Topic: "ICDL", Category: "office", CustomPath: "" }
FocusII := { Topic: "ITS", Category: "its", CustomPath: "" }

Hooks := {
    HookI: { Category: "", Topic: "" },
    HookII: { Category: "", Topic: "" }
}

LongHooks := []


NumpadIns:: {
    if PrevTopic == FocusI.Topic {
        ActivateTopic(FocusII.Topic, FocusII.Category, , FocusII.CustomPath)
    } else if PrevTopic == FocusII.Topic {
        ActivateTopic(FocusI.Topic, FocusI.Category, , FocusI.CustomPath)
    } else if Random(0, 1) {
        ActivateTopic(FocusI.Topic, FocusI.Category, , FocusI.CustomPath)
    } else {
        ActivateTopic(FocusII.Topic, FocusII.Category, , FocusII.CustomPath)
    }
}

ActivateTopic(Topic, Category, AddedStr := "", CustomPath := "") {
    global PrevTopic, PrevCategory
    PrevTopic := Topic
    PrevCategory := Category
    if CustomPath
        run CustomPath
    else if WinExist(Topic)
        WinActivate(Topic)
    Msg := AddedStr ? Topic . "  " . AddedStr : Topic
    ; MsgBox Msg, , "T2"
}

Save() {
    IniWrite PrevTopic, "data.ini", "previous", "Topic"
    IniWrite PrevCategory, "data.ini", "previous", "Category"
    IniWrite Hooks.HookI.Category, "data.ini", "HookI", "Category"
    IniWrite Hooks.HookI.Topic, "data.ini", "HookI", "Topic"
    IniWrite Hooks.HookII.Category, "data.ini", "HookII", "Category"
    IniWrite Hooks.HookII.Topic, "data.ini", "HookII", "Topic"

    SerializedData := ""
    for _, Obj in LongHooks
    {
        SerializedData .= Obj.Category . "|" . Obj.Topic . "|" . Obj.Timer . "`n"
    }

    FileDelete "data.txt"
    FileAppend SerializedData, "data.txt"

}

Load() {
    global PrevTopic, PrevCategory, Hooks, LongHooks
    PrevCategory := IniRead("data.ini", "previous", "Category")
    PrevTopic := IniRead("data.ini", "previous", "Topic")
    Hooks.HookI.Category := IniRead("data.ini", "HookI", "Category")
    Hooks.HookI.Topic := IniRead("data.ini", "HookI", "Topic")
    Hooks.HookII.Category := IniRead("data.ini", "HookII", "Category")
    Hooks.HookII.Topic := IniRead("data.ini", "HookII", "Topic")

    ; Open the File for reading
    File := FileOpen("data.txt", "r")

    ; Check if the File was successfully opened
    if !IsObject(File)
    {
        MsgBox "Failed to open File."
        return
    }

    ; Read the entire content of the File
    FileContent := File.Read()

    ; Close the File
    File.Close()

    ; Split the File content into Lines
    Lines := StrSplit(FileContent, "`n", "`r")
    LongHooks := []

    ; Iterate over each line to deserialize it back into Objects
    for Each, Line in Lines
    {
        if (Line = "")  ; Skip empty Lines
            continue
        Parts := StrSplit(Line, "|")
        LongHooks.Push({ Category: Parts[1], Topic: Parts[2], Timer: Parts[3] })
    }

}

; FUCKING HELL
HookTopic() {
    global Hooks
    if PrevTopic == Hooks.HookI.Topic {
        Hooks.HookI.Topic := ""
        Hooks.HookI.Category := ""
        MsgBox "`"" PrevTopic "`" dehooked.", , "T2"
        return
    } else if PrevTopic == Hooks.HookII.Topic {
        Hooks.HookII.Topic := ""
        Hooks.HookII.Category := ""
        MsgBox "`"" PrevTopic "`" dehooked.", , "T2"
        return
    }
    if Hooks.HookI.Topic != "" {
        if Hooks.HookII.Topic != "" {
            MsgBox "no more hooks available bitch"
        } else {
            Hooks.HookII.Topic := PrevTopic
            Hooks.HookII.Category := PrevCategory
            MsgBox "`"" PrevTopic "`" hooked", , "T2"
        }
    } else {
        Hooks.HookI.Topic := PrevTopic
        Hooks.HookI.Category := PrevCategory
        MsgBox "`"" PrevTopic "`" hooked", , "T2"
    }
}

NumpadEnter:: {
    ; FUCKING HELL
    if Hooks.HookI.Topic != "" && PrevTopic != Hooks.HookI.Topic {
        ActivateTopic(Hooks.HookI.Topic, Hooks.HookI.Category)
        ; ActivateTopic(Hooks.HookI.Topic, Hooks.HookI.Category, "[HOOKED]")
        return
    } else if Hooks.HookII.Topic != "" && PrevTopic != Hooks.HookII.Topic {
        ActivateTopic(Hooks.HookII.Topic, Hooks.HookII.Category)
        ; ActivateTopic(Hooks.HookII.Topic, Hooks.HookII.Category, "[HOOKED]")
        return
    }

    for Index, LongHook in LongHooks {
        LongHook.Timer -= 1
    }
    if LongHooks.Length > 0 && LongHooks[1].Timer <= 0 {
        ExpiredLongHook := LongHooks.RemoveAt(1)
        ActivateTopic(ExpiredLongHook.Topic, ExpiredLongHook.Category)
        ; ActivateTopic(ExpiredLongHook.Topic, ExpiredLongHook.Category, "[LONG HOOKED]")
        return
    }


outer:
    while (true) {
        Rand := Random(1, workableData.weights[workableData.len])
        for Index, CumulativeWeight in workableData.weights {
            if (Rand <= cumulativeWeight) {
                RandomCategory := workableData.data[Index]
                if RandomCategory.name == Hooks.HookI.Category || RandomCategory.name == Hooks.HookII.Category {
                    MsgBox "fuck"
                }
                if RandomCategory.name == PrevCategory || RandomCategory.name == Hooks.HookI.Category || RandomCategory.name == Hooks.HookII.Category
                    continue outer
                for LongHook in LongHooks {
                    if RandomCategory.name == LongHook.Category
                        continue outer
                }
                rand2 := Random(1, RandomCategory.weights[RandomCategory.len])
                for Index2, cumulativeWeight2 in RandomCategory.weights {
                    if (rand2 <= cumulativeWeight2) {
                        randomTopic := RandomCategory.data[Index2]
                        for LongHook in LongHooks {
                            if randomTopic == LongHook.Topic
                                continue outer
                        }
                        ActivateTopic(randomTopic, RandomCategory.name)
                        break outer
                    }
                }

            }
        }
    }

}

NumpadRight:: ActivateTopic(PrevTopic, PrevCategory)

NumpadDel:: HookTopic()

LongHookTopic() {
    global Hooks, LongHooks
    if PrevTopic == Hooks.HookI.Topic {
        Hooks.HookI.Topic := ""
        Hooks.HookI.Category := ""
    } else if PrevTopic == Hooks.HookII.Topic {
        Hooks.HookII.Topic := ""
        Hooks.HookII.Category := ""
    }
    LongHooks.Push({ Category: PrevCategory, Topic: PrevTopic, Timer: 5 })
}

NumpadPgdn:: {
    LongHookTopic()
    MsgBox "`"" PrevTopic "`" long hooked", , "T2"
}

NumpadSub:: {
    choice := InputBox("1. Print hooks`n2. Print long hooks`n3. Save`n4. Reload", , "w100 h200")
    choice := choice.Value
    if choice == "1" {
        MsgBox "Hook I:`t`t" Hooks.HookI.Topic "`nHook II:`t`t" Hooks.HookII.Topic "`n`nCurrent Topic:`t" PrevTopic
    } else if choice == "2" {
        Msg := ""
        for LongHook in LongHooks {
            Msg := Msg . LongHook.Topic . "`t" . LongHook.Timer "`n"
        }
        MsgBox Msg
    } else if choice == "3" {
        Save()
        MsgBox "Saved."
    } else if choice == "4" {
        Save()
        MsgBox "Reloaded."
        Reload()
    }
    else
        MsgBox "idiot"
}

Load()