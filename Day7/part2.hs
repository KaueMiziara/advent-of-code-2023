import Data.List (group, sort, sortBy)

-- Part 2: Now the 'J' is a joker that worths 0 by default.
-- The Joker can be turned into any card that would maximize tha hand's rank.

data Hand = Hand String Int deriving (Show, Eq)

jokers :: String -> Int
jokers = length . filter (== '0')


rankHand :: String -> Int
rankHand hand = case (jokers hand, sortBy (flip compare) $ map length $ group $ sort hand) of
    (_, [5]) -> 7
    (4, [4, _]) -> 7
    (1, [4, _]) -> 7
    (_, [4, _]) -> 6
    (3, [3, 2]) -> 7
    (2, [3, 2]) -> 7
    (_, [3, 2]) -> 5
    (3, [3, _, _]) -> 6
    (1, [3, _, _]) -> 6
    (_, [3, _, _]) -> 4
    (2, [2, 2, _]) -> 6
    (1, [2, 2, _]) -> 5
    (_, [2, 2, _]) -> 3
    (2, [2, _, _, _]) -> 4
    (1, [2, _, _, _]) -> 4
    (_, [2, _, _, _]) -> 2
    (1, _) -> 2
    (_, _) -> 1


compareHand :: Hand -> Hand -> Ordering
compareHand (Hand h1 _) (Hand h2 _)
    | rankHand h1 > rankHand h2 = GT
    | rankHand h1 < rankHand h2 = LT
    | otherwise = compare h1 h2


formatCards :: String -> String
formatCards = map charToCard
  where
    charToCard 'T' = 'A'
    charToCard 'J' = '0'
    charToCard 'Q' = 'C'
    charToCard 'K' = 'D'
    charToCard 'A' = 'E'
    charToCard c = c


parseHand :: (String -> String) -> String -> Hand
parseHand format input = case words input of
    [hand, bid] -> Hand (format hand) (read bid)


parse :: (String -> String) -> String -> [Hand]
parse format = map (parseHand format) . lines


totalWin :: [Hand] -> Int
totalWin = snd . foldl (\(i, total) (Hand _ bid) -> (i + 1, total + i * bid)) (1, 0)


answer :: String -> String
answer = show . totalWin . sortBy compareHand . parse formatCards


main :: IO ()
main = do
  input <- readFile "input.txt"
  putStrLn $ "Answer: " ++ answer input ++ "\n"
