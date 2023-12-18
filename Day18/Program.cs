using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Day18;

class Program
{
    static void Main(string[] args)
    {
        var input = AocUtils.ReadInput("input.txt");

        var answer1 = AocUtils.Part1(input);
        Console.WriteLine("Part 1 answer: {0}", answer1.ToString());
    }
}

class AocUtils
{
    public static double Part1(string[] input)
    {
        var polygon = new List<Point>();
        var position = new Point(0, 0);
        var circumference = 0.0;

        foreach (var line in input)
        {
            polygon.Add(position);
            var steps = line.Split(' ');

            var length = int.Parse(steps[1]);

            position = steps[0] switch
            {
                "R" => new Point(position.Row, position.Col + length),
                "L" => new Point(position.Row, position.Col - length),
                "D" => new Point(position.Row + length, position.Col),
                "U" => new Point(position.Row - length, position.Col),
            };

            circumference += length;
        }

        return AocUtils.GaussArea(polygon) + circumference / 2 + 1;
    }

    public static double GaussArea(List<Point> vertices)
    {
        int n = vertices.Count;
        double summation = 0.0;

        for (int i = 0; i < n - 1; i++)
        {
            summation += vertices[i].Row * vertices[i + 1].Col - vertices[i + 1].Row * vertices[i].Col;
        }
        
        var lastTerm = (vertices[n - 1].Row * vertices[0].Col) - (vertices[0].Row * vertices[n - 1].Col);
        var area = Math.Abs(summation + lastTerm) / 2.0;
        
        return area;
    }

    public static string[] ReadInput(string fileName)
    {
        var input = File.ReadAllLines(fileName);
        return input;
    }
}

public struct Point
{
    public double Row { get; }
    public double Col { get; }

    public Point(double row, double col)
    {
        Row = row;
        Col = col;
    }
}
