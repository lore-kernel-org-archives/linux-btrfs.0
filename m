Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22126 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752977AbdBNTlQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 14:41:16 -0500
Date: Tue, 14 Feb 2017 11:40:21 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 24/29] btrfs: remove unused parameters from btrfs_cmp_data
Message-ID: <20170214194021.GF31091@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <aea50515c7c0bc63f5a40eb125f904b85e420b98.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <aea50515c7c0bc63f5a40eb125f904b85e420b98.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:35AM +0100, David Sterba wrote:
> After the page locking has been reworked, we get all pages prepared via
> cmp_pages.
>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ioctl.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 91188a2ac5a1..1f13f8416d29 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3053,8 +3053,7 @@ static int btrfs_cmp_data_prepare(struct inode *src, u64 loff,
>  	return 0;
>  }
>  
> -static int btrfs_cmp_data(struct inode *src, u64 loff, struct inode *dst,
> -			  u64 dst_loff, u64 len, struct cmp_pages *cmp)
> +static int btrfs_cmp_data(u64 len, struct cmp_pages *cmp)
>  {
>  	int ret = 0;
>  	int i;
> @@ -3221,7 +3220,7 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>  	}
>  
>  	/* pass original length for comparison so we stay within i_size */
> -	ret = btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
> +	ret = btrfs_cmp_data(olen, &cmp);
>  	if (ret == 0)
>  		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
>  
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
