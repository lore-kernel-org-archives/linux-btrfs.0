Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37778 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbbCYPEP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 11:04:15 -0400
Date: Wed, 25 Mar 2015 23:04:06 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chengyu Song <csong84@gatech.edu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: incorrect handling for
 fiemap_fill_next_extent return
Message-ID: <20150325150405.GB4796@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1427235176-19381-1-git-send-email-csong84@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427235176-19381-1-git-send-email-csong84@gatech.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 24, 2015 at 06:12:56PM -0400, Chengyu Song wrote:
> fiemap_fill_next_extent returns 0 on success, -errno on error, 1 if this was
> the last extent that will fit in user array. If 1 is returned, the return
> value may eventually returned to user space, which should not happen, according
> to manpage of ioctl.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> 
> Signed-off-by: Chengyu Song <csong84@gatech.edu>
> ---
>  fs/btrfs/extent_io.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d688cfe..782f3bc 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4514,8 +4514,11 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		}
>  		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
>  					      em_len, flags);
> -		if (ret)
> +		if (ret) {
> +			if (ret == 1)
> +				ret = 0;
>  			goto out_free;
> +		}
>  	}
>  out_free:
>  	free_extent_map(em);
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
