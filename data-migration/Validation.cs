using System;
using System.Collections.Generic;
using System.Linq;

namespace data_migration
{
    public static class Validation
    {
        public static bool ValidateSkinColor(this string s, int row) =>
            s.Validate(row, "cor/raça", new string[] { "branca", "preta", "parda", "indígena", "outras" });

        public static bool ValidateGender(this string s, int row) =>
            s.Validate(row, "sexo", new string[]
            { "feminino", "masculino", "outros" });

        public static bool ValidateMaritalStatus(this string s, int row) =>
            s.Validate(row, "estado civil", new string[]
            { "solteiro", "casado", "viúvo", "divorciado", "separado", "união estável", "amasiado" });

        public static bool ValidateSchoolTraining(this string s, int row) =>
            s.Validate(row, "formação escolar", new string[]
            {"analfabeto", "assina o nome", "fundamental incompleto", "fundamental completo",
            "ensino médio incompleto", "ensino médio completo", "superior incompleto", "superior completo"});

        public static bool ValidateList(this string s, List<string> list, int row, string field)
        {
            if (list.Any(s1 => s1.ToLower() == s.ToLower()))
            {
                var row1 = list.IndexOf(list.FirstOrDefault(s1 => s1.ToLower() == s.ToLower())) + 1;
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine($"{field} ({s}) repetido nas linhas {row} e {row1}");
                return false;
            }
            return true;
        }

        private static bool Validate(this string s, int row, string field, string[] avaibles)
        {
            if (!avaibles.Any(s1 => s1.ToLower() == s.ToLower().Replace("'", "")))
            {
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine($"Linha {row} - {field} inválido: {s.ToLower()}");
                return false;
            }
            return true;
        }
    }
}