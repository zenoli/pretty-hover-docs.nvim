local M = {}

---@param sentence string Sentence to split
---@param max_width integer Max width constraint.
---@return integer split_position Indicates that `sentence` must be split from `[0, split_position]`
function M.find_split_position(sentence, max_width)
    if string.len(sentence) <= max_width then
        return string.len(sentence)
    end
    local word_pattern = "%f[%w]%w-%f[%W]"
    local i ---@type integer?
    local j = 0 ---@type integer?
    repeat
        i = j
        i, j = string.find(sentence, word_pattern, i + 1)
    until j > max_width
    -- If sentence consists of single word > max_width
    if i == 1 then
        ---@cast j integer
        return j
    else
        return i - 1
    end
end

---@param sentence string
---@param max_width integer
---@return string[]
function M.split_sentence(sentence, max_width)
    local splits = {}

    local next_sentence = sentence

    repeat
        local split_position = M.find_split_position(next_sentence, max_width)
        local new_split = string.sub(next_sentence, 1, split_position):gsub("%s+$", "")
        next_sentence = string.sub(next_sentence, split_position + 1)
        table.insert(splits, new_split)
    until next_sentence == ''

    return splits
end

return M
