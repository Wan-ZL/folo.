'use strict'

const Course = require('../models/course')
const Building = require('../models/building')

let CourseController = {
  'post': {
    'createCourse': async (req, res, next) => {
      const course = req.body.crouse
      let findCourse
      let findBuilding
      try {
        findCourse = await Course.findCourse({number: course.number})
        findBuilding = Building.findBuilding({'name': course.buildingName})
      } catch (error) {
        console.error(error)
        return res.status(500).json({
          'code': 101,
          'message': 'internal server error',
          'result': {}
        })
      }
      if (findCourse !== null) {
        return res.status(200).json({
          'code': 200,
          'message': 'found the course',
          'result': {}
        })
      } else if (findBuilding !== null) {

      } else {
        return res.status(500).json({
          'code': 101,
          'message': 'internal server error',
          'result': {}
        })
      }
    }
  },
  'get': {
    'getCourse': async (req, res, next) => {
      const mass = req.query.mass
      const section = mass.replace(/[a-z]+|[A-Z]+/, '')
      const subject = mass.replace(/[0-1]+/, '')
      console.log(section + ' ' + subject)
      const querySection = {'section': new RegExp(section)}
      const querySubject = {'subject': new RegExp(subject.toLowerCase())}
      let results
      try {
        results = Course.findCourse(querySection)
      } catch (error) {
        console.error(error)
        return res.status(500).json({
          'code': 101,
          'message': 'internal server error',
          'result': {}
        })
      }
      return res.status(200).json({
        'code': 200,
        'message': 'successful',
        'result': results
      })
    }
  }
}

module.exports = CourseController
