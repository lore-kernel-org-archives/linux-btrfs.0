Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:45787 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaEMKtD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 06:49:03 -0400
Message-ID: <5371F89B.1060401@giantdisaster.de>
Date: Tue, 13 May 2014 12:48:59 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: save us an unnecessary ioctl call
References: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 13 May 2014 17:05:05 +0800, Wang Shilong wrote:
> Btrfs device id start from 1, not 0.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  utils.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/utils.c b/utils.c
> index 560c557..d480353 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1765,7 +1765,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>  		goto out;
>  	}

You've not seen the two assignments in get_fs_info() above the lines
that you change:

        if (is_block_device(path)) {
                ...
                fi_args->max_id = devid;
                i = devid;

>  
> -	for (; i <= fi_args->max_id; ++i) {
> +	for (i = 1; i <= fi_args->max_id; ++i) {
>  		BUG_ON(ndevs >= fi_args->num_devices);
>  		ret = get_device_info(fd, i, &di_args[ndevs]);
>  		if (ret == -ENODEV)


