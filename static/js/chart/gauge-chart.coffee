define [
  'v/echarts'
  'utils'
  "moment"
  '_'
], (_echarts, _utils, _moment, _)->

  class gaugeChart
    constructor: (@container)->
      @option =
        tooltip :
          formatter : "{a} <br/>{b} : {c}%"
        toolbox : show: false
        series : [
          name:'flash加载成功率'
          type:'gauge'    

          center : ['50%', '50%'],    
          radius : [0, '75%'],
          startAngle: 140,
          endAngle : -140,

          min: 0,                    
          max: 100,                   
          precision: 0,               
          splitNumber: 5,            
          axisLine: {            
              show: true,       
              lineStyle: {   
                  color: [[0.8, 'orange'],[0.85, 'lightgreen'],[1, 'skyblue']] , 
                  width: 20
              }
          },
          axisTick: {            
              show: true,        
              splitNumber: 5,    
              length :8,        
              lineStyle: {      
                  color: '#eee',
                  width: 1,
                  type: 'solid'
              }
          },
          axisLabel: {          
              show: true,
              textStyle: {     
                  color: '#333'
              }
          },
          splitLine: {          
              show: true,       
              length :10,       
              lineStyle: {       
                  color: '#eee',
                  width: 2,
                  type: 'solid'
              }
          },
          pointer : {
              length : '80%',
              width : 8,
              color : 'auto'
          },
          title : {
              show : true,
              offsetCenter: ['-105%', -10],      
              textStyle: {      
                  color: '#333',
                  fontSize : 12
              }
          },
          detail : {
              show : true,
              backgroundColor: 'rgba(0,0,0,0)',
              borderWidth: 0,
              borderColor: '#ccc',
              width: 100,
              height: 20,
              offsetCenter: ['-100%', 5],      
              formatter:'{value}%',
              textStyle: {       
                  color: 'auto',
                  fontSize : 15
              }
          },

          # splitNumber: 5   
          # axisLine: 
          #   lineStyle:   
          #     color: [[0.8, '#ff4500'],[0.85, '#A4C21E'],[1, '#228b22']]
          #     width: 8
   
          # axisTick: 
          #   splitNumber: 5
          #   length :12    
          #   lineStyle: 
          #     color: 'auto'
    
          # axisLabel: 
          #     textStyle:
          #         color: 'auto'

          # splitLine: 
          #   show: true
          #   length :30
          #   lineStyle:
          #     color: 'auto'
 
          # pointer :
          #   width : 5
         
          # title : 
          #   show : true,
          #   offsetCenter: [0, '-110%']     
          #   textStyle: 
          #     fontWeight: 'normal'

          # detail :
          #   formatter: '{value}%'
          #   textStyle:
          #     color: 'auto'
          #     fontWeight: 'normal'
          #     fontSize: 15

          data:[{value: 50, name: '完成率'}]
    		]


      @chart = echarts.init @container
      @chart.setOption @option


    reload: (data, title)->
      @option.series[0].data[0] = 
      	value: Math.round(data * 10000)/100
      	name: title
      @chart.setOption @option, true
        

