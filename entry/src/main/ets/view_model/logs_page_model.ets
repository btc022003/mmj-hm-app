import dayjs from "@hview/dayjs";
import { ObservedArray } from "../common/app_model";
import { CommonConstants } from "../common/constants/CommonConstants";

export class LogItem {
  id: string;
  cate: string;
  remarks: string;
  amount: number;
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
    this.amount = amount
    this.showTradeCate = this.dalCate(cate)
  }

}

export class LogsPageModel {
  list: ObservedArray<LogItem> = new ObservedArray([])

  loadData() {
    this.list.push(
      new LogItem("4c5d6e7f-8a9b-0c1d-2e3f-4a5b6c7d8e9", "canyin_expend", 39.82, new Date(), "咖啡消费"),
      new LogItem("3b4a5d6c-7e8f-9a0b-1c2d-3e4f5a6b7c8d", "chuxing_expend", 100.00, new Date(), "地铁卡充值"),
      new LogItem("2a3f4b5e-6d7c-8b9a-0f1e-2d3c4e5f6a7b", "tongxin_expend", 200.00, new Date(), "网络服务费"),
      new LogItem("1b2c3d4e-5f6a-7b8c-9d0e-1f2a3b4c5d6f", "wanggou_expend", 150.00, new Date(), "厨房用具"),
    )
  }
}