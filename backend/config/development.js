'use strict'

let config = {
  'app': {
    'name': 'ClassroomLocator',
    'host': 'localhost',
    'port': 4000
  },

  'mongodb': {
    'classroomLocator': {
      'host': 'localhost',
      'port': 27017,
      'db': 'classroomLocator',
      'options': {
        'poolSize': 1,
        'useMongoClient': true
      }
    }
  },

  'statusCode': {
    '101': 'internal server',  // 服务器错误
    '102': 'connection failed',  // 连接失败
    '103': 'not found',  // 没找到资源
    '104': 'invalid json', //无效 JSON
    '105': 'incorrect type',  // 无效 类型
    '108': 'operation forbidden',  // 操作被禁止
    '109': 'timeout',  // 超时
    '117': 'invalid parameter',  // 参数错误

    '200': 'success'  // 请求成功
  }
}

config.mongodb.classroomLocator.url = 'mongodb://' + config.mongodb.classroomLocator.host + ':' + config.mongodb.classroomLocator.port + '/' + config.mongodb.classroomLocator.db

module.exports = config
