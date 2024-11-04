import { CommonConstants, TradeType } from "../common/constants/CommonConstants";
import utils from "@arkts.utils";
import { util } from "@kit.ArkTS";
import { ObservedArray } from "../common/app_model";

export class TodayTrade {
  id: string;
  cate: string;
  remarks: string;
  amount: number;
  date: Date;
  showTradeCate: string = ""; // 页面中显示的分类信息


  private dalCate(cate: string) {
    return cate.includes("_income")?'【收入】':'【支出】'+CommonConstants.TRADE_TYPES.find(item=>item.value == cate)?.name
  }

  constructor(id: string, cate: string, amount: number,date: Date, remarks: string) {
    this.id = id
    this.cate = cate;
    this.remarks = remarks
    this.date = new Date()
    this.amount = amount
    this.showTradeCate = this.dalCate(cate)
  }
}

export class HomePageModel {
  incomeMonth: number = 30;
  expandMonth: number = 60;

  todayTradeList: ObservedArray<TodayTrade> = new ObservedArray([])



  loadTodayTrade() {
    //
    this.todayTradeList.push(
      new TodayTrade("9b1deb4d-3b7d-4bad-9bdd-2b0d7a3ecb6d", "canyin_expend", 16.5, new Date() ,"买早餐花费了这么多，感觉还行"),
      new TodayTrade("61f0c679-a8c0-42a1-ab0b-e9627e3acfe0", "chuxing_expend", 230.00, new Date(), "周末旅行交通费"),
      new TodayTrade("3e73e9f9-4a11-4f62-8ade-7f3d2c5e0f33", "chuxing_expend", 50.00, new Date(), "手机话费充值"),
      new TodayTrade("7d8e9f0a-1b2c-3d4e-5f6a-7b8c9d0e1f2", "licai_income", 250.00, new Date(), "股票分红"),
    )
  }

  addToTodayTradeList(amount: number, cate: string, remarks: string) {
    // 插入数据
    this.todayTradeList.unshift(new TodayTrade(util.generateRandomUUID(), cate, amount, new Date(), remarks))
    this.incomeMonth = this.todayTradeList.filter(item=>item.cate.includes("_income")).reduce((pre, cur) => {
      return pre+cur.amount
    }, 0)
    this.expandMonth = this.todayTradeList.filter(item=>item.cate.includes("_expend")).reduce((pre, cur) => {
      return pre+cur.amount
    }, 0)
  }
}