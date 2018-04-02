Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43995 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754243AbeDBKKt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Apr 2018 06:10:49 -0400
Subject: Re: [PATCH] btrfs: rename btrfs_get_block_group_info and make it
 static
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180402092411.14960-1-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3e3dacfa-77f4-86d5-b328-152aab4df049@suse.com>
Date: Mon, 2 Apr 2018 13:10:46 +0300
MIME-Version: 1.0
In-Reply-To: <20180402092411.14960-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.04.2018 12:24, Su Yue wrote:
> The function btrfs_get_block_group_info() was introduced by the
> commit 5af3e8cce8b7 ("Btrfs: make filesystem read-only when submitting
>  barrier fails") which used it in disk-io.c.
> 
> However, the function is only called in ioctl.c now.
> Its parameter type btrfs_ioctl_space_info* is only for ioctl.
> 
> So, make it static and rename it to be original name
> get_block_group_info.
> 
> No functional change.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/ctree.h | 2 --
>  fs/btrfs/ioctl.c | 8 ++++----
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0eb55825862a..e69ef37efbc1 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3253,8 +3253,6 @@ int btrfs_is_empty_uuid(u8 *uuid);
>  int btrfs_defrag_file(struct inode *inode, struct file *file,
>  		      struct btrfs_ioctl_defrag_range_args *range,
>  		      u64 newer_than, unsigned long max_pages);
> -void btrfs_get_block_group_info(struct list_head *groups_list,
> -				struct btrfs_ioctl_space_info *space);
>  void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
>  			       struct btrfs_ioctl_balance_args *bargs);
>  ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 4ba793f25c3a..184001ffe38c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4047,8 +4047,8 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
>  	return ret;
>  }
>  
> -void btrfs_get_block_group_info(struct list_head *groups_list,
> -				struct btrfs_ioctl_space_info *space)
> +static void get_block_group_info(struct list_head *groups_list,
> +				 struct btrfs_ioctl_space_info *space)
>  {
>  	struct btrfs_block_group_cache *block_group;
>  
> @@ -4164,8 +4164,8 @@ static long btrfs_ioctl_space_info(struct btrfs_fs_info *fs_info,
>  		down_read(&info->groups_sem);
>  		for (c = 0; c < BTRFS_NR_RAID_TYPES; c++) {
>  			if (!list_empty(&info->block_groups[c])) {
> -				btrfs_get_block_group_info(
> -					&info->block_groups[c], &space);
> +				get_block_group_info(&info->block_groups[c],
> +						     &space);
>  				memcpy(dest, &space, sizeof(space));
>  				dest++;
>  				space_args.total_spaces++;
> 
