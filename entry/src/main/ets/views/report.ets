import { CommonConstants } from "../common/constants/CommonConstants"
import { webview } from "@kit.ArkWeb"

@Styles
function styleShadow() {
  .shadow({
    radius: 4,
    color: CommonConstants.SECONDARY_COLOR,
    offsetX: 1,
    offsetY: 1
  })
}

@Component
export struct ReportView {

  webMControll: WebviewController = new webview.WebviewController()
  webYControll: WebviewController = new webview.WebviewController()

  webOutMControll: WebviewController = new webview.WebviewController()
  webOutYControll: WebviewController = new webview.WebviewController()
  // tabsController: TabsController = new TabsController()

  @State selTabIndex: number = 0 // tab页切换的是支出还是收入

  build() {
    Column({
      space: 8
    }) {
      Row(){
        Text("收入")
          .fontColor(this.selTabIndex==0?"":CommonConstants.DISABLED_COLOR)
          .onClick(()=>{
            this.selTabIndex = 0
            // this.tabsController.changeIndex(0)
          })
        Text("|")
        Text("支出")
          .fontColor(this.selTabIndex==1?"":CommonConstants.DISABLED_COLOR)
          .onClick(()=>{
            this.selTabIndex = 1
            // this.tabsController.changeIndex(0)
          })
      }
      Tabs({
        // controller: this.tabsController,
        index: this.selTabIndex
      }) {
        TabContent() {
          Column() {
            Text("本月收入")
              .backgroundColor(CommonConstants.PRIMARY_COLOR)
              .padding(8)
              .fontColor("#fff")
              .styleShadow()
              .alignSelf(ItemAlign.Start)
            // 月汇总
            Web({
              controller: this.webMControll,
              src: $rawfile("web/index.html")
            })
              .width(300)
              .height(300)

            Text("本年收入")
              .backgroundColor(CommonConstants.PRIMARY_COLOR)
              .padding(8)
              .fontColor("#fff")
              .styleShadow()
              .alignSelf(ItemAlign.Start)
            // 年汇总
            Web({
              controller: this.webYControll,
              src: $rawfile("web/index.html")
            })
              .width(300)
              .height(300)
          }
        }

        // 支出
        TabContent() {
          Column() {
            Text("本月支出")
              .backgroundColor(CommonConstants.PRIMARY_COLOR)
              .padding(8)
              .fontColor("#fff")
              .styleShadow()
              .alignSelf(ItemAlign.Start)
            // 月汇总
            Web({
              controller: this.webOutMControll,
              src: $rawfile("web/index.html")
            })
              .width(300)
              .height(300)

            Text("本年支出")
              .backgroundColor(CommonConstants.PRIMARY_COLOR)
              .padding(8)
              .fontColor("#fff")
              .styleShadow()
              .alignSelf(ItemAlign.Start)
            // 年汇总
            Web({
              controller: this.webOutYControll,
              src: $rawfile("web/index.html")
            })
              .width(300)
              .height(300)
          }
        }
      }
      .layoutWeight(1)
      .scrollable(false)
      .barHeight(0)
      // .tabIndex(this.selTabIndex)


    }
    .height('100%')
    .width('100%')
    .padding(12)
  }
}