Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40453 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbbGSD0W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Jul 2015 23:26:22 -0400
Date: Sun, 19 Jul 2015 11:25:40 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH] btrfs: its btrfs_err() instead of btrfs_error()
Message-ID: <20150719032539.GB11450@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1437147923-23965-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437147923-23965-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 17, 2015 at 11:45:23PM +0800, Anand Jain wrote:
> sorry I indented to use btrfs_err() and I have no idea
> how btrfs_error() got there.
> infact I was thinking about these kind of oversights
> since these two func are too closely named.

Good catch.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/dev-replace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 862fbc2..564a7de 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -378,7 +378,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
>  
>  	ret = btrfs_kobj_add_device(tgt_device->fs_devices, tgt_device);
>  	if (ret)
> -		btrfs_error(root->fs_info, ret, "kobj add dev failed");
> +		btrfs_err(root->fs_info, "kobj add dev failed %d\n", ret);
>  
>  	printk_in_rcu(KERN_INFO
>  		      "BTRFS: dev_replace from %s (devid %llu) to %s started\n",
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
