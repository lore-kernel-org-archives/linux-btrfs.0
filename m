Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46668 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaGDB6e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 21:58:34 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 29C163EE1B0
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 10:58:33 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 27F40AC0A80
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 10:58:32 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id CC1661DB8032
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 10:58:31 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
	by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 7752D328542
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 10:58:29 +0900 (JST)
Message-ID: <53B60A38.9090102@jp.fujitsu.com>
Date: Fri, 4 Jul 2014 10:58:16 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RESEND 4/9] Btrfs: fix put dio bio twice when we submit
 dio bio fail
References: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com> <1404382933-26672-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1404382933-26672-4-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

(2014/07/03 19:22), Miao Xie wrote:
> The caller of btrfs_submit_direct_hook() will put the original dio bio
> when btrfs_submit_direct_hook() return a error number, so we needn't
> put the original bio in btrfs_submit_direct_hook().
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Here is the review result, CMIIW.

call trace:
  btrfs_submit_direct
    -> btrfs_submit_direct_hook

fs/btrfs/inode.c:
===============================================================================
static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
				    int skip_sum)
{
	...
	struct bio *orig_bio = dip->orig_bio;
	...
	map_length = orig_bio->bi_iter.bi_size;
	ret = btrfs_map_block(root->fs_info, rw, start_sector << 9,
			      &map_length, NULL, 0);
	if (ret) {
		bio_put(orig_bio); # (1)
		return -EIO;
	}
	...
}
...
static void btrfs_submit_direct(int rw, struct bio *dio_bio,
				struct inode *inode, loff_t file_offset)
{
	dip = kmalloc(sizeof(*dip) + sum_len, GFP_NOFS);
	if (!dip) {
		ret = -ENOMEM;
		goto free_io_bio; # (2)
	}
	...
	ret = btrfs_submit_direct_hook(rw, dip, skip_sum);
	if (!ret)
		return;

free_io_bio:
	bio_put(io_bio); # (3)
	...
}
===============================================================================

If btrfs_map_block() fails in btrfs_submit_direct_hook(), it put
orig_bio at (1) and return -EIO. Then caller, btrfs_submit_direct()
free the same bio at (3). Since (3) is also used for other error
handling (2), I consider your way, removing (1), is better.

Thanks,
Satoru

> ---
>   fs/btrfs/inode.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a616fa4..15902eb 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7325,10 +7325,8 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
>   	map_length = orig_bio->bi_iter.bi_size;
>   	ret = btrfs_map_block(root->fs_info, rw, start_sector << 9,
>   			      &map_length, NULL, 0);
> -	if (ret) {
> -		bio_put(orig_bio);
> +	if (ret)
>   		return -EIO;
> -	}
>   
>   	if (map_length >= orig_bio->bi_iter.bi_size) {
>   		bio = orig_bio;
> @@ -7345,6 +7343,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
>   	bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev, start_sector, GFP_NOFS);
>   	if (!bio)
>   		return -ENOMEM;
> +
>   	bio->bi_private = dip;
>   	bio->bi_end_io = btrfs_end_dio_bio;
>   	atomic_inc(&dip->pending_bios);
> 

