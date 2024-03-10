#Requires AutoHotkey v2.0

#Include "topics.ahk"

#SingleInstance force
SetTitleMatchMode 3


; clearTopic() {
;     global
;     newTopic := ''
;     prevTopic := ''
;     nextTopic()

; }

prevTopic := ""


; NumpadPgdn:: clearTopic()

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

NumpadEnter:: {
    global prevTopic
outer:
    while (true) {
        rand := Random(1, workableData.weights[workableData.len])
        for index, cumulativeWeight in workableData.weights {
            if (rand <= cumulativeWeight) {
                randomTopic := workableData.data[index]
                if (IsObject(randomTopic)) {
                    if randomTopic.name == prevTopic
                        continue outer
                } else {
                    if randomTopic == prevTopic
                        continue outer
                }
                if (IsObject(randomTopic)) {
                    rand2 := Random(1, randomTopic.weights[randomTopic.len])
                    for index2, cumulativeWeight2 in randomTopic.weights {
                        if (rand2 <= cumulativeWeight2) {
                            randomTopic2 := randomTopic.data[index2]
                            prevTopic := randomTopic.name
                            activateTopic(randomTopic2)
                            break outer
                        }
                    }
                } else {
                    prevTopic := randomTopic
                    activateTopic(randomTopic)
                    break outer
                }
            }
        }
    }

}

NumpadDel:: activateTopic(prevTopic)