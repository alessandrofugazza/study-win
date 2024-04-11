unworkableData :=
    [{
        name: "computer hardware",
        data: ["HWiNFO"],
        customPaths: { hwinfo: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\HWiNFO64\HWiNFO Manual.lnk" }
    }, {
        name: "google",
        data: [
            "Google"
        ]
    }, {
        name: "adblock",
        data: [
            "uBlock Origin"
        ]
    }, {
        name: "postman",
        data: [
            "Postman"
        ]
    },
        ; {
        ;     name: "fastweb",
        ;     data: ["Fastweb"]
        ; },
        {
            name: "english",
            data: ["English"]
        }, {
            name: "ios shortcuts",
            data: ["iOS Shortcuts"]
        }, {
            name: "ios dev",
            data: [
                "Swift",
                "SwiftUI"
            ]
        }, {
            name: "ahk",
            data: ["AHK"]
        }, {
            name: "webdev",
            data: [
                "HTML",
                "CSS",
                "JavaScript",
                "TypeScript",
                "Java",
                "Spring",
                "React",
                "React Bootstrap"
                "Bootstrap",
            ]
        }, {
            name: "japanese",
            data: ["Japanese"]
        }, {
            name: "german",
            data: ["German"]
        }, {
            name: "devtools",
            data: [
                "IntelliJ",
                "VS Code",
                "Chrome Devtools"
            ]
        },
        ; {
        ;     name: "poker",
        ;     data: ["Poker"]
        ; },
        ; {
        ;     name: "warehouse",
        ;     data: [
        ;         "Forklift"
        ;     ]
        ; },
        ; {
        ;     name: "its",
        ;     data: [
        ;         "ITS"
        ;     ]
        ; },
        {
            name: "icdl",
            data: [
                "Computer Essentials",
                "Online Essentials",
                "IT Security",
                "Online Collaboration"
            ]
        }, {
            name: "office",
            data: [
                "PowerPoint",
                "Word",
                ; "Excel"
            ]
        }, {
            name: "real shit",
            data: [
                "Improvement",
                "Task",
            ]
        }
    ]


getWeights(arr) {
    totalWeight := 0
    weights := []
    for index, value in arr {
        weight := 1.2 ** index
        totalWeight += weight
        weights.Push(totalWeight)
    }
    return weights
}


workableData := { data: unworkableData, weights: getWeights(unworkableData), len: unworkableData.Length }

for index, value in workableData.data
{
    value.len := value.data.Length
    value.weights := getWeights(value.data)
}