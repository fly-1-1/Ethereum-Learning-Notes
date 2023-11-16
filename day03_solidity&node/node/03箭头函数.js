function Add(a,b){
    return a+b
}
let c = Add(1,2)
console.log(c)

// let add=(a,b)=>{
//   return   a+b
// }

let add=(a,b)=>a+b
console.log(add(1,5))

//默认值 右填充
function print(name,address="bj"){
    console.log(`${name} ${address}`)
}

print('xh')
print('xm','sh')

