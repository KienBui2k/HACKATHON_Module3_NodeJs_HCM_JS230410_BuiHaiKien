import express from "express";
const router = express.Router();
import fs from "fs"
import path from "path";


router.get("/", (req, res) => {

    fs.readFile(path.join(__dirname, "users.json"), 'utf-8', (err, data) => {
        if (err) {
            return res.status(500).json(
                {
                    message: "failed",
                }
            )
        }
        if (req.query.id) {
            let item = JSON.parse(data).find(item => item.id == req.query.id);
            if (item) {
                return res.status(200).json(
                    {
                        data: item
                    }
                )
            }
        }
        return res.status(200).json(
            {
                message: "success",
                data: JSON.parse(data)
            }
        )
    })
})
router.delete('/:userId', (req, res) => {
    if (req.params.userId) {
        fs.readFile(path.join(__dirname, "users.json"), 'utf-8', (err, data) => {
            if (err) {
                return res.status(500).json({
                    message: "Lấy users thất bại!"
                })
            }
            let users = JSON.parse(data);
            users = users.filter(user => user.id != req.params.userId);

            fs.writeFile(path.join(__dirname, "users.json"), JSON.stringify(users), (err) => {
                if (err) {
                    return res.status(500).json({
                        message: "Lưu file thất bại!"
                    })
                }
                return res.status(200).json({
                    message: "Xóa user thành công!"
                })
            })
        })
    } else {
        return res.status(500).json(
            {
                message: "Vui lòng truyền userId!"
            }
        )
    }
})
router.post('/', (req, res) => {
    fs.readFile(path.join(__dirname, "users.json"), 'utf-8', (err, data) => {
        if (err) {
            return res.status(500).json(
                {
                    message: "Đọc dữ liệu thất bại!"
                }
            )
        }
        let oldData = JSON.parse(data);
        let newUser = {
            id: Date.now(),
            ...req.body
        }
        oldData.push(newUser)
        fs.writeFile(path.join(__dirname, "users.json"), JSON.stringify(oldData), (err) => {
            if (err) {
                return res.status(500).json(
                    {
                        message: "Ghi file thất bại!"
                    }
                )
            }
            res.status(200).json({
                message: "Add user thanh cong!",
                data: data
            })
        })
    })

})
router.patch("/:id", (req, res) => {
    fs.readFile(path.join(__dirname, "users.json"), 'utf-8', (err, data) => {
        const dataObj = JSON.parse(data)
        let userPatch;
        if (req.params.id) {
            let flag = false
            const newDataObj = dataObj.map((user) => {
                if (user.id == req.params.id) {
                    flag = true;
                    userPatch = {
                        ...user,
                        ...req.body
                    }
                    return {
                        ...user,
                        ...req.body
                    }
                }
                return user
            })
            fs.writeFile(path.join(__dirname, "users.json"), JSON.stringify(newDataObj), (err) => {
                if (err) {
                    return res.status(500).json(
                        {
                            message: "Ghi file thất bại!"
                        }
                    )
                }
                return
            })
            if (!flag) {
                return res.status(500).json({
                    message: req.params.id + " - khong ton tai "
                })
            }
            return res.status(200).json(
                {
                    message: "patch thanh cong" + req.params.id,
                    data: userPatch
                })
        }
    })
})
router.get('/:id/posts', (req, res) => {
    if (req.params.id) {
        fs.readFile(path.join(__dirname, "users.json"), 'utf-8', (err, data) => {
            if (err) {
                return res.status(500).json({
                    message: "Lấy users thất bại!"
                });
            }

            const users = JSON.parse(data);
            const user = users.find(user => user.id == req.params.id);

            if (!user) {
                return res.status(500).json({
                    message: `Không tìm được người có ID ${req.params.id}`
                });
            }

            fs.readFile(path.join(__dirname, "../posts/posts.json"), 'utf-8', (err, postData) => {
                if (err) {
                    return res.status(500).json({
                        message: "Lấy posts thất bại!"
                    });
                }

                const posts = JSON.parse(postData);
                const userPosts = posts.filter(post => post.userId == req.params.id);

                return res.status(200).json({
                    message: "Lấy posts thành công!",
                    data: userPosts
                });
            });
        });
    } else {
        return res.status(500).json({
            message: "Vui lòng truyền idUser!"
        });
    }
});
module.exports = router;