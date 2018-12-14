with ada.Command_Line; use ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Calendar; use Ada.Calendar;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;
with Ada.Calendar.Time_Zones; use Ada.Calendar.Time_Zones;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Hash;

use Ada.Containers;



procedure Main is
   type array_Vector is array (Natural range 1..11) of Integer;
   onOff, SinErroresEntrada: Boolean := false;
   Start_Time  : Time;

   --HASHMAP Para guardar claves valor
   package Maps is new Indefinite_Hashed_Maps (Key_Type => String,
                                               Element_Type => Integer,
                                               Hash => Ada.Strings.Hash,
                                               Equivalent_Keys => "=");

   use Maps;

   X : Map := Empty_Map;



   --metodo recursivo
   function count (a : in String;b : in String;m: in Integer;n: in Integer) return Integer is
   begin
      -- If both first and second string is empty,
      -- or if second string is empty, return 1
      if (m = 1 and then n = 1) or else n = 1 then
        return 1;
      end if;
      -- If only first string is empty and
      -- second string is not empty, return 0
      if m = 1 then
         return 0;
      end if;
      -- If last characters are same
      -- Recur for remaining strings by
      -- 1. considering last characters of
      -- both strings
      -- 2. ignoring last character of
      -- first string
      if a(m-1) = b(n-1) then
         return count(a, b, m - 1, n - 1) + count(a, b, m - 1, n);
      else
         return count(a, b, m - 1, n);
      end if;
   end count;




   --analizamos si ya hemos recibido esos datos y en caso contrario los calculamos
   --si ya los hemos recibido devolvemos el valor
   procedure pDinamica (Entrada : in String) is
      Resultado : Integer := 0;
      Separador : Integer := 1;
   begin
      if X.Contains(Entrada) then
         --lo tenemos en el mapa
         Put_Line("Ya lo habia probado!!!! Veras que poco tardo");
         if onOff then
            Start_Time := Clock;
         end if;
         Resultado := X.Element(Entrada);
         Put_Line("El resultado es: " & Resultado'Image);

         --muestro tiempo
         if onOff then
            Put_Line("He tardado: " & Duration'Image(Clock - Start_Time));
         end if;

      else
         Put_Line("Hey!!!! No lo habia probado, dame unos milisegundos");
         --buscamos el separador
         for J in Entrada'First..Entrada'Last loop
            if Entrada(J..J) = "-" then
               Separador := J;
            end if;
         end loop;

         declare
            part1 : String (1..Separador-1);
            part2 : String (1..Entrada'Last - Separador);
         begin
            part1 := Entrada(Entrada'First..Separador-1);
            part2 := Entrada(Separador+1..Entrada'Last);
            --activo reloj si corresponde
            if onOff then
               Start_Time := Clock;
            end if;
            Resultado := count (part1,
                  part2, part1'Length+1 ,
                                part2'Length +1);
            Put_Line("El resultado es: " & Resultado'Image);

            X.Insert (Entrada, Resultado);--lo añadimos al mapa



            --muestro tiempo
            if onOff then
               Put_Line("He tardado: " & Duration'Image(Clock - Start_Time));
            end if;
         end;
      end if;
   end pDinamica;



   --Analizamos los parametros de entrada llamamos a metodo para tratar los datos
   procedure readComandLine is
      F_Entrada         : File_Type;
      Con : Integer := 1;


   begin
      if Argument_Count > 2 or Argument_Count < 1 then
         Put_Line("Parametros Incorrectos. Ejemplos: 1) fichero.txt");
         return;
      end if;

      if Argument_Count = 2 then
         if Argument(Con) = "-t" then
            onOff := true;
            Con := Con + 1;
         else
            Put_Line("Parametros Incorrectos. Ejemplos: 1) fichero.txt");
            return;
         end if;
      end if;

      --se abren los ficheros
      Open(F_Entrada,Mode => In_File,Name => Argument(Con));

      SinErroresEntrada := true;
      declare
         A : String := Get_Line (F_Entrada);
      begin
         pDinamica (A); --tratamiento de los datos
         pDinamica (A); --llamamos otra vez para la programacion dinamica
      end;
      --se cierran el fichero
      Close(F_Entrada);
   end readComandLine;

begin
      readComandLine;
end Main;
