local sentence_splitter = require("src.sentence-splitter")

local function main()
    local split_position = sentence_splitter.split_sentence("Hello", 3)
end

main()
