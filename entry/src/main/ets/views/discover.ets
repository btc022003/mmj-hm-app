import { CommonConstants } from "../common/constants/CommonConstants"

@Component
export struct DiscoverView {
  build() {
    Column({
      space: 8
    }) {
      Text("把一个远大的目标分割成一个一个可以实现的小计划，日复一日的向着每一个小计划前行。多和优秀的人在一起，远离负面情绪，积极阳光的迎接每一天")
        .textIndent(32)
        // .backgroundColor(CommonConstants.SECONDARY_COLOR)
        .fontColor(CommonConstants.SECONDARY_COLOR)
        .lineHeight(24)
      List({
        space: 8
      }) {
        ListItem() {
          Column({
            space: 8
          }) {
            Text("投资适合我吗？")
              .fontSize(CommonConstants.FONT_SIZE_XL)
              .fontWeight(FontWeight.Bold)
            Text("开启新窗口，如果您已经拥有了大笔钱款，或在每月月底都有结余现金，您可能会这样问自己：我到底是要留着这些现金呢？还是拿去投资？")
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
        }

        ListItem() {
          Column({
            space: 8
          }) {
            Text("投资适合我吗？")
              .fontSize(CommonConstants.FONT_SIZE_XL)
              .fontWeight(FontWeight.Bold)
            Text("开启新窗口，如果您已经拥有了大笔钱款，或在每月月底都有结余现金，您可能会这样问自己：我到底是要留着这些现金呢？还是拿去投资？")
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
        }

        ListItem() {
          Column({
            space: 8
          }) {
            Text("投资适合我吗？")
              .fontSize(CommonConstants.FONT_SIZE_XL)
              .fontWeight(FontWeight.Bold)
            Text("开启新窗口，如果您已经拥有了大笔钱款，或在每月月底都有结余现金，您可能会这样问自己：我到底是要留着这些现金呢？还是拿去投资？")
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
        }

        ListItem() {
          Column({
            space: 8
          }) {
            Text("投资适合我吗？")
              .fontSize(CommonConstants.FONT_SIZE_XL)
              .fontWeight(FontWeight.Bold)
            Text("开启新窗口，如果您已经拥有了大笔钱款，或在每月月底都有结余现金，您可能会这样问自己：我到底是要留着这些现金呢？还是拿去投资？")
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
        }

        ListItem() {
          Column({
            space: 8
          }) {
            Text("投资适合我吗？")
              .fontSize(CommonConstants.FONT_SIZE_XL)
              .fontWeight(FontWeight.Bold)
            Text("开启新窗口，如果您已经拥有了大笔钱款，或在每月月底都有结余现金，您可能会这样问自己：我到底是要留着这些现金呢？还是拿去投资？")
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
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

    }
    .height('100%')
    .padding(12)
  }
}