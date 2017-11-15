Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25608 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdKOXqn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 18:46:43 -0500
Date: Wed, 15 Nov 2017 15:46:06 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: fix deadlock when writing out space cache
Message-ID: <20171115234606.GA23320@dhcp-whq-twvpn-1-vpnpool-10-159-153-242.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1510780852-8862-1-git-send-email-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1510780852-8862-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 15, 2017 at 04:20:52PM -0500, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> If we fail to prepare our pages for whatever reason (out of memory in
> our case) we need to make sure to drop the block_group->data_rwsem,
> otherwise hilarity ensues.
>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/free-space-cache.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index cdc9f4015ec3..a6c643275210 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1263,8 +1263,12 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
>  
>  	/* Lock all pages first so we can lock the extent safely. */
>  	ret = io_ctl_prepare_pages(io_ctl, inode, 0);
> -	if (ret)
> +	if (ret) {
> +		if (block_group &&
> +		    (block_group->flags & BTRFS_BLOCK_GROUP_DATA))
> +			up_write(&block_group->data_rwsem);
>  		goto out;
> +	}
>  
>  	lock_extent_bits(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
>  			 &cached_state);
> -- 
> 2.7.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
