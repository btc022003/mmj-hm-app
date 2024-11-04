import { CommonConstants, TradeType } from "../common/constants/CommonConstants"
import { HomePageModel, TodayTrade } from "../view_model/home_page_model"
import { promptAction } from "@kit.ArkUI"
import { ObservedArray } from "../common/app_model";

interface LogInfo {
  amount: number;
  cate: string;
  remarks: string;
}

@CustomDialog
struct CheckInCustomDialog {
  controller: CustomDialogController = new CustomDialogController({
    builder: CheckInCustomDialog({}),
  })

  @State tradeTypeValue: string = "canyin_expend"
  @State txtAmount: string = ""
  @State txtRemarks: string = ""

  save: (data: LogInfo) => void = (data: LogInfo) => {} // 保存

  build() {
    Column({
      space: 8
    }) {
      Column({
        space: 8
      }) {
        Text("收入")
          .backgroundColor(CommonConstants.PRIMARY_COLOR)
          .padding(8)
          .fontColor("#fff")
        List() {
          ForEach(CommonConstants.TRADE_TYPES.filter(item=>item.value.includes('_income')), (item: TradeType) => {
            ListItem() {
              Row() {
                Text(item.name)
                Radio({ value: item.value, group: 'radioGroup' }).checked(false)
                  .radioStyle({
                    checkedBackgroundColor: CommonConstants.PRIMARY_COLOR
                  })
                  .onChange(v=> {
                    if(v) {
                      // 选中
                      this.tradeTypeValue = item.value
                    }
                  })
              }
              .justifyContent(FlexAlign.Center)
            }
          }, (item: TradeType) => item.id)
        }.lanes(4)

        Text("支出")
          .backgroundColor(CommonConstants.PRIMARY_COLOR)
          .padding(8)
          .fontColor("#fff")
        List() {
          ForEach(CommonConstants.TRADE_TYPES.filter(item=>item.value.includes('_expend')), (item: TradeType) => {
            ListItem() {
              Row() {
                Text(item.name)
                Radio({ value: item.value, group: 'radioGroup' }).checked(item.value == this.tradeTypeValue)
                  .radioStyle({
                    checkedBackgroundColor: CommonConstants.PRIMARY_COLOR
                  })
                  .onChange(v=> {
                    if(v) {
                      // 选中
                      this.tradeTypeValue = item.value
                    }
                  })
              }
              .justifyContent(FlexAlign.Center)
            }
          }, (item: TradeType) => item.id)
        }.lanes(4)
        .alignListItem(ListItemAlign.Center)
      }
      .alignItems(HorizontalAlign.Start)

      TextInput({
        placeholder: '请输入金额',
        text: $$this.txtAmount
      }).type(InputType.NUMBER_DECIMAL)
        .showUnderline(true)
        .borderRadius(4)
      TextArea({
        placeholder: "请输入备注",
        text: $$this.txtRemarks
      })
        .height(90)
        .borderRadius(4)
        .maxLines(10)
        .borderRadius(4)

      Button("确认")
        .backgroundColor(CommonConstants.PRIMARY_COLOR)
        .type(ButtonType.Normal)
        .borderRadius(4)
        .width('55%')
        .onClick(() => {
          if(this.txtAmount && this.txtRemarks && this.tradeTypeValue) {

            if(isNaN(Number(this.txtAmount))) {
              promptAction.showToast({
                message: '请输入正确的金额数据'
              })
              return
            }
            // 保存
            this.save({
              amount: Number(this.txtAmount),
              remarks: this.txtRemarks,
              cate: this.tradeTypeValue
            })
            // 关闭弹窗
            this.controller.close()
          } else {
            promptAction.showToast({
              message: '请输入记账数据'
            })
          }
        })
    }
    .height('80%')
    .padding({
      top: 30,
      left: 12,
      right: 12,
      bottom: 12
    })
  }
}

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
struct TodayTradeView {
  @ObjectLink list: ObservedArray<TodayTrade>
  build() {
    List() {
      ForEach(this.list, (item: TodayTrade) => {
        ListItem() {
          Column({
            space: 8
          }) {
            Text(item.showTradeCate)
              .fontSize(CommonConstants.FONT_SIZE_MD)
            Text("￥"+item.amount?.toFixed(2))
              .fontWeight(FontWeight.Bolder)
            Text("注："+item.remarks)
              .fontColor(CommonConstants.SECONDARY_COLOR)
            Divider()
              .width('100%')
              .color(CommonConstants.SECONDARY_COLOR)
              .height(.5)
              .styleShadow()
          }
          .alignItems(HorizontalAlign.Start)
          .padding(4)
        }
      }, (item: TodayTrade) => item.id)
    }
    .scrollBar(BarState.Off)
    .layoutWeight(1)
  }
}

@Component
export struct HomeView {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CheckInCustomDialog({
      save: this.saveLog.bind(this)
    }),
    // autoCancel: false,

  })
  
  @State pageModel: HomePageModel = new HomePageModel()
  
  aboutToAppear(): void {
    this.pageModel.loadTodayTrade()
  }

  saveLog(data: LogInfo) {
    this.pageModel.addToTodayTradeList(data.amount, data.cate, data.remarks)
  }

  build() {
    Column({
      space: 8
    }) {

      // 头部文字
      Text("每美记账")
        .fontSize(CommonConstants.FONT_SIZE_XL)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)
        .width('100%')

      Text("记录美好生活每一天")
        .fontSize(CommonConstants.FONT_SIZE_XL)
        .fontColor(CommonConstants.SECONDARY_COLOR)
        .fontWeight(FontWeight.Lighter)
        .textAlign(TextAlign.Start)
        .width('100%')

      // 当月汇总
      Row() {
        Column({
          space: 4
        }) {
          Text("本月收入")
            .fontColor('#fff')
          Text("￥"+this.pageModel.incomeMonth?.toFixed(2))
            .fontColor('#fff')
        }
        .padding(32)
        .width("45%")
        .backgroundColor(CommonConstants.PRIMARY_COLOR)
        .styleShadow()


        Column() {
          Text("本月支出")
          Text("￥"+this.pageModel.expandMonth?.toFixed(2))
        }
        .padding(32)
        .width('45%')
        .border({
          color: CommonConstants.PRIMARY_COLOR,
          width: 1
        })
        .styleShadow()
      }
      .justifyContent(FlexAlign.SpaceAround)
      .width('100%')

      // 一键记账
      Button("一键记账")
        .width('70%')
        .backgroundColor(CommonConstants.PRIMARY_COLOR)
        .fontColor('#fff')
        .type(ButtonType.Normal)
        .borderRadius(6)
        .styleShadow()
        .onClick(() => {
          this.dialogController.open()
        })

      // tips
      Text("今日汇总")
        .backgroundColor(CommonConstants.PRIMARY_COLOR)
        .padding(8)
        .fontColor("#fff")
        .styleShadow()
        .alignSelf(ItemAlign.Start)

      // 当日记录
      TodayTradeView({
        list: this.pageModel.todayTradeList
      })

    }
    .height('100%')
    .padding(12)
  }
}