'use strict'

let express = require('express')
let router = express.Router()

const buildingController = require('../controllers/building')

router.post('createBuilding', buildingController.post.createBuilding)

module.exports = router
