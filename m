Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1738 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895AbaISCDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 22:03:55 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8J23uO3029770
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 10:04:00 +0800
Message-ID: <541B8F08.5020102@cn.fujitsu.com>
Date: Fri, 19 Sep 2014 10:03:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] btrfs: correct a message on setting nodatacow
References: <541A9717.5000003@jp.fujitsu.com> <541A979D.8060409@jp.fujitsu.com>
In-Reply-To: <541A979D.8060409@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH 2/5] btrfs: correct a message on setting nodatacow
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
To: linux-btrfs@vger.kernel.org <linux-btrfs@vger.kernel.org>
Date: 2014年09月18日 16:28
> From: Naohiro Aota <naota@elisp.net>
>
> If we set nodatacow mount option after compress-force option,
> we don't get compression disabling message.
>
> ===
> $ sudo mount -o remount,compress-force,nodatacow /; dmesg|tail -n 3
> [ 3845.719047] BTRFS info (device vda2): force zlib compression
> [ 3845.719052] BTRFS info (device vda2): setting nodatacow
> [ 3845.719055] BTRFS info (device vda2): disk space caching is enabled
> ===
>
> Signed-off-by: Naohiro Aota <naota@elisp.net>
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> ---
>   fs/btrfs/super.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index d1c5b6d..d131098 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -462,8 +462,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>   			break;
>   		case Opt_nodatacow:
>   			if (!btrfs_test_opt(root, NODATACOW)) {
> -				if (!btrfs_test_opt(root, COMPRESS) ||
> -				    !btrfs_test_opt(root, FORCE_COMPRESS)) {
> +				if (btrfs_test_opt(root, COMPRESS)) {
>   					btrfs_info(root->fs_info,
>   						   "setting nodatacow, compression disabled");
>   				} else {
> -- 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Although the patch makes the output ok, the core problem is missing 
conflict options check.

compress-force mount options implies datacow and datasum, but following 
nodatasum will disable datasum and compress, in fact they are 
conflicting mount option...

Even the current behavior(later mount option will override previous 
ones) provides great tolerance,
IMO there should better be some conflicting check for mount options.

For example, we first save all the mount options passed in into a 
temporary bitmaps to finds out the conflicting
and only when they contains no conflicts, set the mount options to fs_info.
(Maybe bitmap is not enough for this case, since we can't distinguish 
default value and value to be set?)

What do you think about this idea ?

Thanks,
Qu
