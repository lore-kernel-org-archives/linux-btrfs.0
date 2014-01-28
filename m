Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50003 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645AbaA1Pu6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 10:50:58 -0500
Message-ID: <52E7D1DD.1030309@fb.com>
Date: Tue, 28 Jan 2014 10:50:53 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: add simple debugfs interface
References: <1389835529-23944-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1389835529-23944-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/15/2014 08:25 PM, David Sterba wrote:
> Help during debugging to export various interesting infromation and
> tunables without the need of extra mount options or ioctls.
>
> Usage:
> * declare your variable in sysfs.h, and include where you need it
> * define the variable in sysfs.c and make it visible via
>    debugfs_create_TYPE
>
> Depends on CONFIG_DEBUG_FS.
>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>   fs/btrfs/sysfs.c |   23 +++++++++++++++++++++++
>   1 files changed, 23 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index ba94b277e98d..d0023196e996 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -24,6 +24,7 @@
>   #include <linux/kobject.h>
>   #include <linux/bug.h>
>   #include <linux/genhd.h>
> +#include <linux/debugfs.h>
>   
>   #include "ctree.h"
>   #include "disk-io.h"
> @@ -593,6 +594,12 @@ static int add_device_membership(struct btrfs_fs_info *fs_info)
>   /* /sys/fs/btrfs/ entry */
>   static struct kset *btrfs_kset;
>   
> +/* /sys/kernel/debug/btrfs */
> +static struct dentry *btrfs_debugfs_root_dentry;
> +
> +/* Debugging tunables and exported data */
> +u64 btrfs_debugfs_test;
> +
>   int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
>   {
>   	int error;
> @@ -636,6 +643,18 @@ failure:
>   	return error;
>   }
>   
> +static int btrfs_init_debugfs(void)
> +{
> +#ifdef CONFIG_DEBUG_FS
> +	btrfs_debugfs_root_dentry = debugfs_create_dir("btrfs", NULL);
> +	if (!btrfs_debugfs_root_dentry)
> +		return -ENOMEM;
> +
> +	debugfs_create_u64("test", S_IRUGO | S_IWUGO, btrfs_debugfs_root_dentry,
> +			&btrfs_debugfs_test);
> +#endif

Need to return a value.

Josef
