Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab3GKIES (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 04:04:18 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6B84EZl014059
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 16:04:14 +0800
Message-ID: <51DE673A.1050100@cn.fujitsu.com>
Date: Thu, 11 Jul 2013 16:05:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] Btrfs: remove unnecessary argument of bio_readpage_error()
References: <1373520339-13870-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1373520339-13870-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are only 4 patches in this patchset, not 5.
Sorry for my mistake.

Miao

On thu, 11 Jul 2013 13:25:36 +0800, Miao Xie wrote:
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/extent_io.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index f8586a9..4bfbcc5 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2202,8 +2202,7 @@ out:
>   */
>  
>  static int bio_readpage_error(struct bio *failed_bio, struct page *page,
> -				u64 start, u64 end, int failed_mirror,
> -				struct extent_state *state)
> +				u64 start, u64 end, int failed_mirror)
>  {
>  	struct io_failure_record *failrec = NULL;
>  	u64 private;
> @@ -2212,6 +2211,7 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
>  	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
>  	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
>  	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
> +	struct extent_state *state;
>  	struct bio *bio;
>  	int num_copies;
>  	int ret;
> @@ -2297,21 +2297,18 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
>  		 * matter what the error is, it is very likely to persist.
>  		 */
>  		pr_debug("bio_readpage_error: cannot repair, num_copies == 1. "
> -			 "state=%p, num_copies=%d, next_mirror %d, "
> -			 "failed_mirror %d\n", state, num_copies,
> -			 failrec->this_mirror, failed_mirror);
> +			 "num_copies=%d, next_mirror %d, failed_mirror %d\n", 
> +			 num_copies, failrec->this_mirror, failed_mirror);
>  		free_io_failure(inode, failrec, 0);
>  		return -EIO;
>  	}
>  
> -	if (!state) {
> -		spin_lock(&tree->lock);
> -		state = find_first_extent_bit_state(tree, failrec->start,
> -						    EXTENT_LOCKED);
> -		if (state && state->start != failrec->start)
> -			state = NULL;
> -		spin_unlock(&tree->lock);
> -	}
> +	spin_lock(&tree->lock);
> +	state = find_first_extent_bit_state(tree, failrec->start,
> +					    EXTENT_LOCKED);
> +	if (state && state->start != failrec->start)
> +		state = NULL;
> +	spin_unlock(&tree->lock);
>  
>  	/*
>  	 * there are two premises:
> @@ -2541,7 +2538,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
>  			 * can't handle the error it will return -EIO and we
>  			 * remain responsible for that page.
>  			 */
> -			ret = bio_readpage_error(bio, page, start, end, mirror, NULL);
> +			ret = bio_readpage_error(bio, page, start, end, mirror);
>  			if (ret == 0) {
>  				uptodate =
>  					test_bit(BIO_UPTODATE, &bio->bi_flags);
> 

