describe("sentence-splitter", function()
    local sentence_splitter = require("src.sentence-splitter")

    describe("find_split_position", function()
        it("should split correctly", function()
            assert.equals(
                15,
                sentence_splitter.find_split_position(
                    "This is a very long sentence",
                    18
                )
            )
        end)

        it("should not split long words", function()
            local long_word = "Supercalifragilisticexpialidocious"
            assert.equals(
                long_word:len(),
                sentence_splitter.find_split_position(
                    long_word,
                    10
                )
            )
        end)
    end)

    describe("split_sentence", function()
        it("should split a sentence", function()
            local splits = sentence_splitter.split_sentence("This is a very long sentence", 10)

            assert.equals(#splits, 3)
            assert.equals(splits[1], "This is a")
            assert.equals(splits[2], "very long")
            assert.equals(splits[3], "sentence")
        end)

        it("should violate max constraint if word length exceeds `max_width", function()
            local sentence = "short words Supercalifragilisticexpialidocious short word"
            local max_width = 20
            local splits = sentence_splitter.split_sentence(sentence, max_width)

            assert.equals(#splits, 3)
            assert(splits[1], "short words")
            assert(splits[2], "Supercalifragilisticexpialidocious")
            assert(splits[3], "short words")
        end)

        it("can handle empty strings", function()
            local splits = sentence_splitter.split_sentence("", 10)
            assert.equals(#splits, 1)
            assert.equals(splits[1], "")
        end)

        it("can handle zero width", function()
            local splits = sentence_splitter.split_sentence("foo", 0)
            assert.equals(#splits, 1)
            assert.equals(splits[1], "foo")
        end)

        it("should not consider spaces at split boundary", function()
            local splits = sentence_splitter.split_sentence("a  b   c", 4)
            assert.equals(#splits, 2)
            assert.equals(splits[1], "a  b")
            assert.equals(splits[2], "c")
        end)
    end)
end)
