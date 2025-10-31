
@Component
export struct Tab2 {
  build() {
    Column() {
      Text("这是Tab2")
      Button("跳去二级页面")
        .margin({ top: 10 })
    }
  }
}