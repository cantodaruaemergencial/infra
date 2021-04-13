using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace data_migration
{
    public static class Util
    {
        public static List<List<string>> ReadCsv(string path)
        {
            var ls = File.ReadAllLines(path);
            var csv = (from li in ls select (li.Split(',').ToList())).Skip(1).ToList();
            return csv;
        }

        public static string Sanitize(this string s) =>
            s.Replace(Environment.NewLine, string.Empty);

        public static string ReadDate(this string s) =>
            $"'{s.Substring(6, 4)}-{s.Substring(3, 2)}-{s.Substring(0, 2)}'";

        public static string ReadString(this string s)
        {
            s = s.Replace(';', '\0');
            return string.IsNullOrWhiteSpace(s) ? "null" : $"'{s}'";
        }
    }
}