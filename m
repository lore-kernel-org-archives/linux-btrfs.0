Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16776 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbdBVFdv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 00:33:51 -0500
Date: Tue, 21 Feb 2017 21:33:23 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: handle allocation error in
 update_dev_stat_item
Message-ID: <20170222053322.GB1497@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1487614974.git.dsterba@suse.com>
 <b5cd1b62a67b7ee96ae495628aef097294f7797d.1487614974.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b5cd1b62a67b7ee96ae495628aef097294f7797d.1487614974.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 20, 2017 at 07:25:04PM +0100, David Sterba wrote:
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/volumes.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1fac98728814..64d6665f6eda 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6954,7 +6954,8 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
>  	key.offset = device->devid;
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;
>  	ret = btrfs_search_slot(trans, dev_root, &key, path, -1, 1);
>  	if (ret < 0) {
>  		btrfs_warn_in_rcu(fs_info,

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
