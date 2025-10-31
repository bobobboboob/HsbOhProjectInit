import { page_text1 } from "../pages/test1"

@Component
export struct TabMine {
  build() {
    Scroll() {
      Column({ space: 10 }) {
        Text("这是我的页面。下面埋点了事件1、事件5")
          .onClick(() => {
          })
      }
    }
    .width("100%")
    .height("100%")
    .scrollBar(BarState.Off)
    .align(Alignment.Top)

  }
}