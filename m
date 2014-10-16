Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:62100 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaJPJ0g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 05:26:36 -0400
Message-ID: <543F8F4B.5080506@giantdisaster.de>
Date: Thu, 16 Oct 2014 11:26:35 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix wrong pad for kernelspace arg of btrfs dev
 stat
References: <1413424419-15237-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1413424419-15237-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 16 Oct 2014 09:53:37 +0800, Gui Hecheng wrote:
> The @btrfs_ioctl_get_dev_stats fails to pad to 1k as descripted,
> actually it valuates to 1032 bytes.
> The corresponding userspace change follows this change.
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> ---
>  include/uapi/linux/btrfs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 2f47824..fc4e326 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -416,7 +416,7 @@ struct btrfs_ioctl_get_dev_stats {
>  	/* out values: */
>  	__u64 values[BTRFS_DEV_STAT_VALUES_MAX];
>  
> -	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
> +	__u64 unused[128 - 3 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */

You can't change an existing ioctl interface like this and make it
incompatible, the length of the structure is used in _IOWR(). Just
change the comment from "pad to 1k" to "pad to 1032 bytes" instead.


>  };
>  
>  #define BTRFS_QUOTA_CTL_ENABLE	1
> 


