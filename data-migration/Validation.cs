using System;
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

        private static bool Validate(this string s, int row, string field, string[] avaibles)
        {
            if (!avaibles.Contains(s.ToLower().Replace("'", "")))
            {
                Console.WriteLine($"Linha {row} - {field} inválido: {s.ToLower()}");
                return false;
            }
            return true;
        }
    }
}