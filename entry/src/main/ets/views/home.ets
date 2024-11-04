import { CommonConstants } from "../common/constants/CommonConstants"

@CustomDialog
struct CheckInCustomDialog {
  controller: CustomDialogController = new CustomDialogController({
    builder: CheckInCustomDialog({}),
  })

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
          ListItem() {
            Row() {
              Text('理财')
              Radio({ value: 'Radio2', group: 'radioGroup' }).checked(false)
                .radioStyle({
                  checkedBackgroundColor: CommonConstants.PRIMARY_COLOR
                })
            }
          }

          ListItem() {
            Row() {
              Text('工资')
              Radio({ value: 'Radio2', group: 'radioGroup' }).checked(false)
                .radioStyle({
                  checkedBackgroundColor: CommonConstants.PRIMARY_COLOR
                })
            }
          }

          ListItem() {
            Row() {
              Text('其他')
              Radio({ value: 'Radio2', group: 'radioGroup' }).checked(false)
                .radioStyle({
                  checkedBackgroundColor: CommonConstants.PRIMARY_COLOR
                })
            }
          }
        }.lanes(4)

        Text("支出")
          .backgroundColor(CommonConstants.PRIMARY_COLOR)
          .padding(8)
          .fontColor("#fff")
        List() {
          ListItem() {
            Row() {
              Text('餐饮')
              Radio({ value: 'Radio2', group: 'radioGroup' }).checked(false)
                .radioStyle({
                  checkedBackgroundColor: CommonConstants.PRIMARY_COLOR
                })
            }
            .justifyContent(FlexAlign.Center)
          }

          ListItem() {
            Row() {
              Text('交通')
              Radio({ value: 'Radio2', group: 'radioGroup' }).checked(false)
                .radioStyle({
                  checkedBackgroundColor: CommonConstants.PRIMARY_COLOR
                })
            }
          }

          ListItem() {
            Row() {
              Text('人情')
              Radio({ value: 'Radio2', group: 'radioGroup' }).checked(false)
                .radioStyle({
                  checkedBackgroundColor: CommonConstants.PRIMARY_COLOR
                })
            }
          }

          ListItem() {
            Row() {
              Text('网购')
              Radio({ value: 'Radio2', group: 'radioGroup' }).checked(false)
                .radioStyle({
                  checkedBackgroundColor: CommonConstants.PRIMARY_COLOR
                })
            }
          }

          ListItem() {
            Row() {
              Text('其他')
              Radio({ value: 'Radio2', group: 'radioGroup' }).checked(false)
                .radioStyle({
                  checkedBackgroundColor: CommonConstants.PRIMARY_COLOR
                })
            }
          }
        }.lanes(4)
        .alignListItem(ListItemAlign.Center)
      }
      .alignItems(HorizontalAlign.Start)

      TextInput({
        placeholder: '请输入金额',
      }).type(InputType.Number)
        .showUnderline(true)
        .borderRadius(4)


      TextArea({
        placeholder: "请输入备注"
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
          this.controller.close()
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
export struct HomeView {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CheckInCustomDialog(),
    autoCancel: false
  })

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
          Text("￥10000")
            .fontColor('#fff')
        }
        .padding(32)
        .width("40%")
        .backgroundColor(CommonConstants.PRIMARY_COLOR)
        .styleShadow()


        Column() {
          Text("本月支出")
          Text("￥100")
        }
        .padding(32)
        .width('40%')
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
      List() {
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
            Divider()
              .width('100%')
              .color(CommonConstants.SECONDARY_COLOR)
              .height(.5)
              .styleShadow()
          }
          .alignItems(HorizontalAlign.Start)
          .padding(4)
        }

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
            Divider()
              .width('100%')
              .color(CommonConstants.SECONDARY_COLOR)
              .height(.5)
              .styleShadow()
          }
          .alignItems(HorizontalAlign.Start)
          .padding(4)
        }

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
            Divider()
              .width('100%')
              .color(CommonConstants.SECONDARY_COLOR)
              .height(.5)
              .styleShadow()
          }
          .alignItems(HorizontalAlign.Start)
          .padding(4)
        }

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
            Divider()
              .width('100%')
              .color(CommonConstants.SECONDARY_COLOR)
              .height(.5)
              .styleShadow()
          }
          .alignItems(HorizontalAlign.Start)
          .padding(4)
        }

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
            Divider()
              .width('100%')
              .color(CommonConstants.SECONDARY_COLOR)
              .height(.5)
              .styleShadow()
          }
          .alignItems(HorizontalAlign.Start)
          .padding(4)
        }

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
            Divider()
              .width('100%')
              .color(CommonConstants.SECONDARY_COLOR)
              .height(.5)
              .styleShadow()
          }
          .alignItems(HorizontalAlign.Start)
          .padding(4)
        }
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)

    }
    .height('100%')
    .padding(12)
  }
}