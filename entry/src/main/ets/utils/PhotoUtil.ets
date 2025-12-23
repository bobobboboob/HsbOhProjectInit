import { componentSnapshot } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'
import fileIo from '@ohos.file.fs'
import { fileUri } from '@kit.CoreFileKit'

/**
 * 图片工具类 - 参考 oh-lytcamera 项目实现
 */
export class PhotoUtil {
  /**
   * 截图指定组件
   * @param id 组件id
   * @param scale 缩放比例，默认2倍以获得更高清晰度
   * @returns PixelMap | null
   */
  static screenshotImage(id: string, scale: number = 2): image.PixelMap | null {
    try {
      console.info(`PhotoUtil: 开始截图，ID: ${id}, scale: ${scale}`)
      const pixelMap = componentSnapshot.getSync(id, { scale: scale, waitUntilRenderFinished: true })
      if (pixelMap) {
        console.info(`PhotoUtil: 截图成功，ID: ${id}`)
      } else {
        console.error(`PhotoUtil: 截图返回null，ID: ${id}`)
      }
      return pixelMap
    } catch (error) {
      console.error(`PhotoUtil: 截图失败，ID: ${id}, 错误:`, JSON.stringify(error))
      return null
    }
  }

  /**
   * 保存图片到相册
   * @param pixelMap 图片数据
   * @param editType 编辑类型，用于保存记录
   */
  static async writePhoto(pixelMap: image.PixelMap , context : Context) {
    try {

      // 先保存到相册
      ImageUtil.savePixelMap2SysGallery(pixelMap)

      console.info('PhotoUtil: 保存到相册成功')
      
      // 注意：editType 可能是 0（CUT），所以不能用 if(editType)，要用 !== undefined
      if (editType !== undefined) {
        // 保存记录需要URI，保存到应用沙箱的filesDir（不是tempDir）
        const uniqueFileName = `image_${Date.now()}.png`
        const path = `${context.filesDir}/${uniqueFileName}`
        console.info(`PhotoUtil: 保存到沙箱, path: ${path}`)
        
        const imgBuffer = await PhotoUtil.transferPixelMap2Buffer(pixelMap)
        console.info(`PhotoUtil: 图片转换完成, buffer size: ${imgBuffer.byteLength}`)
        
        const file = fileIo.openSync(path, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
        await fileIo.write(file.fd, imgBuffer)
        await fileIo.close(file.fd)
        
        const uri = fileUri.getUriFromPath(path)
        console.info(`PhotoUtil: 文件保存成功, URI: ${uri}`)
        
        await RecordStorage.saveRecord(uri, editType)
        console.info(`PhotoUtil: 保存记录成功, URI: ${uri}, Type: ${editType}`)
      } else {
        console.info('PhotoUtil: editType 为 undefined，跳过保存记录')
      }
    } catch (error) {
      console.error('PhotoUtil: 保存图片到相册失败:', JSON.stringify(error))
    }
  }

  /**
   * 保存到应用沙箱（从PixelMap）
   */
  static async addUri(pix: image.PixelMap, isTemp: boolean = false) {
    try {
      const uniqueFileName = `image_${Date.now()}.png`
      const path = `${isTemp ? AppUtil.getContext().tempDir : AppUtil.getContext().filesDir}/${uniqueFileName}`
      const imgBuffer = await PhotoUtil.transferPixelMap2Buffer(pix)
      const file = fileIo.openSync(path, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
      await fileIo.write(file.fd, imgBuffer)
      await fileIo.close(file.fd)
      // 保存记录
      await RecordStorage.saveRecord(fileUri.getUriFromPath(path), EditFunctionType.ROTATE)
    } catch (error) {
      console.error('Error saving image:', error)
    }
  }

  /**
   * 将 PixelMap 转为图片格式
   */
  static transferPixelMap2Buffer(pixelMap: image.PixelMap): Promise<ArrayBuffer> {
    return new Promise((resolve, reject) => {
      try {
        const packOpts: image.PackingOption = { format: 'image/jpeg', quality: 98 }
        const imagePackerApi = image.createImagePacker()
        imagePackerApi
          .packing(pixelMap, packOpts)
          .then((buffer: ArrayBuffer) => {
            resolve(buffer)
          })
      } catch (error) {
        reject(error)
      }
    })
  }
}

