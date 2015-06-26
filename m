Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32724 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbbFZDfI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 23:35:08 -0400
Date: Fri, 26 Jun 2015 11:35:02 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Davide Italiano <dccitaliano@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Improve FL_KEEP_SIZE handling in fallocate.
Message-ID: <20150626033501.GC9860@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1428383355-1686-1-git-send-email-dccitaliano@gmail.com>
 <1428383355-1686-2-git-send-email-dccitaliano@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1428383355-1686-2-git-send-email-dccitaliano@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 06, 2015 at 10:09:15PM -0700, Davide Italiano wrote:
> - We call inode_size_ok() only if FL_KEEP_SIZE isn't specified.
> - As an optimisation we can skip the call if (off + len)
>   isn't greater than the current size of the file. This operation
>   is called under the lock so the less work we do, the better.
> - If we call inode_size_ok() pass to it the correct value rather
>   than a more conservative estimation.

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> 
> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
> ---
>  fs/btrfs/file.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 30982bb..f649bfc 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2586,9 +2586,13 @@ static long btrfs_fallocate(struct file *file, int mode,
>  	}
>  
>  	mutex_lock(&inode->i_mutex);
> -	ret = inode_newsize_ok(inode, alloc_end);
> -	if (ret)
> -		goto out;
> +
> +	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> +	    offset + len > inode->i_size) {
> +		ret = inode_newsize_ok(inode, offset + len);
> +		if (ret)
> +			goto out;
> +	}
>  
>  	if (alloc_start > inode->i_size) {
>  		ret = btrfs_cont_expand(inode, i_size_read(inode),
> -- 
> 2.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
