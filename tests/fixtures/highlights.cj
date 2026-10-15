package showcase

import std.collection.*

// Syntax highlighting example.
/* A block comment. */
const MAX_COUNT: Int64 = 42
type Count = Int64

interface Named {
    func name(): String
}

class Greeter <: Named {
    private var greeting: String = "Hello"

    public init(greeting: String) {
        this.greeting = greeting
    }

    public func name(): String {
        return this.greeting
    }

    public prop message: String {
        get() { greeting }
        set(value) { greeting = value }
    }
}

struct Point {
    let x: Int64 = 0
}

enum Color {
    | Red | Green | Blue
}

func identity<T>(value: T): T {
    return value
}

main() {
    let enabled: Bool = true
    let disabled = false
    let ratio: Float64 = 3.14
    let letter = r'a'
    let byte = b'a'
    let raw = #"raw text"#
    let greeter = Greeter("Hello")
    let result = identity<Int64>(MAX_COUNT)
    let text = "Value: ${result + 1}"
    let multiline = """
Value: ${result}
"""
    println(greeter.name())
    @Assert(enabled)
    if (enabled) {
        println(text)
    } else {
        println(raw)
    }
    for (i in 0..3) {
        println(i)
    }
    var count = 0
    while (count < 3) {
        count += 1
    }
    do {
        count--
    } while (count > 0)
    match (Color.Red) {
        case Red => println("red")
        case _ => println("other")
    }
}
