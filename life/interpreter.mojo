#Data Defintions

struct NumV:
    var number: Float64

    fn __init__(out self, number: Float64):
        self.number = number

    fn __copyinit__(out self, existing: Self):
        self.number = existing.number

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

    fn __init__(out self, num: Optional[NumV], str: Optional[StringV], bool: Optional[BoolV], prim: Optional[PrimV] = None):
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

fn serialize(expr: Expr) -> String:
    if expr.num:
        return String(expr.num.value().number)
    elif expr.str:
        return "\"" + expr.str.value().s + "\""
    elif expr.bool:
        if expr.bool.value().b:
            return "true"
        else:
            return "false"
    elif expr.prim:
        return "#<primop>"
    else:
        return "QTUM: unknown value"

fn top_interp(expr: Expr) -> String:
    var result = interp(expr)  
    return serialize(expr)     


fn main():
    var strTest = Expr(num=None, str=StringV("hi"), bool=None)
    var numTest = Expr(num=NumV(5), str=None, bool=None)
    var boolTest = Expr(num=None, str=None, bool=BoolV(True))
    var prim_expr = Expr(num=None, str=None, bool=None, prim=PrimV("+"))

    print(top_interp(strTest))  
    print(top_interp(numTest)) 
    print(top_interp(boolTest))
    print(top_interp(prim_expr))


fn println(s: StringV):
    print(s.__str__())

fn read_num() raises -> NumV:
    num = input(">")
    return NumV(Float64(atol(num)))

fn read_str() raises -> StringV:
    str = input(">")
    return StringV(str)

fn interp(expr: Expr):
    var representation = expr.__rep__()
    print("interp:", expr.__str__())
    if representation == "StringV":
        print("test")
    elif representation == "NumV":
        print("test2")
    elif representation == "BoolV":
        print("test3")
    elif representation == "PrimV":
        print("test4")



