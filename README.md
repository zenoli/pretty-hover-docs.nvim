# Pretty Hover Docs

Manually insert linebreaks to make hover docs more readable.

# Pseudocode

```lua
"This is a very lon|g sentence"
 1  4 67 9 11 1415  18

function find_next_split(sentence, width)
    local i, j = 0
    while j <= width do
        local i, j = next_split(sentence, pattern, j)
        if i == nil then 
            -- sentence fits entirely
            break 
        end
    end

    return i
end

```
