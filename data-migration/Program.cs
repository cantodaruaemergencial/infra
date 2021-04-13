using System;

namespace data_migration
{
    public class Program
    {
        static void Main(string[] args)
        {
            if (args[0] == "person")
            {
                var m = Util.ReadCsv(args[1]);
                var s = PersonMigration.Do(m);
                Console.WriteLine(s);
            }
        }
    }
}
