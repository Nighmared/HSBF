data Tape = Tape [Int] Int [Int]

emptyTape :: Tape
emptyTape = Tape [] 0 []

current :: Tape -> Int
current (Tape l c r) = c

moveLeft :: Tape -> Tape
moveLeft (Tape [] c r) = Tape [] 0 (c:r)
moveLeft (Tape (l:ls) c r) = Tape ls l (c:r)

moveRight :: Tape -> Tape
moveRight (Tape l c []) = Tape (c:l) 0 []
moveRight (Tape l c (r:rs)) = Tape (c:l) r rs

updateTape :: (Int -> Int) -> Tape -> Tape
updateTape f (Tape l c r) = Tape l (f c) r

data Op = Inc | Dec | GoLeft | GoRight | Out | Loop Program
type Program = [Op]

run :: Program -> [Int]
run p = snd $ exec p emptyTape []

exec :: Program -> Tape -> [Int] -> (Tape,[Int])
exec [] t r = (t,r)
exec (o:p) t r = case o of
    Inc -> exec p (updateTape (+1) t) r
    Dec -> exec p (updateTape (+(0-1)) t) r
    GoLeft -> exec p (moveLeft t) r
    GoRight -> exec p (moveRight t) r
    Out -> exec p t (r ++ [current t])
    Loop l -> doLoop l (t, r) where
        doLoop :: Program -> (Tape, [Int]) -> (Tape,[Int])
        doLoop i (m, o)
          | current m == 0 = exec p m o
          | otherwise = doLoop i $ exec i m o

go :: [Char] -> [Char] -> Int -> Program
go body r 0 = Loop (parse body) : parse r
go body (t:ts) d
  | (t == ']' && d==1) = go (body) ts (d-1)
  | t == ']' = go (body ++ "]") ts (d-1)
  | t == '[' = go (body ++ "[") ts (d+1)
  | otherwise = go (body ++ [t]) ts d

parse :: [Char] -> Program
parse [] = []
parse (i:is)
  | i == '[' = (go [] is 1 )
  | otherwise = (parseChar i) : parse is

parseChar :: Char -> Op
parseChar c
  |c == '+' = Inc
  |c == '-' = Dec
  |c == '<' = GoLeft
  |c == '>' = GoRight
  |c == '.' = Out

interpret :: [Char] -> [Int]
interpret = run.parse

main = do putStrLn "Input Brainfuck Program:"
          prg <- getLine
          putStrLn  $ show $ interpret prg
