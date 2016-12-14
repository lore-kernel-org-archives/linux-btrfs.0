Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33869 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753976AbcLNTDw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 14:03:52 -0500
Date: Wed, 14 Dec 2016 11:03:09 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, fdmanana@gmail.com,
        wangxg.fnst@cn.fujitsu.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] Btrfs: fix btrfs_ordered_update_i_size to update
 disk_i_size properly
Message-ID: <20161214190309.GA10388@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1480628770-18848-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480628770-18848-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 01, 2016 at 01:46:10PM -0800, Liu Bo wrote:
> btrfs_ordered_update_i_size can be called by truncate and endio, but only endio
> takes ordered_extent which contains the completed IO.
> 
> while truncating down a file, if there are some in-flight IOs,
> btrfs_ordered_update_i_size in endio will set disk_i_size to @orig_offset that
> is zero.  If truncating-down fails somehow, we try to recover in memory isize
> with this zero'd disk_i_size.
> 
> Fix it by only updating disk_i_size with @orig_offset when
> btrfs_ordered_update_i_size is not called from endio while truncating down and
> waiting for in-flight IOs completing their work before recover in-memory size.
> 
> Besides fixing the above issue, add an assertion for last_size to double check
> we truncate down to the desired size.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/inode.c        | 14 ++++++++++++++
>  fs/btrfs/ordered-data.c |  9 +++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 09157dd..ef3594d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4682,6 +4682,13 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  
>  	btrfs_free_path(path);
>  
> +	if (err == 0) {
> +		/* only inline file may have last_size != new_size */
> +		if (new_size >= root->sectorsize ||
> +		    new_size > root->fs_info->max_inline)
> +			ASSERT(last_size == new_size);
> +	}
> +

This ASSERT has been hit by fstests/generic/299, and it didn't show up
the first time I tested, I'm trying to figure out whether we have
problems in code or in this ASSERT.

Thanks,

-liubo

>  	if (be_nice && bytes_deleted > SZ_32M) {
>  		unsigned long updates = trans->delayed_ref_updates;
>  		if (updates) {
> @@ -5064,6 +5071,13 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
>  		if (ret && inode->i_nlink) {
>  			int err;
>  
> +			/* To get a stable disk_i_size */
> +			err = btrfs_wait_ordered_range(inode, 0, (u64)-1);
> +			if (err) {
> +				btrfs_orphan_del(NULL, inode);
> +				return err;
> +			}
> +
>  			/*
>  			 * failed to truncate, disk_i_size is only adjusted down
>  			 * as we remove extents, so it should represent the true
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index b2d1e95..5eaa25a 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -982,8 +982,13 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
>  	}
>  	disk_i_size = BTRFS_I(inode)->disk_i_size;
>  
> -	/* truncate file */
> -	if (disk_i_size > i_size) {
> +	/*
> +	 * truncate file.
> +	 * If ordered is not NULL, then this is called from endio and
> +	 * disk_i_size will be updated by either truncate itself or any
> +	 * in-flight IOs which are inside the disk_i_size.
> +	 */
> +	if (!ordered && disk_i_size > i_size) {
>  		BTRFS_I(inode)->disk_i_size = orig_offset;
>  		ret = 0;
>  		goto out;
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
