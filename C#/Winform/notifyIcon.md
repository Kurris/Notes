### C# WinForm---Notifyicon
>notifyicon是winform程序显示在任务栏右下角的小图标,可以使用右键菜单,可以有提醒气泡

* **定义`NotifyIcon` ,`ContextMenuStrip`对象**
```C#
private NotifyIcon _mnotifyIcon;
private ContextMenuStrip _mmenuStrip;
```
<u>如果不存在component,如果先初始化该对象</u>
```C#
if (components==null)
 {
components= new Container();
}
```
* 初始化ContextMenuStrip对象到this.components中
```C#
_mmenuStrip = new ContextMenuStrip(this.components);
```
添加右键菜单选项
```C#
_mmenuStrip.Items.Add(new ToolStripMenuItem("Exit"));
```
* 初始化`NotifyIcon`对象到this.components中
* 将`ContextMenuStrip`对象赋予`NotifyIcon`的<u>ContextMenuStrip</u>对象中;
* 并且在程序打开的时候隐藏起来
* 给Icon赋予指定的图片
**注意: 如果不赋予Icon,右下角小图标不会显示**
```C#
_mnotifyIcon = new NotifyIcon(this.components);
_mnotifyIcon.ContextMenuStrip = _mmenuStrip;
_mnotifyIcon.Text = "notify";
_mnotifyIcon.Visible = false;
_mnotifyIcon.Icon = new Icon(@"F:\Ligy Git Code\MVCLearn\favicon.ico");
```

* 在窗体最小化的时候/关闭的时候提醒
* NotifyIcon对象显示
* 窗体程序不显示在任务栏中
* 最后隐藏整个窗体程序
```C#
this.SizeChanged += (s, e) =>
            {
                if (this.WindowState == FormWindowState.Minimized)
                {
                    _mnotifyIcon.Visible = true;
                    this.ShowInTaskbar = false;
                    this.Hide();
                }
            };
```

* 当点击该NotifyIcon对象的时候
* NotifyIcon隐藏
* 窗体的大小状态为正常
```C#
_mnotifyIcon.MouseClick += (s, e) =>
            {
                if (e.Button == MouseButtons.Left)
                {
                    this.Visible = true;
                    this.WindowState = FormWindowState.Normal;
                }
            };
```