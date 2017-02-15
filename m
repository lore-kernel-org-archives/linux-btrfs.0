Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27335 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdBOVSO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:18:14 -0500
Date: Wed, 15 Feb 2017 13:17:19 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/29] btrfs: remove unused parameter from
 btrfs_subvolume_release_metadata
Message-ID: <20170215211719.GA19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <90fed184def9887b599c7d09e8da49ee9d2f3130.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <90fed184def9887b599c7d09e8da49ee9d2f3130.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:33:49AM +0100, David Sterba wrote:
> Unused since qgroup refactoring that split data and metadata accounting,
> the btrfs_qgroup_free helper.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h       |  3 +--
>  fs/btrfs/extent-tree.c |  3 +--
>  fs/btrfs/ioctl.c       | 11 ++++-------
>  3 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 1692ebb05955..0f5b85772023 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2703,8 +2703,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
>  				     int nitems,
>  				     u64 *qgroup_reserved, bool use_global_rsv);
>  void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
> -				      struct btrfs_block_rsv *rsv,
> -				      u64 qgroup_reserved);
> +				      struct btrfs_block_rsv *rsv);
>  int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
>  void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
>  int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9e8d6c2e7a64..b33e2c8325c8 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5826,8 +5826,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
>  }
>  
>  void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
> -				      struct btrfs_block_rsv *rsv,
> -				      u64 qgroup_reserved)
> +				      struct btrfs_block_rsv *rsv)
>  {
>  	btrfs_block_rsv_release(fs_info, rsv, (u64)-1);
>  }
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 77f93a1e65c7..e8c7c313c113 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -487,8 +487,7 @@ static noinline int create_subvol(struct inode *dir,
>  	trans = btrfs_start_transaction(root, 0);
>  	if (IS_ERR(trans)) {
>  		ret = PTR_ERR(trans);
> -		btrfs_subvolume_release_metadata(fs_info, &block_rsv,
> -						 qgroup_reserved);
> +		btrfs_subvolume_release_metadata(fs_info, &block_rsv);
>  		goto fail_free;
>  	}
>  	trans->block_rsv = &block_rsv;
> @@ -613,7 +612,7 @@ static noinline int create_subvol(struct inode *dir,
>  	kfree(root_item);
>  	trans->block_rsv = NULL;
>  	trans->bytes_reserved = 0;
> -	btrfs_subvolume_release_metadata(fs_info, &block_rsv, qgroup_reserved);
> +	btrfs_subvolume_release_metadata(fs_info, &block_rsv);
>  
>  	if (async_transid) {
>  		*async_transid = trans->transid;
> @@ -753,9 +752,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>  	d_instantiate(dentry, inode);
>  	ret = 0;
>  fail:
> -	btrfs_subvolume_release_metadata(fs_info,
> -					 &pending_snapshot->block_rsv,
> -					 pending_snapshot->qgroup_reserved);
> +	btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->block_rsv);
>  dec_and_free:
>  	if (atomic_dec_and_test(&root->will_be_snapshoted))
>  		wake_up_atomic_t(&root->will_be_snapshoted);
> @@ -2555,7 +2552,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  		err = ret;
>  	inode->i_flags |= S_DEAD;
>  out_release:
> -	btrfs_subvolume_release_metadata(fs_info, &block_rsv, qgroup_reserved);
> +	btrfs_subvolume_release_metadata(fs_info, &block_rsv);
>  out_up_write:
>  	up_write(&fs_info->subvol_sem);
>  	if (err) {
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
