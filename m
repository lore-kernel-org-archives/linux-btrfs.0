Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:62271 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbbA3Azg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 19:55:36 -0500
Message-ID: <54CAD5DC.2060603@huawei.com>
Date: Fri, 30 Jan 2015 08:52:44 +0800
From: Miao Xie <miaoxie@huawei.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH RESEND v4 6/8] vfs: Add get_vfsmount_sb() function to
 get vfsmount from a given sb.
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com> <1422498281-20493-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422498281-20493-7-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="gbk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 29 Jan 2015 10:24:39 +0800, Qu Wenruo wrote:
> There are sysfs interfaces in some fs, only btrfs yet, which will modify
> on-disk data.
> Unlike normal file operation routine we can use mnt_want_write_file() to
> protect the operation, change through sysfs won't to be binded to any file
> in the filesystem.
> So we can only extract the first vfsmount of a superblock and pass it to
> mnt_want_write() to do the protection.

This method is wrong, becasue one fs  may be mounted on the multi places
at the same time, someone is R/O, someone is R/W, you may get a R/O and
fail to get the write permission.

I think you do label/feature change by sysfs interface by the following way

btrfs_sysfs_change_XXXX()
{
	/* Use trylock to avoid the race with umount */
	if(!mutex_trylock(&sb->s_umount))
		return -EBUSY;

	check R/O and FREEZE

	mutex_unlock(&sb->s_umount);
}

Thanks
Miao

> 
> Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/namespace.c        | 25 +++++++++++++++++++++++++
>  include/linux/mount.h |  1 +
>  2 files changed, 26 insertions(+)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index cd1e968..5a16a62 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1105,6 +1105,31 @@ struct vfsmount *mntget(struct vfsmount *mnt)
>  }
>  EXPORT_SYMBOL(mntget);
>  
> +/*
> + * get a vfsmount from a given sb
> + *
> + * This is especially used for case where change fs' sysfs interface
> + * will lead to a write, e.g. Change label through sysfs in btrfs.
> + * So vfs can get a vfsmount and then use mnt_want_write() to protect.
> + */
> +struct vfsmount *get_vfsmount_sb(struct super_block *sb)
> +{
> +	struct vfsmount *ret_vfs = NULL;
> +	struct mount *mnt;
> +	int ret = 0;
> +
> +	lock_mount_hash();
> +	if (list_empty(&sb->s_mounts))
> +		goto out;
> +	mnt = list_entry(sb->s_mounts.next, struct mount, mnt_instance);
> +	ret_vfs = &mnt->mnt;
> +	ret_vfs = mntget(ret_vfs);
> +out:
> +	unlock_mount_hash();
> +	return ret_vfs;
> +}
> +EXPORT_SYMBOL(get_vfsmount_sb);
> +
>  struct vfsmount *mnt_clone_internal(struct path *path)
>  {
>  	struct mount *p;
> diff --git a/include/linux/mount.h b/include/linux/mount.h
> index c2c561d..cf1b0f5 100644
> --- a/include/linux/mount.h
> +++ b/include/linux/mount.h
> @@ -79,6 +79,7 @@ extern void mnt_drop_write_file(struct file *file);
>  extern void mntput(struct vfsmount *mnt);
>  extern struct vfsmount *mntget(struct vfsmount *mnt);
>  extern struct vfsmount *mnt_clone_internal(struct path *path);
> +extern struct vfsmount *get_vfsmount_sb(struct super_block *sb);
>  extern int __mnt_is_readonly(struct vfsmount *mnt);
>  
>  struct path;
> 

