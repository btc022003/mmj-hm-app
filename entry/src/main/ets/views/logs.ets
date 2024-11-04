import dayjs from '@hview/dayjs'
import { ObservedArray } from '../common/app_model'
import { CommonConstants } from "../common/constants/CommonConstants"
import { LogItem, LogsPageModel } from '../view_model/logs_page_model'

@Component
struct LogsListView {
  @ObjectLink
  list: ObservedArray<LogItem>
  build() {
    List({
      space: 8
    }) {
      ForEach(this.list, (item: LogItem) => {
        ListItem() {
          Column({
            space: 8
          }) {
            Text(item.showTradeCate)
              .fontSize(CommonConstants.FONT_SIZE_MD)
            Text("￥"+item.amount)
              .fontWeight(FontWeight.Bolder)
            Text("注："+item.remarks)
              .fontColor(CommonConstants.SECONDARY_COLOR)
            Text(item.date)
            Divider()
              .width('100%')
              .color(CommonConstants.SECONDARY_COLOR)
              .height(.5)
          }
          .backgroundColor("#2deeeeee")
          .alignItems(HorizontalAlign.Start)
          .padding(4)
        }
      }, (k: LogItem) => k.id)
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
  }
}

@Component
export struct LogsView {
  @State startDate: string = dayjs().startOf("month").format("YYYY-MM-DD") // 开始时间
  @State endDate: string = dayjs().format("YYYY-MM-DD") // 结束时间
  @State pageModel: LogsPageModel = new LogsPageModel()


  aboutToAppear(): void {
    this.pageModel.loadData()
  }

  build() {
    Column() {
      Row({
        space: 2
      }) {
        Text("开始: "+this.startDate)
          .backgroundColor("#ffd4d4d4")
          .fontSize(16)
          .padding(8)
          .onClick(()=>{
            DatePickerDialog.show({
              onDateAccept: date=> {
                this.startDate = dayjs(date).format("YYYY-MM-DD")
              }
            })
          })
        Text("结束: "+this.endDate)
          .backgroundColor("#ffd4d4d4")
          .fontSize(16)
          .padding(8)
          .onClick(()=> {
            DatePickerDialog.show({
              onDateAccept: date=> {
                this.endDate = dayjs(date).format("YYYY-MM-DD")
              }
            })
          })
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
          .onClick(()=>{
            // this.pageModel.list.splice(0, this.pageModel.list.length)
            this.pageModel.loadData(this.startDate+" 00:00:00", this.endDate+" 23:59:59")
          })
      }
      .margin({
        bottom: 16
      })

      // listView
      LogsListView({
        list: this.pageModel.list
      })
    }
    .height('100%')
    .width('100%')
    .padding(12)
  }
}