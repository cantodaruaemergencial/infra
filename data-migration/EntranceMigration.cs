using System;
using System.Collections.Generic;

namespace data_migration
{
    public class EntranceMigration
    {
        private List<string> dates;
        private EntranceMigrationResult result;

        private static string header = "insert into person_entrances (person, datetime)";

        public EntranceMigration()
        {
            result = new EntranceMigrationResult()
            {
                EmptyLines = 0,
                ImportedLines = 0,
                Query = ""
            };
            dates = new List<string>();
        }

        public EntranceMigrationResult Do(List<List<string>> m)
        {
            ReadHeader(m);

            var sql = "";

            for (int i = 1; i < m.Count; i++)
            {
                if (m[i][2] == "")
                {
                    result.EmptyLines++;
                    Console.WriteLine($"Linha {i} - Nome vazio");
                }
                else
                {
                    var temp = DoLine(m[i]);
                    if (string.IsNullOrWhiteSpace(temp))
                    {
                        result.EmptyLines++;
                        Console.WriteLine($"Linha {i} - Nenhuma entrada");
                    }
                    else
                    {
                        result.ImportedLines++;
                        sql += header + " values " + (temp.Substring(0, temp.Length - 2) + ";").Sanitize();
                    }
                }
            }

            sql += " update person_entrances set published_at = now(), created_at = now(), updated_at = now();";

            result.Query = sql;
            return result;

        }

        public string DoLine(List<string> li)
        {
            string sql = "";
            for (int i = 3; i < li.Count; i++)
            {
                if (li[i] != "")
                    sql += $"((select id from people where name like {li[2].ReadString()} order by id limit 1), '{dates[i - 3]}'), ";
            }
            return sql;
        }

        private void ReadHeader(List<List<string>> m)
        {
            int i = 3;
            while (i < m[0].Count)
                dates.Add(m[0][i++]);
        }
    }
}