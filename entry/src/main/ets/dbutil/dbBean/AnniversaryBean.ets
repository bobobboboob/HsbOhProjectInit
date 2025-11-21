import { Columns, ColumnType, Entity } from "@ohos/dataorm";
import { BaseDbItem } from "./BaseDbItem";

@Entity("AnniversaryBean")
export class AnniversaryBean extends BaseDbItem {
  @Columns({ columnName: "TITLE", types: ColumnType.str })
  title: string;
  @Columns({ columnName: "TIME", types: ColumnType.str })
  time: string;
  @Columns({ columnName: "BGCOLOR", types: ColumnType.str })
  bgColor: string;
  @Columns({ columnName: "IMG", types: ColumnType.str })
  img: string;
  @Columns({ columnName: "CREATETIME", types: ColumnType.str })
  creatTime: string;
  @Columns({ columnName: "TEMP", types: ColumnType.str })
  temp: string;
  @Columns({ columnName: "DAYNUM", types: ColumnType.num })
  dayNum: number;

  constructor(title: string, time: string, bgColor: string, img: string, creatTime: string) {
    super();
    this.title = title;
    this.time = time;
    this.bgColor = bgColor;
    this.img = img;
    this.creatTime = creatTime;
    this.temp = '';
    this.dayNum = 0;
  }
}


