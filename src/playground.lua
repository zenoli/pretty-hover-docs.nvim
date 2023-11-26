local sentence_splitter = require("src.sentence-splitter")

local function main()
    local splits_long = sentence_splitter.split_sentence("start [desc](link) end", 10)
end

main()
