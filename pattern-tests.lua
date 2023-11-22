describe("Java Doc Splitter", function()
    it("Find next markdown link", function()
        local link = "[markdown link](https://www.example.com)"
        local text = "This is a file containing a " .. link .. " to detect."
        local matched_link = text:match("%[.-%]%(.-%)")
        assert.equals(link, matched_link)
    end)

    it("Find next word", function()
        local sentence = "word, 123word word, WORD! word. [abc]"
        local pattern = "%f[%w]%w-%f[%W]"

        local function match_next(word, start)
            local i, j = string.find(sentence, pattern, start)
            if i ~= nil then
                local match = string.sub(sentence, i, j)
                assert.equals(word, match)
            end
            return j
        end

        local start = match_next("word", 1)
        start = match_next("123word", start)
        start = match_next("word", start)
        start = match_next("WORD", start)
        start = match_next("word", start)
        start = match_next("abc", start)
    end)
end)
