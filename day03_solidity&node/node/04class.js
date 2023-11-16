class Person {
    constructor(name, age) {
        this.name = name
        this.age = age
    }

    say() {
        console.log(`我是:${this.name} 年龄:${this.age}`)
    }
}

let p1 = new Person("zs", 50)
p1.say()

class DD extends Person{
    //需要先构造父类
    constructor(name,age) {
        super(name,age);
        this.name = name
        this.age = age
    }

    say() {
        console.log(`人很话不多`)
    }
}

let dd=new DD('dong ge',26)
dd.say()