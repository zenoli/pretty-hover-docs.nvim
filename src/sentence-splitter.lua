local M = {}

local function count_stars(sentence, block_start)
    local s, e = string.find(sentence, "[%*`]*", block_start)
    return e - s + 1
end

local function find_next_match_type(matches)
    local match_start
    local current_match_type = nil
    for _, match_type in ipairs { "link", "fmt", "word" } do
        local match_block = matches[match_type]
        if match_block[1] and (not match_start or match_block[1] < match_start) then
            current_match_type = match_type
            match_start = match_block[1]
        end
    end
    return current_match_type
end

---@param sentence string Sentence to split
---@param max_width integer Max width constraint.
---@return integer split_position Indicates that `sentence` must be split from `[0, split_position]`
function M.find_split_position(sentence, max_width)
    if string.len(sentence) <= max_width then
        return string.len(sentence)
    end
    local word_pattern = "%S+"
    local link_pattern = "%[.-%]%(.-%)"
    -- local fmt_pattern = "([%*`]*).+%1"
    local fmt_pattern = "([%*`]+).-%1"

    local search_start = 1 ---@type integer? Visible begin of current block


    while true do
        local matches = {
            link = { string.find(sentence, link_pattern, search_start) },
            word = { string.find(sentence, word_pattern, search_start) },
            fmt = { string.find(sentence, fmt_pattern, search_start) },
        }

        local match_type = find_next_match_type(matches)

        if match_type == "word" then
            -- next block is word
            if matches.word[2] <= max_width then
                search_start = matches.word[2] + 1
            else
                if search_start == 1 then
                    return math.min(matches.word[2] + 1, sentence:len())
                else
                    return matches.word[1] - 1
                end
            end
        elseif match_type == "fmt" then
            local n_fmt_chars = count_stars(sentence, matches.fmt[1])

            if matches.fmt[2] <= max_width + n_fmt_chars * 2 then
                search_start = matches.fmt[2] + 1
                local n_conceal_columns = n_fmt_chars * 2
                max_width = max_width + n_conceal_columns
            else
                if search_start == 1 then
                    return math.min(matches.fmt[2] + 1, sentence:len())
                else
                    return matches.fmt[1] - 1
                end
            end
        else
            -- next block is markdown link
            local link_desc_end = string.find(sentence, "%]%(", matches.link[1])
            -- Concealed cols don't contribute to `max_width` (+2 is for `[]`)
            if link_desc_end <= max_width + 2 then
                search_start = matches.link[2] + 1
                local n_conceal_columns = (matches.link[2] - link_desc_end) + 2
                max_width = max_width + n_conceal_columns
            else
                if search_start == 1 then
                    return math.min(matches.link[2] + 1, sentence:len())
                else
                    return matches.link[1] - 1
                end
            end
        end

        if search_start > sentence:len() then
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
