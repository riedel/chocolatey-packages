-- filter.lua
--
function is_top_level_section(elem)
    return elem.level == 1
end

function is_features_subsection(elem)
    return elem.level == 2 and elem.identifier == "features"
end

function Pandoc(doc)
    local new_blocks = {}
    local in_section = false

    for _, elem in ipairs(doc.blocks) do

        if elem.t == "Header" then
            if is_top_level_section(elem) then
                table.insert(new_blocks, elem)
                in_section = true
            elseif is_features_subsection(elem) then
                table.insert(new_blocks, elem)
                in_section = true
            else
                in_section = false
            end
        elseif in_section then
            table.insert(new_blocks, elem)
        end
    end

    doc.blocks = new_blocks
    return doc
end
