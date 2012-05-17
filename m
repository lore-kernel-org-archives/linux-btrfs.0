Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:45888 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231Ab2EQPIb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 11:08:31 -0400
Received: by weyu7 with SMTP id u7so1220746wey.19
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 08:08:29 -0700 (PDT)
Date: Thu, 17 May 2012 18:08:27 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/5] Btrfs: pause/recover the space balance when doing
 remount
Message-ID: <20120517150827.GB1934@zambezi.lan>
References: <4FB4E7B4.7060006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB4E7B4.7060006@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2012 at 07:57:40PM +0800, Miao Xie wrote:
> pause the space balance threads when remounting the fs to be readonly,
> and recover it when remounting it from r/o to r/w
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/super.c   |    9 ++++++++-
>  fs/btrfs/volumes.c |    8 +++++++-
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 7deb00e..ea17f0a 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1148,6 +1148,9 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  	if (*flags & MS_RDONLY) {
>  		sb->s_flags |= MS_RDONLY;
>  
> +		/* pause restriper - we want to resume on remount to r/w */
> +		btrfs_pause_balance(root->fs_info);
> +
>  		ret = btrfs_commit_super(root);
>  		if (ret)
>  			goto restore;
> @@ -1174,7 +1177,10 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  		if (ret)
>  			goto restore;
>  
> -		sb->s_flags &= ~MS_RDONLY;
> +		if (sb->s_flags & MS_RDONLY) {
> +			sb->s_flags &= ~MS_RDONLY;
> +			btrfs_recover_balance(fs_info->tree_root);
> +		}
>  	}
>  
>  	return 0;
> @@ -1190,6 +1196,7 @@ restore:
>  	fs_info->alloc_start = old_alloc_start;
>  	fs_info->thread_pool_size = old_thread_pool_size;
>  	fs_info->metadata_ratio = old_metadata_ratio;
> +
>  	return ret;
>  }
>  
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 91da8a2..c536d52 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2833,7 +2833,13 @@ static int balance_kthread(void *data)
>  	mutex_lock(&fs_info->volume_mutex);
>  	mutex_lock(&fs_info->balance_mutex);
>  
> -	set_balance_control(bctl);
> +	if (fs_info->balance_ctl) {
> +		kfree(bctl);
> +		bctl = fs_info->balance_ctl;
> +		bctl->flags = bctl->flags | BTRFS_BALANCE_RESUME;
> +	} else {
> +		set_balance_control(bctl);
> +	}
>  
>  	if (btrfs_test_opt(fs_info->tree_root, SKIP_BALANCE)) {
>  		printk(KERN_INFO "btrfs: force skipping balance\n");

This is a known bug.  There is a deeper problem here, related to the
fact that we restore balancing state not early enough and that we don't
restore it on ro mounts at all.  I have a patch in the works to fix that
problem, and it also fixes this one the right way.  I'm backed up with
other things right now, but I'll post it as soon as I get a chance.

Thanks,

		Ilya
