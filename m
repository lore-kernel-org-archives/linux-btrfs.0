Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31728 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752734AbaLAKwQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 05:52:16 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB1AptSI024041
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Dec 2014 18:51:55 +0800
Message-ID: <547C48C5.3020808@cn.fujitsu.com>
Date: Mon, 1 Dec 2014 18:53:57 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix wrong list access on the failure of reading
 out checksum
References: <1417428253-3139-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1417428253-3139-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please ignore this patch, Chris has fixed this problem.

Thanks
Miao

On Mon, 1 Dec 2014 18:04:13 +0800, Miao Xie wrote:
> If we failed to reading out the checksum, we would free all the checksums
> in the list. But the current code accessed the list head, not the entry
> in the list. Fix it.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/file-item.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 783a943..c26b58f 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -413,7 +413,8 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
>  	ret = 0;
>  fail:
>  	while (ret < 0 && !list_empty(&tmplist)) {
> -		sums = list_entry(&tmplist, struct btrfs_ordered_sum, list);
> +		sums = list_first_entry(&tmplist, struct btrfs_ordered_sum,
> +					list);
>  		list_del(&sums->list);
>  		kfree(sums);
>  	}
> 

