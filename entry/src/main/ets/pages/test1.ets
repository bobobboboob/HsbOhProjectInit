@Builder
export function test1Builder() {
  text1()
}

export const page_text1 = 'text1'

@ComponentV2
export struct text1 {
  build() {
    NavDestination() {
      Column() {
        Text("你好啊 嘻嘻")
      }
    }
  }
}