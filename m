Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48060 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbeBHTII (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Feb 2018 14:08:08 -0500
Date: Thu, 8 Feb 2018 10:57:11 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Remove invalid null checks from
 btrfs_cleanup_dirty_bgs
Message-ID: <20180208185710.GB9008@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1518107118-15137-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518107118-15137-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 08, 2018 at 06:25:17PM +0200, Nikolay Borisov wrote:
> list_first_entry is essentially a wrapper over cotnainer_of. The latter
> can never return null even if it's working on inconsistent list since it
> will either crash or return some offset in the wrong struct.
> Additionally, for the dirty_bgs list the iteration is done under
> dirty_bgs_lock which ensures consistency of the list.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/disk-io.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index aca906971abe..1b3989c54d7c 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4323,11 +4323,6 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
>  		cache = list_first_entry(&cur_trans->dirty_bgs,
>  					 struct btrfs_block_group_cache,
>  					 dirty_list);
> -		if (!cache) {
> -			btrfs_err(fs_info, "orphan block group dirty_bgs list");
> -			spin_unlock(&cur_trans->dirty_bgs_lock);
> -			return;
> -		}
>  
>  		if (!list_empty(&cache->io_list)) {
>  			spin_unlock(&cur_trans->dirty_bgs_lock);
> @@ -4351,10 +4346,6 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
>  		cache = list_first_entry(&cur_trans->io_bgs,
>  					 struct btrfs_block_group_cache,
>  					 io_list);
> -		if (!cache) {
> -			btrfs_err(fs_info, "orphan block group on io_bgs list");
> -			return;
> -		}
>  
>  		list_del_init(&cache->io_list);
>  		spin_lock(&cache->lock);
> -- 
> 2.7.4
> 
