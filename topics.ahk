RawCommonData := [{
    Name: "computer hardware",
    Data: ["HWiNFO"]
}, { Name: "ios shortcuts", Data: ["iOS Shortcuts"] }, {
    Name: "office",
    Data: ["Excel"]
}, {
    Name: "computer software",
    Data: ["HWiNFO_Info"] ; todo solve this shit
}, {
    Name: "google",
    Data: ["Google"]
}, {
    Name: "adblock",
    Data: ["uBlock Origin"]
}, {
    Name: "postman",
    Data: ["Postman"]
}, { Name: "english", Data: ["English"] }, {
    Name: "devtools",
    Data: [
        "IntelliJ",
        "VS Code",
        "Chrome Devtools"
    ]
}, { Name: "ios dev", Data: ["Swift", "SwiftUI"] }, {
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
        ; }, {
        ; }, {
        ;     Name: "office",
        ;     Data: [
        ;         "PowerPoint",
        ;         "Word",
        ;     ]
}, {
    Name: "real shit",
    Data: [
        "Improvement",
        "Task",
    ]
}, {
    Name: "coding",
    Data: [
        "coding learn",
        "coding todo",
        ; "coding"
    ]
}
]

RawFocusData := [
    ;     {
    ;     Category: "vehicle_engineering",
    ;     Topic: "Honda_SH125"
    ; }, {
    ; {
    ;     Category: "driving",
    ;     Topic: "Driving_Book"
    ; }
]

RawUrgentData := [{
    Category: "real life shit",
    Topic: "New Job"
}
    ; }, {
    ;     Category: "trips",
    ;     Topic: "Study Trip"
    ; }
]

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

; todo this
ProcessedCommonData := { Data: RawCommonData, Weights: GetWeights(RawCommonData), Len: RawCommonData.Length }
ProcessedFocusData := { Data: RawFocusData, Weights: GetWeights(RawFocusData), Len: RawFocusData.Length }
ProcessedUrgentData := { Data: RawUrgentData, Weights: GetWeights(RawUrgentData), Len: RawUrgentData.Length }

for Index, Value in ProcessedCommonData.Data
{
    Value.Len := Value.Data.Length
    Value.Weights := GetWeights(Value.Data)
}