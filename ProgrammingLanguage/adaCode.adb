-- a linked list
WITH Ada.Text_IO;
USE Ada.Text_IO;
WITH Ada.Integer_Text_IO;
USE Ada.Integer_Text_IO;
WITH Ada.Float_Text_IO;
USE Ada.Float_Text_IO;
WITH Ada.Strings.Unbounded;
USE Ada.Strings.Unbounded;
WITH Ada.Characters;

WITH Ada.Characters.Handling;

PROCEDURE Test IS

   -- linked list
   TYPE Node;
   TYPE NodePoint IS ACCESS Node;
   TYPE Node IS
      RECORD
         Name         : Unbounded_String;
         Value        : Unbounded_String;
         NextNodeName : Unbounded_String;
         NextNode     : NodePoint        := NULL;
      END RECORD;


   LinkedList       : NodePoint;
   ValueIntegerFlag : Boolean;
   BadInputFlag     : Boolean   := False;
   ProgramFlag      : Boolean   := True;
   InputFlag        : Boolean   := False;


   --------------------------------------------------------
   FUNCTION IsCmd (
         Char : Character)
     RETURN Boolean IS
      Result : Boolean := False;
   BEGIN
      IF Ada.Characters.Handling.Is_Letter(Char) THEN
         Result := True;
      END IF;
      RETURN Result;
   END IsCmd;

   -- Define the procedure
   -- sum calucation
   PROCEDURE SumCalculation (
         Lst        : NodePoint;
         TargetName : Unbounded_String) IS
      Result : Unbounded_String;
      Temp   : Float            := 0.0;
      Point  : NodePoint        := Lst;
      Name   : Unbounded_String := TargetName;
   BEGIN
      WHILE Point /= NULL LOOP
         IF Name = Point.Name THEN
            IF ValueIntegerFlag THEN
               Temp := Temp + Float'Value(To_String(Point.Value));
               --Result := To_Unbounded_String(Float'Image(Temp));
            ELSE
               Result := Result & Point.Value;
            END IF;
            Name := Point.NextNodeName;
            Point := Lst;
         ELSE
            Point  := Point.NextNode;
         END IF;

      END LOOP;
      New_Line;
      IF ValueIntegerFlag THEN
         Put(Temp, Exp =>0);
      ELSE
         Put(To_String(Result));
      END IF;
      New_Line;

   END SumCalculation;

   -- Count the node
   PROCEDURE CountNodes (
         Lst        : NodePoint;
         TargetName : Unbounded_String) IS
      Point  : NodePoint        := Lst;
      Name   : Unbounded_String := TargetName;
      Result : Integer          := 0;
   BEGIN
      WHILE Point /= NULL LOOP
         IF Name = Point.Name THEN
            Result := Result + 1;
            Name := Point.NextNodeName;
            Point := Lst;
         ELSE
            Point  := Point.NextNode;
         END IF;

      END LOOP;

      New_Line;
      Put(integer'image(Result));
      New_Line;
   END CountNodes ;

   -- Num Link To Node
   PROCEDURE NumLinkToNode (
         Lst        : NodePoint;
         TargetName : Unbounded_String) IS
      Point  :          NodePoint        := Lst;
      Name   : CONSTANT Unbounded_String := TargetName;
      Result :          Integer          := 0;
   BEGIN
      WHILE Point /= NULL LOOP
         IF Name = Point.NextNodeName THEN
            Result := Result + 1;
         END IF;
         Point  := Point.NextNode;
      END LOOP;
      New_Line;
      Put(Integer'Image(Result));
      New_Line;
   END NumLinkToNode;

   -- Num unused node
   PROCEDURE NumUnusedNode (
         Lst : NodePoint) IS
      Point   : NodePoint        := Lst;
      Cur     : NodePoint        := Lst;
      Name    : Unbounded_String;
      AddFlag : Boolean          := False;
      Result  : Integer          := 0;
   BEGIN

      WHILE Point /= NULL LOOP
         Name := Point.NextNodeName;
         Cur := Lst;
         WHILE Cur /= NULL LOOP
            New_Line;
            IF Name = Cur.Name THEN
               AddFlag := True;
               EXIT;
            END IF;
            Cur :=Cur.NextNode;
         END LOOP;

         IF NOT AddFlag THEN
            Result := Result +1;
            AddFlag := False;
         END IF;
         Point  := Point.NextNode;
      END LOOP;

      New_Line;
      Put(Result);
      New_Line;
   END NumUnusedNode;

   -- Insert node
   PROCEDURE Insert_Append (
         Anchor : NodePoint;
         Newbie : NodePoint) IS
   BEGIN
      IF Anchor /= NULL AND Newbie /= NULL THEN
         Newbie.NextNode := Anchor.NextNode;
         Anchor.NextNode := Newbie;
      END IF;

   END Insert_Append;

   -- Define the function


   FUNCTION IsValidNameInput (
         Input : Character)
     RETURN Boolean IS
      Result : Boolean := False;
   BEGIN
      IF Ada.Characters.Handling.Is_Letter(Input) THEN
         Result := True;
      END IF;
      IF Ada.Characters.Handling.Is_Digit(Input) THEN
         Result := True;
      END IF;

      RETURN Result;

   END IsValidNameInput;

   -- check value type
   FUNCTION IsFloatValue (
         Char : Character)
     RETURN Boolean IS
      Result : Boolean;
   BEGIN
      IF Ada.Characters.Handling.Is_Digit(Char) THEN
         Result := True;
      ELSE
         Result := False;
      END IF;

      RETURN Result;
   END IsFloatValue;

   --check value input
   FUNCTION IsValidValueInput (
         Input : Character)
     RETURN Boolean IS
      Result : Boolean := False;
   BEGIN
      IF Ada.Characters.Handling.Is_Letter(Input) THEN
         Result := True;
      END IF;
      IF Ada.Characters.Handling.Is_Digit(Input) THEN
         Result := True;
      END IF;
      IF Ada.Characters.Handling.Is_Space(Input) THEN
         Result :=True;
      END IF;

      RETURN Result;
   END IsValidValueInput;

   -- read input
   FUNCTION ReadInput (
         Char : Character)
     RETURN NodePoint IS
      Result   : NodePoint        := NULL;
      Name     : Unbounded_String;
      Value    : Unbounded_String;
      NextName : Unbounded_String;
      SwithNum : Integer          := 0;
      Input    : Character        := Char;
   BEGIN
      Loop_1:
         WHILE SwithNum < 3 LOOP
         IF Ada.Characters.Handling.Is_Line_Terminator(Input) AND SwithNum = 2 THEN
            BadInputFlag := False;
            EXIT Loop_1;
         ELSIF Ada.Characters.Handling.Is_Line_Terminator(Input) AND SwithNum /= 2 THEN
            BadInputFlag := True;
            EXIT Loop_1;
         END IF;

         IF Input = ';' THEN
            SwithNum := SwithNum + 1;
            GOTO Continue;
         END IF;

         IF SwithNum  = 0 THEN
            IF IsValidNameInput(Input ) THEN
               Name:= Name& Input ;
            ELSE
               BadInputFlag := True;
               EXIT Loop_1;
            END IF;
         ELSIF SwithNum =1 THEN
            IF IsValidValueInput(Input ) THEN
               Value := Value & Input ;
            ELSE

               BadInputFlag := True;
               EXIT Loop_1;

            END IF;
            ValueIntegerFlag := IsFloatValue(Input );
         ELSIF SwithNum = 2 THEN
            --put("hit");
            IF IsValidNameInput(Input) THEN
               NextName := NextName & Input;
            ELSE
               BadInputFlag := True;
               EXIT Loop_1;
            END IF;

         END IF;

         <<Continue>>

            Get_Immediate(Input);
         Put(Input );
      END LOOP Loop_1;

      IF SwithNum < 2 AND NOT BadInputFlag THEN
         BadInputFlag := True;
      ELSIF SwithNum > 2 THEN
         BadInputFlag := True;
      ELSIF NOT BadInputFlag THEN
         InputFlag := True;
         Result := NEW Node'(Name,Value,NextName,NULL);
      ELSE
         ProgramFlag := False;
      END IF;

      RETURN Result;
   END ReadInput;



   -- part I run--------------------------------------------
   FUNCTION PartIRun RETURN NodePoint IS
      Result       : NodePoint;
      NextNode     : NodePoint;
      Char         : Character;
      FistNodeFlag : Boolean   := True;
   BEGIN
      Get_Immediate(Char);
      Put(Char);
      Loop_1:
         LOOP

         IF Ada.Characters.Handling.Is_Line_Terminator(Char) OR BadInputFlag THEN
            IF InputFlag THEN
               EXIT Loop_1;
            ELSE
               BadInputFlag := True;
               EXIT Loop_1;
            END IF;
         END IF;
         InputFlag :=False;
         IF FistNodeFlag THEN
            Result    := ReadInput(Char);
            FistNodeFlag := False;
         ELSE
            NextNode := ReadInput(Char);
            Insert_Append(Result,NextNode);
         END IF;
         New_Line;
         Get_Immediate(Char);
         Put(Char);

      END LOOP Loop_1;

      RETURN Result;
   END PartIRun;

   -- part II run--------------------------------------------
   FUNCTION PartIIRun (
         Lst : NodePoint)
     RETURN Boolean IS
      CmdChar        : Character;
      CmdString      : Unbounded_String;
      Name           : Unbounded_String;
      Result         : Boolean          := True;
      FristEnterFlag : Boolean          := True;
   BEGIN
      -- get cmd
      Loop_1:
         LOOP

         <<Continue>>
         Get_Immediate(CmdChar);
         Put(CmdChar);
         IF Ada.Characters.Handling.Is_Line_Terminator(CmdChar)  AND FristEnterFlag THEN
            FristEnterFlag := False;
            New_Line;
            GOTO Continue;
         END IF;
         IF Ada.Characters.Handling.Is_Space(CmdChar) OR Ada.Characters.Handling.Is_Line_Terminator(CmdChar) THEN
            EXIT Loop_1;
         END IF;
         IF NOT Result THEN
            EXIT Loop_1;
         END IF;

         IF NOT IsCmd(CmdChar) THEN
            Result := False;
            New_Line;
            Put("ERR");
            EXIT Loop_1;
         END IF;

         CmdString := CmdString & Ada.Characters.Handling.To_Lower(CmdChar);
      END LOOP Loop_1;

      -- get parameter for cmd
      IF CmdString =To_Unbounded_String("unused") THEN
         NumUnusedNode(Lst);
      ELSIF CmdString =To_Unbounded_String("quit") THEN
         Result := False;
      ELSE
         Loop_2:
            LOOP
            Get_Immediate(CmdChar);
            Put(CmdChar);
            IF NOT Result THEN
               EXIT Loop_2;
            END IF;
            IF Ada.Characters.Handling.Is_Line_Terminator(CmdChar) THEN
               EXIT Loop_2;
            ELSE

               IF NOT IsValidNameInput(CmdChar) THEN
                  Result := False;
                  Put("ERR");
                  EXIT Loop_2;
               END IF;
               Name := Name & CmdChar;
            END IF;

         END LOOP Loop_2;

         IF To_String(CmdString) = "count" THEN
            CountNodes(Lst,Name);
         ELSIF CmdString =To_Unbounded_String("sum") THEN
            SumCalculation(Lst,Name);
         ELSIF CmdString =To_Unbounded_String("links") THEN
            NumLinkToNode(Lst,Name);
         ELSE
            New_Line;
            Result := False;
            Put("ERR");
         END IF;
      END IF;
      RETURN Result;
   END PartIIRun;


   --------------------------------------------------------
BEGIN

   BEGIN
      Linkedlist := PartIRun;


      IF BadInputFlag THEN
         New_Line;
         Put("BAD");
      ELSE
         New_Line;
         Loop_1:
            LOOP
            IF not ProgramFlag or BadInputFlag THEN
               EXIT Loop_1;
            END IF;

            ProgramFlag := PartIIRun(Linkedlist);
         END LOOP Loop_1;
      END IF;

   EXCEPTION
      WHEN OTHERS =>
         Put("ERR");
   END;


END Test;

