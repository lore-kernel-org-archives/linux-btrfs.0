Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18409 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdBVFjY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 00:39:24 -0500
Date: Tue, 21 Feb 2017 21:39:05 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: do proper error handling in
 btrfs_insert_xattr_item
Message-ID: <20170222053905.GC1497@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1487614974.git.dsterba@suse.com>
 <e204841964263393974c193010c74648faa5a761.1487614974.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e204841964263393974c193010c74648faa5a761.1487614974.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 20, 2017 at 07:25:06PM +0100, David Sterba wrote:
> The space check in btrfs_insert_xattr_item is duplicated in it's caller
> (do_setxattr) so we won't hit the BUG_ON. Continuing without any check
> could be disasterous so turn it to a proper error handling.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/dir-item.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index 724504a2d7ac..640801082533 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -80,7 +80,8 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
>  	struct extent_buffer *leaf;
>  	u32 data_size;
>  
> -	BUG_ON(name_len + data_len > BTRFS_MAX_XATTR_SIZE(root->fs_info));
> +	if (name_len + data_len > BTRFS_MAX_XATTR_SIZE(root->fs_info))
> +		return -ENOSPC;
>

Besides making it silent, how about adding a ASSERT to cry out?
(Although currently we'd never come into this case.)

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
>  	key.objectid = objectid;
>  	key.type = BTRFS_XATTR_ITEM_KEY;
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
