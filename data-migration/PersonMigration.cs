using System;
using System.Collections.Generic;

namespace data_migration
{
    public static class PersonMigration
    {

        private static string header =
            "insert into table people (" +
                "name, " +
                "socialname, " +
                "mothername, " +
                "birthdate, " +
                "birthplace, " +
                "skincolor " +
            ")";

        public static string Do(List<List<string>> m)
        {
            var sql = header + " values ";
            foreach (var p in m)
                sql += DoLine(p) + ", ";
            return (sql.Substring(0, sql.Length - 2) + ";").Sanitize();
        }

        private static string DoLine(List<string> li) => "(" +
            $"{li[4].ReadString()}," + // name
            $"{li[5].ReadString()}," + // socialname
            $"{li[7].ReadString()}," + // mothername
            $"{li[6].ReadDate()}," + // birthdate
            $"{li[8].ReadString()}," + // birthplace
            $"(select id from skincolor where skincolor = {li[9].ReadString()})" + // skincolor
        ")";
    }
}