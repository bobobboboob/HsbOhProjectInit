import { AnniversaryBean } from "./dbBean/AnniversaryBean";
import { DbHelper } from "./DbHelper";
import { common } from "@kit.AbilityKit";

@ObservedV2
export class DataService {
  private static sInstance: DataService | null = null;

  @Trace anniList: Array<AnniversaryBean> = [];
  private context?: common.Context;

  private constructor() {
    // 禁止外部 new
  }

  static instance(): DataService {
    if (!DataService.sInstance) {
      DataService.sInstance = new DataService();
    }
    return DataService.sInstance;
  }

  /**
   * 必须先初始化 context
   */
  init(context: common.Context) {
    this.context = context;
  }

  private checkContext(): common.Context {
    if (!this.context) {
      throw new Error("DataService 未初始化，请先调用 DataService.instance().init(context)");
    }
    return this.context;
  }

  async initializeData(): Promise<void> {
    const ctx = this.checkContext();

    try {
      await DbHelper.instance(ctx).init();
      await this.loadData();
    } catch (error) {
      console.error("DataService.initializeData() 错误:", error);
    }
  }

  async loadData(): Promise<void> {
    const ctx = this.checkContext();

    try {
      const dao = DbHelper.instance(ctx).anniversaryDao();
      this.anniList = await dao.getAll();
    } catch (error) {
      console.error("DataService.loadData() 错误:", error);
    }
  }

  async delData(bean: AnniversaryBean) {
    const ctx = this.checkContext();
    await DbHelper.instance(ctx).anniversaryDao().delBean(bean);
    await this.loadData();
  }

  async updata(bean: AnniversaryBean) {
    const ctx = this.checkContext();
    await DbHelper.instance(ctx).anniversaryDao().updataBean(bean);
    await this.loadData();
  }
}
