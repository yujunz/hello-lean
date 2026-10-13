def joinStringsWith (delim: String) (a: String) (b: String) : String :=
  String.append a (String.append delim b)

#eval joinStringsWith ", " "one" "and another" -- "one, and another"

#check (joinStringsWith ", ") -- "String → String → String"

def volume (height: Nat) (width: Nat) (depth: Nat) : Nat :=
  height * width * depth
