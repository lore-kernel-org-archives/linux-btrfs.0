Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27276 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbdBNUUX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 15:20:23 -0500
Date: Tue, 14 Feb 2017 12:19:27 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 28/29] btrfs: remove unused parameters from
 __btrfs_write_out_cache
Message-ID: <20170214201927.GG31091@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <77ed54d3725b1d4e2443e3fc6c55cb717d3b7ca1.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <77ed54d3725b1d4e2443e3fc6c55cb717d3b7ca1.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:47AM +0100, David Sterba wrote:
> Both unused after the call to update_cache_item has been moved to
> __btrfs_wait_cache_io.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/free-space-cache.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 0d02599d22bc..c169acef2a23 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1224,8 +1224,6 @@ int btrfs_wait_cache_io(struct btrfs_trans_handle *trans,
>   * @ctl - the free space cache we are going to write out
>   * @block_group - the block_group for this cache if it belongs to a block_group
>   * @trans - the trans handle
> - * @path - the path to use
> - * @offset - the offset for the key we'll insert
>   *
>   * This function writes out a free space cache struct to disk for quick recovery
>   * on mount.  This will return 0 if it was successful in writing the cache out,
> @@ -1235,8 +1233,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
>  				   struct btrfs_free_space_ctl *ctl,
>  				   struct btrfs_block_group_cache *block_group,
>  				   struct btrfs_io_ctl *io_ctl,
> -				   struct btrfs_trans_handle *trans,
> -				   struct btrfs_path *path, u64 offset)
> +				   struct btrfs_trans_handle *trans)
>  {
>  	struct btrfs_fs_info *fs_info = root->fs_info;
>  	struct extent_state *cached_state = NULL;
> @@ -1394,8 +1391,7 @@ int btrfs_write_out_cache(struct btrfs_fs_info *fs_info,
>  		return 0;
>  
>  	ret = __btrfs_write_out_cache(root, inode, ctl, block_group,
> -				      &block_group->io_ctl, trans,
> -				      path, block_group->key.objectid);
> +				      &block_group->io_ctl, trans);
>  	if (ret) {
>  #ifdef DEBUG
>  		btrfs_err(fs_info,
> @@ -3542,8 +3538,7 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
>  		return 0;
>  
>  	memset(&io_ctl, 0, sizeof(io_ctl));
> -	ret = __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl,
> -				      trans, path, 0);
> +	ret = __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl, trans);
>  	if (!ret) {
>  		/*
>  		 * At this point writepages() didn't error out, so our metadata
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
