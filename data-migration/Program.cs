using System;
using System.IO;

namespace data_migration
{
    public class Program
    {
        static void Main(string[] args)
        {
            char separator = args[1].EndsWith("tsv") ? '\t' : ',';

            if (args[0] == "person")
            {
                var m = Util.ReadCsv(args[1], separator);
                var s = new PersonMigration().Do(m);
                Console.ForegroundColor = ConsoleColor.White;

                Console.WriteLine($"Importados - {s.ImportedLines}");
                Console.WriteLine($"Nomes vazios - {s.EmptyLines}");
                Console.WriteLine($"Nomes repetidos - {s.RepeatedNames}");
                Console.WriteLine($"Números repetidos - {s.RepeatedNumbers}");

                File.WriteAllText("output-person.sql", s.Query);
            }
        }
    }
}
