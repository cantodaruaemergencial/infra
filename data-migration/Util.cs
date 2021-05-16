using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

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

        public static string ReadDate(this string s)
        {
            if (string.IsNullOrEmpty(s)) return "null";
            var d = s.Split("/");
            if (d.Length != 3) return "null";
            return $"'{d[2]}-{d[1]}-{d[0]}'";
        }

        public static string ReadString(this string s)
        {
            if (s.Length > 0 && s[s.Length - 1] == ';')
                s = s.Substring(0, s.Length - 1);
            if (s.Length > 0 && s[s.Length - 1] == '.')
                s = s.Substring(0, s.Length - 1);
            return string.IsNullOrWhiteSpace(s) ? "null" : $"'{s.Trim()}'";
        }

        public static string ReadLongString(this string s) =>
            string.IsNullOrWhiteSpace(s) ? "null" : $"'{s}'";

        public static string ReadBool(this string s) =>
            s.ToLower() == "s" ? "1" : "0";

        public static string ReadInt(this string s) => s;

        public static string SpellingCheck(this string s, List<(string, string)> cs)
        {
            foreach (var c in cs)
                s = Regex.Replace(s, @$"\b{c.Item1}\b", c.Item2, RegexOptions.IgnoreCase);

            return s;
        }

        public static string RemoveExtraInformation(this string s)
        {
            var i = s.IndexOf(" - ");
            if (i > -1)
                s = s.Substring(0, i);
            return s;
        }

        public static string ToMasculineVersion(this string s)
        {
            if (s.EndsWith("a"))
                s = s.Substring(0, s.Length - 1) + "o";
            else if (s.EndsWith("A"))
                s = s.Substring(0, s.Length - 1) + "O";
            return s;
        }

        public static bool IsNullExpression(this string s) =>
            s.ToLower().Equals("s/i") ||
            s.ToLower().Equals("não informou") ||
            s.ToLower().Equals("não");
    }
}