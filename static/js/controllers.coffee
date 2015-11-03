#    Author: 易晓峰
#    E-mail: wvv8oo@gmail.com
#    Date: 1/13/15 11:34 AM
#    Description:

define [
  'ng'
], (_ng)->
  _ng.module("app.controllers", ['app.services'])
  # .controller('homeController', ['$rootScope', 'API', ($rootScope, API)->
  #   loadData = (page_name, data)->
  #     API.pages(page_name).retrive(data).then (result)->
  #       $scope.loading = false
  #       $rootScope.data = result

  #   loadData('BHF')
  # ])

  .controller('agentController', ['$rootScope', '$scope', 'API',
    ($rootScope, $scope, API)->
      $rootScope.activeMenu = 'agent'
#      $scope.status = {}
#      updateStatus = (event, status)->
#        $scope.status = status
#        $scope.$apply()
#
#      #服务器主动推送代理的状态
#      $rootScope.$on 'socket:status', updateStatus
#
#      #获取服务器状态
#      SOCKET.getHoobotStatus (status)-> updateStatus null, status
  ])

  .controller('mainController', ['$rootScope', '$scope', 'API',
    ($rootScope, $scope, API)->
      $rootScope.page_name = ""
      $rootScope.query = {}
      loadData = ()->
        $scope.loading = true
        API.pages($rootScope.page_name).retrieve($rootScope.query).then (result)->
          $scope.loading = false
          $rootScope.$broadcast 'main:data:loaded', result

      $rootScope.$on 'pages:menu:click', (event, page)->
        $rootScope.page_name = page.page_name
        $rootScope.query.page_like = page.page_like
        $rootScope.query.isSpeed = $rootScope.isSpeed
        $rootScope.query.type = $rootScope.type
        loadData()

      $rootScope.$on 'top:menu:select', (event, query)->
        $rootScope.query = query
        $rootScope.query.isSpeed = $rootScope.isSpeed
        $rootScope.query.type = $rootScope.type
        loadData()
  ])

  