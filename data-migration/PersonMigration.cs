using System;
using System.Collections.Generic;

namespace data_migration
{
    public static class PersonMigration
    {
        private static string header =
            "insert into people (" +
                "Preferential, " +
                "CardNumber, " +
                "Name, " +
                "SocialName, " +
                "BirthDate, " +
                "MotherName, " +
                "BirthPlace, " +
                "skin_color, " +
                "gender, " +
                "Childrens, " +
                "HasHabitation, " +
                "HomelessTime, " +
                "HasEmergencyAid, " +
                "HasPbhBasket, " +
                "HasUniqueRegister, " +
                "HasGeneralRegister, " +
                "GeneralRegister, " +
                "HasCpf, " +
                "Cpf, " +
                "HasCtps, " +
                "HasBirthCertificate, " +
                "marital_status, " +
                "school_training, " +
                "ReferenceLocation, " +
                "Occupation, " +
                "Profession, " +
                "ContactPhone, " +
                "ReferenceAddress, " +
                "Observation" +
            ")";

        private static List<string> CardNumbers;
        private static List<string> Names;

        public static string Do(List<List<string>> m)
        {
            var sql = header + " values ";
            var row = 0;
            Names = new List<string>();
            CardNumbers = new List<string>();
            foreach (var p in m)
            {
                var line = DoLine(p, ++row);
                if (line == "-1")
                {
                    continue;
                }
                else if (string.IsNullOrWhiteSpace(line))
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine("FALHA AO IMPORTAR");
                    return "";
                }
                else
                {
                    sql += line + ", ";
                }
            }
            return (sql.Substring(0, sql.Length - 2) + ";").Sanitize();
        }

        private static string DoLine(List<string> li, int row)
        {
            try
            {
                var skinColor = li[11].ReadString().PreValidateSkinColor();
                if (!skinColor.ValidateSkinColor(row))
                    return "";

                var gender = li[12].ReadString();
                if (!gender.ValidateGender(row))
                    return "";

                var maritalStatus = li[25].ReadString().PreValidateMaritalStatus();
                if (!maritalStatus.ValidateMaritalStatus(row))
                    return "";

                var schoolTraining = li[26].ReadString().PreValidateSchoolTraining();
                if (!schoolTraining.ValidateSchoolTraining(row))
                    return "";

                var cardNumber = li[3].ReadString();
                if (!cardNumber.ValidateList(CardNumbers, row, "Número Cadastro"))
                {
                    return "-1";
                }

                var name = li[4].ReadString();

                if (name == "null")
                {
                    Console.WriteLine($"Linha {row} - Nome vazio");
                    return "-1";
                }

                if (!name.ValidateList(Names, row, "Nome"))
                {
                    return "-1";
                }

                CardNumbers.Add(cardNumber);
                Names.Add(name);

                return "(" +
                    $"{li[2].ReadBool()}," + // Preferential
                    $"{cardNumber}," + // CardNumber
                    $"{name}," + // Name
                    $"{li[5].ReadString()}," + // SocialName
                    $"{li[6].ReadDate()}," + // BirthDate
                    $"{li[7].ReadString()}," + // MotherName
                    $"{li[8].ReadString()}," + // BirthPlace
                    $"(select id from skin_colors where SkinColor = {skinColor})," + // skin_color
                    $"(select id from genders where Gender = {gender})," + // gender
                    $"{li[11].ReadInt()}," + // Childrens
                    $"{li[12].ReadBool()}," + // HasHabitation
                    $"{li[13].ReadString()}," + // HomelessTime
                    $"{li[14].ReadBool()}," + // HasEmergencyAid
                    $"{li[15].ReadBool()}," + // HasPbhBasket
                    $"{li[16].ReadBool()}," + // HasUniqueRegister
                    $"{li[17].ReadBool()}," + // HasGeneralRegister
                    $"{li[18].ReadString()}," + // GeneralRegister
                    $"{li[19].ReadBool()}," + // HasCpf
                    $"{li[20].ReadString()}," + // Cpf
                    $"{li[21].ReadBool()}," + // HasCtps
                    $"{li[22].ReadBool()}," + // HasBirthCertificate
                    $"(select id from marital_statuses where MaritalStatus = {maritalStatus})," + // marital_status
                    $"(select id from school_trainings where SchoolTraining = {schoolTraining})," + // school_training
                    $"{li[28].ReadLongString()}," + // ReferenceLocation
                    $"{li[29].ReadString()}," + // Occupation
                    $"{li[30].ReadString()}," + // Profession
                    $"{li[31].ReadString()}," + // ContactPhone
                    $"{li[32].ReadString()}," + // ReferenceAddress
                    $"{li[34].ReadLongString()}" + // Observation
                ")";
            }
            catch (Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine($"Linha {row} - Exception: {ex.Message} - {ex.StackTrace}");
                return "";
            }
        }
    }
}