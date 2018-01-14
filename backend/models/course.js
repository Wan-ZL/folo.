'use strict'

const Mongoose = require('mongoose')
const SchemaTypes = Mongoose.SchemaTypes
const CourseSchema = new Mongoose.Schema({
  'subject': {
    type: SchemaTypes.String,
    require: true
  },
  'number': {
    type: SchemaTypes.Number,
    require: true
  },
  'section': {
    type: SchemaTypes.String,
    require: true
  },
  'courseType': {
    type: SchemaTypes.String,
    require: true
  },
  'instructor': {
    type: SchemaTypes.String,
    require: true
  },
  'room': {
    type: SchemaTypes.String,
    require: true
  },
  'createdAt': {
    type: SchemaTypes.Number,
    required: true,
    validate: (timestamp) => (timestamp + '').length === 13,
    default: () => new Date().getTime()
  }
})

const CourseModel = Mongoose.model('Course', CourseSchema, 'course')

let Course = {
  'createCourse': (course) => {
    return new Promise(async (resolve, reject) => {
      const newCourse = new CourseModel(course)
      let result
      try {
        result = await newCourse.save()
      } catch (error) {
        console.error(error)
        reject(error)
      }
      resolve(result)
    })
  },
  'findCourse': (query) => {
    return new Promise(async (resolve, reject) => {
      let results
      try {
        results = await CourseModel.find(query).sort({'number': -1})
      } catch (error) {
        console.error(error)
        reject(error)
      }
      resolve(results)
    })
  }
}

module.exports = Course
