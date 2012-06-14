Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42428 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab2FNDMS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 23:12:18 -0400
Message-ID: <4FD9563E.5020906@cn.fujitsu.com>
Date: Thu, 14 Jun 2012 11:10:54 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: implement ->show_devname V2
References: <1339530642-13862-1-git-send-email-josef@redhat.com> <1339530642-13862-2-git-send-email-josef@redhat.com>
In-Reply-To: <1339530642-13862-2-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	tue, 12 Jun 2012 15:50:42 -0400, Josef Bacik wrote:
> Because btrfs can remove the device that was mounted we need to have a
> ->show_devname so that in this case we can print out some other device in
> the file system to /proc/mount.  So if there are multiple devices in a btrfs
> file system we will just print the device with the lowest devid that we can
> find.  This will make everything consistent and deal with device removal
> properly.  The drawback is if you mount with a device that is higher than
> the lowest devicd it won't show up as the mounted device in /proc/mounts,
> but this is a small price to pay. This was inspired by Miao Xie's patch.
> Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
> V1->V2: Dropped the mounted tracking stuff since it doesn't work right if you
> mount the same thing twice
>  fs/btrfs/super.c |   33 +++++++++++++++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 85cef50..0874dba 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -54,6 +54,7 @@
>  #include "version.h"
>  #include "export.h"
>  #include "compression.h"
> +#include "rcu-string.h"
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/btrfs.h>
> @@ -1472,12 +1473,44 @@ static int btrfs_unfreeze(struct super_block *sb)
>  	return 0;
>  }
>  
> +static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
> +{
> +	struct btrfs_fs_info *fs_info = btrfs_sb(root->d_sb);
> +	struct btrfs_fs_devices *cur_devices;
> +	struct btrfs_device *dev, *first_dev = NULL;
> +	struct list_head *head;
> +	struct rcu_string *name;
> +
> +	mutex_lock(&fs_info->fs_devices->device_list_mutex);
> +	cur_devices = fs_info->fs_devices;
> +	while (cur_devices) {
> +		head = &cur_devices->devices;
> +		list_for_each_entry(dev, head, dev_list) {
> +			if (!first_dev || dev->devid < first_dev->devid)
> +				first_dev = dev;
> +		}
> +		cur_devices = cur_devices->seed;
> +	}
> +
> +	if (first_dev) {
> +		rcu_read_lock();
> +		name = rcu_dereference(first_dev->name);
> +		seq_escape(m, name->str, " \t\n\\");
> +		rcu_read_unlock();
> +	} else {
> +		WARN_ON(1);
> +	}
> +	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +	return 0;
> +}
> +
>  static const struct super_operations btrfs_super_ops = {
>  	.drop_inode	= btrfs_drop_inode,
>  	.evict_inode	= btrfs_evict_inode,
>  	.put_super	= btrfs_put_super,
>  	.sync_fs	= btrfs_sync_fs,
>  	.show_options	= btrfs_show_options,
> +	.show_devname	= btrfs_show_devname,
>  	.write_inode	= btrfs_write_inode,
>  	.alloc_inode	= btrfs_alloc_inode,
>  	.destroy_inode	= btrfs_destroy_inode,

