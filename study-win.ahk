#Requires AutoHotkey v2.0

#Include "topics.ahk"

#SingleInstance force
SetTitleMatchMode 3


loadPrevious()


activateTopic(topicName) {
    if WinActive(topicName) {
        WinMinimize()
    } else {
        try {
            WinActivate(topicName)
        } catch {
            MsgBox topicName, "TOPICS", "T2"
        }
    }
}

savePrevious(category, topic) {
    IniWrite category, "data.ini", "previous", "category"
    IniWrite topic, "data.ini", "previous", "topic"
}

loadPrevious() {
    global prevCategory
    global prevTopic
    prevCategory := IniRead("data.ini", "previous", "category")
    prevTopic := IniRead("data.ini", "previous", "topic")
}


NumpadEnter:: {
    global prevCategory
    global prevTopic
    loadPrevious()
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

NumpadDel:: activateTopic(prevTopic)
NumpadIns:: activateTopic("ICDL")