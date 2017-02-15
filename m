Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29785 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbdBOVU7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:20:59 -0500
Date: Wed, 15 Feb 2017 13:20:02 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/29] btrfs: remove unused parameter from
 btrfs_prepare_extent_commit
Message-ID: <20170215212002.GC19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <6ac74e62110a8cd9f5aa04f9b664287a5d115e5b.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6ac74e62110a8cd9f5aa04f9b664287a5d115e5b.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:33:52AM +0100, David Sterba wrote:
> Added but never used.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h       | 3 +--
>  fs/btrfs/extent-tree.c | 3 +--
>  fs/btrfs/transaction.c | 2 +-
>  3 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0f5b85772023..e7dbda3dd3b8 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2630,8 +2630,7 @@ int btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info,
>  			       u64 start, u64 len, int delalloc);
>  int btrfs_free_and_pin_reserved_extent(struct btrfs_fs_info *fs_info,
>  				       u64 start, u64 len);
> -void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
> -				 struct btrfs_fs_info *fs_info);
> +void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info);
>  int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
>  			       struct btrfs_fs_info *fs_info);
>  int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index b33e2c8325c8..2500e3df3250 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6558,8 +6558,7 @@ static int btrfs_free_reserved_bytes(struct btrfs_block_group_cache *cache,
>  	spin_unlock(&space_info->lock);
>  	return ret;
>  }
> -void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
> -				struct btrfs_fs_info *fs_info)
> +void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info)
>  {
>  	struct btrfs_caching_control *next;
>  	struct btrfs_caching_control *caching_ctl;
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 7d1d71259cd0..8bfb5e2c31f9 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2211,7 +2211,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  		goto scrub_continue;
>  	}
>  
> -	btrfs_prepare_extent_commit(trans, fs_info);
> +	btrfs_prepare_extent_commit(fs_info);
>  
>  	cur_trans = fs_info->running_transaction;
>  
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
