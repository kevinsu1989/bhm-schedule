
exports.schema =
  name: 'records'

  fields:
    # 客户端ip
    ip: 'bigInteger'
    # 分辨率
    resolution: ''
    # 地区
    district: ''
    # 页面名称
    page_name: '' 
    # 页面版本号
    version: '' 
    # 浏览器名 
    browser_name: ''
    # 浏览器版本
    browser_version: ''
    # 上报时间
    timestamp: 'bigInteger'
    # 首次渲染时间
    first_paint: 'integer'
    # domReady时间
    dom_ready: 'integer'
    # 完全加载时间
    load_time: 'integer'
    # 首屏时间
    first_view: 'integer'
    # 播放器加载是否成功
    flash_load: 'integer'
    # 是否安装flash
    flash_installed: 'integer'
    # flash版本
    flash_version: ''
    # 播放器加载时间
    flash_load_time: 'integer'
    # 页面加载耗时最长的元素
    snail_name: ''
    # 页面加载耗时最长元素的耗时
    snail_duration: 'integer'
    # 上报的url
    url: ''
    # 本次上报的hasl
    hash: ''
    # 服务端版本
    server_version: ''


