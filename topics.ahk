unworkableData :=
    [
        "AHK",
        "Miscellaneous",
        "DSA", {
            name: "webdev",
            data: [
                "HTML",
                "CSS",
                "JavaScript",
                "TypeScript",
                "Bootstrap",
                "Java",
                "Spring",
                "React",
                "React Bootstrap"
            ]
        }, {
            name: "devtools",
            data: [
                "IntelliJ",
                "VS Code",
                "Chrome Devtools"
            ]
        }, {
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
                "Excel"
            ]
        }, {
            name: "real shit",
            data: [
                "Clean Up",
                "Workout"
            ]
        }
    ]

getWeights(arr) {
    totalWeight := 0
    weights := []
    for index, value in arr {
        weight := 1.4 ** (index - 1)
        totalWeight += weight
        weights.Push(totalWeight)
    }
    return weights
}


workableData := { data: unworkableData, weights: getWeights(unworkableData), len: unworkableData.Length }

for index, value in workableData.data
{
    if (IsObject(value)) {
        value.len := value.data.Length
        value.weights := getWeights(value.data)
    } else {
    }
}