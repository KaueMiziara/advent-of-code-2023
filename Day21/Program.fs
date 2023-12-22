open System.IO

let applyBoth f g x = (f x, g x)

let parseInput = 
    let makeGrid = Seq.map (Seq.toArray) >> Seq.toArray

    let size = applyBoth (Seq.head >> String.length) Seq.length
    applyBoth makeGrid size

let walk grid start =
    let step positions =
        let stepFrom (x, y) = 
            let validStep (x, y) = grid (x, y) <> '#'
        
            [(x - 1, y); (x + 1, y); (x, y - 1); (x, y + 1)] |> List.filter validStep |> Seq.ofList
        let p' = positions |> Set.toSeq |> Seq.collect stepFrom |> Set.ofSeq
        
        Some (p', p')
    Seq.unfold step (Set.singleton start)

let steps stepsNumber = Seq.skip (stepsNumber - 1) >> Seq.head

let part1 (grid:char [][], (w, h)) = 
    walk (fun (x,y) -> grid[y][x]) (w/2, h/2) |> steps 64 |> Set.count

let part2 (grid: char[][], (width, height)) =
    let wrapIndex index size =
        if index < 0 then (size + (index % size)) % size
        else index % size

    let walker = 
        walk (fun (x, y) -> grid.[wrapIndex y height].[wrapIndex x width]) 
            (width / 2, height / 2)

    let findCrossings = 
        Seq.mapi (fun i element -> 
            if i % width = (width / 2 - 1) then Some element else None)
        >> Seq.choose id
    
    let crossings =
        walker
        |> findCrossings
        |> Seq.take 3
        |> Seq.map (Set.count >> int64)
        |> Seq.toArray

    let numberOfGrids = 26501365L / int64 width

    crossings.[0] + numberOfGrids * (crossings.[1] - crossings.[0]) +
        (numberOfGrids * (numberOfGrids - 1L) / 2L) * 
        ((crossings.[2] - crossings.[1]) - (crossings.[1] - crossings.[0]))


let main =
    let parsedInput = 
        File.ReadAllLines "input.txt" |> parseInput

    let answer1 =
        parsedInput |> part1 

    let answer2 =
        parsedInput |> part2

    printfn "%A" answer1
    printfn "%A" answer2

main
