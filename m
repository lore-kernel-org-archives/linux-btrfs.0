Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49767 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbdBNU1Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 15:27:24 -0500
Date: Tue, 14 Feb 2017 12:26:30 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: make space cache inode readahead failure nonfatal
Message-ID: <20170214202630.GI31091@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170213095312.18495-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170213095312.18495-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:53:12AM +0100, David Sterba wrote:
> We do a readahead of the free space cache inode to speed things up but
> the failure is not fatal, like in other readahead cases. Proper reads
> would need to happen anyway and any errors would be caught there.
>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/free-space-cache.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 437580e84d9d..e96e981ef01e 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -286,14 +286,14 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
>  	return ret;
>  }
>  
> -static int readahead_cache(struct inode *inode)
> +static void readahead_cache(struct inode *inode)
>  {
>  	struct file_ra_state *ra;
>  	unsigned long last_index;
>  
>  	ra = kzalloc(sizeof(*ra), GFP_NOFS);
>  	if (!ra)
> -		return -ENOMEM;
> +		return;
>  
>  	file_ra_state_init(ra, inode->i_mapping);
>  	last_index = (i_size_read(inode) - 1) >> PAGE_SHIFT;
> @@ -301,8 +301,6 @@ static int readahead_cache(struct inode *inode)
>  	page_cache_sync_readahead(inode->i_mapping, ra, NULL, 0, last_index);
>  
>  	kfree(ra);
> -
> -	return 0;
>  }
>  
>  static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
> @@ -730,9 +728,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
>  	if (ret)
>  		return ret;
>  
> -	ret = readahead_cache(inode);
> -	if (ret)
> -		goto out;
> +	readahead_cache(inode);
>  
>  	ret = io_ctl_prepare_pages(&io_ctl, inode, 1);
>  	if (ret)
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
