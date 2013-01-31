Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63280 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab3AaFxn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 00:53:43 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0V5re7Y006122
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 13:53:41 +0800
Message-ID: <510A070F.7010004@cn.fujitsu.com>
Date: Thu, 31 Jan 2013 13:54:23 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: fix remount vs autodefrag
References: <50B32FE7.5080908@cn.fujitsu.com> <50B3362D.1030409@cn.fujitsu.com>
In-Reply-To: <50B3362D.1030409@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any comments about this patch?

Thanks
Miao

On mon, 26 Nov 2012 17:28:13 +0800, Miao Xie wrote:
> If we remount the fs to close the auto defragment or make the fs R/O, we should
> stop the auto defragment.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/ctree.h |  1 +
>  fs/btrfs/file.c  | 13 +++++++++++++
>  fs/btrfs/super.c | 29 +++++++++++++++++++++++++++++
>  3 files changed, 43 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 4ce24ce..01d671c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1759,6 +1759,7 @@ struct btrfs_ioctl_defrag_range_args {
>  
>  #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
>  #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
> +#define btrfs_raw_test_opt(o, opt)	((o) & BTRFS_MOUNT_##opt)
>  #define btrfs_test_opt(root, opt)	((root)->fs_info->mount_opt & \
>  					 BTRFS_MOUNT_##opt)
>  /*
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 40b17d0..7aaae56 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -320,8 +320,21 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
>  	range.start = defrag->last_offset;
>  
>  	sb_start_write(fs_info->sb);
> +
> +	/* Avoid defraging files on R/O fs */
> +	if (!down_write_trylock(&fs_info->sb->s_umount)) {
> +		sb_end_write(fs_info->sb);
> +		btrfs_requeue_inode_defrag(inode, defrag);
> +		iput(inode);
> +		return -EBUSY;
> +	}
> +
> +	BUG_ON(fs_info->sb->s_flags & MS_RDONLY);
> +
>  	num_defrag = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
>  				       BTRFS_DEFRAG_BATCH);
> +
> +	up_write(&fs_info->sb->s_umount);
>  	sb_end_write(fs_info->sb);
>  	/*
>  	 * if we filled the whole defrag batch, there
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b3b041a..2e7beee 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1189,6 +1189,32 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
>  	btrfs_set_max_workers(&fs_info->scrub_workers, new_pool_size);
>  }
>  
> +static inline void btrfs_remount_prepare(struct btrfs_fs_info *fs_info,
> +					 unsigned long old_opts, int flags)
> +{
> +	if (btrfs_raw_test_opt(old_opts, AUTO_DEFRAG) &&
> +	    (!btrfs_raw_test_opt(fs_info->mount_opt, AUTO_DEFRAG) ||
> +	     (flags & MS_RDONLY))) {
> +		/* wait for any defraggers to finish */
> +		wait_event(fs_info->transaction_wait,
> +			   (atomic_read(&fs_info->defrag_running) == 0));
> +	}
> +}
> +
> +static inline void btrfs_remount_cleanup(struct btrfs_fs_info *fs_info,
> +					 unsigned long old_opts, int flags)
> +{
> +	/*
> +	 * We remount the fs successfully, then we need cleanup all defragable
> +	 * inodes if the autodefragment is close or the fs is R/O.
> +	 */
> +	if (btrfs_raw_test_opt(old_opts, AUTO_DEFRAG) &&
> +	    (!btrfs_raw_test_opt(fs_info->mount_opt, AUTO_DEFRAG) ||
> +	     (flags & MS_RDONLY)))
> +		btrfs_cleanup_defrag_inodes(fs_info);
> +
> +}
> +
>  static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
> @@ -1214,6 +1240,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
>  		return 0;
>  
> +	btrfs_remount_prepare(fs_info, old_opts, *flags);
> +
>  	if (*flags & MS_RDONLY) {
>  		sb->s_flags |= MS_RDONLY;
>  
> @@ -1247,6 +1275,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  		sb->s_flags &= ~MS_RDONLY;
>  	}
>  
> +	btrfs_remount_cleanup(fs_info, old_opts, *flags);
>  	return 0;
>  
>  restore:
> 

