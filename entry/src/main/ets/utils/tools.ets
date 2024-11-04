import { rcp } from '@kit.RemoteCommunicationKit'
import { preferences } from '@kit.ArkData'
import { common } from '@kit.AbilityKit'
import { picker } from '@kit.CoreFileKit'
import fs from '@ohos.file.fs';
import { promptAction } from '@kit.ArkUI'
import dayjs from "@hview/dayjs";

/**
 * 服务器地址
 */
export const serverURL: string = "http://192.168.14.70:1337"

/**
 * 处理图片地址
 * @param url
 * @returns
 */
export function dalImage(url: string) {
  if(url) {
    if(url.startsWith("http")) return url
    return serverURL + url
  }
  return 'http://gips0.baidu.com/it/u=3602773692,1512483864&fm=3028&app=3028&f=JPEG&fmt=auto?w=960&h=1280'
}

export interface DayMonthRange {
  dayStart: string;
  dayEnd: string;
  monthStart: string;
  monthEnd: string
}

/**
 * 获取当天和当月的时间边界
 * @returns
 */
export function getDayMonthRange(): DayMonthRange {
  return {
    dayStart: dayjs().format("YYYY-MM-DD")+" 00:00:00",
    dayEnd: dayjs().format("YYYY-MM-DD")+" 23:59:59",
    monthStart: dayjs().startOf("month").format("YYYY-MM-DD")+" 0:00:00",
    monthEnd: dayjs().endOf("month").format("YYYY-MM-DD")+" 23:59:59"
  }
}

/**
 * 处理富文本内容，返回一个字符串组成的数组
 * @param htmlString
 * @returns
 */
export function extractImgSrc(htmlString: string) {
  // 正则表达式匹配<img>标签中的src属性
  const imgSrcRegex = /<img [^>]*src="([^"]+)"[^>]*>/g;
  let match: RegExpExecArray | null;
  const srcs: string[] = [];

  // 使用正则表达式全局匹配所有src属性
  while ((match = imgSrcRegex.exec(htmlString)) !== null) {
    // 将匹配的src属性值添加到数组中
    srcs.push(match[1]);
  }

  return srcs;
}

/**
 * 文件上传
 * @param context 上下文
 * @param cb 返回一个结果
 */
export function uploadFile(context: common.UIAbilityContext, cb: (str: string) => void) {
  let myPicker = new picker.DocumentViewPicker() // 文件选择
  // select 选择文件
  // 弹出一个选择框
  myPicker.select({

  }).then(res=> {
    // this.imgSrc = res[0] // 获取到选择的结果，是一个数组
    // res 是一个数组，这个数组中包含了我们选择的文件的路径信息
    // 此处会涉及到系统的文件权限问题
    // 系统中的文件可以分为以下几类
    // - 系统文件
    // - 用户文件
    // - app的文件
    // 文件安全沙箱，我们需要把对应的文件进行一些处理之后，存放在可以被app访问的位置进行操作，这就是安全沙箱
    // fs https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/app-file-V5
    // picker https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-file-picker-V5

    // 文件上传
    // 我们使用rcp传递一个formdata数据

    // 把用户的文件存储在app的临时目录中
    // 需要先获取临时目录
    // context.cacheDir // 缓存目录
    // 我的目标地址
    const file = fs.openSync(res[0]) // 需要打开选择的文件
    // 每一个file都有一个fd属性，这个是文件的唯一值，我们以后操作文件的话可以使用这个fd
    const destPath = context.cacheDir + "/avatar.jpg"
    fs.copyFileSync(file.fd, destPath) // 文件复制
    const session = rcp.createSession()
    const formData = new rcp.MultipartForm({
      "file": {
        contentType: 'image/png', // 文件类型, 设置文件为图片
        contentOrPath: destPath // 地址或者内容
      }
    })
    session.post(serverURL+'/api/v1/common/upload_file', formData)
      .then(res=>{
        console.log("文件上传成功")
        const data = res.toJSON()!['data'] as string
        cb(data)
      })
  })
}

// 自定义拦截器
class MyIntercept implements rcp.Interceptor {
  intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    // throw new Error('Method not implemented.')
    context.request.headers!['token'] = PreferencesStorage.get('token') // 请求头中的token，这个值是你们公司服务器端接口提供的
    const promise = next.handle(context)

    // 这里弹loading
    // promptAction.

    // 这里捕获到的是网络异常
    promise.catch((err: Error)=>{
      // 处理异常
      // 删除loading
      console.log(err.message)
      promptAction.showToast({
        message: '网络异常！！！'
      })
    })

    // promise.then(()=>)

    return promise// 返回结果
  }
}

export class HttpRequest {
  private static _session: rcp.Session

  private static getInstance() {
    if(HttpRequest._session == null) {
      HttpRequest._session = rcp.createSession({
        baseAddress: serverURL,
        interceptors: [new MyIntercept()], // 拦截器
        requestConfiguration: {
          transfer: {
            // 设置超时时间
            timeout: {
              connectMs: 5000, // 连接时间
              transferMs: 5000 // 传输时间
            }
          }
        }
      })
    }
    return HttpRequest._session
  }

  static get(url: string) {
    return HttpRequest.getInstance().get(url).then(res => {
      // 删除loading
      // 只要服务器返回内容都走成功，我们需要对状态码做处理
      if(res.statusCode == 401) {
        promptAction.showToast({
          message: '请先登录'
        })
        return null
      }
      return res.toJSON()
    })
  }

  static post(url: string, data: Object) {
    return HttpRequest.getInstance().post(url, data).then(res => {
      if(res.statusCode == 401) {
        promptAction.showToast({
          message: '请先登录'
        })
        return null
      }
      return res.toJSON()
    })
  }
}

/**
 * 用户首选项操作
 */
export class PreferencesStorage {
  static dataPreferences: preferences.Preferences | null = null;
  // 初始化函数
  static init(context: common.UIAbilityContext) {
    let options: preferences.Options = { name: 'myStore' };
    PreferencesStorage.dataPreferences = preferences.getPreferencesSync(context, options);
  }

  /**
   * 设置本地首选项存储
   * @param name
   * @param value
   */
  static set(name: string, value: string) {
    PreferencesStorage.dataPreferences?.putSync(name, value)
    // .flush作用是存本地
    PreferencesStorage.dataPreferences?.flush(err=>{
      console.log("本地首选项存储失败")
    })
  }

  /**
   * 读取本地首选项存储
   * @param name
   * @returns
   */
  static get(name: string) {
    return PreferencesStorage.dataPreferences?.getSync(name, '') as string
  }

  /**
   * 删除本地存储
   * @param name
   */
  static del(name: string) {
    PreferencesStorage.dataPreferences?.deleteSync(name)
    // 删除之后需要重新存本次操作一次
    PreferencesStorage.dataPreferences?.flush(err=>{
      console.log("本地首选项存储失败")
    })
  }
}