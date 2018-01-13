'use strict'

const Building = require('../models/building')

let BuildingController = {
  'post': {
    'createBuilding': async (req, res, next) => {
      const building = req.body.building
      let findBuilding
      try {
        findBuilding = await Building.findBuilding({name: building.name})
      } catch (error) {

      }
    }
  },
  'get': {}
}

module.exports = BuildingController
