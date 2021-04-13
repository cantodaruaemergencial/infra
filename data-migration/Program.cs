using System;

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
                var s = PersonMigration.Do(m);
                Console.WriteLine(s);
            }
        }
    }
}
