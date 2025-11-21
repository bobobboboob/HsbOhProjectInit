import { Columns, ColumnType, Id } from "@ohos/dataorm";
export class BaseDbItem {
  @Id({ isPrimaryKey: true, autoincrement: true })
  @Columns({ columnName: "id", types: ColumnType.num })
  id: number|null = null;
}