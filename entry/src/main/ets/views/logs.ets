import { CommonConstants } from "../common/constants/CommonConstants"

@Component
export struct LogsView {
  build() {
    Column() {
      Row({
        space: 2
      }) {
        Text("开始: 2024-10-01")
          .backgroundColor("#ffd4d4d4")
          .fontSize(12)
          .padding(8)
        Text("结束: 2024-11-30")
          .backgroundColor("#ffd4d4d4")
          .fontSize(12)
          .padding(8)
        Button("查询")
          .backgroundColor(CommonConstants.PRIMARY_COLOR)
          .type(ButtonType.Normal)
          .borderRadius(4)
          .fontSize(12)
          .padding({
            left: 12,
            right: 12,
            top: 4,
            bottom: 4
          })
          .height(30)
      }
      .margin({
        bottom: 16
      })
      List({
        space: 8
      }) {
        ForEach([1,2,3,4,5,6], (item: number) => {
          ListItem() {
            Column({
              space: 8
            }) {
              Text("【支出】餐饮")
                .fontSize(CommonConstants.FONT_SIZE_MD)
              Text("￥15")
                .fontWeight(FontWeight.Bolder)
              Text("注：买早饭花费了15块，吃的包子，虽然有点贵但是很好吃")
                .fontColor(CommonConstants.SECONDARY_COLOR)
              Text("2024-11-02")
              Divider()
                .width('100%')
                .color(CommonConstants.SECONDARY_COLOR)
                .height(.5)
            }
            .alignItems(HorizontalAlign.Start)
            .padding(4)
          }
        }, (k: string) => k+"")
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .height('100%')
    .width('100%')
    .padding(12)
  }
}