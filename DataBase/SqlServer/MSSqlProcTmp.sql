/*<��д���ܵ�����>
���� : 
�޸�����		�޸���		����
--------------------------------------------------------------------------------------------------------------
20200502		ligy		create

set quoted_identifier off
*/
--sp_�������_���� system,system
if OBJECT_ID('sp_�������_����') is not null
drop proc sp_�������_����
go
create proc sp_�������_����
( 
 @UserCode varchar(20)			 --�û�����
,@UserName nvarchar(50)			 --�û�����
,@NeedTrans bit =1				 --�Ƿ��ڱ�sp�п�������,����ⲿ�Ѿ�����,�ڲ���������
,@RtnTblResult bit =1			 --sp����󷵻�һ��fok,fmsgָʾ���̵ĳɹ�/ʧ��
,@Debug bit =0					 --�Ƿ���DEBUG
,@Success bit = 0 output		 --���������,ָʾ������ִ�гɹ���
,@Msg nvarchar(2000) = '' output --���������,���ر�����ִ�н����Ϣ
)
as
begin

	set nocount on

	select @Success=0,@Msg=''

	declare @Trans1 int , @Trans2 int
	if @@TRANCOUNT>0 select @NeedTrans=0 -- ����Ѿ�������֮��,���ؿ�������

	if @NeedTrans = 1 --�����Ҫ��������
		begin tran

		select @Trans1 = @@TRANCOUNT

			begin try
/*****************************************�淶*****************************************************/
		/*    A.��������:  1.������ʱ�������������ĳ�ͻ,������Ҫ��������
						  2.���������Ƿ�������
						  3.�����������ֲ���
						  4.Union all ���ܳ���2���Ӳ�ѯ
						  5.����ʹ�ú���
						  6.����ʹ������ת��
						  7.������ֶβ�Ϊnull,��Ҫʹ��isnull����
						  8.���÷��� group by
		      B.��������: 1.null������λ,��null���null֮������ʼ��Ϊnull
						2.�����ֶδ���
						3.����������ȫ���������ظ�/����
						4.���ݹ���
						5.��ѯδ�� with(nolocak)   */

						  

/***************************************ʵ��ҵ���߼�**************************************************/
					select @Msg='������ʾ' --ÿһ������ǰ,�ȼٶ�����
					--insert into ........


					goto Success
			end try

			begin catch
				select @Msg=@Msg+CHAR(13)+CHAR(10)
					+'sp'+Coalesce(Error_Procedure(),object_name(@@procid),'')+CHAR(13)+CHAR(10)
					+'line' +convert(varchar(10),error_line())+CHAR(13)+CHAR(10)
					+'msg'+error_message()
				goto Rtn --��׽���
			end catch


	Success:
	select @Success=1 ,@Msg='�ɹ���Ϣ'
	goto Rtn

	Rtn:
	Select @Trans2=@@TRANCOUNT

	if @NeedTrans=1
	begin
		--�ɹ�			����ʼ�ͽ�������һ��	�������������				
		if @Success=1 and @Trans1=@Trans2 and @Trans2>0 
		begin
			commit tran
		end

		else if @Trans2>0
		begin
			rollback tran
		end
	end

	if @RtnTblResult=1
	begin
		select fok=@Success,fmsg=@Msg
	end

end;