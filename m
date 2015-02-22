Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31921 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbbBVO7P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Feb 2015 09:59:15 -0500
Date: Sun, 22 Feb 2015 22:58:53 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: check io_ctl_prepare_pages return in
 __btrfs_write_out_cache
Message-ID: <20150222145852.GB22213@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1424168589.git.osandov@osandov.com>
 <a0a696b3a042c53d868e29a6bd49960eef2aeee9.1424168589.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a0a696b3a042c53d868e29a6bd49960eef2aeee9.1424168589.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 17, 2015 at 02:51:09AM -0800, Omar Sandoval wrote:
> If io_ctl_prepare_pages fails, the pages in io_ctl.pages are not valid.
> When we try to access them later, things will blow up in various ways.
> 

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
>  fs/btrfs/free-space-cache.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index d6c03f7..0460632 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1114,7 +1114,7 @@ cleanup_write_cache_enospc(struct inode *inode,
>   *
>   * This function writes out a free space cache struct to disk for quick recovery
>   * on mount.  This will return 0 if it was successfull in writing the cache out,
> - * and -1 if it was not.
> + * or an errno if it was not.
>   */
>  static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
>  				   struct btrfs_free_space_ctl *ctl,
> @@ -1130,11 +1130,11 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
>  	int ret;
>  
>  	if (!i_size_read(inode))
> -		return -1;
> +		return -EIO;
>  
>  	ret = io_ctl_init(&io_ctl, inode, root, 1);
>  	if (ret)
> -		return -1;
> +		return ret;
>  
>  	if (block_group && (block_group->flags & BTRFS_BLOCK_GROUP_DATA)) {
>  		down_write(&block_group->data_rwsem);
> @@ -1151,7 +1151,9 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
>  	}
>  
>  	/* Lock all pages first so we can lock the extent safely. */
> -	io_ctl_prepare_pages(&io_ctl, inode, 0);
> +	ret = io_ctl_prepare_pages(&io_ctl, inode, 0);
> +	if (ret)
> +		goto out;
>  
>  	lock_extent_bits(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
>  			 0, &cached_state);
> -- 
> 2.3.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks,

-liubo
