'use strict'

let express = require('express')
let router = express.Router()

const buildingController = require('../controllers/building')

// post
router.post('/createBuilding', buildingController.post.createBuilding)

// get
router.get('/getBuilding', buildingController.get.getBuilding)

module.exports = router
