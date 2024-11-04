import { DiscoverView } from '../views/discover';
import { HomeView } from '../views/home';
import { LogsView } from '../views/logs';
import { ReportView } from '../views/report';



@Entry
@Component
struct Index {
  @State tabSelectedIndex: number = 0;

  @Builder
  tabBarBuilder(label: string, icon: Resource, selIcon: Resource, index = 0) {
  Column({
    space: 4
  }) {
    Image(this.tabSelectedIndex == index ? selIcon : icon)
      .width(20)
    Text(label).fontColor(this.tabSelectedIndex == index ? "#fff" : "#000")
  }
  .width('100%')
  .backgroundColor(this.tabSelectedIndex == index?"#000":'000')
  .padding(4)
}

  build() {
    RelativeContainer() {
      Tabs({}) {
        TabContent() {
          HomeView()
        }.tabBar(this.tabBarBuilder("首页", $rawfile("images/home-b.png"), $rawfile("images/home-f.png"), 0))

        TabContent() {
          ReportView()
        }.tabBar(this.tabBarBuilder("报表", $rawfile("images/report-b.png"), $rawfile("images/report-f.png"), 1))

        TabContent() {
          DiscoverView()
        }.tabBar(this.tabBarBuilder("发现", $rawfile("images/discover-b.png"), $rawfile("images/discover-f.png"), 2))

        TabContent() {
          LogsView()
        }.tabBar(this.tabBarBuilder("日志", $rawfile("images/logs-b.png"), $rawfile("images/logs-f.png"), 3))
      }.barPosition(BarPosition.End)
      // .onChange((index)=> {
      //   this.tabSelectedIndex = index
      // })
      .onContentWillChange((c, n) => {
        this.tabSelectedIndex = n
        return true
      })
    }
    .height('100%')
    .width('100%')
  }
}