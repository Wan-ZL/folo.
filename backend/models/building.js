'use strict'

const Mongoose = require('mongoose')
const SchemaTypes = Mongoose.SchemaTypes
const BuildingSchema = new Mongoose.Schema({
  'name': {
    type: SchemaTypes.String,
    require: true
  },
  'latitude': {
    type: SchemaTypes.Number,
    require: true
  },
  'longitude': {
    type: SchemaTypes.Number,
    require: true
  },
  'createdAt': {
    type: SchemaTypes.Number,
    validate: (timestamp) => (timestamp + '').length === 13,
    default: () => new Date().getTime()
  }
})

const BuildingModel = Mongoose.model('Building', BuildingSchema, 'building')

let Building = {
  'createBuilding': (building) => {
    return new Promise(async (resolve, reject) => {
      const newBuilding = new BuildingModel(building)
      let result
      try {
        result = await newBuilding.save()
      } catch (error) {
        console.error(error)
        return reject(error)
      }
      resolve(result)
    })
  },
  'findBuilding': (query) => {
    return new Promise(async (resolve, reject) => {
      let result
      try {
        result = await BuildingModel.findOne(query)
      } catch (error) {
        console.error(error)
        reject(error)
      }
      resolve(result)
    })
  }
}

module.exports = Building
