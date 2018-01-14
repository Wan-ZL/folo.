'use strict'

let express = require('express')
let router = express.Router()

const courseController = require('../controllers/course')

// post
router.post('/createCourse', courseController.post.createCourse)
// get
router.get('/getCourse', courseController.get.getCourse)

module.exports = router
