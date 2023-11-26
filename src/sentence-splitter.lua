local M = {}

---@param sentence string Sentence to split
---@param max_width integer Max width constraint.
---@return integer split_position Indicates that `sentence` must be split from `[0, split_position]`
function M.find_split_position(sentence, max_width)
    if string.len(sentence) <= max_width then
        return string.len(sentence)
    end
    local word_pattern = "%S+"
    local link_pattern = "%[.-%]%(.-%)"

    local block_start = 1 ---@type integer? Visible begin of current block
    local block_end ---@type integer?       Visible end of current block
    local conceal_end ---@type integer?     Concealed end of current block


    while true do
        local word_start, word_end = string.find(sentence, word_pattern, block_start)
        local link_start, link_end = string.find(sentence, link_pattern, block_start)

        if not link_start or word_start < link_start then
            -- next block is word
            if word_end <= max_width then
                block_start = word_end + 1
            else
                if block_start == 1 then
                    return math.min(word_end + 1, sentence:len())
                else
                    return word_start - 1
                end
            end
        else
            -- next block is markdown link
            local link_desc_end = string.find(sentence, "%]%(", link_start)
            -- Concealed cols don't contribute to `max_width` (+2 is for `[]`)
            if link_desc_end <= max_width + 2 then
                block_start = link_end + 1
                max_width = max_width + (link_end - link_desc_end) + 2
            else
                if block_start == 1 then
                    return math.min(link_end + 1, sentence:len())
                else
                    return link_start - 1
                end
            end
        end

        if block_start > sentence:len() then
            return sentence:len()
        end
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
