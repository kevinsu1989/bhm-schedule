define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->

  class mainChart
    constructor: (@container)->
      @option =
        legend: x: 'right', padding: [8, 20, 5, 5]
        grid: x: 50, y: 60, x2: 20, y2: 20, borderWidth: 0, borderColor: 'transparent'
        tooltip:
          trigger: "axis"

        toolbox: show: false
        calculable: true
        boundaryGap: true
        xAxis: [
          type: "category"
          boundaryGap: false
        ]

      @chart = echarts.init @container
      @chart.setOption @option


    #获取所有的时间点
    getAllTimes: (data)->
      times = {}
      for item in data
        times[_moment(Number(item.time_start)).format('MM-DD HH:mm')] = 0
      times

    #剪切Top5
    cutTopN: (data)->
      list = (value for key, value of data)
      list.sort (left, right)-> if left.total > right.total then -1 else 1
      list.splice 0, 5

    #准备数据
    prepareSeries: (data)->
      result = [
        {name: "开始渲染", type: "line", data: []},
        {name: "页面解析", type: "line", data: []},
        {name: "首屏时间", type: "line", data: []},
        {name: "完全加载", type: "line", data: []}
      ]

      _.map data, (item)->
        result[0].data.push(Math.round item.result.first_paint)
        result[1].data.push(Math.round item.result.dom_ready)
        result[2].data.push(Math.round item.result.first_view)
        result[3].data.push(Math.round item.result.load_time)
        
      # @cutTopN result

      result

    getStyles: (data, color)->
      rgba = _utils.hex2rgba color
      color = _utils.formatString 'rgba({0}, {1}, {2}, {3})', rgba.r, rgba.g, rgba.b, 0.6
      name: data.name
      type: data.type
      smooth: true
      symbol: 'none'
      itemStyle:
        normal:
          color: color
        # normal:
        #   color: color
        #   lineStyle: 
        #     color: color
          # nodeStyle:
          #   color: color
          #   borderWidth: 2
          # areaStyle:
          #   color: color
          #   type: "default"
      data: data.data

    reload: (origin)->
      return if origin.length is 0
      originTimes = @getAllTimes origin
      data = @prepareSeries origin
      colors = ['#2f91da', '#00ff00', '#ff00ff', '#ff0000']

      series = (@getStyles(item, colors[index]) for item, index in data)
      xAxis = [
        type: 'category'
        data: _.keys originTimes
        splitLine: show: true
        boundaryGap: false
        axisLabel:
          formatter: (text)->
            text
      ]

      yAxis = [
        type: 'value'
        splitLine: show: true
        name: 'ms'
      ]
      option =
        xAxis: xAxis
        yAxis: yAxis
        legend: data: _.pluck(data, 'name'), x: 'right', padding: [8, 20, 5, 5]
        series: series

      @chart.setOption _.extend(@option, option), true
        
