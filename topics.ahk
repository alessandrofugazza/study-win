unworkableData :=
    [{
        name: "postman",
        data: [
            "Postman"
        ]
    }, {
        name: "fastweb",
        data: [
            "Fastweb"
        ]
    }, {
        name: "ahk",
        data: [
            "AHK"
        ]
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
        name: "devtools",
        data: [
            "IntelliJ",
            "VS Code",
            "Chrome Devtools"
        ]
    },
        ; {
        ;     name: "warehouse",
        ;     data: [
        ;         "Forklift"
        ;     ]
        ; },
        {
            name: "its",
            data: [
                "ITS"
            ]
        }, {
            name: "icdl",
            data: [
                "Computer Essentials",
                "Online Essentials",
                "IT Security",
                "Online Collaboration"
            ]
        },
        ; {
        ;     name: "office",
        ;     data: [
        ;         "PowerPoint",
        ;         "Word",
        ;         "Excel"
        ;     ]
        ; },
        {
            name: "real shit",
            data: [
                "Improvement",
                "Clean Up"
            ]
        }
    ]


getWeights(arr) {
    totalWeight := 0
    weights := []
    for index, value in arr {
        weight := 1.2 ** (index - 1)
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