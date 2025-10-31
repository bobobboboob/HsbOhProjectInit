import { page_text1 } from "../pages/test1"

@Component
export struct TabHome {
  build() {
    Column() {
      Text("这是首页")
      Button("跳去二级页面")
        .margin({ top: 10 })
        .onClick(()=>{
          this.queryNavigationInfo()?.pathStack.pushDestinationByName(page_text1, undefined)
        })
    }
  }
}