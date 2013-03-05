Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47337 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3CECw7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 21:52:59 -0500
Date: Tue, 5 Mar 2013 10:51:24 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allow running defrag in parallel to
 administrative tasks
Message-ID: <20130305025123.GA18743@liubo.cn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1362418118-20277-1-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362418118-20277-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 04, 2013 at 06:28:38PM +0100, Stefan Behrens wrote:
> Commit 5ac00add added a testnset mutex and code that disallows
> running administrative tasks in parallel. It is prevented that
> the device add/delete/balance/replace/resize operations are
> started in parallel. By mistake, the defragmentation operation
> was included in the check for mutually exclusiveness as well.
> This is fixed with this commit.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  fs/btrfs/ioctl.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b908960..40631cf 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2245,13 +2245,6 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
>  	if (ret)
>  		return ret;
>  
> -	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
> -			1)) {
> -		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
> -		mnt_drop_write_file(file);
> -		return -EINVAL;
> -	}
> -
>  	if (btrfs_root_readonly(root)) {
>  		ret = -EROFS;
>  		goto out;
> @@ -2306,7 +2299,6 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
>  		ret = -EINVAL;
>  	}
>  out:
> -	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
>  	mnt_drop_write_file(file);
>  	return ret;
>  }
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
