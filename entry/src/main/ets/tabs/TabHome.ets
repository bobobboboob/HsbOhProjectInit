import { page_text1 } from "../pages/test1"
import { systemShare } from "@kit.ShareKit";
import { common } from "@kit.AbilityKit";
import { uniformTypeDescriptor } from "@kit.ArkData";

@Component
export struct TabHome {
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

  build() {
    Column() {
      Text("这是首页")
      Button("跳去二级页面")
        .margin({ top: 10 })
        .onClick(()=>{
          this.queryNavigationInfo()?.pathStack.pushDestinationByName(page_text1, undefined)
        })
    }
  }
}