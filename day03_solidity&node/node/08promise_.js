let fs = require('fs')

let check = () => {
    fs.readFile('./1.txt', 'utf-8', function (err, data) {
        console.log('读取文件', data)
        fs.writeFile('./2.txt', 'utf-8', function (err) {
            if (err) {
                return
            }
            console.log("写文件成功")
            fs.stat("./2.txt", function (err, stats) {
                console.log(stats)
                return stats
            })
        })

    })
}



let readFilePromise = () => {
    return new Promise((resolve, reject) => {
        try {
            fs.readFile('./1.txt', 'utf-8', function (err, data) {
                console.log('读取文件', data)
                resolve(data)
            })
        } catch (e) {
            reject(e)
        }
    })
}
let writeFilePromise = (data) => {
    return new Promise((resolve, reject) => {
        fs.writeFile('./2.txt', data, 'utf-8', function (err) {
            if (err) {
                reject(err)
            }
            resolve('写入成功')
        })
    })
}
let statPromise = () => {
    return new Promise((resolve, reject) => {
        fs.stat("./2.txt", function (err, stats) {
            if (err) {
                reject(err)
            }
            //console.log(stats)
            resolve(stats)
        })
    })
}


let check2 = async () => {
    try {
        let data = await readFilePromise()
        let res = await writeFilePromise(data)
        console.log('res:',res)
        let stat = await statPromise()
        console.log(stat)
    } catch (e) {
        console.log(e)
    }
}

check2()