local library = {}

local function kmerge(table)
    for k, v in pairs(table) do
        library[k] = v
    end
end

kmerge(require("external"))
kmerge(require("constants"))
kmerge(require("internal"))
kmerge(require("functions"))

return library
