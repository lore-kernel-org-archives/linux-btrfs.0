Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17915 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3AJJVU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 04:21:20 -0500
Message-ID: <50EE8805.6000601@oracle.com>
Date: Thu, 10 Jan 2013 17:21:09 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Chris Mason <chris.mason@fusionio.com>,
        Alexander Block <ablock84@googlemail.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] Btrfs: fix access_ok() check in btrfs_ioctl_send()
References: <20130110085725.GA23063@elgon.mountain>
In-Reply-To: <20130110085725.GA23063@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/10/2013 04:57 PM, Dan Carpenter wrote:
> The closing parenthesis is in the wrong place.  We want to check
> "sizeof(*arg->clone_sources) * arg->clone_sources_count" instead of
> "sizeof(*arg->clone_sources * arg->clone_sources_count)".
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This is also vulnerable to integer overflows.  It's only done under
> root, but these days we are trying to restrict what root can do without
> configuring Secure Boot in UEFI.
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 5445454..4be3832 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -4553,8 +4553,8 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>  	}
>  
>  	if (!access_ok(VERIFY_READ, arg->clone_sources,
> -			sizeof(*arg->clone_sources *
> -			arg->clone_sources_count))) {
> +			sizeof(*arg->clone_sources) *
> +			arg->clone_sources_count)) {
>  		ret = -EFAULT;
>  		goto out;
>  	}
Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Thanks,
-Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

