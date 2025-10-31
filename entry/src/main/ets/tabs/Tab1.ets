
@Component
export struct Tab1 {
  build() {
    Column() {
      Text("这是Tab1")
      Button("跳去二级页面")
        .margin({ top: 10 })
    }
  }
}