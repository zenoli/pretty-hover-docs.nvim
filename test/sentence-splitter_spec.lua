local function main()
    local sentence_splitter = require("src.sentence-splitter")
    local sentence = "This is a very long sentence"
    local max_width = 18
    local split_position = sentence_splitter.find_split_position(sentence, max_width)
end

main()

describe("sentence-splitter", function()
    it("Test 'find_split_position'", function()
        local sentence_splitter = require("src.sentence-splitter")
        local sentence = "This is a very long sentence"
        local max_width = 18
        local split_position = sentence_splitter.find_split_position(sentence, max_width)
        assert.equals(15, split_position)
    end)
end)
