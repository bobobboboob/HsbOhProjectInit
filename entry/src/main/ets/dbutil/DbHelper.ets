import { DaoSession, OpenHelper, Database, DaoMaster, GlobalContext } from "@ohos/dataorm";
import { AnniversaryDao } from "./dao/AnniversaryDao";
import { AnniversaryBean } from "./dbBean/AnniversaryBean";
import { common } from "@kit.AbilityKit";

// -------------------- DbHelper.ts --------------------
export class DbHelper extends OpenHelper {
  private static sInstance: DbHelper;
  private daoSession?: DaoSession;
  private _anniversaryDao?: AnniversaryDao;
  private contextInfo? : common.Context


  private constructor(context: common.Context) {
    super(context, "db_anniversary", "db_anniversary");
    this.contextInfo = context;
  }

  static instance(context: common.Context): DbHelper {
    if (!DbHelper.sInstance) {
      if (!context) {
        throw new Error("DbHelper.instance() 需要先传入 context 才能初始化");
      }
      console.info("提示提示 DbHelper.instance() 创建单例");
      DbHelper.sInstance = new DbHelper(context);
    }
    return DbHelper.sInstance;
  }

  // 数据库升级
  onUpgradeDatabase(db: Database, oldVersion: number, newVersion: number): Promise<void> {
    console.info(`提示提示 DbHelper.onUpgradeDatabase() 从 v${oldVersion} 升级到 v${newVersion}`);
    return Promise.resolve();
  }

  // 数据库降级
  onDowngradeDatabase(db: Database, oldVersion: number, newVersion: number): Promise<void> {
    console.info(`提示提示 DbHelper.onDowngradeDatabase() 从 v${oldVersion} 降级到 v${newVersion}`);
    return Promise.resolve();
  }

  async init(): Promise<void> {
    console.info("提示提示 DbHelper.init() 开始初始化数据库...");

    if (this.daoSession) {
      console.info("提示提示 DbHelper.init() 已初始化，跳过重复初始化");
      return;
    }

    try {
      await this.setVersionAsync(1);
      this.setEntities(AnniversaryBean);

      const db = await this.getWritableDb();
      this.daoSession = new DaoMaster(db).newSession();

      if (!this.daoSession) {
        console.error("提示提示 DbHelper.init() DaoSession 初始化失败");
        return;
      }

      console.info("提示提示 DbHelper.init() DaoSession 初始化成功");

      GlobalContext.getContext().setValue("daoSession", this.daoSession);
      console.info("提示提示 DbHelper.init() DaoSession 已注册到 GlobalContext");
    } catch (err) {
      console.error("提示提示 DbHelper.init() 初始化数据库时出错:", err);
    }
  }

  anniversaryDao(): AnniversaryDao {
    console.info("提示提示 DbHelper.anniversaryDao() 获取 AnniversaryDao");
    if (!this._anniversaryDao) {
      if (!this.daoSession) {
        console.error("提示提示 DbHelper.anniversaryDao() DaoSession 为空，无法创建 Dao");
        throw new Error("DaoSession 未初始化，请先调用 DbHelper.init()");
      }
      this._anniversaryDao = new AnniversaryDao(this.daoSession.getBaseDao(AnniversaryBean)!);
      console.info("提示提示 DbHelper.anniversaryDao() 创建完成");
    }
    return this._anniversaryDao!;
  }
}
