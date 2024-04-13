UnworkableData :=
    [{
        Name: "computer hardware",
        Data: ["HWiNFO"]
    }, {
        Name: "google",
        Data: [
            "Google"
        ]
    }, {
        Name: "adblock",
        Data: [
            "uBlock Origin"
        ]
    }, {
        Name: "postman",
        Data: [
            "Postman"
        ]
    }, {
        Name: "english",
        Data: ["English"]
    }, {
        Name: "ios shortcuts",
        Data: ["iOS Shortcuts"]
    }, {
        Name: "webdev",
        Data: [
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
        Name: "japanese",
        Data: ["Japanese"],
    }, {
        Name: "german",
        Data: ["German"]
    }, {
        Name: "ios dev",
        Data: [
            "Swift",
            "SwiftUI"
        ]
    }, {
        Name: "ahk",
        Data: ["AHK"]
    }, {
        Name: "devtools",
        Data: [
            "IntelliJ",
            "VS Code",
            "Chrome Devtools"
        ]
    }, {
        Name: "icdl",
        Data: [
            "Computer Essentials",
            "Online Essentials",
            "IT Security",
            "Online Collaboration"
        ]
    }, {
        Name: "office",
        Data: [
            "PowerPoint",
            "Word",
        ]
    }, {
        Name: "real shit",
        Data: [
            "Improvement",
            "Task",
        ]
    }
    ]


GetWeights(arr) {
    TotalWeight := 0
    Weights := []
    for Index, Value in arr {
        Weight := 1.2 ** Index
        TotalWeight += Weight
        Weights.Push(TotalWeight)
    }
    return Weights
}


WorkableData := { Data: UnworkableData, Weights: GetWeights(UnworkableData), Len: UnworkableData.Length }

for Index, Value in WorkableData.Data
{
    Value.Len := Value.Data.Length
    Value.Weights := GetWeights(Value.Data)
}