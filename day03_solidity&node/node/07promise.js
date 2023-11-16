let fs=require('fs')

let readFilePromise = new Promise(function (resolve, reject) {
    fs.readFile('./1.txt', 'utf-8', function (err, data) {
        if (err) {
            // console.log("err:",err)
            // return
            reject(err)
        }
        // console.log('异步', data)
        resolve(data)
    })
})

readFilePromise.then(res=>{
    console.log('data:',res)
}).catch(err=>{
    console.log(err)
})