Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42768 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750858AbaJ0ERY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 00:17:24 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9R4HG4O008899
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 12:17:16 +0800
Message-ID: <544DC7BC.9020608@cn.fujitsu.com>
Date: Mon, 27 Oct 2014 12:19:08 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
CC: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: [PATCH] btrfs: SSD related mount option dependency rework.
References: <1406863651-11042-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1406863651-11042-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any new comments?

Cc: Satoru
Sorry for the late reply.
Unfortunately, it seems that your mail doesn't show in my inbox, but 
only occurs in patchwork.

About writing the dependency in btrfs.txt, since the patch is based on 
the btrfs.txt,
it already shows the dependency, so I'd like not to repeat them in 
btrfs.txt.

Thanks,
Qu

-------- Original Message --------
Subject: [PATCH] btrfs: SSD related mount option dependency rework.
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年08月01日 11:27
> According to Documentations/filesystem/btrfs.txt, ssd/ssd_spread/nossd
> has their own dependency(See below), but only ssd_spread implying ssd is
> implemented.
>
> ssd_spread implies ssd, conflicts nossd.
> ssd conflicts nossd.
> nossd conflicts ssd and ssd_spread.
>
> This patch adds ssd{,_spread} confliction with nossd.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/super.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 8e16bca..2508a16 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -515,19 +515,22 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>   						   compress_type);
>   			}
>   			break;
> -		case Opt_ssd:
> -			btrfs_set_and_info(root, SSD,
> -					   "use ssd allocation scheme");
> -			break;
>   		case Opt_ssd_spread:
>   			btrfs_set_and_info(root, SSD_SPREAD,
>   					   "use spread ssd allocation scheme");
> +			/* suppress the ssd mount option log */
>   			btrfs_set_opt(info->mount_opt, SSD);
> +			/* fall through for other ssd routine */
> +		case Opt_ssd:
> +			btrfs_set_and_info(root, SSD,
> +					   "use ssd allocation scheme");
> +			btrfs_clear_opt(info->mount_opt, NOSSD);
>   			break;
>   		case Opt_nossd:
>   			btrfs_set_and_info(root, NOSSD,
>   					     "not using ssd allocation scheme");
>   			btrfs_clear_opt(info->mount_opt, SSD);
> +			btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
>   			break;
>   		case Opt_barrier:
>   			btrfs_clear_and_info(root, NOBARRIER,

