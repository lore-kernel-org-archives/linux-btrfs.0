Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39313 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbaHGKhh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Aug 2014 06:37:37 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 407593EE158
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Aug 2014 19:37:36 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 51138AC0945
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Aug 2014 19:37:35 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 05BC9E08005
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Aug 2014 19:37:35 +0900 (JST)
Received: from G01JPEXCHKW16.g01.fujitsu.local (G01JPEXCHKW16.g01.fujitsu.local [10.0.194.55])
	by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 2484B328497
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Aug 2014 19:37:34 +0900 (JST)
Message-ID: <53E356E6.3070705@jp.fujitsu.com>
Date: Thu, 7 Aug 2014 19:37:26 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: SSD related mount option dependency rework.
References: <1406863651-11042-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1406863651-11042-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

(2014/08/01 12:27), Qu Wenruo wrote:
> According to Documentations/filesystem/btrfs.txt, ssd/ssd_spread/nossd
> has their own dependency(See below), but only ssd_spread implying ssd is
> implemented.
> 
> ssd_spread implies ssd, conflicts nossd.
> ssd conflicts nossd.
> nossd conflicts ssd and ssd_spread.
> 
> This patch adds ssd{,_spread} confliction with nossd.

How about write down above-mentioned dependencies in
Documentations/filesystem/btrfs.txt too?

Thanks,
Satoru

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
> 

