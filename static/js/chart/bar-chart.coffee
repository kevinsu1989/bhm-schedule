define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->

  class barChart
    constructor: (@container)->
      @option =
        title:
          x: 'center'
          text: 'ECharts例子个数统计'
          textStyle:
            fontSize: 15
        tooltip: 
            trigger: 'item'
        calculable: true
        grid: x: 50, borderWidth: 0, y: 40, y2: 20   
        xAxis: [
          type: 'category'
          show: false
          splitLine: show: false
          data: ['白屏时间', '首屏时间', '页面解析', '完全加载']
          axisLabel:
            margin: 0
            show: false
        ]
        yAxis: [
            type: 'value'
            show: false
        ]    
        series: [
          name: '性能数据'
          type: 'bar'
          itemStyle: 
            normal: 
              color: (params, index)->
                colorList = ['#2f91da', '#ff00ff', '#00ff00', '#ff0000']
                colorList[index]
              label: 
                show: true
                position: 'top'
                formatter: '{b}\n{c}ms'
          data: [12,21,10,4]
        ]
    


      @chart = echarts.init @container
      @chart.setOption @option

    reload: (data, title)->
      @option.title.text = title
      @option.series[0].data = [Math.round(data.first_paint), Math.round(data.first_view), Math.round(data.dom_ready), Math.round(data.load_time)]
      @chart.setOption @option , true



