import Data.List (group, sort, sortBy)

-- Input: Poker hands + bid
-- Rules to define the hand rank + untie
-- Oder the hands by following these rules. The winnings are the hand rank times its bid.
-- Answer: sum all of the winnings.

data Hand = Hand String Int deriving (Show, Eq)

rankHand :: String -> Int
rankHand hand = case sortBy (flip compare) $ map length $ group $ sort hand of
    [5] -> 7
    [4, _] -> 6
    [3, 2] -> 5
    [3, _, _] -> 4
    [2, 2, _] -> 3
    [2, _, _, _] -> 2
    _ -> 1


compareHand :: Hand -> Hand -> Ordering
compareHand (Hand h1 _) (Hand h2 _)
    | rankHand h1 > rankHand h2 = GT
    | rankHand h1 < rankHand h2 = LT
    | otherwise = compare h1 h2


formatCards :: String -> String
formatCards = map charToCard
  where
    charToCard 'T' = 'A'
    charToCard 'J' = 'B'
    charToCard 'Q' = 'C'
    charToCard 'K' = 'D'
    charToCard 'A' = 'E'
    charToCard c = c


parseHand :: (String -> String) -> String -> Hand
parseHand format input = case words input of
    [hand, bid] -> Hand (format hand) (read bid)
    _ -> error "Invalid input"


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
