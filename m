Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22512 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbaEICCq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 May 2014 22:02:46 -0400
Date: Fri, 9 May 2014 10:02:34 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH] Btrfs: fix EIO on reading file after ioctl clone works
 on it
Message-ID: <20140509020234.GA4250@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1399600862-3141-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399600862-3141-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(cc David)

-liubo

On Fri, May 09, 2014 at 10:01:02AM +0800, Liu Bo wrote:
> For inline data extent, we need to make its length aligned, otherwise,
> we can get a phantom extent map which confuses readpages() to return -EIO.
> 
> This can be detected by xfstests/btrfs/035.
> 
> Reported-by: David Disseldorp <ddiss@suse.de>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/ioctl.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 2ad7de9..2f6d7b1 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3120,6 +3120,8 @@ process_slot:
>  			} else if (type == BTRFS_FILE_EXTENT_INLINE) {
>  				u64 skip = 0;
>  				u64 trim = 0;
> +				u64 aligned_end = 0;
> +
>  				if (off > key.offset) {
>  					skip = off - key.offset;
>  					new_key.offset += skip;
> @@ -3136,9 +3138,11 @@ process_slot:
>  				size -= skip + trim;
>  				datal -= skip + trim;
>  
> +				aligned_end = ALIGN(new_key.offset + datal,
> +						    root->sectorsize);
>  				ret = btrfs_drop_extents(trans, root, inode,
>  							 new_key.offset,
> -							 new_key.offset + datal,
> +							 aligned_end,
>  							 1);
>  				if (ret) {
>  					if (ret != -EOPNOTSUPP)
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
