import dayjs from "@hview/dayjs";
import { ObservedArray } from "../common/app_model";
import { CommonConstants } from "../common/constants/CommonConstants";
import { RODTools } from "../utils/db";
import { getDayMonthRange } from "../utils/tools";

export class LogItem {
  id: string;
  cate: string;
  remarks: string;
  amount: string;
  date: string;
  showTradeCate: string = ""; // 页面中显示的分类信息


  private dalCate(cate: string) {
    return cate.includes("_income")?'【收入】':'【支出】'+CommonConstants.TRADE_TYPES.find(item=>item.value == cate)?.name
  }

  constructor(id: string, cate: string, amount: number,date: Date, remarks: string) {
    this.id = id
    this.cate = cate;
    this.remarks = remarks
    this.date = dayjs(date).format("YYYY-MM-DD")
    this.amount = amount.toFixed(2)
    this.showTradeCate = this.dalCate(cate)
  }

}

export class LogsPageModel {
  list: ObservedArray<LogItem> = new ObservedArray([])

  /**
   * 加载数据
   * @param startDate
   * @param endDate
   */
  loadData(startDate: string  = '', endDate: string = '') {
    this.list = new ObservedArray<LogItem>([])
    if(startDate && endDate) {

    } else {
      const dayMonthRange = getDayMonthRange()
      startDate = dayMonthRange.monthStart
      endDate = dayMonthRange.monthEnd
    }
    RODTools.getInstance()
      .querySql(`select * from trade_logs WHERE created_at >= '${startDate}' and created_at<= '${endDate}' order by created_at desc`)
      .then(resultSet => {
        while (resultSet.goToNextRow()) {
          // 继续
          const id = resultSet.getString(resultSet.getColumnIndex("id")) // id
          const cate = resultSet.getString(resultSet.getColumnIndex("cate")) // cate
          const amount = resultSet.getDouble(resultSet.getColumnIndex("amount")) // camount
          const remarks = resultSet.getString(resultSet.getColumnIndex("remarks")) // remarks
          const date = resultSet.getString(resultSet.getColumnIndex("created_at")) // created_at
          this.list.push(new LogItem(id, cate, amount, new Date(date), remarks))
        }
      })
  }
}