import { CommonConstants, TradeType } from "../common/constants/CommonConstants";
import utils from "@arkts.utils";
import { util } from "@kit.ArkTS";
import { ObservedArray } from "../common/app_model";
import { RODTools } from "../utils/db";
import dayjs from "@hview/dayjs";

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

/*
*
-- create Table if not exists trade_logs(id TEXT PRIMARY KEY UNIQUE,amount DECIMAL, remarks TEXT, cate TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)

-- INSERT INTO trade_logs(id,amount,remarks,cate) VALUES('9b1deb4d-3b7d-4bad-9bdd-2b0d7a3ecb6d',100.95,'吃饭花了很多钱','canyin_expend')

-- SELECT * from trade_logs WHERE created_at < '2024-11-04 23:00:00' -- and created_at<= '2024-11-30'

-- INSERT INTO trade_logs(id,amount,remarks,cate) VALUES('2dd41bab-5f23-4220-aabc-5ba558ac24d1',500,'吞吞吐吐吐','licai_income')

-- 分类统计
SELECT sum(amount) as sum_amount, cate from ( select * from trade_logs WHERE created_at >= '2024-11-01' and created_at<= '2024-11-30' ) GROUP BY cate
*
*
 */

export class HomePageModel {
  incomeMonth: number = 0;
  expandMonth: number = 0;

  todayTradeList: ObservedArray<TodayTrade> = new ObservedArray([])

  loadTodayTrade() {
    // 本月的统计数据
    const monthStart = dayjs().startOf("month").format("YYYY-MM-DD")+" 0:00:00"
    const monthEnd = dayjs().endOf("month").format("YYYY-MM-DD")+" 23:59:59"
    RODTools.getInstance().querySql(`SELECT sum(amount) as sum_amount, cate from ( select * from trade_logs WHERE created_at >= '${monthStart}' and created_at<= '${monthEnd}' ) GROUP BY cate`)
      .then(resultSet=>{
        while (resultSet.goToNextRow()) {
          const cate = resultSet.getString(resultSet.getColumnIndex("cate")) // cate
          const sumAmount = resultSet.getLong(resultSet.getColumnIndex("sum_amount")) // sum_amount
          if(cate.includes("_income")) {
            this.incomeMonth += sumAmount
          } else {
            this.expandMonth += sumAmount
          }
        }
      })

    // 数据库中查询数据
    // 当天开始结束时间
    const todayStart = dayjs().format("YYYY-MM-DD")+" 00:00:00"
    const todayEnd = dayjs().format("YYYY-MM-DD")+" 23:59:59"
    // 查询当天的交易信息
    RODTools.getInstance().querySql(`select * from trade_logs WHERE created_at >= '${todayStart}' and created_at<= '${todayEnd}' order by created_at desc`)
      .then(resultSet=>{
        while (resultSet.goToNextRow()) {
          // 继续
          const id = resultSet.getString(resultSet.getColumnIndex("id")) // id
          const cate = resultSet.getString(resultSet.getColumnIndex("cate")) // cate
          const amount = resultSet.getDouble(resultSet.getColumnIndex("amount")) // camount
          const remarks = resultSet.getString(resultSet.getColumnIndex("remarks")) // remarks
          const date = resultSet.getString(resultSet.getColumnIndex("created_at")) // created_at
          this.todayTradeList.push(new TodayTrade(id, cate, Number(amount), new Date(date), remarks))
        }
      })
    // this.todayTradeList.push(
    //   new TodayTrade("9b1deb4d-3b7d-4bad-9bdd-2b0d7a3ecb6d", "canyin_expend", 16.5, new Date() ,"买早餐花费了这么多，感觉还行"),
    //   new TodayTrade("61f0c679-a8c0-42a1-ab0b-e9627e3acfe0", "chuxing_expend", 230.00, new Date(), "周末旅行交通费"),
    //   new TodayTrade("3e73e9f9-4a11-4f62-8ade-7f3d2c5e0f33", "chuxing_expend", 50.00, new Date(), "手机话费充值"),
    //   new TodayTrade("7d8e9f0a-1b2c-3d4e-5f6a-7b8c9d0e1f2", "licai_income", 250.00, new Date(), "股票分红"),
    // )
  }

  addToTodayTradeList(amount: number, cate: string, remarks: string) {
    // 插入数据

    // this.incomeMonth = this.todayTradeList.filter(item=>item.cate.includes("_income")).reduce((pre, cur) => {
    //   return pre+cur.amount
    // }, 0)
    // this.expandMonth = this.todayTradeList.filter(item=>item.cate.includes("_expend")).reduce((pre, cur) => {
    //   return pre+cur.amount
    // }, 0)

    const id =util.generateRandomUUID()
    RODTools.getInstance().executeSql(`INSERT INTO trade_logs(id,amount,remarks,cate) VALUES('${id}',${amount},'${remarks}','${cate}')`)
      .then(()=>{
        console.log("插入数据成功")
        // 直接修改保存的数据，不重复查询数据库
        this.todayTradeList.unshift(new TodayTrade(util.generateRandomUUID(), cate, amount, new Date(), remarks))
        // 修改统计信息
        this.incomeMonth = this.todayTradeList.filter(item=>item.cate.includes("_income")).reduce((pre, cur) => {
          return pre+cur.amount
        }, 0)
        this.expandMonth = this.todayTradeList.filter(item=>item.cate.includes("_expend")).reduce((pre, cur) => {
          return pre+cur.amount
        }, 0)
      })
      .catch(()=>{
        //
        console.log("插入数据异常")
      })
  }
}