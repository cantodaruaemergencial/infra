using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace data_migration
{
    public static class Util
    {
        public static List<List<string>> ReadCsv(string path, char separator)
        {
            var ls = File.ReadAllLines(path);
            var csv = (from li in ls select (li.Split(separator).ToList())).Skip(1).ToList();
            return csv;
        }

        public static string Sanitize(this string s) =>
            s.Replace(Environment.NewLine, string.Empty);

        public static string ReadDate(this string s) =>
            $"'{s.Substring(6, 4)}-{s.Substring(3, 2)}-{s.Substring(0, 2)}'";

        public static string ReadString(this string s)
        {
            if (s.Length > 0 && s[s.Length - 1] == ';')
                s = s.Substring(0, s.Length - 1);
            if (s.Length > 0 && s[s.Length - 1] == '.')
                s = s.Substring(0, s.Length - 1);
            return string.IsNullOrWhiteSpace(s) ? "null" : $"'{s}'";
        }

        public static string ReadLongString(this string s) =>
            string.IsNullOrWhiteSpace(s) ? "null" : $"'{s}'";

        public static string ReadBool(this string s) =>
            s.ToLower() == "s" ? "1" : "0";

        public static string ReadInt(this string s) => s;

    }
}