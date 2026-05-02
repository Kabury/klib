local module = {}

local meld = require("meld")
local inter = require("internal")
local const = require("constants")

---@class RecipeOptions
---@field en double Pass energy value
---@field cat RecipeCategoryID Pass category value
---@field enabled boolean Pass enabled value
---@field rt string "type-name-amounts" / "names-and-amount" / "names"
---@field it string "type-name-amounts" / "names-and-amount" / "names"
---@field ret boolean Whether it gives you the table OR it just data:extends instead

--- Shorthand to make recipes.
---
--- Automatically calls data:extend() on the created recipe unless specified otherwise.
---
--- ### Examples
---
--- ```lua
--- qrecipe{"preservation-wagon",{"cargo-wagon",1,"refrigerator",2,"electronic-circuit",5}}
--- ```
--- @param _name string The name of the recipe prototype.
--- @param _ingredients table Table defaults to "names-and-amount". The ingredients have to be declared as {ingredient,amount,i,a,...}. Use "type-name-amounts" to use {i/f,ingredient,amount} for fluid recipes. "i" and "f" expand automatically.
--- @param _results table Table defaults to "names". The result will be one of each item in the table.
--- @param _opts RecipeOptions Pass values to recipe energy, category and enabled fields. 'rt' and 'it' determine the structure of _ingredients and _results tables. 'ret' determines if the function data:extends or returns.
--- @return table? recipe If ret=true, then the recipe table is returned
function module.qrecipe(_name,_ingredients,_results,_opts)
    if _opts == nil then _opts = {} end
    local _energy, _category, _enabled, _resulttype, _ingredienttype, _return = _opts.en, _opts.cat, _opts.enabled, _opts.rt, _opts.it, _opts.ret
    if _ingredienttype == nil then _ingredienttype = "name-and-amount" end
    if _resulttype == nil then _resulttype = "names" end
    if _results == nil then _results = {_name} end
    if _enabled == nil then _enabled = false end
    if _return == nil then _return = false end

    local _fingredient = inter.recipetable{_ingredients,_ingredienttype}
    local _fresult = inter.recipetable{_results,_resulttype}

    local _recipe=
    {
        type="recipe",
        name=_name,
        enabled=_enabled,
        ingredients=_fingredient,
        results=_fresult,
        category=_category,
        energy_required=_energy
    }

    if _return then
        return _recipe
    else
        data:extend{_recipe}
    end

end



---@class TechnologyOptions
---@field pre table<TechnologyID> Contains all prerequisites for the tech 
---@field time double How many seconds it takes to research a single unit
---@field order table Provide all of the science packs item name strings to use in the technology. Defaults to the vanilla order
---@field add table Add these science packs at the end of the order table. Useful if using for example to add military tech to any other tech.
---@field eff table Contains the name of the effect. For recipes, it's the name of the recipe
---@field efft table Contains a type for every effect in the table. If not provided every effect is assumed to be "unlock-recipe"
---@field pi table Contains path to science logo, size, and optionally r,g,b,a tint values
---@field t boolean Whether you provided tint values in the above table
---@field ret boolean Whether it gives you the table OR it just data:extends instead

--- Shorthand to make technologies.
---
--- Automatically calls data:extend() on the created technology unless specified otherwise.
---
--- ### Examples
---
--- ```lua
--- qtech{"preservation-wagon",{"cargo-wagon",1,"refrigerator",2,"electronic-circuit",5}}
--- ```
--- @param _name string The name of the recipe prototype
--- @param _counter double The number of units the research has to do to complete
--- @param _levels table If integer, it's the level number to target (logistics level 2, chem 3, etc.). And all amounts are 1. If a table, it's the amount of each pack in the order table. 
--- @param _opts TechnologyOptions Pass values to recipe energy, category and enabled fields. 'rt' and 'it' determine the structure of _ingredients and _results tables. 'ret' determines if the function data:extends or returns.
--- @return table? recipe If ret=true, then the recipe table is returned
function module.qtech(_name,_counter,_levels,_opts)
    local _prerequisites, _time, _order, _add, _effectv, _effecttypes, _preicons, _tint, _return = _opts.pre, _opts.time, _opts.order, _opts.add, _opts.eff, _opts.efft, _opts.pi, _opts.t, _opts.ret
    if _preicons==nil then _preicons={"__core__/graphics/empty.png",1} end
    if _effectv==nil then _effectv={"_"} end
    if _time==nil then _time=30 end
    if _order==nil then _order= const.baseorder end
    if _return == nil then _return = false end

    --local _picons=kh_strable{_preicons}
    --local _icons={icon=_picons[1],icon_size=tonumber(_picons[2])}
    --if _tint then
    --    _icons.tint={r=tonumber(_picons[3]),g=tonumber(_picons[4]),b=tonumber(_picons[5]),a=tonumber(_picons[6])}
    --end

    if _effecttypes==nil then
        _effecttypes={}
        for i=1,#_effectv do
            _effecttypes[i]="unlock-recipe"
        end
    end

    if _add ~= nil then
        _new_order = {}
        for k,v in pairs(_add) do
            table.insert(_new_order,v)
        end
        for k,v in pairs(_order) do
            table.insert(_new_order,v)
        end
        _order=_new_order
    end

    local _ingredients={}
    if type(_levels) ~= "table" then
        for i=1,_levels do
            _ingredients[i]={_order[i],1}
        end
    end

    if type(_levels) == "table" then
        local cont_count = 1
        for i,v in pairs(_levels) do
            if v ~=0 then
                _ingredients[cont_count]={_order[i],v}
                cont_count=cont_count+1
            end
        end
    end

    local _effects = {}
    for k,v in pairs(_effectv) do
        _effects[k]={type = _effecttypes[k],recipe=_effectv[k]}
    end

    local _icons={icon=_preicons[1],icon_size=_preicons[2]}
    if _tint then
        _icons.tint={r=_preicons[3],g=_preicons[4],b=_preicons[5],a=_preicons[6]}
    end

    local _technology =
    {
        type="technology",
        name=_name,
        icons={_icons},
        prerequisites=_prerequisites,
        effects=_effects,
        unit= {count=_counter,ingredients=_ingredients,time=_time},
    }

    if _return then
        return _technology
    else
        data:extend{_technology}
    end
end



--- Shorthand to call meld
---
--- Automatically calls data:extend() on the melded prototype
---
--- ### Examples
---
--- ```lua
--- kh_recipe{"preservation-wagon",{"cargo-wagon",1,"refrigerator",2,"electronic-circuit",5}}
--- ```
--- @param _prototype string The prototype we will clone from and to
--- @param _from string The base prototype to copy
--- @param _to table The table to meld with the old prototype 
function module.qmeld(_prototype,_from,_to)
    local _original = table.deepcopy(data.raw[_prototype][_from])
    local _new = meld.meld(_original,_to)
    data:extend{_new}
end

return module
