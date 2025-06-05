
#Data Defintions 

struct NumV:
    var number: Float64

    fn __init__(out self, number: Float64):
        self.number = number

    fn __copyinit__(out self, existing: Self):
        self.number = existing.number

    fn dump(self):
        print(self.number)


struct StringV:
    var s: String

    fn __init__(out self, s: String):
        self.s = s

    fn __copyinit__(out self, existing: Self):
        self.s = existing.s

    fn dump(self):
        print(self.s)

struct BoolV:
    var b: Bool

    fn __init__(out self, b: Bool):
        self.b = b

    fn __copyinit__(out self, existing: Self):
        self.b = existing.b

    fn dump(self):
        print(self.b)


#mojo does not have primv 


struct ExprC:
    fn __init__(out self):
        pass

    fn __copyinit__(out self, existing: Self):
        pass

struct Env:
    fn __init__(out self):
        pass

    fn __copyinit__(out self, existing: Self):
        pass

struct CloV:
    var args: List[String]
    var body: ExprC
    var env: Env

    fn __init__(out self, args: List[String], body: ExprC, env: Env):
        self.args = args
        self.body = body
        self.env = env

    fn __copyinit__(out self, existing: Self):
        self.args = existing.args
        self.body = existing.body
        self.env = existing.env

    fn dump(self):
        print("Args:")
        for arg in self.args:
            print(" ", arg)
        print("Body:", "ExprC instance")
        print("Env:", "Env instance")



fn main():
    var num_val = NumV(3.14)
    num_val.dump()

    var str_val = StringV("Hello, Mojo!")
    str_val.dump()



    var val = BoolV(True)
    val.dump()  

    var args: List[String] = []
    args.append(String("x"))
    args.append(String("y"))

    var body = ExprC()  
    var env = Env()  

    var closure = CloV(args, body, env)
    closure.dump()




