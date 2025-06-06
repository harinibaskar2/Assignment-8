from testing import assert_equal

# Data Definitions


struct NumV:
    var number: Float64

    # constructor method
    # called when creating a new instance of struct
    # out keyowrd indicates method will modify instance being created
    fn __init__(out self, number: Float64):
        self.number = number

    # copy constructor
    # called when making a copy of an instance, 
    # ex: 
    # var num1 = NumV(10.0)
    # var num2 = num2 copies the instance of num1 - they don't share memory
    fn __copyinit__(out self, existing: Self):
        self.number = existing.number

    # move constructor
    # transfers ownership of resources from one object to another
    # performance beneficial in things like avoiding expensive copying operations
    fn __moveinit__(out self, owned existing: Self):
        self.number = existing.number

    fn dump(self):
        print(self.number)


struct StringV:
    var s: String

    fn __init__(out self, s: String):
        self.s = s

    fn __copyinit__(out self, existing: Self):
        self.s = existing.s

    fn __moveinit__(out self, owned existing: Self):
        self.s = existing.s

    fn __str__(self) -> String:
        return self.s

    fn dump(self):
        print(self.s)


struct BoolV:
    var b: Bool

    fn __init__(out self, b: Bool):
        self.b = b

    fn __copyinit__(out self, existing: Self):
        self.b = existing.b

    fn __moveinit__(out self, owned existing: Self):
        self.b = existing.b

    fn dump(self):
        print(self.b)


struct PrimV:
    var s: String

    fn __init__(out self, s: String):
        self.s = s

    fn __copyinit__(out self, existing: Self):
        self.s = existing.s

    fn __moveinit__(out self, owned existing: Self):
        self.s = existing.s


struct Expr:
    var num: Optional[NumV]
    var str: Optional[StringV]
    var bool: Optional[BoolV]
    var prim: Optional[PrimV]

    fn __init__(
        out self,
        num: Optional[NumV],
        str: Optional[StringV],
        bool: Optional[BoolV],
        prim: Optional[PrimV] = None,
    ):
        self.num = num
        self.str = str
        self.bool = bool
        self.prim = prim

    fn __copyinit__(out self, existing: Self):
        self.num = existing.num
        self.str = existing.str
        self.bool = existing.bool
        self.prim = existing.prim

    fn __str__(self) -> String:
        if self.num:
            return String(self.num.value().number)
        if self.str:
            return self.str.value().s
        if self.bool:
            return String(self.bool.value().b)
        if self.prim:
            return "#<primop>"
        return "None"

    fn __rep__(self) -> String:
        if self.num:
            return "NumV"
        if self.str:
            return "StringV"
        if self.bool:
            return "BoolV"
        if self.prim:
            return "PrimV"
        return "None"


struct Env:
    fn __init__(out self):
        pass

    fn __copyinit__(out self, existing: Self):
        pass


struct CloV:
    var args: List[String]
    var body: Expr
    var env: Env

    fn __init__(out self, args: List[String], body: Expr, env: Env):
        self.args = args
        self.body = body
        self.env = env

    fn dump(self):
        print("Args:")
        for arg in self.args:
            print(" ", arg)
        print("Body:", "ExprC instance")
        print("Env:", "Env instance")


# Core Functions


fn serialize(expr: Expr) -> String:
    if expr.num:
        return String(expr.num.value().number)
    elif expr.str:
        return '"' + expr.str.value().s + '"'
    elif expr.bool:
        if expr.bool.value().b:
            return "true"
        else:
            return "false"
    elif expr.prim:
        return "#<primop>"
    else:
        return "QTUM: unknown value"


fn interp(expr: Expr) raises -> Expr:
    var representation = expr.__rep__()
    # Check if expr is one of the valid types
    if (representation != "StringV" and 
        representation != "NumV" and 
        representation != "BoolV" and 
        representation != "PrimV"):
        raise Error("Invalid expression type: " + representation)
        
    # Return the expr itself as the evaluation result
    if representation == "StringV":
        return expr
    elif representation == "NumV":
        return expr
    elif representation == "BoolV":
        return expr
    elif representation == "PrimV":
        return expr
    else:
        # This should never be reached due to the check above
        raise Error("Unexpected error in interp")

fn top_interp(expr: Expr) raises -> String:
    var result = interp(expr)
    return serialize(result)


# Test Functions


fn test_interp_string() raises:
    var result = top_interp(Expr(num=None, str=StringV("hi"), bool=None))
    assert_equal(result, '"hi"')


fn test_interp_num() raises:
    var result = top_interp(Expr(num=NumV(5.0), str=None, bool=None))
    assert_equal(result, "5.0")


fn test_interp_bool() raises:
    var result = top_interp(Expr(num=None, str=None, bool=BoolV(True)))
    assert_equal(result, "true")


fn test_interp_prim() raises:
    var result = top_interp(
        Expr(num=None, str=None, bool=None, prim=PrimV("+"))
    )
    assert_equal(result, "#<primop>")


fn test_interp_error() raises:
    var result = top_interp(Expr(num=None, str=None, bool=None, prim=None))
    assert_equal(result, "QTUM: unknown value")


fn test_add_1_plus_1() raises:
    var left = Expr(num=NumV(1.0), str=None, bool=None)
    var right = Expr(num=NumV(1.0), str=None, bool=None)
    var sum = left.num.value().number + right.num.value().number
    var result = Expr(num=NumV(sum), str=None, bool=None)
    print(top_interp(result))


# Utility Functions


fn println(s: StringV):
    print(s.__str__())


fn read_num() raises -> NumV:
    num = input(">")
    return NumV(Float64(atol(num)))


fn read_str() raises -> StringV:
    str = input(">")
    return StringV(str)


# Main function


fn main() raises:
    var strTest = Expr(num=None, str=StringV("hi"), bool=None)
    var numTest = Expr(num=NumV(5), str=None, bool=None)
    var boolTest = Expr(num=None, str=None, bool=BoolV(True))
    var prim_expr = Expr(num=None, str=None, bool=None, prim=PrimV("+"))
    var error_expr = Expr(num=None, str=None, bool=None, prim=None)

    print(top_interp(strTest))
    print(top_interp(numTest))
    print(top_interp(boolTest))
    print(top_interp(prim_expr))
    print(top_interp(error_expr))

    test_interp_string()
    test_interp_num()
    test_interp_bool()
    test_interp_prim()
    test_interp_error()
    test_add_1_plus_1()

    print("All tests passed!")
