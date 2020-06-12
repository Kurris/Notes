### C# DataGridView控件
>绑定DataTable

- 按钮删除dgv的选中行数据
```C#
                if (MainDgv.DataSource != null 
            && (MainDgv.DataSource as DataTable).Rows.Count == 0)
                {
                    Msg.ShowInfo("当前没有可删除的数据!");
                    return;
                }
                var rows = MainDgv.SelectedRows;
                if (rows != null && rows.Count > 0)
                {
                    var row = rows[0].DataBoundItem as DataRowView;
                    int iIndex = MainDgv.CurrentRow.Index;

                    row.Delete();

                    if (MainDgv.RowCount == iIndex && MainDgv.RowCount != 0)
                    {
                        int rowIndex = iIndex - 1;
                        MainDgv.Rows[rowIndex].Selected = true;
                    }
                    else if (MainDgv.RowCount == 0)
                    {
                        tsDelete.Enabled = false;
                    }
                }
                else
                {
                    Msg.ShowInfo("请选择需要删除的行数据!");
                    return;
                }
```