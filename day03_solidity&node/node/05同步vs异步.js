
let fs=require('fs')

//同步
let data = fs.readFileSync('./1.txt','utf-8')

console.log('同步',data)

//异步
fs.readFile('./1.txt','utf-8',function (err,data){
    if(err){
        console.log("err:",err)
        return
    }
    console.log('异步',data)
})

console.log('2222')
