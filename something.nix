# example.nix
# This is a simple example Nix file demonstrating basic Nix concepts

# Define some variables
let
  # Basic variable assignment
  greeting = "Hello, Nix!";
  
  # List of numbers
  numbers = [ 1 2 3 4 5 ];
  
  # Attribute set (similar to a dictionary/object)
  config = {
    name = "example";
    version = "1.0.0";
    dependencies = [ "nix" "nixpkgs" ];
  };
  
  # Function definition
  add = a: b: a + b;
in
  # The main expression that gets evaluated
  {
    # Basic string
    message = greeting;
    
    # Using the function
    sum = add 5 3;
    
    # List operations
    firstNumber = builtins.head numbers;
    allNumbers = numbers;
    
    # Accessing attribute set
    projectName = config.name;
    projectVersion = config.version;
    
    # Using built-in functions
    currentTime = builtins.currentTime;
    
    # Conditional expression
    isEven = if builtins.mod 4 2 == 0 then true else false;
    
    # List transformation using builtins.map
    doubledNumbers = builtins.map (x: x * 2) numbers;
  }
