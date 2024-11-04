import { ObservedArray } from "../common/app_model"
import { CommonConstants } from "../common/constants/CommonConstants"
import { DiscoverPageModel, NewsItem } from "../view_model/discover_page_model"

@Component
struct NewsListView {
  @ObjectLink list: ObservedArray<NewsItem>
  build() {
    List({
      space: 8
    }) {
      ForEach(this.list, (item: NewsItem)=> {
        ListItem() {
          Column({
            space: 8
          }) {
            Text(item.title)
              .fontSize(CommonConstants.FONT_SIZE_XL)
              .fontWeight(FontWeight.Bold)
            Text(item.summary)
              .fontColor(CommonConstants.SECONDARY_COLOR)
            Divider()
              .width('100%')
              .height(1)
              .color(CommonConstants.SECONDARY_COLOR)
              .shadow({
                radius: 4,
                color: CommonConstants.DISABLED_COLOR,
                offsetX: -1,
                offsetY: .5
              })
          }
          .alignItems(HorizontalAlign.Start)
          .backgroundColor("#0ceeeeee")
        }
      }, (item: NewsItem) => item.id)

    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
  }
}

@Component
export struct DiscoverView {
  @State pageModel: DiscoverPageModel = new DiscoverPageModel()
  
  aboutToAppear(): void {
    this.pageModel.loadData()
  }
  
  build() {
    Column({
      space: 8
    }) {
      Text("把一个远大的目标分割成一个一个可以实现的小计划，日复一日的向着每一个小计划前行。多和优秀的人在一起，远离负面情绪，积极阳光的迎接每一天")
        .textIndent(32)
        // .backgroundColor(CommonConstants.SECONDARY_COLOR)
        .fontColor(CommonConstants.SECONDARY_COLOR)
        .lineHeight(24)

      NewsListView({
        list: this.pageModel.list
      })
    }
    .height('100%')
    .padding(12)
  }
}