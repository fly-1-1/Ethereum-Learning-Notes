//数组解构
let arr1 = [0, 1, 2, 3, 4]
console.log('arr1', arr1[0])
let [a, b, c, d,] = arr1
console.log(a, b, c, d)

//对象解构
const person = {
    name: 'jack',
    age: 10,
    address: 'bj'
}
let {name:name1, age, address} = person
//let {name, age, address} = person

console.log(name1, age, address)

//作为参数传递
const person1 = {
    name: 'jack',
    age: 11,
    address: 'bj'
}
function printP({name,age}){
    console.log(`${name} ${age}`);
}
printP(person1)


