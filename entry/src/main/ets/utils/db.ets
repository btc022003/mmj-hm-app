import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { BusinessError, request } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

export class RODTools {
  private static _store: relationalStore.RdbStore

  static getInstance() {
    return RODTools._store
  }

  static init(context: common.UIAbilityContext) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'my_naruto.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
      // encrypt: false, // 可选参数，指定数据库是否加密，默认不加密
      // customDir: 'customDir/subCustomDir', // 可选参数，数据库自定义路径。数据库将在如下的目录结构中被创建：context.databaseDir + '/rdb/' + customDir，其中context.databaseDir是应用沙箱对应的路径，'/rdb/'表示创建的是关系型数据库，customDir表示自定义的路径。当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。
      // isReadOnly: false // 可选参数，指定数据库是否以只读方式打开。该参数默认为false，表示数据库可读可写。该参数为true时，只允许从数据库读取数据，不允许对数据库进行写操作，否则会返回错误码801。
    };

    // 判断数据库版本，如果不匹配则需进行升降级操作
    // 假设当前数据库版本为3，表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, IDENTITY)
    const SQL_CREATE_TABLE = 'create Table if not exists trade_logs(id TEXT PRIMARY KEY UNIQUE,amount DECIMAL, remarks TEXT, cate TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)'; // 建表Sql语句, IDENTITY为bigint类型，sql中指定类型为UNLIMITED INT

    relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in getting RdbStore.');

      // 当数据库创建时，数据库默认版本为0
      if (store.version === 0) {
        // executeSql每次只能执行一个sql命名
        store.executeSql(SQL_CREATE_TABLE); // 创建数据表
        // 设置数据库的版本，入参为大于0的整数
        store.version = 3;
      }
      // 传递数据到外面
      RODTools._store = store

      // 如果数据库版本不为0且和当前数据库版本不匹配，需要进行升降级操作
      // 当数据库存在并假定版本为1时，例应用从某一版本升级到当前版本，数据库需要从1版本升级到2版本
      // if (store.version === 1) {
      //   // version = 1：表结构：EMPLOYEE (NAME, SALARY, CODES, ADDRESS) => version = 2：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS)
      //   if (store !== undefined) {
      //     (store as relationalStore.RdbStore).executeSql('ALTER TABLE EMPLOYEE ADD COLUMN AGE INTEGER');
      //     store.version = 2;
      //   }
      // }

      // 当数据库存在并假定版本为2时，例应用从某一版本升级到当前版本，数据库需要从2版本升级到3版本
      // if (store.version === 2) {
      //   // version = 2：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS) => version = 3：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES)
      //   if (store !== undefined) {
      //     (store as relationalStore.RdbStore).executeSql('ALTER TABLE EMPLOYEE DROP COLUMN ADDRESS TEXT');
      //     store.version = 3;
      //   }
      // }
    });
  }
}

/**
 * 恢复数据库
 */
export function restoreMyDb(context: common.UIAbilityContext) {
  //
  // 我从网上下载我的数据库文件
  // 然后进行恢复
  let dbPath = context.cacheDir+"/naruto_back.db"
  request.downloadFile(context, {
    url: 'http://192.168.14.70:3303/naruto.db', // 数据库文件的地址
    filePath: dbPath, // 下载之后数据库文件的存放路径
  })
    .then(res => {
      res.on("complete", () => {
        console.log("下载数据库文件成功")
        RODTools.getInstance().restore(dbPath, (err: BusinessError) => {
          if (err) {
            console.log(err.message)
          }
          console.log("恢复数据成功")
          promptAction.showToast({ message: "恢复数据成功" })
        })
      })
    })
}