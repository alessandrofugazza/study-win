RawCommonData := [{
    Name: "computer hardware",
    Data: [
        "Device Monitor",
        "HWiNFO"
    ]
}, {
    Name: "ios shortcuts",
    Data: ["iOS Shortcuts"]
}, {
    Name: "computer software",
    Data: [
        "Working Copy",
        "HWiNFO_Info"
    ] ; todo solve this shit
}, {
    Name: "office",
    Data: [
        "Word",
        "Excel"
    ]
}, {
    Name: "adblock",
    Data: ["uBlock Origin"]
}, {
    Name: "web",
    Data: ["DuckDuckGo", "Tor"]
}, {
    Name: "devtools",
    Data: [
        "Chrome Devtools"
        "VS Code",
    ]
}, {
    Name: "coding",
    Data: [
        "HTML",
        "CSS",
        "JavaScript",
        "TypeScript",
        "Bootstrap",
        "React Bootstrap",
        "React",
        "AHK",
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
        Weight := 1.5 ** Index
        TotalWeight += Weight
        Weights.Push(TotalWeight)
    }
    return Weights
}

ProcessData(RawData) {
    return { Data: RawData, Weights: GetWeights(RawData), Len: RawData.Length }
}

ProcessedCommonData := ProcessData(RawCommonData)
ProcessedFocusData := ProcessData(RawFocusData)
ProcessedUrgentData := ProcessData(RawUrgentData)

for Index, Value in ProcessedCommonData.Data
{
    Value.Len := Value.Data.Length
    Value.Weights := GetWeights(Value.Data)
}