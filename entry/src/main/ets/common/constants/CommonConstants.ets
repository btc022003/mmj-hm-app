// 交易类型
export class TradeType {
  id: string;
  name: string;
  remarks: string;
  value: string; // xx_income(收入) xx_expend(支出)

  constructor(id: string, name: string, value: string, remarks = "") {
    this.id = id;
    this.name = name;
    this.value = value;
    this.remarks = remarks;
  }
}

export class CommonConstants {
  static readonly PRIMARY_COLOR: string = '#000';

  static readonly SECONDARY_COLOR: string = "#4b5563"

  static readonly DISABLED_COLOR: string = '#999999'

  static readonly FONT_SIZE_XL: number = 24;

  static readonly FONT_SIZE_MD: number = 16;

  static readonly FONT_SIZE_SM: number = 12;

  // 交易类型数据
  static readonly TRADE_TYPES = [
    new TradeType("d0eaf567-d0af-46e4-a286-9dabdb67c3bb", "餐饮", "canyin_expend", ""),
    new TradeType("0e14a579-c12f-4cc4-b0c1-a623606a7055", "出行", "chuxing_expend", ""),
    new TradeType("c355eccf-47ab-4eb5-8881-2b3fd07ce0ac", "通信", "tongxin_expend", ""),
    new TradeType("1dc5c741-88f9-47a5-bc57-9cdcc4f40ee6", "网购", "wanggou_expend", ""),
    new TradeType("58504a52-9b53-4ae7-be1c-550c9991ed0e", "其他", "qita_expend", ""),
    new TradeType("a2cd8d96-f664-4d49-9e40-4a8f55d9a6fd", "薪资", "xinzi_income", ""),
    new TradeType("05374dcb-6481-454b-8073-56ce4f07fe8f", "理财", "licai_income", ""),
    new TradeType("f9e3140c-5bc5-46ed-8329-39594217a75c", "其他", "qita_income", ""),
  ]
}
