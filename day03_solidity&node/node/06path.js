let path = require('path')

let p1='/Go/Code_06/1.txt'

console.log(path.basename(p1))
console.log(path.dirname(p1))
console.log(path.extname(p1))
console.log(path.join('/tet/a/te/tete','dwad','/w/','wdawd.txt'))

console.log(path.normalize(p1))//干掉多余

