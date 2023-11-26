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

        it("should allow markdown links to violate `max_width` constraint", function()
            local sentence = "This is a text containing a [markdown link](https://www.example.com) and some text after"
            assert.equals(
                78,
                sentence_splitter.find_split_position(sentence, 50)
            )
            assert.equals(
                28,
                sentence_splitter.find_split_position(sentence, 40)
            )
        end)

        it("should allow markdown links to violate `max_width` constraint", function()
            assert.equals(19, sentence_splitter.find_split_position("start [desc](link) end", 10))
            assert.equals(6, sentence_splitter.find_split_position("start [desc](link) end", 9))
            assert.equals(32, sentence_splitter.find_split_position("start [desc](link) [desc](link) end", 15))
            assert.equals(35, sentence_splitter.find_split_position("start [desc](link) [desc](link) end", 19))
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

        it("should handle punctuation marks", function()
            local splits = sentence_splitter.split_sentence("This, is a (very long) sentence", 10)

            assert.equals(#splits, 4)
            assert.equals(splits[1], "This, is a")
            assert.equals(splits[2], "(very")
            assert.equals(splits[3], "long)")
            assert.equals(splits[4], "sentence")
        end)

        it("should violate max constraint if word length exceeds `max_width`", function()
            local sentence = "short words Supercalifragilisticexpialidocious short words"
            local max_width = 20
            local splits = sentence_splitter.split_sentence(sentence, max_width)

            assert.equals(3, #splits)
            assert.equals("short words", splits[1])
            assert.equals("Supercalifragilisticexpialidocious", splits[2])
            assert.equals("short words", splits[3])
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

        it("should allow markdown links to violate `max_width` constraint", function()
            local sentence = "This is a text containing a [markdown link](https://www.example.com) and some text after"
            local splits_long = sentence_splitter.split_sentence(sentence, 50)
            assert.equals(2, #splits_long)
            assert.equals(
                "This is a text containing a [markdown link](https://www.example.com) and some",
                splits_long[1]
            )
            assert.equals("text after", splits_long[2])

            local splits_short = sentence_splitter.split_sentence(sentence, 40)
            assert.equals(2, #splits_short)
            assert.equals("This is a text containing a", splits_short[1])
            assert.equals("[markdown link](https://www.example.com) and some text after", splits_short[2])
        end)
    end)
end)
