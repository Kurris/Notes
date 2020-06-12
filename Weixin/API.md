### 微信小程序---API
* 取值: `this.data.XXX`
* 赋值: 
```
this.setData( { 
XXX: value  
} ) `
```
* 弹窗
```
function(){
    wx.showToast({
        title: 'xx',         显示内容
        icon:' success',  成功图标
        duration: 2000  出现时间
 })
}
```
* 显示加载中
```
function(){
wx.showLoading({
 title: ''
})
}
```
* 隐藏加载中
```
function(){
wx.HideLoading({
 title: ''
})
}
```
* 模式窗体
```
function(){
wx.showModal({
titile:'',
context:' '
}),
success:function(e){

}或者
success:()=>{
}
}
```
* 跳转
```
wx.navigateTo({
url : ''
})
```
* 请求
```
wx.request({
url:'',
success: (res)=>{

})
```
* 选择图片
```
wx.chooseImage({
})
```