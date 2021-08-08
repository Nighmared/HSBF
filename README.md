# HSBF - Brainfuck interpreter written in haskell
using the function `interpret :: String -> [Int]` the program will return the output of running the Brainfuck program represented by the String. Syntax below
- '+' Increment current cell by 1
- '-' Decrement current cell by 1
- '<' Move one cell to the left
- '>' Move one cell to the right
- '.' Add value of current cell to the output
- '[**X**]' repeat the operations represented by `X :: [Char]` until the current cell has value 0


## Example:
```bash
$ ghci bf.hs
*Main> interpret "+++.>++.<--."
[3, 2, 1]
*Main >
```
Here the input String first increments the current cell 3 times, adds it to the output and the moves one cell to the right. Now it increments this cell by 2, adds it to the output
and moves back to the starting cell. This cell is now decremented by 2 and added to the output.
