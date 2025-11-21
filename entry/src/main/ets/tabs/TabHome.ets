import { page_text1 } from "../pages/test1"
import { systemShare } from "@kit.ShareKit";
import { common } from "@kit.AbilityKit";
import { uniformTypeDescriptor } from "@kit.ArkData";
import { fileUri } from "@kit.CoreFileKit";

@ObservedV2
export class FileInfo {
  @Trace name: string = ''
  @Trace info: string = ''
  @Trace uri: string = ''
  @Trace imgType: number = 0
}

@ComponentV2
export struct TabHome {
  @Local selList: FileInfo[] = []
  @Local selBean: FileInfo[] = []

  build() {
    Column() {
      Text("这是首页")
      Button("跳去二级页面")
        .margin({ top: 10 })
        .onClick(() => {
          this.queryNavigationInfo()?.pathStack.pushDestinationByName(page_text1, undefined)
        })
    }
  }

  //分享链接
  private async share() {
    // 生成应用图标缩略图
    let uiContext: UIContext = this.getUIContext();
    // 构造ShareData，需配置一条有效数据信息
    let shareData: systemShare.SharedData = new systemShare.SharedData({
      utd: uniformTypeDescriptor.UniformDataType.HYPERLINK,
      // App Linking链接 仅为示例
      content: "www.baidu.com",
      title: '', // 不传title时 显示链接
      description: '', // 不传则不显示描述内容
    });
    // 进行分享面板显示
    let controller: systemShare.ShareController = new systemShare.ShareController(shareData);
    let context: common.UIAbilityContext = uiContext.getHostContext() as common.UIAbilityContext;
    controller.show(context, {
      previewMode: systemShare.SharePreviewMode.DEFAULT,
      selectionMode: systemShare.SelectionMode.SINGLE
    }).then(() => {
      console.info('ShareController show success.');
    }).catch((error: string) => {
      console.error(`ShareController show error. code: ${error}, message: ${error}`);
    });
  }

  //分析多图
  async shareImages() {
    let sandUri: string[] = []
    try {
      // 第一个 record 必须传入构造函数
      let firstRecord: systemShare.SharedRecord = {
        utd: uniformTypeDescriptor.UniformDataType.IMAGE,
        uri: fileUri.getUriFromPath(sandUri[0])   // 第一张图片
      };

      let shareData = new systemShare.SharedData(firstRecord);

      // 其它图片追加 record
      for (let i = 1; i < sandUri.length; i++) {
        shareData.addRecord({
          utd: uniformTypeDescriptor.UniformDataType.IMAGE,
          uri: fileUri.getUriFromPath(sandUri[i])
        });
      }

      // 显示分享
      let controller = new systemShare.ShareController(shareData);
      await controller.show(this.getUIContext().getHostContext() as common.UIAbilityContext, {
        selectionMode: systemShare.SelectionMode.BATCH,
        previewMode: systemShare.SharePreviewMode.DETAIL
      });

      this.getUIContext().getPromptAction().showToast({ message: "分享成功" })
    } catch (e) {
      console.error('分享失败:', e);
      this.getUIContext().getPromptAction().showToast({ message: "分享失败" })
    }
  }

  async shareVedios() {
    let vedioPaths: string[] = []
    if (!vedioPaths || vedioPaths.length === 0) {
      this.getUIContext().getPromptAction().showToast({ message: "未选中视频" })
      return;
    }

    try {
      // 第一个 record 必须放到构造函数中
      const firstRecord: systemShare.SharedRecord = {
        utd: uniformTypeDescriptor.UniformDataType.VIDEO,
        uri: fileUri.getUriFromPath(vedioPaths[0])
      };

      const shareData = new systemShare.SharedData(firstRecord);

      // 添加后续的视频
      for (let i = 1; i < vedioPaths.length; i++) {
        shareData.addRecord({
          utd: uniformTypeDescriptor.UniformDataType.VIDEO,
          uri: fileUri.getUriFromPath(vedioPaths[i])
        });
      }

      // 调用分享控制器
      const controller = new systemShare.ShareController(shareData);
      await controller.show(this.getUIContext().getHostContext() as common.UIAbilityContext, {
        selectionMode: systemShare.SelectionMode.BATCH,
        previewMode: systemShare.SharePreviewMode.DETAIL
      });

      this.getUIContext().getPromptAction().showToast({ message: "分享成功" })
    } catch (e) {
      console.error('分享失败:', e);
      this.getUIContext().getPromptAction().showToast({ message: "分享失败" })
    }
  }

  async shareAudios(): Promise<void> {
    const list = this.selList;

    if (!list || list.length === 0) {
      this.getUIContext().getPromptAction().showToast({ message: "未选中音频" })
      return;
    }

    try {
      // 第 1 条 audio 构造 SharedData
      const first = list[0];
      const firstRecord: systemShare.SharedRecord = {
        utd: uniformTypeDescriptor.UniformDataType.MEDIA,
        uri: fileUri.getUriFromPath(first.uri),
        content: first.name,
      };
      const shareData: systemShare.SharedData = new systemShare.SharedData(firstRecord);

      // 追加其余音频
      for (let i = 1; i < list.length; i++) {
        const bean = list[i];
        const realPath = bean.uri

        const record: systemShare.SharedRecord = {
          utd: uniformTypeDescriptor.UniformDataType.MEDIA,
          uri: fileUri.getUriFromPath(realPath),
          content: bean.name,
        };
        shareData.addRecord(record);
      }

      const context = this.getUIContext().getHostContext() as common.UIAbilityContext;

      // ShareController
      const controller = new systemShare.ShareController(shareData);

      await controller.show(context, {
        selectionMode: systemShare.SelectionMode.BATCH,
        previewMode: systemShare.SharePreviewMode.DETAIL,
      });

      this.getUIContext().getPromptAction().showToast({ message: "分享成功" })

    } catch (error) {
      console.error(`分享失败 code:${error.code}, msg:${error.message}`);
      this.getUIContext().getPromptAction().showToast({ message: "分享失败" })

    }
  }

  async shareFiles() {
    if (!this.selBean.length) {
      this.getUIContext().getPromptAction().showToast({ message: "未选中文件" })
      return
    }

    try {
      const shareData = this.getFileShareData()

      const controller = new systemShare.ShareController(shareData)

      await controller.show(this.getUIContext().getHostContext() as common.UIAbilityContext, {
        selectionMode: systemShare.SelectionMode.BATCH,
        previewMode: systemShare.SharePreviewMode.DETAIL
      })

      this.getUIContext().getPromptAction().showToast({ message: "分享成功" })

    } catch (err) {
      console.error("shareFiles error:", err)
      this.getUIContext().getPromptAction().showToast({ message: "分享失败" })
    }
  }

  private getFileShareData(): systemShare.SharedData {
    const firstRecord = this.getShareRecord(this.selBean[0])
    const shareData = new systemShare.SharedData(firstRecord)

    try {
      for (let i = 1; i < this.selBean.length; i++) {
        const record = this.getShareRecord(this.selBean[i])
        shareData.addRecord(record)
      }
    } catch (err) {
      console.error(`addRecord error`)
    }

    return shareData
  }

  private getShareRecord(data: FileInfo): systemShare.SharedRecord {
    let suffix = "." + data.name.split(".").pop()

    // 自动从后缀解析 UTD
    let utd = uniformTypeDescriptor.getUniformDataTypeByFilenameExtension(suffix)

    console.info(`分享文件：${data.name} -> utd=${utd}`)

    return {
      utd: utd,
      uri: fileUri.getUriFromPath(data.uri), // 本地路径转 uri（必须）
      title: data.name,
      description: data.info,
      thumbnailUri: undefined   // 如需缩略图可添加
    }
  }

}