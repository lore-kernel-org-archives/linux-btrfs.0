Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4272 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S934695AbdCaBSA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 21:18:00 -0400
Subject: Re: [PATCH v3] Btrfs: bring back repair during read
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1490393090-14360-1-git-send-email-bo.li.liu@oracle.com>
 <1490809919-17425-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <aa1fcde6-fc31-d3e1-ea63-98be465b52d1@cn.fujitsu.com>
Date: Fri, 31 Mar 2017 09:17:55 +0800
MIME-Version: 1.0
In-Reply-To: <1490809919-17425-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/30/2017 01:51 AM, Liu Bo wrote:
> Commit 20a7db8ab3f2 ("btrfs: add dummy callback for readpage_io_failed
> and drop checks") made a cleanup around readpage_io_failed_hook, and
> it was supposed to keep the original sematics, but it also
> unexpectedly disabled repair during read for dup, raid1 and raid10.
>
> This fixes the problem by letting data's inode call the generic
> readpage_io_failed callback by returning -EAGAIN from its
> readpage_io_failed_hook in order to notify end_bio_extent_readpage to
> do the rest.  We don't call it directly because the generic one takes
> an offset from end_bio_extent_readpage() to calculate the index in the
> checksum array and inode's readpage_io_failed_hook doesn't offer that
> offset.
>
> Cc: David Sterba <dsterba@suse.cz>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Tested-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

The case can be verified by btrfs/124 test case with compress=lzo.
(Any mount option that affects data extents layout may reproduce it, 
like nospace_cache, inode_cache, nodatacow and compress)

Without the patchset, btrfs/124 fails while with the patchset applied, 
btrfs/124 passes without problem.

Thanks,
Qu
> ---
> v2: fix grammar typos and additional details about the change.
> v3: add back const attribute.
>
>  fs/btrfs/extent_io.c | 46 ++++++++++++++++++++++++++++------------------
>  fs/btrfs/inode.c     |  6 +++---
>  2 files changed, 31 insertions(+), 21 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 28e8192..d39a11c 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2583,26 +2583,36 @@ static void end_bio_extent_readpage(struct bio *bio)
>
>  		if (tree->ops) {
>  			ret = tree->ops->readpage_io_failed_hook(page, mirror);
> -			if (!ret && !bio->bi_error)
> -				uptodate = 1;
> -		} else {
> +			if (ret == -EAGAIN) {
> +				/*
> +				 * Data inode's readpage_io_failed_hook() always
> +				 * returns -EAGAIN.
> +				 *
> +				 * The generic bio_readpage_error handles errors
> +				 * the following way: If possible, new read
> +				 * requests are created and submitted and will
> +				 * end up in end_bio_extent_readpage as well (if
> +				 * we're lucky, not in the !uptodate case). In
> +				 * that case it returns 0 and we just go on with
> +				 * the next page in our bio. If it can't handle
> +				 * the error it will return -EIO and we remain
> +				 * responsible for that page.
> +				 */
> +				ret = bio_readpage_error(bio, offset, page,
> +							 start, end, mirror);
> +				if (ret == 0) {
> +					uptodate = !bio->bi_error;
> +					offset += len;
> +					continue;
> +				}
> +			}
> +
>  			/*
> -			 * The generic bio_readpage_error handles errors the
> -			 * following way: If possible, new read requests are
> -			 * created and submitted and will end up in
> -			 * end_bio_extent_readpage as well (if we're lucky, not
> -			 * in the !uptodate case). In that case it returns 0 and
> -			 * we just go on with the next page in our bio. If it
> -			 * can't handle the error it will return -EIO and we
> -			 * remain responsible for that page.
> +			 * metadata's readpage_io_failed_hook() always returns
> +			 * -EIO and fixes nothing.  -EIO is also returned if
> +			 * data inode error could not be fixed.
>  			 */
> -			ret = bio_readpage_error(bio, offset, page, start, end,
> -						 mirror);
> -			if (ret == 0) {
> -				uptodate = !bio->bi_error;
> -				offset += len;
> -				continue;
> -			}
> +			ASSERT(ret == -EIO);
>  		}
>  readpage_ok:
>  		if (likely(uptodate)) {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index c40060c..4296cae 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -10509,9 +10509,9 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
>  }
>
>  __attribute__((const))
> -static int dummy_readpage_io_failed_hook(struct page *page, int failed_mirror)
> +static int btrfs_readpage_io_failed_hook(struct page *page, int failed_mirror)
>  {
> -	return 0;
> +	return -EAGAIN;
>  }
>
>  static const struct inode_operations btrfs_dir_inode_operations = {
> @@ -10556,7 +10556,7 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
>  	.submit_bio_hook = btrfs_submit_bio_hook,
>  	.readpage_end_io_hook = btrfs_readpage_end_io_hook,
>  	.merge_bio_hook = btrfs_merge_bio_hook,
> -	.readpage_io_failed_hook = dummy_readpage_io_failed_hook,
> +	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
>
>  	/* optional callbacks */
>  	.fill_delalloc = run_delalloc_range,
>


