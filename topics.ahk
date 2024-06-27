Multiplier := 1.15

RawCommonData := [{
    Name: "ml",
    Data: [
        "ML Article",
        "ML Book",
    ]
}, {
    Name: "diagnostics",
    Data: [
        "Diagnostics Article",
        "Diagnostics Book",
    ]
}, {
    Name: "anatomy",
    Data: [
        "Anatomy Article",
        "Anatomy Book",
    ]
}, {
    Name: "anthropology",
    Data: [
        "Anthropology Article",
        "Anthropology Book",
    ]
}, {
    Name: "psychiatry",
    Data: [
        "Psychiatry Article",
        "Psychiatry Book",
    ]
}, {
    Name: "psychology",
    Data: [
        "Psychology Article",
        "Psychology Book",
    ]
}, {
    Name: "body language",
    Data: [
        "Body Language Article",
        "Body Language Book",
    ]
}, {
    Name: "cooking",
    Data: [
        "Cooking Article",
        "Cooking Book",
    ]
}, {
    Name: "poker",
    Data: [
        "Poker Article",
        "Poker Book",
    ]
}, {
    Name: "mechanic",
    Data: [
        "Mechanic Article",
        "Mechanic Book",
    ]
}, {
    Name: "computer hardware",
    Data: [
        "Device Monitor",
        "HWiNFO (hardware)"
    ]
}, {
    Name: "ios shortcuts",
    Data: ["iOS Shortcuts"]
}, {
    Name: "computer software",
    Data: [
        "Working Copy",
        "HWiNFO (sofware)",
        "Proton VPN"
    ]
}, {
    Name: "adblock",
    Data: [
        "AdGuard",
        "uBlock Origin"
    ]
}, {
    Name: "web",
    Data: [
        "DuckDuckGo",
        "Tor"
    ]
}, {
    Name: "devtools",
    Data: [
        "Chrome Devtools",
        "Swift Playground",
        "VS Code",
    ]
}, {
    Name: "webdev",
    Data: [
        "Java",
        "HTML",
        "CSS",
        "JavaScript",
        "TypeScript",
        "Query",
        "Spring",
        "Bootstrap",
        "React Bootstrap",
        "React",
        "Web Dev Coding"
    ]
}, {
    name: "swift",
    Data: [
        "Swift",
        "SwiftUI",
        "Swift Coding"
    ]
}, {
    Name: "ahk",
    Data: [
        "AHK Docs",
        "AHK Coding"
    ]
}, {
    Name: "english",
    Data: [
        "English Article",
        "English Book"
    ]
}, {
    Name: "russian",
    Data: [
        "Russian Article",
        "Russian Book",
    ]
}, {
    Name: "japanese",
    Data: [
        "Japanese Article",
        "Japanese Book",
    ]
}, {
    Name: "german",
    Data: [
        "German Article",
        "German Book",
    ]
}, {
    Name: "driving",
    Data: [
        "Driving Article",
        "Driving Book",
    ]
}]

RawFocusData := []

RawUrgentData := []


GetWeights(arr) {
    TotalWeight := 0
    Weights := []
    for Index, Value in arr {
        Weight := Multiplier ** Index
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