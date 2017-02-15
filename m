Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51945 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750719AbdBOVHu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:07:50 -0500
Date: Wed, 15 Feb 2017 13:05:53 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/29] btrfs: merge two superblock writing helpers
Message-ID: <20170215210553.GA12445@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <616929b18253874e8ad87b6b0667b20e7ce58832.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <616929b18253874e8ad87b6b0667b20e7ce58832.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:33:39AM +0100, David Sterba wrote:
> write_all_supers and write_ctree_super are almost equal, the parameter
> 'trans' is unused so we can drop it and have just one helper.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c     | 8 +-------
>  fs/btrfs/disk-io.h     | 3 +--
>  fs/btrfs/transaction.c | 2 +-
>  fs/btrfs/tree-log.c    | 2 +-
>  4 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 43e71457c193..441a62cd0351 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3695,7 +3695,7 @@ int btrfs_calc_num_tolerated_disk_barrier_failures(
>  	return num_tolerated_disk_barrier_failures;
>  }
>  
> -static int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
> +int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>  {
>  	struct list_head *head;
>  	struct btrfs_device *dev;
> @@ -3789,12 +3789,6 @@ static int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>  	return 0;
>  }
>  
> -int write_ctree_super(struct btrfs_trans_handle *trans,
> -		      struct btrfs_fs_info *fs_info, int max_mirrors)
> -{
> -	return write_all_supers(fs_info, max_mirrors);
> -}
> -
>  /* Drop a fs root from the radix tree and free it. */
>  void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
>  				  struct btrfs_root *root)
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 1864e7ce9c70..0be2d4fe705b 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -57,8 +57,7 @@ int open_ctree(struct super_block *sb,
>  	       struct btrfs_fs_devices *fs_devices,
>  	       char *options);
>  void close_ctree(struct btrfs_fs_info *fs_info);
> -int write_ctree_super(struct btrfs_trans_handle *trans,
> -		      struct btrfs_fs_info *fs_info, int max_mirrors);
> +int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors);
>  struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
>  int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
>  			struct buffer_head **bh_ret);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 48aabb367f73..7d1d71259cd0 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2261,7 +2261,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  		goto scrub_continue;
>  	}
>  
> -	ret = write_ctree_super(trans, fs_info, 0);
> +	ret = write_all_supers(fs_info, 0);
>  	if (ret) {
>  		mutex_unlock(&fs_info->tree_log_mutex);
>  		goto scrub_continue;
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index cea93ba1f099..62dd138018b5 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2961,7 +2961,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  	 * the running transaction open, so a full commit can't hop
>  	 * in and cause problems either.
>  	 */
> -	ret = write_ctree_super(trans, fs_info, 1);
> +	ret = write_all_supers(fs_info, 1);
>  	if (ret) {
>  		btrfs_set_log_full_commit(fs_info, trans);
>  		btrfs_abort_transaction(trans, ret);
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
