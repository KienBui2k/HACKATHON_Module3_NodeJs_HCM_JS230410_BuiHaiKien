import express from "express";
const router = express.Router();
import fs from "fs"
import path from "path";


router.get("/", (req, res) => {

    fs.readFile(path.join(__dirname, "posts.json"), 'utf-8', (err, data) => {
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
router.delete('/:postId', (req, res) => {
    if (req.params.postId) {
        fs.readFile(path.join(__dirname, "posts.json"), 'utf-8', (err, data) => {
            if (err) {
                return res.status(500).json({
                    message: "Lấy posts thất bại!"
                })
            }
            let posts = JSON.parse(data);
            posts = posts.filter(post => post.id != req.params.postId);

            fs.writeFile(path.join(__dirname, "posts.json"), JSON.stringify(posts), (err) => {
                if (err) {
                    return res.status(500).json({
                        message: "Lưu file thất bại!"
                    })
                }
                return res.status(200).json({
                    message: "Xóa post thành công!"
                })
            })
        })
    } else {
        return res.status(500).json(
            {
                message: "Vui lòng truyền postId!"
            }
        )
    }
})
router.post('/', (req, res) => {
    fs.readFile(path.join(__dirname, "posts.json"), 'utf-8', (err, data) => {
        if (err) {
            return res.status(500).json(
                {
                    message: "Đọc dữ liệu thất bại!"
                }
            )
        }
        let oldData = JSON.parse(data);
        let newPost = {
            id: Date.now(),
            ...req.body
        }
        oldData.push(newPost)
        fs.writeFile(path.join(__dirname, "posts.json"), JSON.stringify(oldData), (err) => {
            if (err) {
                return res.status(500).json(
                    {
                        message: "Ghi file thất bại!"
                    }
                )
            }
            res.status(200).json({
                message: "Add posts thanh cong!",
            })
        })
    })

})
router.patch("/:id", (req, res) => {
    fs.readFile(path.join(__dirname, "posts.json"), 'utf-8', (err, data) => {
        const dataObj = JSON.parse(data)
        let postPatch;
        if (req.params.id) {
            let flag = false
            const newDataObj = dataObj.map((post) => {
                if (post.id == req.params.id) {
                    flag = true;
                    postPatch = {
                        ...post,
                        ...req.body
                    }
                    return {
                        ...post,
                        ...req.body
                    }
                }
                return post
            })
            fs.writeFile(path.join(__dirname, "posts.json"), JSON.stringify(newDataObj), (err) => {
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
                    data: postPatch
                })
        }

    })
})

module.exports = router;