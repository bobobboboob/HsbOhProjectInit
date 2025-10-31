import { Tab1 } from '../tabs/Tab1';
import { Tab2 } from '../tabs/Tab2';
import { Tab3 } from '../tabs/Tab3';
import { Tab4 } from '../tabs/Tab4';
import { TabHome } from '../tabs/TabHome';
import { TabMine } from '../tabs/TabMine';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Stack() {
      Navigation() {
        Tabs() {
          TabContent() {
            TabHome()
          }
          .tabBar("首页")

          TabContent() {
            Tab1()
          }
          .tabBar("Tab1")

          TabContent() {
            Tab2()
          }
          .tabBar("Tab2")

          TabContent() {
            Tab3()
          }
          .tabBar("Tab3")

          TabContent() {
            Tab4()
          }
          .tabBar("Tab4")

          TabContent() {
            TabMine()
          }
          .tabBar("我的")
        }
        .barPosition(BarPosition.End)
      }
      .mode(NavigationMode.Stack)
      .hideToolBar(true)
    }
  }
}