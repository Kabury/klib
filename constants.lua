local module = {}

module.saorder = {
    "automation-science-pack",
    "logistic-science-pack",
    "chemical-science-pack",
    "production-science-pack",
    "utility-science-pack",
    "space-science-pack",
    "metallurgic-science-pack",
    "agricultural-science-pack",
    "electromagnetic-science-pack",
    "cryogenic-science-pack",
    "promethium-science-pack"
}

module.baseorder = {
    "automation-science-pack",
    "logistic-science-pack",
    "chemical-science-pack",
    "production-science-pack",
    "utility-science-pack",
    "space-science-pack"
}

module.pyorder = {
    "automation-science-pack",
    "py-science-pack-1",
    "logistic-science-pack",
    "py-science-pack-2",
    "chemical-science-pack",
    "py-science-pack-3",
    "production-science-pack",
    "py-science-pack-4",
    "utility-science-pack",
    "space-science-pack"
}

module.pyamounts = {
    {1},
    {2, 1},
    {3, 2, 1},
    {6, 3, 2, 1},
    {10, 6, 3, 2, 1},
    {20, 10, 6, 3, 2, 1},
    {30, 20, 10, 6, 3, 2, 1},
    {60, 30, 20, 10, 6, 3, 2, 1},
    {100, 60, 30, 20, 10, 6, 3, 2, 1},
    {200, 100, 60, 30, 20, 10, 6, 3, 2, 1},
}

return module
