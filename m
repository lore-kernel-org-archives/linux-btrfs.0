Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32822 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbbAEIVI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 03:21:08 -0500
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 163E33EE0BB
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 17:21:07 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 2C8D4AC03B0
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 17:21:06 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id CC0A2E08005
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 17:21:05 +0900 (JST)
Received: from G01JPEXCHKW14.g01.fujitsu.local (G01JPEXCHKW14.g01.fujitsu.local [10.0.194.53])
	by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id ED26E32849E
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Jan 2015 17:21:04 +0900 (JST)
Message-ID: <54AA4953.3080703@jp.fujitsu.com>
Date: Mon, 5 Jan 2015 17:20:35 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Fix a extent buffer leak in count_csum_range().
References: <1420444575-23259-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1420444575-23259-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/01/05 16:56, Qu Wenruo wrote:
> The commit f495a2ac6611 ("btrfs-progs: fsck: remove unfriendly BUG_ON()
> for searching tree failure") is causing tons of extent buffer leak if some
> csum mismatches in btrfsck.
> 
> This is caused by a misplaced btrfs_release_path(), fix it.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   cmds-check.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index d2d218a..5b644cf 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -1186,9 +1186,9 @@ static int count_csum_range(struct btrfs_root *root, u64 start,
>   		path.slots[0]++;
>   	}
>   out:
> +	btrfs_release_path(&path);
>   	if (ret < 0)
>   		return ret;
> -	btrfs_release_path(&path);
>   	return 0;
>   }
>   
> 

