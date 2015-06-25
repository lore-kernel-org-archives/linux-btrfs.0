Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35704 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbbFYDEL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 23:04:11 -0400
Date: Thu, 25 Jun 2015 11:04:01 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] btrfs: pass unaligned length to btrfs_cmp_data()
Message-ID: <20150625030400.GC23794@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1435094920-22442-1-git-send-email-mfasheh@suse.de>
 <1435094920-22442-2-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435094920-22442-2-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 02:28:36PM -0700, Mark Fasheh wrote:
> In the case that we dedupe the tail of a file, we might expand the dedupe
> len out to the end of our last block. We don't want to compare data past
> i_size however, so pass the original length to btrfs_cmp_data().

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> Reviewed-by: David Sterba <dsterba@suse.cz>
> ---
>  fs/btrfs/ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 2d24ff4..2deea1f 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2933,7 +2933,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>  		goto out_unlock;
>  	}
>  
> -	ret = btrfs_cmp_data(src, loff, dst, dst_loff, len);
> +	/* pass original length for comparison so we stay within i_size */
> +	ret = btrfs_cmp_data(src, loff, dst, dst_loff, olen);
>  	if (ret == 0)
>  		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff);
>  
> -- 
> 2.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
