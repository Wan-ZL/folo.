'use strict'

const Course = require('../models/course')
const Building = require('../models/building')

let CourseController = {
  'post': {
    'createCourse': async (req, res, next) => {
      const course = req.body
      console.log(course)
      let findCourse
      let findBuilding
      let result
      try {
        findCourse = await Course.findCourse([{'number': course.number}])
        findBuilding = await Building.findBuilding({'name': course.location})
      } catch (error) {
        console.error(error)
        return res.status(500).json({
          'code': 101,
          'message': 'internal server error',
          'result': {}
        })
      }

      console.log(findCourse)
      console.log(findBuilding)

      if (findCourse !== null && findCourse.length > 0) {
        console.log(findCourse.length)
        return res.status(200).json({
          'code': 200,
          'message': 'found the course',
          'result': {}
        })
      } else if (findBuilding !== null) {
        result = await Course.createCourse({
          'subject': course.subject.toLowerCase(),
          'section': course.section,
          'number': course.number,
          'courseType': course.courseType,
          'instructor': course.instructor,
          'room': course.room,
          'location': course.location
        })
      } else {
        return res.status(500).json({
          'code': 101,
          'message': 'internal server error',
          'result': {}
        })
      }
      return res.status(200).json({
        'code': 200,
        'message': 'successful',
        'result': result
      })
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
      const query = [querySection, querySubject]
      let results
      try {
        results = await Course.findCourse(query)
      } catch (error) {
        console.error(error)
        return res.status(500).json({
          'code': 101,
          'message': 'internal server error',
          'result': {}
        })
      }
      console.log(results)
      return res.status(200).json({
        'code': 200,
        'message': 'successful',
        'result': results
      })
    }
  }
}

module.exports = CourseController
