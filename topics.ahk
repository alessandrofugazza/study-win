RawCommonData := [{
    Name: "computer hardware",
    Data: ["HWiNFO"]
}, {
    Name: "google",
    Data: ["Google"]
}, {
    Name: "adblock",
    Data: ["uBlock Origin"]
}, {
    Name: "postman",
    Data: ["Postman"]
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
    Name: "russian",
    Data: ["Russian"]
}, {
    Name: "japanese",
    Data: ["Japanese"],
}, {
    Name: "german",
    Data: ["German"]
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
    Name: "real shit",
    Data: [
        "Improvement",
        "Task",
    ]
}
]

RawFocusData := [{
    Category: "office",
    Topic: "Excel"
}, {
    Category: "office",
    Topic: "Word"
}
]

; {
; Name: "office",
;         Data: [
;             ; "PowerPoint",
;             "Word",
;         ]
; },

; }, {
;     Name: "icdl",
;     Data: [
;         "Computer Essentials",
;         "Online Essentials",
;         "IT Security",
;         "Online Collaboration"
;     ]
; }, {

; {
; Category: "driving",
;         Topic: "Car License"
; },

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


ProcessedCommonData := { Data: RawCommonData, Weights: GetWeights(RawCommonData), Len: RawCommonData.Length }
ProcessedFocusData := { Data: RawFocusData, Weights: GetWeights(RawFocusData), Len: RawFocusData.Length }

for Index, Value in ProcessedCommonData.Data
{
    Value.Len := Value.Data.Length
    Value.Weights := GetWeights(Value.Data)
}