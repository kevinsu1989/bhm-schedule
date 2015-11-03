define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->
        
  class pieChart
    constructor: (@container)->
      @option =
    		tooltip: 
        	trigger: 'axis'
        grid: x: 50,x2: 20, y: 25
        legend:
        	data:['IE','chrome']
        	x: 'right'
        	padding: [8, 20, 5, 5]
    		calculable : true
		    yAxis: [{
          type : 'value'
        }]

      @chart = echarts.init @container
      @chart.setOption @option

    #获取所有的时间点
    getAllTimes: (data)->
      times = {}
      for item in data
        times[_moment(Number(item.time_start)).format('MM-DD HH:mm')] = 0
      times


    prepareSeries: (data)->
      result = [
        {name: "IE", type: "line", stack: '总量', itemStyle: {normal: {areaStyle: {type: 'default'}}},data: []},
        {name: "chrome", type: "line", stack: '总量', itemStyle: {normal: {areaStyle: {type: 'default'}}},data: []}
      ]

      _.map data, (item)->
        result[0].data.push(Math.round 100*item.result.iepv/item.result.pv)
        result[1].data.push(Math.round 100*item.result.chromepv/item.result.pv)

      result



    reload: (data, title)->
      data = data.records
      return if data.length is 0

      times = @getAllTimes data
      console.log @prepareSeries data
      option =
        series: @prepareSeries data
        xAxis: [
          type: 'category'
          data: _.keys times
          boundaryGap: false
        ]
      @chart.setOption _.extend(@option, option), true
        








# option = {
#     tooltip : {
#         trigger: 'axis'
#     },
#     legend: {
#         data:['邮件营销','联盟广告','视频广告','直接访问','搜索引擎']
#     },
#     toolbox: {
#         show : true,
#         feature : {
#             mark : {show: true},
#             dataView : {show: true, readOnly: false},
#             magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
#             restore : {show: true},
#             saveAsImage : {show: true}
#         }
#     },
#     calculable : true,
#     xAxis : [
#         {
#             type : 'category',
#             boundaryGap : false,
#             data : ['周一','周二','周三','周四','周五','周六','周日']
#         }
#     ],
#     yAxis : [
#         {
#             type : 'value'
#         }
#     ],
#     series : [
#         {
#             name:'邮件营销',
#             type:'line',
#             stack: '总量',
#             itemStyle: {normal: {areaStyle: {type: 'default'}}},
#             data:[120, 132, 101, 134, 90, 230, 210]
#         },
#         {
#             name:'联盟广告',
#             type:'line',
#             stack: '总量',
#             itemStyle: {normal: {areaStyle: {type: 'default'}}},
#             data:[220, 182, 191, 234, 290, 330, 310]
#         },
#         {
#             name:'视频广告',
#             type:'line',
#             stack: '总量',
#             itemStyle: {normal: {areaStyle: {type: 'default'}}},
#             data:[150, 232, 201, 154, 190, 330, 410]
#         },
#         {
#             name:'直接访问',
#             type:'line',
#             stack: '总量',
#             itemStyle: {normal: {areaStyle: {type: 'default'}}},
#             data:[320, 332, 301, 334, 390, 330, 320]
#         },
#         {
#             name:'搜索引擎',
#             type:'line',
#             stack: '总量',
#             itemStyle: {normal: {areaStyle: {type: 'default'}}},
#             data:[820, 932, 901, 934, 1290, 1330, 1320]
#         }
#     ]
# };
#                     