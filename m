Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49757 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbdDRD7R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 23:59:17 -0400
Date: Mon, 17 Apr 2017 20:58:03 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix extent map leak during fallocate error path
Message-ID: <20170418035803.GA31484@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1491272436-11127-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491272436-11127-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 04, 2017 at 03:20:36AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If the call to btrfs_qgroup_reserve_data() failed, we were leaking an
> extent map structure. The failure can happen either due to an -ENOMEM
> condition or, when quotas are enabled, due to -EDQUOT for example.
>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/file.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 48dfb8e..56304c4 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2856,8 +2856,10 @@ static long btrfs_fallocate(struct file *file, int mode,
>  			}
>  			ret = btrfs_qgroup_reserve_data(inode, cur_offset,
>  					last_byte - cur_offset);
> -			if (ret < 0)
> +			if (ret < 0) {
> +				free_extent_map(em);
>  				break;
> +			}
>  		} else {
>  			/*
>  			 * Do not need to reserve unwritten extent for this
> -- 
> 2.7.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
