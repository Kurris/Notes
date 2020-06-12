### C# WCF框架---事务
>TranscationScope是.net中的一个事务类--->System.Transcations
>WCF中的事务和TranscationScope做了集成
>TranscationScope内部使用了ThreadStaticAttribute原理

该事务的配置方式需要使用TransactionOptions 

依赖于Windows服务的distribute Transcation Coordinator 

在WCF服务中,方法特性改为OperationBehavior
其中的

`TranscationSocapeRequired=true` 使用事务
`TranscationAutoComplete=true` 自动提交事务

回滚事务
`Transcation.Current.RollBack();`

手工提交事务
`OperationContext.Current.SetTranscationComplete(); `