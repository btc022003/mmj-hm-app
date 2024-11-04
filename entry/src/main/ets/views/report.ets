import { CommonConstants } from "../common/constants/CommonConstants"
import { webview } from "@kit.ArkWeb"
import { RODTools } from "../utils/db"
import dayjs from "@hview/dayjs"

@Styles
function styleShadow() {
  .shadow({
    radius: 4,
    color: CommonConstants.SECONDARY_COLOR,
    offsetX: 1,
    offsetY: 1
  })
}

// 两个方法一样，待优化
function loadDataByYear(cbIncome: (str: string) => void, cbExpend: (str: string) => void) {
  const yearStart = dayjs().startOf('year').format('YYYY-MM-DD') + " 00:00:00"
  const yearEnd = dayjs().endOf('year').format('YYYY-MM-DD') + " 23:59:59"
  // group by 分组查询，做统计
  RODTools.getInstance()
    .querySql(`SELECT sum(amount) as sum_amount, cate from ( select * from trade_logs WHERE created_at >= '${yearStart}' and created_at<= '${yearEnd}' ) GROUP BY cate`)
    .then(resultSet => {
      // 收入和支出分开处理
      let arrIncomeValues: string[] = []
      let arrExpendValues: string[] = []
      while (resultSet.goToNextRow()) {
        const sumAmount = resultSet.getString(resultSet.getColumnIndex("sum_amount"))
        const cate = resultSet.getString(resultSet.getColumnIndex("cate"))
        const cateName = CommonConstants.TRADE_TYPES.find(item => item.value == cate)?.name
        if (cate.includes("_income")) {
          arrIncomeValues.push(`{value: ${sumAmount}, name: "${cateName}"}`)
        } else {
          arrExpendValues.push(`{value: ${sumAmount}, name: "${cateName}"}`)
        }
      }
      cbIncome(`initChat([${arrIncomeValues.join(",")}])`) // 处理数据
      cbExpend(`initChat([${arrExpendValues.join(",")}])`) // 处理数据
    })
}

function loadDataByMonth(cbIncome: (str: string) => void, cbExpend: (str: string) => void) {
  const yearStart = dayjs().startOf('month').format('YYYY-MM-DD') + " 00:00:00"
  const yearEnd = dayjs().endOf('month').format('YYYY-MM-DD') + " 23:59:59"
  // group by 分组查询，做统计
  RODTools.getInstance()
    .querySql(`SELECT sum(amount) as sum_amount, cate from ( select * from trade_logs WHERE created_at >= '${yearStart}' and created_at<= '${yearEnd}' ) GROUP BY cate`)
    .then(resultSet => {
      // 收入和支出分开处理
      let arrIncomeValues: string[] = []
      let arrExpendValues: string[] = []
      while (resultSet.goToNextRow()) {
        const sumAmount = resultSet.getString(resultSet.getColumnIndex("sum_amount"))
        const cate = resultSet.getString(resultSet.getColumnIndex("cate"))
        const cateName = CommonConstants.TRADE_TYPES.find(item => item.value == cate)?.name
        if (cate.includes("_income")) {
          arrIncomeValues.push(`{value: ${sumAmount}, name: "${cateName}"}`)
        } else {
          arrExpendValues.push(`{value: ${sumAmount}, name: "${cateName}"}`)
        }
      }
      cbIncome(`initChat([${arrIncomeValues.join(",")}])`) // 处理数据
      cbExpend(`initChat([${arrExpendValues.join(",")}])`) // 处理数据
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
  monthIncomeData = ""
  monthExpendData = ""
  yearIncomeDate = ""
  yearExpendData = ""

  aboutToAppear(): void {

    // 初始化之后获取数据
    loadDataByYear(str => {
      this.yearIncomeDate = str
    }, str => {
      this.yearExpendData = str
    })
    loadDataByMonth(str => {
      this.monthIncomeData = str
    }, str => {
      this.monthExpendData = str
    })
  }

  build() {
    Column({
      space: 8
    }) {
      Row() {
        Text("收入")
          .fontColor(this.selTabIndex == 0 ? "" : CommonConstants.DISABLED_COLOR)
          .onClick(() => {
            this.selTabIndex = 0
            // this.tabsController.changeIndex(0)
          })
        Text("|")
        Text("支出")
          .fontColor(this.selTabIndex == 1 ? "" : CommonConstants.DISABLED_COLOR)
          .onClick(() => {
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
              .onPageEnd(() => {
                setTimeout(()=>{
                  this.webMControll.runJavaScript(this.monthIncomeData)
                }, 10)
                // this.webMControll.runJavaScript('initChat([{ value: 9480, name: "薪资" },{ value: 1500, name: "理财" },{ value: 3000, name: "其他" }])')
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
              .onPageEnd(() => {
                setTimeout(()=>{
                  this.webYControll.runJavaScript(this.yearIncomeDate)
                }, 10)
                // this.webYControll.runJavaScript('initChat([{ value: 60480, name: "薪资" },{ value: 150026, name: "理财" },{ value: 8900, name: "其他" }])')
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
              .onPageEnd(() => {
                setTimeout(()=>{
                  this.webOutMControll.runJavaScript(this.monthExpendData)
                }, 10)
                // this.webOutMControll.runJavaScript('initChat([{ value: 1048, name: "餐饮" },{ value: 735, name: "出行" },{ value: 580, name: "人情" },{ value: 484, name: "网购" },{ value: 300, name: "其他" },])')
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
              .onPageEnd(() => {
                setTimeout(()=>{
                  this.webOutYControll.runJavaScript(this.yearExpendData)
                }, 10)
                // this.webOutYControll.runJavaScript('initChat([{ value: 10480, name: "餐饮" },{ value: 3735, name: "出行" },{ value: 2580, name: "人情" },{ value: 8484, name: "网购" },{ value: 23300, name: "其他" },])')
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