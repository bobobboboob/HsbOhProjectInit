import { BaseDao } from '@ohos/dataorm';
import { AnniversaryBean } from '../dbBean/AnniversaryBean';
import { UIContext } from '@kit.ArkUI';


// -------------------- AnniversaryDao.ts --------------------
export class AnniversaryDao {
  private dao: BaseDao<AnniversaryBean, number>;

  constructor(dao: BaseDao<AnniversaryBean, number>) {
    this.dao = dao;
  }

  async addData(data: AnniversaryBean): Promise<void> {
    console.info("提示提示 AnniversaryDao.addData() 开始插入数据");
    if (!this.dao) {
      console.error("提示提示 AnniversaryDao.addData() dao 未初始化");
      return;
    }
    try {
      await this.dao.insert(data);
      console.info("提示提示 AnniversaryDao.addData() 插入成功");
    } catch (err) {
      console.error("提示提示 AnniversaryDao.addData() 插入失败:", err);
    }
  }

  async getAll(): Promise<Array<AnniversaryBean>> {
    console.info("提示提示 AnniversaryDao.getAll() 开始加载数据");
    try {
      const list = await this.dao.loadAll();
      console.info(`提示提示 AnniversaryDao.getAll() 加载完成，共 ${list.length} 条`);
      return list;
    } catch (err) {
      console.error("提示提示 AnniversaryDao.getAll() 加载失败:", err);
      return [];
    }
  }

  async delBean(data: AnniversaryBean): Promise<void> {
    console.info("提示提示 AnniversaryDao.delBean() 开始删除数据");
    if (!this.dao) {
      console.error("提示提示 AnniversaryDao.delBean() dao 未初始化");
      return;
    }
    try {
      await this.dao.deleteAsync(data);
      console.info("提示提示 AnniversaryDao.delBean() 删除成功");
    } catch (err) {
      console.error("提示提示 AnniversaryDao.delBean() 删除失败:", err);
    }
  }

  async updataBean(data: AnniversaryBean): Promise<void> {
    console.info("提示提示 AnniversaryDao.updataBean() 开始更新数据");
    if (!this.dao) {
      console.error("提示提示 AnniversaryDao.updataBean() dao 未初始化");
      return;
    }
    try {
      await this.dao.updateAsync(data);
      console.info("提示提示 AnniversaryDao.updataBean() 更新成功");
    } catch (err) {
      console.error("提示提示 AnniversaryDao.updataBean() 更新失败:", err);
    }
  }
}
