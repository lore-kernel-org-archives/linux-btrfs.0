From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [RFC PATCH 3/4] Btrfs add readonly support for error handle
Date: Fri, 26 Nov 2010 11:23:04 +0800
Message-ID: <4CEF2818.5000009@cn.fujitsu.com>
References: <4CEE3297.4020202@cn.fujitsu.com> <AANLkTinLx_FWgEOG-Lha7HkMX0v=ZKrVOjw4cv0bLx7y@mail.gmail.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Wenyi Liu <qingshenlwy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinLx_FWgEOG-Lha7HkMX0v=ZKrVOjw4cv0bLx7y@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 25 Nov 2010 19:42:53 +0800, Wenyi Liu wrote:
> Hi Xie Miao:
>      I cannot understand the btrfs_decode_error(). why you chose the
> three errnos? what about others? eager for Ur replay. Thanks!!

I think liu chose these three errors is because these errors are familiar ones
that are hard to be dealt with and can not be returned to the user. So...

This is similar to ext4.

Thanks
Miao

>
> ---
> Best Regards,
> Liu Wenyi
>
> 2010/11/25, Miao Xie<miaox@cn.fujitsu.com>:
>> From: Liu Bo<liubo2009@cn.fujitsu.com>
>>
>> This patch provide a new error handle interface for those errors that
>> handled
>>   by current BUG_ONs.
>>
>> In order to protect btrfs from panic, when it comes to those BUG_ON errors,
>> the interface forces btrfs readonly and saves the FS state to disk. And the
>> filesystem can be umounted, although with some warning in kernel dmesg.
>> Then btrfsck is helpful to recover btrfs.
>>
>> Signed-off-by: Liu Bo<liubo2009@cn.fujitsu.com>
>> Signed-off-by: Miao Xie<miaox@cn.fujitsu.com>
>> ---
>>   fs/btrfs/ctree.h |    8 +++++
>>   fs/btrfs/super.c |   88
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 96 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 78b4c34..ccf6aaf 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -2554,6 +2554,14 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char
>> *buffer, size_t size);
>>   /* super.c */
>>   int btrfs_parse_options(struct btrfs_root *root, char *options);
>>   int btrfs_sync_fs(struct super_block *sb, int wait);
>> +void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
>> +		     unsigned int line, int errno);
>> +
>> +#define btrfs_std_error(fs_info, errno)				\
>> +do {								\
>> +	if ((errno))						\
>> +		__btrfs_std_error((fs_info), __func__, __LINE__, (errno));\
>> +} while (0)
>>
>>   /* acl.c */
>>   #ifdef CONFIG_BTRFS_FS_POSIX_ACL
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 8299a25..48fac6e 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -54,6 +54,94 @@
>>
>>   static const struct super_operations btrfs_super_ops;
>>
>> +static const char *btrfs_decode_error(struct btrfs_fs_info *fs_info, int
>> errno,
>> +				      char nbuf[16])
>> +{
>> +	char *errstr = NULL;
>> +
>> +	switch (errno) {
>> +	case -EIO:
>> +		errstr = "IO failure";
>> +		break;
>> +	case -ENOMEM:
>> +		errstr = "Out of memory";
>> +		break;
>> +	case -EROFS:
>> +		errstr = "Readonly filesystem";
>> +		break;
>> +	default:
>> +		if (nbuf) {
>> +			if (snprintf(nbuf, 16, "error %d", -errno)>= 0)
>> +				errstr = nbuf;
>> +		}
>> +		break;
>> +	}
>> +
>> +	return errstr;
>> +}
>> +
>> +static void __save_error_info(struct btrfs_fs_info *fs_info)
>> +{
>> +	struct btrfs_super_block *disk_super =&fs_info->super_copy;
>> +
>> +	fs_info->fs_state = BTRFS_SUPER_FLAG_ERROR;
>> +	disk_super->flags&= cpu_to_le64(~BTRFS_SUPER_FLAG_VALID);
>> +	disk_super->flags |= cpu_to_le64(BTRFS_SUPER_FLAG_ERROR);
>> +
>> +	mutex_lock(&fs_info->trans_mutex);
>> +
>> +	memcpy(&fs_info->super_for_commit, disk_super,
>> +	       sizeof(fs_info->super_for_commit));
>> +
>> +	mutex_unlock(&fs_info->trans_mutex);
>> +}
>> +
>> +static void save_error_info(struct btrfs_fs_info *fs_info)
>> +{
>> +	__save_error_info(fs_info);
>> +	write_ctree_super(NULL, btrfs_sb(fs_info->sb), 0);
>> +}
>> +
>> +/* btrfs handle error by forcing the filesystem readonly */
>> +static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
>> +{
>> +	struct super_block *sb = fs_info->sb;
>> +
>> +	if (sb->s_flags&  MS_RDONLY)
>> +		return;
>> +
>> +	if (fs_info->fs_state&  BTRFS_SUPER_FLAG_ERROR) {
>> +		sb->s_flags |= MS_RDONLY;
>> +		printk(KERN_INFO "btrfs is forced readonly\n");
>> +	}
>> +}
>> +
>> +/*
>> + * __btrfs_std_error decodes expected errors from the caller and
>> + * invokes the approciate error response.
>> + */
>> +void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
>> +		     unsigned int line, int errno)
>> +{
>> +	struct super_block *sb = fs_info->sb;
>> +	char nbuf[16];
>> +	const char *errstr;
>> +
>> +	/*
>> +	 * Special case: if the error is EROFS, and we're already
>> +	 * under MS_RDONLY, then it is safe here.
>> +	 */
>> +	if (errno == -EROFS&&  (sb->s_flags&  MS_RDONLY))
>> +		return;
>> +
>> +	errstr = btrfs_decode_error(fs_info, errno, nbuf);
>> +	printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: %s\n",
>> +		sb->s_id, function, line, errstr);
>> +	save_error_info(fs_info);
>> +
>> +	btrfs_handle_error(fs_info);
>> +}
>> +
>>   static void btrfs_put_super(struct super_block *sb)
>>   {
>>   	struct btrfs_root *root = btrfs_sb(sb);
>> --
>> 1.7.0.1
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

