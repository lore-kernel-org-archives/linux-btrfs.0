Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29966 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaENFaG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 01:30:06 -0400
Message-ID: <5372FFEF.5020405@oracle.com>
Date: Wed, 14 May 2014 13:32:31 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: save us an unnecessary ioctl call
References: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



 > Btrfs device id start from 1, not 0.

  That was an intentional change.

  50275ba btrfs-progs: there is devid 0 when replace is running




>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>   utils.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/utils.c b/utils.c
> index 560c557..d480353 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1765,7 +1765,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>   		goto out;
>   	}
>
> -	for (; i <= fi_args->max_id; ++i) {
> +	for (i = 1; i <= fi_args->max_id; ++i) {
>   		BUG_ON(ndevs >= fi_args->num_devices);
>   		ret = get_device_info(fd, i, &di_args[ndevs]);
>   		if (ret == -ENODEV)
>
