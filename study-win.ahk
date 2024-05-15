#Requires AutoHotkey v2.0

#Include "Topics.ahk"

#SingleInstance force
SetTitleMatchMode 3

A_ScriptName := "Study"
A_IconTip := "Study"

CustomPaths := {
    HWiNFO: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\HWiNFO64\HWiNFO Manual.lnk",
    Japanese: "ahk_exe Kindle.exe",
    German: "ahk_exe Kindle.exe",
    Russian: "ahk_exe Kindle.exe",
    Car_License: "ahk_exe Kindle.exe"
}

IconPath := "C:\Users\aless\Desktop\projects\personal\ahk\study-win\tray-icon.ico"
TraySetIcon IconPath

MsgBoxTimer := "T1"

Hooks := {
    HookI: { Category: "", Topic: "" },
    HookII: { Category: "", Topic: "" }
}

LongHooks := []


ActivateTopic(Topic, Category, AddedStr?) {
    global PrevTopic, PrevCategory
    PrevTopic := Topic
    PrevCategory := Category
    if CustomPaths.HasProp(Topic) {
        if SubStr(CustomPaths.%Topic%, 1, 3) = "C:\"
            Run CustomPaths.%Topic%
        else {
            WinActivate(CustomPaths.%Topic%)
        }
    }
    else if WinExist(Topic)
        WinActivate(Topic)
    Msg := IsSet(AddedStr) ? Topic . "  " . AddedStr : Topic
    MsgBox Msg, , MsgBoxTimer
}

Save() {
    IniWrite PrevTopic, "data.ini", "previous", "topic"
    IniWrite PrevCategory, "data.ini", "previous", "category"
    IniWrite Hooks.HookI.Category, "data.ini", "hookI", "category"
    IniWrite Hooks.HookI.Topic, "data.ini", "hookI", "topic"
    IniWrite Hooks.HookII.Category, "data.ini", "hookII", "category"
    IniWrite Hooks.HookII.Topic, "data.ini", "hookII", "topic"

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
    PrevCategory := IniRead("data.ini", "previous", "category")
    PrevTopic := IniRead("data.ini", "previous", "topic")
    Hooks.HookI.Category := IniRead("data.ini", "hookI", "category")
    Hooks.HookI.Topic := IniRead("data.ini", "hookI", "topic")
    Hooks.HookII.Category := IniRead("data.ini", "hookII", "category")
    Hooks.HookII.Topic := IniRead("data.ini", "hookII", "topic")

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

HookTopic() {
    global Hooks
    if PrevTopic == Hooks.HookI.Topic {
        Hooks.HookI.Topic := Hooks.HookII.Topic
        Hooks.HookI.Category := Hooks.HookII.Category
        Hooks.HookII.Topic := ""
        Hooks.HookII.Category := ""
        MsgBox "`"" PrevTopic "`" dehooked.", , MsgBoxTimer
        return
    } else if PrevTopic == Hooks.HookII.Topic {
        Hooks.HookII.Topic := ""
        Hooks.HookII.Category := ""
        MsgBox "`"" PrevTopic "`" dehooked.", , MsgBoxTimer
        return
    }
    if Hooks.HookI.Topic != "" {
        if Hooks.HookII.Topic != "" {
            MsgBox "no more hooks available bitch"
        } else {
            Hooks.HookII.Topic := PrevTopic
            Hooks.HookII.Category := PrevCategory
            MsgBox "`"" PrevTopic "`" hooked", , MsgBoxTimer
        }
    } else {
        Hooks.HookI.Topic := PrevTopic
        Hooks.HookI.Category := PrevCategory
        MsgBox "`"" PrevTopic "`" hooked", , MsgBoxTimer
    }
}

NumpadEnter:: {
    if Hooks.HookI.Topic != "" && Hooks.HookII.Topic != "" && PrevTopic != Hooks.HookI.Topic && PrevTopic != Hooks.HookII.Topic {
        if Random(0, 1) {
            ActivateTopic(Hooks.HookI.Topic, Hooks.HookI.Category, "[HOOKED]")
            return
        }
        else {
            ActivateTopic(Hooks.HookII.Topic, Hooks.HookII.Category, "[HOOKED]")
            return
        }
    } else if Hooks.HookI.Topic && PrevTopic != Hooks.HookI.Topic {
        ActivateTopic(Hooks.HookI.Topic, Hooks.HookI.Category, "[HOOKED]")
        return
    } else if Hooks.HookII.Topic && PrevTopic != Hooks.HookII.Topic {
        ActivateTopic(Hooks.HookII.Topic, Hooks.HookII.Category, "[HOOKED]")
        return
    }

    for Index, LongHook in LongHooks {
        LongHook.Timer -= 1
    }
    if LongHooks.Length > 0 && LongHooks[1].Timer <= 0 {
        ExpiredLongHook := LongHooks.RemoveAt(1)
        ActivateTopic(ExpiredLongHook.Topic, ExpiredLongHook.Category, "[LONG HOOKED]")
        return
    }


outer:
    while (true) {
        Rand := Random(1, ProcessedCommonData.Weights[ProcessedCommonData.Len])
        for Index, CumulativeWeight in ProcessedCommonData.Weights {
            if (Rand <= CumulativeWeight) {
                RandomCategory := ProcessedCommonData.Data[Index]
                if RandomCategory.Name == PrevCategory || RandomCategory.Name == Hooks.HookI.Category || RandomCategory.Name == Hooks.HookII.Category
                    continue outer
                for LongHook in LongHooks {
                    if RandomCategory.Name == LongHook.Category
                        continue outer
                }
                Rand2 := Random(1, RandomCategory.Weights[RandomCategory.Len])
                for Index2, CumulativeWeight2 in RandomCategory.Weights {
                    if (Rand2 <= CumulativeWeight2) {
                        RandomTopic := RandomCategory.Data[Index2]
                        for LongHook in LongHooks {
                            if RandomTopic == LongHook.Topic
                                continue outer
                        }
                        ActivateTopic(RandomTopic, RandomCategory.Name)
                        break outer
                    }
                }

            }
        }
    }

}

NumpadIns:: {
outer:
    while (true) {
        Rand := Random(1, ProcessedFocusData.Weights[ProcessedFocusData.Len])
        for Index, CumulativeWeight in ProcessedFocusData.Weights {
            if (Rand <= CumulativeWeight) {
                RandomCategory := ProcessedFocusData.Data[Index]
                if RandomCategory.Category == PrevCategory || RandomCategory.Category == Hooks.HookI.Category || RandomCategory.Category == Hooks.HookII.Category ; todo fuck this too
                    continue outer
                for LongHook in LongHooks {
                    if RandomCategory.Category == LongHook.Category
                        continue outer
                }
                ActivateTopic(RandomCategory.Topic, RandomCategory.Category)
                break outer
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
    MsgBox "`"" PrevTopic "`" long hooked", , MsgBoxTimer
}

NumpadSub:: {
    Choice := InputBox("1. Print hooks`n2. Print long hooks`n3. Save`n4. Reload", , "w100 h200")
    Choice := Choice.Value
    if Choice == "1" {
        MsgBox "Hook I:`t`t" Hooks.HookI.Topic "`nHook II:`t`t" Hooks.HookII.Topic "`n`nCurrent Topic:`t" PrevTopic
    } else if Choice == "2" {
        Msg := ""
        for LongHook in LongHooks {
            Msg := Msg . LongHook.Topic . "`t" . LongHook.Timer "`n"
        }
        MsgBox Msg
    } else if Choice == "3" {
        Save()
        MsgBox "Saved."
    } else if Choice == "4" {
        Save()
        MsgBox "Reloaded."
        Reload()
    }
    else
        MsgBox "idiot"
}

Load()