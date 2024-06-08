#Requires AutoHotkey v2.0

#Include "Topics.ahk"

#SingleInstance force
SetTitleMatchMode 3

A_ScriptName := "Study"
A_IconTip := "Study"

CustomPaths := {
    HWiNFO: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\HWiNFO64\HWiNFO Manual.lnk",
    Honda_SH125: "C:\Users\aless\Desktop\sh125.pdf",
    Japanese: "ahk_exe Kindle.exe",
    German: "ahk_exe Kindle.exe",
    Russian: "ahk_exe Kindle.exe",
    Driving_Book: "ahk_exe Kindle.exe"
}

IconPath := "C:\Users\aless\Desktop\projects\personal\ahk\study-win\tray-icon.ico"
TraySetIcon IconPath

MsgBoxTimer := "T1"

Hooks := []
LongHooks := []

ActivateTopic(Topic, Category, AddedStr?) {
    global PrevTopic, PrevCategory
    PrevTopic := Topic
    PrevCategory := Category
    if CustomPaths.HasProp(Topic) {
        if SubStr(CustomPaths.%Topic%, 1, 3) = "C:\" ; todo if program is too slow to start it hides msgbox
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

CheckIfTimeHasPassed(Timer, Time) {
    ElapsedTime := A_TickCount - Timer
    if (ElapsedTime > Time * 60 * 1000)
        return true
    else
        return false
}

SaveLongData(Data, FilePath) {
    SerializedData := ""
    for _, Obj in Data
    {
        SerializedData .= Obj.Category . "|" . Obj.Topic . "|" . Obj.Timer . "`n"
    }

    FileDelete FilePath
    FileAppend SerializedData, FilePath
}

Save() {
    IniWrite PrevTopic, "data.ini", "previous", "topic"
    IniWrite PrevCategory, "data.ini", "previous", "category"
    IniWrite PrevUrgentTimer, "data.ini", "previous", "urgentTimer"

    SaveLongData(Hooks, "hooks-data.txt")
    SaveLongData(LongHooks, "long-hooks-data.txt")
}

LoadLongData(Data, FilePath) {
    File := FileOpen(FilePath, "r")
    FileContent := File.Read()
    File.Close()
    Lines := StrSplit(FileContent, "`n", "`r")
    Data := []

    for Each, Line in Lines
    {
        if (Line = "")
            continue
        Parts := StrSplit(Line, "|")
        Data.Push({ Category: Parts[1], Topic: Parts[2], Timer: Parts[3] })
    }
    return Data

}

Load() {
    global PrevCategory := IniRead("data.ini", "previous", "category")
    global PrevTopic := IniRead("data.ini", "previous", "topic")
    global PrevUrgentTimer := IniRead("data.ini", "previous", "urgentTimer")
    global Hooks
    global LongHooks
    Hooks := LoadLongData(Hooks, "hooks-data.txt")
    LongHooks := LoadLongData(LongHooks, "long-hooks-data.txt")
}

HookTopic() {
    global Hooks
    if Hooks.Length > 0 && PrevTopic == Hooks[Hooks.Length].Topic {
        Hooks.RemoveAt(Hooks.Length)
        MsgBox "`"" PrevTopic "`" dehooked.", , MsgBoxTimer
        return
    } else {
        NewHook := {}
        NewHook.Topic := PrevTopic
        NewHook.Category := PrevCategory
        NewHook.Timer := A_TickCount
        Hooks.Push(NewHook)
        MsgBox "`"" PrevTopic "`" hooked", , MsgBoxTimer

    }
}

CheckIfUrgentHasToBeSkipped() {
    if ProcessedUrgentData.Len > 0 {

        Flag := true
        PrevCheckedCategory := ProcessedUrgentData.Data[1].Category
        for Index, Value in ProcessedUrgentData.Data {
            if Index == 1
                continue

            if Value.Category != PrevCheckedCategory {
                Flag := false
                break
            }
        }
        if (ProcessedUrgentData.Len == 1 && ProcessedUrgentData.Data[1].Category != PrevCategory)
            Flag := false
        if Flag {
            MsgBox "Skipping Urgent"
            return true
        }
        return false
    } else
        return false
}

NumpadEnter:: {
    global PrevUrgentTimer
    if CheckIfTimeHasPassed(PrevUrgentTimer, 15) {
        if CheckIfUrgentHasToBeSkipped() {
urgentOuter:
            while (true) {
                Rand := Random(1, ProcessedUrgentData.Weights[ProcessedUrgentData.Len])
                for Index, CumulativeWeight in ProcessedUrgentData.Weights {
                    if (Rand <= CumulativeWeight) {
                        RandomCategory := ProcessedUrgentData.Data[Index]
                        if RandomCategory.Category == PrevCategory || RandomCategory.Category == Hooks.HookI.Category || RandomCategory.Category == Hooks.HookII.Category
                            continue urgentOuter
                        for LongHook in LongHooks {
                            if RandomCategory.Category == LongHook.Category
                                continue urgentOuter
                        }
                        PrevUrgentTimer := A_TickCount
                        ActivateTopic(RandomCategory.Topic, RandomCategory.Category)
                        break urgentOuter
                    }
                }
            }
            return
        }
    }


    if (Hooks.Length > 0 && (CheckIfTimeHasPassed(Hooks[1].Timer, 5))) {
        ActivateTopic(Hooks[1].Topic, Hooks[1].Category, "[HOOKED]")
        removedHook := Hooks.RemoveAt(1)
        removedHook.Timer := A_TickCount
        Hooks.Push(removedHook)
        return
    }
    if LongHooks.Length > 0 && (A_TickCount - LongHooks[1].Timer) > 15 * 60 * 1000 {
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
                if RandomCategory.Name == PrevCategory
                    continue outer
                for Hook in Hooks {
                    if Hook.Category == RandomCategory.Name {
                        continue outer
                    }
                }
                for LongHook in LongHooks {
                    if LongHook.Category == RandomCategory.Name {
                        continue outer
                    }
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
    if CheckIfTimeHasPassed(PrevUrgentTimer, 15) {
        if CheckIfUrgentHasToBeSkipped() {
            return
        }

urgentOuter:
        while (true) {
            Rand := Random(1, ProcessedUrgentData.Weights[ProcessedUrgentData.Len])
            for Index, CumulativeWeight in ProcessedUrgentData.Weights {
                if (Rand <= CumulativeWeight) {
                    RandomCategory := ProcessedUrgentData.Data[Index]
                    if RandomCategory.Category == PrevCategory || RandomCategory.Category == Hooks.HookI.Category || RandomCategory.Category == Hooks.HookII.Category
                        continue urgentOuter
                    for LongHook in LongHooks {
                        if RandomCategory.Category == LongHook.Category
                            continue urgentOuter
                    }
                    ActivateTopic(RandomCategory.Topic, RandomCategory.Category)
                    PrevUrgentTimer := A_TickCount
                    break urgentOuter
                }
            }
        }
        return
    }
    if ProcessedFocusData.Len == 0 {
        MsgBox "idiot"
        return
    } else {
        flag := true
        prevCheckedCategory := ProcessedFocusData.Data[1].Category
        for Index, Value in ProcessedFocusData.Data {
            if Index == 1
                continue

            if Value.Category != prevCheckedCategory {
                flag := false
                break
            }
        }
        if (ProcessedFocusData.Len == 1 && ProcessedFocusData.Data[1].Category != PrevCategory)
            flag := false
        if flag {
            MsgBox "Skipping Focus"
            return
        }

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

}

NumpadRight:: ActivateTopic(PrevTopic, PrevCategory)

NumpadDel:: HookTopic()

LongHookTopic() {
    global Hooks, LongHooks
    for Hook in Hooks {
        if Hook.Topic == PrevTopic {
            Hooks.RemoveAt(A_Index)
            break
        }
    }
    LongHooks.Push({ Category: PrevCategory, Topic: PrevTopic, Timer: A_TickCount })
}

NumpadPgdn:: {
    LongHookTopic()
    MsgBox "`"" PrevTopic "`" long hooked", , MsgBoxTimer
}

NumpadSub:: {
    Choice := InputBox("1. Print hooks`n2. Print long hooks`n3. Save`n4. Reload`n5. Insert Urgent", , "w100 h200")
    Choice := Choice.Value
    if Choice == "1" {
        Msg := ""
        for Hook in Hooks {
            Msg := Msg . A_Index . "`t" . Hook.Topic . "`n"
        }
        MsgBox Msg
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
    } else if Choice == "5" {
        global PrevTopic := "Urgent"
        global PrevCategory := "Urgent"
        HookTopic()
    }
    else
        MsgBox "idiot"
}

Load()