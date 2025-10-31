
@Component
export struct Tab3 {
  build() {
    Column() {
      Text("这是Tab3")
      Button("跳去二级页面")
        .margin({ top: 10 })
    }
  }
}