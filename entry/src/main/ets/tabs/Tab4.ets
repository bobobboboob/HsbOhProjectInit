@Component
export struct Tab4 {
  build() {
    Column() {
      Text("这是Tab4")
      Button("跳去二级页面")
        .onClick(() => {
          // this.queryNavigationInfo()?.pathStack.pushPath()
        })
        .margin({ top: 10 })
    }
  }
}