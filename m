Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42406 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751241AbaLWCBd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 21:01:33 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBN214UL001934
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Dec 2014 10:01:04 +0800
Message-ID: <1419299971.2086.8.camel@localhost.localdomain>
Subject: Re: [PATCH 1/2] Remove unnecessary placeholder in btrfs_err_code
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Tue, 23 Dec 2014 09:59:31 +0800
In-Reply-To: <5497F4CD.4010301@jp.fujitsu.com>
References: <5497F2EE.1010906@jp.fujitsu.com>
	 <5497F4CD.4010301@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-12-22 at 19:39 +0900, Satoru Takeuchi wrote:
> Sorry, I forgot to add Signed-off-by line.
> 
> ---
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> "notused" is not necessary. Set 1 to the first entry is enough.

Hi Satoru,

Actually, the struct is copied from the kernel header
include/uapi/linux/btrfs.h.
I think they should stay the same, so either change the kernel header
in another path, or just keep them in old style.

Thanks,
Gui 

> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> ---
>  ioctl.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/ioctl.h b/ioctl.h
> index 2c2c7c1..c377b96 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -474,8 +474,7 @@ struct btrfs_ioctl_qgroup_create_args {
>  
>  /* Error codes as returned by the kernel */
>  enum btrfs_err_code {
> -	notused,
> -	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET,
> +	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1,
>  	BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET,
>  	BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET,
>  	BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
> -- 1.8.3.1 -- To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body of a message to majordomo@vger.kernel.org More majordomo info at http://vger.kernel.org/majordomo-info.html 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


