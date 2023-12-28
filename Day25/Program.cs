namespace Day25;

class Program
{
    static void Main()
    {
        var answer = AocUtils.Part1("input.txt");

        Console.WriteLine($"Answer: {answer}");
    }
}

class Graph
{
    private readonly int _vertices;
    private readonly Random _random;
    private readonly List<(string origin, string dest)> _edges;

    public Graph(List<(string origin, string dest)> edges, Random random)
    {
        _vertices = edges.SelectMany(x => 
            new List<string> { x.origin, x.dest }
        ).Distinct().Count();

        _edges = edges;
        _random = random;
    }

    public (int minCut, int vertices1Count, int vertices2Count) KargerCut()
    {
        var contractedEdges = _edges;
        var contractedVertices = _vertices;
        var contracted = new Dictionary<string, List<string>>();

        while (contractedVertices > 2)
        {
            var (origin, dest) = contractedEdges[_random.Next(0, contractedEdges.Count)];

            if (contracted.ContainsKey(origin))
                contracted[origin].Add(dest);
            else
                contracted.Add(origin, [dest]);

            if (contracted.ContainsKey(dest))
            {
                contracted[origin].AddRange(contracted[dest]);
                contracted.Remove(dest);
            }

            var newEdges = new List<(string origin, string dest)>();
            foreach (var edge in contractedEdges)
            {
                if (edge.dest == dest)
                    newEdges.Add((edge.origin, origin));
                else if (edge.origin == dest)
                    newEdges.Add((origin, edge.dest));
                else
                    newEdges.Add(edge);
            }

            contractedEdges = newEdges.Where(x => x.origin != x.dest).ToList();
            contractedVertices--;
        }

        var counts = contracted.Select(x => x.Value.Count + 1).ToList();
        return (contractedEdges.Count, counts.First(), counts.Last());
    }
}

class AocUtils
{
    public static int Part1(string fileName)
    {
        var input = ReadInput(fileName);
        var edges =
            from row in input
            select row.Replace(":", "").Split(" ") into split
            from dest in split.Skip(1)
            let origin = split[0]
            select (origin, dest);

        var graph = new Graph(edges.ToList(), new Random());

        var minCut = int.MaxValue;
        int count1 = 0;
        int count2 = 0;

        while (minCut != 3)
            (minCut, count1, count2) = graph.KargerCut();

        return count1 * count2;
    }

    public static string[] ReadInput(string fileName)
    {
        var input = File.ReadAllLines(fileName);
        return input;
    }
}
