RawCommonData := [{
    Name: "encyclopedia",
    Data: [
        "Anatomy",
        "Diagnostics",
        "Antropology",
        "Genetics",
        "Psychiatry",
        "Psychology",
    ]
}, {
    Name: "computer hardware",
    Data: [
        "Device Monitor",
        "HWiNFO"
    ]
}, {
    Name: "ios shortcuts",
    Data: ["iOS Shortcuts"]
}, {
    Name: "office",
    Data: [
        "Word",
        "Excel"
    ]
}, {
    Name: "search engines",
    Data: ["Google"]
}, {
    Name: "computer software",
    Data: [
        "Working Copy",
        "HWiNFO_Info"
    ] ; todo solve this shit
}, {
    Name: "adblock",
    Data: ["uBlock Origin"]
}, {
    Name: "postman",
    Data: ["Postman"]
}, {
    Name: "devtools",
    Data: [
        "IntelliJ",
        "VS Code",
        "Chrome Devtools"
    ]
}, {
    Name: "coding",
    Data: [
        "HTML",
        "CSS",
        "JavaScript",
        "TypeScript",
        "Java",
        "Query",
        "AHK",
        "Spring",
        "Bootstrap",
        "React Bootstrap",
        "React",
        "Swift",
        "SwiftUI",
        "Coding Learn"
    ]
}
]

RawFocusData := []

RawUrgentData := [
    ;     {
    ;     Category: "real life shit",
    ;     Topic: "New Job"
    ; }
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