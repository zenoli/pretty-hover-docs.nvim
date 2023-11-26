local M = {}

function M.find_split_position(sentence, max_width)
    if string.len(sentence) <= max_width then
        return max_width
    end
    local word_pattern = "%f[%w]%w-%f[%W]"
    ---@type integer|nil
    local i = 0
    ---@type integer|nil
    local j = 0

    while i <= max_width do
        i, j = string.find(sentence, word_pattern, i + 1)
        if j > max_width then
            return i - 1
        end
        i = j
    end

    return i
end

return M
