Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932107AbdERMXb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 08:23:31 -0400
Date: Thu, 18 May 2017 14:23:27 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        dsterba@suse.com, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH RFC] vfs: add mount umount logs
Message-ID: <20170518122327.5s57k7o7acjdwwsy@eorzea.usersys.redhat.com>
References: <20170518100804.25538-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170518100804.25538-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 18, 2017 at 06:08:04PM +0800, Anand Jain wrote:
> By looking at the logs we should be able to know when was the FS
> mounted and unmounted and the options used, so to help forensic
> investigations.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> You may want to know that, during boot and shutdown this
> adds roughly 25 lines more logs depending on the config, and it
> logs even for non block device FS, such as proc, sysfs ..etc.
> And blockdev FS only check will eliminate overlay as well, which
> is kind of defeats the purpose.
> Further, just to highlight if your test script involves mount and
> umount, which probably all of fstests does, it will add logs when
> FS is mounted and umounted.
> Still IMO, these logs are useful for the end purpose as mentioned
> above. Its for your feedback. Thanks.
> 
>  fs/namespace.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index b3b115bd4e1e..78375b6f8330 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1686,6 +1686,8 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
>  	struct mount *mnt;
>  	int retval;
>  	int lookup_flags = 0;
> +	struct super_block *sb;
> +	char umntlog[256] = {0};
>  
>  	if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | UMOUNT_NOFOLLOW))
>  		return -EINVAL;
> @@ -1711,7 +1713,15 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
>  	if (flags & MNT_FORCE && !capable(CAP_SYS_ADMIN))
>  		goto dput_and_out;
>  
> +	sb = mnt->mnt.mnt_sb;
> +	snprintf(umntlog, sizeof(umntlog), "umount %s dev:%s flags:%d",
> +		sb->s_type->name, sb->s_id, flags);
> +

This will log a message when the umount has been started, but it won't by any
chance be a confirmation the filesystem has been properly unmounted, wouldn't be
better to log it after the FS has been properly unmounted, or, change the
message to something like "umount started"?

Although, from a forensic POV, would be better to have an "unmount started" +
"unmount finished".

>  	retval = do_umount(mnt, flags);
> +
> +	if (!retval)
> +		printk(KERN_NOTICE "%s\n", umntlog);
> +
>  dput_and_out:
>  	/* we mustn't call path_put() as that would clear mnt_expiry_mark */
>  	dput(path.dentry);
> @@ -2833,6 +2843,11 @@ long do_mount(const char *dev_name, const char __user *dir_name,
>  	else
>  		retval = do_new_mount(&path, type_page, flags, mnt_flags,
>  				      dev_name, data_page);
> +
> +	if (!retval)
> +		printk(KERN_NOTICE "mount %s dev:%s dir:%pd flags:0x%lX opt:%s\n",
> +			type_page, dev_name, path.dentry, flags, (char *)data_page);
> +
>  dput_out:
>  	path_put(&path);
>  	return retval;
> -- 
> 2.10.0
> 

-- 
Carlos
