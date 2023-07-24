import express from "express";
const router = express.Router();

import postModule from './modules/posts/posts.module'
router.use("/posts", postModule)

import userModule from './modules/users/users.module'
router.use("/users", userModule)
module.exports = router;