// kích hoạt .env
import dotenv from 'dotenv'
dotenv.config()

import express from 'express'; //gọi thư viện express
const server = express() // dùng thư viện tạo ra server

// cấu hình cors cho phép mọi nguồn call api 
import cors from 'cors'
server.use(cors());

// cau hinh request.body
import bodyParser from 'body-parser';
server.use(bodyParser.json())

// gọi cấu hình routing và yêu cầu server
import routerConfig from './routes'
server.use('/api', routerConfig
)



/* public folder domain/file */
server.use(express.static("public"));

/*sever lắng nghe tại cổng 3000 trên máy */
server.listen(process.env.PORT, () => {
    console.log("server chay tai port", process.env.PORT);
})