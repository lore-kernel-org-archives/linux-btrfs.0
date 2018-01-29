Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57120 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751604AbeA2T6N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 14:58:13 -0500
Date: Mon, 29 Jan 2018 11:58:06 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH] btrfs: btrfs_evict_inode must clear all inodes
Message-ID: <20180129195806.GA6535@dhcp-10-159-251-27.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <c38b2527-899f-9be2-87e5-6b4048e17217@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c38b2527-899f-9be2-87e5-6b4048e17217@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 29, 2018 at 11:46:28AM -0500, Jeff Mahoney wrote:
> btrfs_evict_inode must clear all inodes or we'll hit a BUG_ON in evict().
> 
> Fixes: 3d48d9810de (btrfs: Handle uninitialised inode eviction)
> Cc: Nikolay Borisov <nborisov@suse.com>
> Cc: <stable@vger.kernel.org> # v4.8+
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/inode.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5282,6 +5282,7 @@ void btrfs_evict_inode(struct inode *ino
>  	trace_btrfs_inode_evict(inode);
>  
>  	if (!root) {
> +		clear_inode(inode);
>  		kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));

I had a patch for this, and also kmem_cache_free() is not supposed to
be called here, but in ->destroy_inode().

Thanks,

-liubo
>  		return;
>  	}
> 
> -- 
> Jeff Mahoney
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
