local module = {}

function module.strable(arg)
    local _input = arg[1]
    local _output = {}
    for _value in string.gmatch(_input,'([^,]+)') do
        table.insert(_output,_value)
    end
    return _output
end

function module.recipetable(arg)
    local _input, _type = arg[1], arg[2]
    local _output = {}

    if _type == "names" then
        for i = 1, #_input do
            _output[i] = {type="item",name=_input[i],amount=1}
        end
    end

    if _type == "name-and-amount" then
        for i = 1, (#_input/2) do
            _output[i] = {type="item",name=_input[i*2-1],amount=_input[i*2]}
        end
    end

    if _type == "type-name-amounts" then
        for i = 1, (#_input/3) do
            local _ttype = "nil"
            if _input[i*3-2] == "i" then
                _ttype = "item"
            end
            if _input[i*3-2] == "f" then
                _ttype = "fluid"
            end
            _output[i] = {type=_ttype,name=_input[i*3-1],amount=_input[i*3]}
        end
    end

    return _output
end

return module
