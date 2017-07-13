Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31787 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751267AbdGMQkF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 12:40:05 -0400
Date: Thu, 13 Jul 2017 09:37:25 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: cloned bios must not be iterated by
 bio_for_each_segment_all
Message-ID: <20170713163725.GC12913@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170713161536.25100-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170713161536.25100-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 06:15:36PM +0200, David Sterba wrote:
> We've started using cloned bios more in 4.13, there are some specifics
> regarding the iteration.  Filipe found [1] that the raid56 iterated a
> cloned bio using bio_for_each_segment_all, which is incorrect. The
> cloned bios have wrong bi_vcnt and this could lead to silent
> corruptions.  This patch adds assertions to all remaining
> bio_for_each_segment_all cases.
> 
> [1] https://patchwork.kernel.org/patch/9838535/
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo

> CC: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/compression.c | 1 +
>  fs/btrfs/disk-io.c     | 1 +
>  fs/btrfs/extent_io.c   | 3 +++
>  fs/btrfs/inode.c       | 2 ++
>  4 files changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index fcd323eceb5b..8ba1b86c9b72 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -152,6 +152,7 @@ static void end_compressed_bio_read(struct bio *bio)
>  		 * we have verified the checksum already, set page
>  		 * checked so the end_io handlers know about it
>  		 */
> +		ASSERT(!bio_flagged(bio, BIO_CLONED));
>  		bio_for_each_segment_all(bvec, cb->orig_bio, i)
>  			SetPageChecked(bvec->bv_page);
>  
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 1a2e0b43ef2a..f1ed7e490fca 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -964,6 +964,7 @@ static int btree_csum_one_bio(struct bio *bio)
>  	struct btrfs_root *root;
>  	int i, ret = 0;
>  
> +	ASSERT(!bio_flagged(bio, BIO_CLONED));
>  	bio_for_each_segment_all(bvec, bio, i) {
>  		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
>  		ret = csum_dirty_buffer(root->fs_info, bvec->bv_page);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 9a213ed5b074..8aedcbb55da2 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2451,6 +2451,7 @@ static void end_bio_extent_writepage(struct bio *bio)
>  	u64 end;
>  	int i;
>  
> +	ASSERT(!bio_flagged(bio, BIO_CLONED));
>  	bio_for_each_segment_all(bvec, bio, i) {
>  		struct page *page = bvec->bv_page;
>  		struct inode *inode = page->mapping->host;
> @@ -2521,6 +2522,7 @@ static void end_bio_extent_readpage(struct bio *bio)
>  	int ret;
>  	int i;
>  
> +	ASSERT(!bio_flagged(bio, BIO_CLONED));
>  	bio_for_each_segment_all(bvec, bio, i) {
>  		struct page *page = bvec->bv_page;
>  		struct inode *inode = page->mapping->host;
> @@ -3674,6 +3676,7 @@ static void end_bio_extent_buffer_writepage(struct bio *bio)
>  	struct extent_buffer *eb;
>  	int i, done;
>  
> +	ASSERT(!bio_flagged(bio, BIO_CLONED));
>  	bio_for_each_segment_all(bvec, bio, i) {
>  		struct page *page = bvec->bv_page;
>  
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 6b3b7152cb6c..d97579891670 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8058,6 +8058,7 @@ static void btrfs_retry_endio_nocsum(struct bio *bio)
>  	ASSERT(bio->bi_io_vec->bv_len == btrfs_inode_sectorsize(inode));
>  
>  	done->uptodate = 1;
> +	ASSERT(!bio_flagged(bio, BIO_CLONED));
>  	bio_for_each_segment_all(bvec, bio, i)
>  		clean_io_failure(BTRFS_I(inode)->root->fs_info, failure_tree,
>  				 io_tree, done->start, bvec->bv_page,
> @@ -8149,6 +8150,7 @@ static void btrfs_retry_endio(struct bio *bio)
>  	io_tree = &BTRFS_I(inode)->io_tree;
>  	failure_tree = &BTRFS_I(inode)->io_failure_tree;
>  
> +	ASSERT(!bio_flagged(bio, BIO_CLONED));
>  	bio_for_each_segment_all(bvec, bio, i) {
>  		ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
>  					     bvec->bv_offset, done->start,
> -- 
> 2.13.0
> 
