Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18626 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbbGAOpY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 10:45:24 -0400
Date: Wed, 1 Jul 2015 22:45:00 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V11 09/21] Btrfs: subpagesize-blocksize: Direct I/O
 read: Work on sectorsized blocks.
Message-ID: <20150701144459.GD7847@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1433172176-8742-10-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433172176-8742-10-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 01, 2015 at 08:52:44PM +0530, Chandan Rajendra wrote:
> The direct I/O read's endio and corresponding repair functions work on
> page sized blocks. Fix this.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/btrfs/inode.c | 94 ++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 71 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ac6a3f3..958e4e6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7643,9 +7643,9 @@ static int btrfs_check_dio_repairable(struct inode *inode,
>  }
>  
>  static int dio_read_error(struct inode *inode, struct bio *failed_bio,
> -			  struct page *page, u64 start, u64 end,
> -			  int failed_mirror, bio_end_io_t *repair_endio,
> -			  void *repair_arg)
> +			struct page *page, unsigned int pgoff,
> +			u64 start, u64 end, int failed_mirror,
> +			bio_end_io_t *repair_endio, void *repair_arg)
>  {
>  	struct io_failure_record *failrec;
>  	struct bio *bio;
> @@ -7666,7 +7666,9 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
>  		return -EIO;
>  	}
>  
> -	if (failed_bio->bi_vcnt > 1)
> +	if ((failed_bio->bi_vcnt > 1)
> +		|| (failed_bio->bi_io_vec->bv_len
> +			> BTRFS_I(inode)->root->sectorsize))
>  		read_mode = READ_SYNC | REQ_FAILFAST_DEV;
>  	else
>  		read_mode = READ_SYNC;
> @@ -7674,7 +7676,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
>  	isector = start - btrfs_io_bio(failed_bio)->logical;
>  	isector >>= inode->i_sb->s_blocksize_bits;
>  	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
> -				      0, isector, repair_endio, repair_arg);
> +				pgoff, isector, repair_endio, repair_arg);
>  	if (!bio) {
>  		free_io_failure(inode, failrec);
>  		return -EIO;
> @@ -7704,12 +7706,17 @@ struct btrfs_retry_complete {
>  static void btrfs_retry_endio_nocsum(struct bio *bio, int err)
>  {
>  	struct btrfs_retry_complete *done = bio->bi_private;
> +	struct inode *inode;
>  	struct bio_vec *bvec;
>  	int i;
>  
>  	if (err)
>  		goto end;
>  
> +	BUG_ON(bio->bi_vcnt != 1);
> +	inode = bio->bi_io_vec->bv_page->mapping->host;
> +	BUG_ON(bio->bi_io_vec->bv_len != BTRFS_I(inode)->root->sectorsize);
> +
>  	done->uptodate = 1;
>  	bio_for_each_segment_all(bvec, bio, i)
>  		clean_io_failure(done->inode, done->start, bvec->bv_page, 0);
> @@ -7724,22 +7731,30 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
>  	struct bio_vec *bvec;
>  	struct btrfs_retry_complete done;
>  	u64 start;
> +	unsigned int pgoff;
> +	u32 sectorsize;
> +	int nr_sectors;
>  	int i;
>  	int ret;
>  
> +	sectorsize = BTRFS_I(inode)->root->sectorsize;
> +
>  	start = io_bio->logical;
>  	done.inode = inode;
>  
>  	bio_for_each_segment_all(bvec, &io_bio->bio, i) {
> -try_again:
> +		nr_sectors = bvec->bv_len >> inode->i_sb->s_blocksize_bits;
> +		pgoff = bvec->bv_offset;
> +
> +next_block_or_try_again:
>  		done.uptodate = 0;
>  		done.start = start;
>  		init_completion(&done.done);
>  
> -		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page, start,
> -				     start + bvec->bv_len - 1,
> -				     io_bio->mirror_num,
> -				     btrfs_retry_endio_nocsum, &done);
> +		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page,
> +				pgoff, start, start + sectorsize - 1,
> +				io_bio->mirror_num,
> +				btrfs_retry_endio_nocsum, &done);
>  		if (ret)
>  			return ret;
>  
> @@ -7747,10 +7762,15 @@ try_again:
>  
>  		if (!done.uptodate) {
>  			/* We might have another mirror, so try again */
> -			goto try_again;
> +			goto next_block_or_try_again;
>  		}
>  
> -		start += bvec->bv_len;
> +		start += sectorsize;
> +
> +		if (nr_sectors--) {
> +			pgoff += sectorsize;
> +			goto next_block_or_try_again;
> +		}
>  	}
>  
>  	return 0;
> @@ -7760,7 +7780,9 @@ static void btrfs_retry_endio(struct bio *bio, int err)
>  {
>  	struct btrfs_retry_complete *done = bio->bi_private;
>  	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
> +	struct inode * inode;
>  	struct bio_vec *bvec;
> +	u64 start;
>  	int uptodate;
>  	int ret;
>  	int i;
> @@ -7769,13 +7791,20 @@ static void btrfs_retry_endio(struct bio *bio, int err)
>  		goto end;
>  
>  	uptodate = 1;
> +
> +	start = done->start;
> +
> +	BUG_ON(bio->bi_vcnt != 1);
> +	inode = bio->bi_io_vec->bv_page->mapping->host;
> +	BUG_ON(bio->bi_io_vec->bv_len != BTRFS_I(inode)->root->sectorsize);
> +
>  	bio_for_each_segment_all(bvec, bio, i) {
>  		ret = __readpage_endio_check(done->inode, io_bio, i,
> -					     bvec->bv_page, 0,
> -					     done->start, bvec->bv_len);
> +					bvec->bv_page, bvec->bv_offset,
> +					done->start, bvec->bv_len);
>  		if (!ret)
>  			clean_io_failure(done->inode, done->start,
> -					 bvec->bv_page, 0);
> +					bvec->bv_page, bvec->bv_offset);
>  		else
>  			uptodate = 0;
>  	}
> @@ -7793,16 +7822,30 @@ static int __btrfs_subio_endio_read(struct inode *inode,
>  	struct btrfs_retry_complete done;
>  	u64 start;
>  	u64 offset = 0;
> +	u32 sectorsize;
> +	int nr_sectors;
> +	unsigned int pgoff;
> +	int csum_pos;
>  	int i;
>  	int ret;
> +	unsigned char blocksize_bits;
> +
> +	blocksize_bits = inode->i_sb->s_blocksize_bits;
> +	sectorsize = BTRFS_I(inode)->root->sectorsize;
>  
>  	err = 0;
>  	start = io_bio->logical;
>  	done.inode = inode;
>  
>  	bio_for_each_segment_all(bvec, &io_bio->bio, i) {
> -		ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
> -					     0, start, bvec->bv_len);
> +		nr_sectors = bvec->bv_len >> blocksize_bits;
> +		pgoff = bvec->bv_offset;
> +next_block:
> +		csum_pos = offset >> blocksize_bits;
> +
> +		ret = __readpage_endio_check(inode, io_bio, csum_pos,
> +					bvec->bv_page, pgoff, start,
> +					sectorsize);
>  		if (likely(!ret))
>  			goto next;
>  try_again:
> @@ -7810,10 +7853,10 @@ try_again:
>  		done.start = start;
>  		init_completion(&done.done);
>  
> -		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page, start,
> -				     start + bvec->bv_len - 1,
> -				     io_bio->mirror_num,
> -				     btrfs_retry_endio, &done);
> +		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page,
> +				pgoff, start, start + sectorsize - 1,
> +				io_bio->mirror_num,
> +				btrfs_retry_endio, &done);
>  		if (ret) {
>  			err = ret;
>  			goto next;
> @@ -7826,8 +7869,13 @@ try_again:
>  			goto try_again;
>  		}
>  next:
> -		offset += bvec->bv_len;
> -		start += bvec->bv_len;
> +		offset += sectorsize;
> +		start += sectorsize;
> +

It'd better to put a ASSERT(nr_sectors) in case some crazy things
happen.

Thanks,

-liubo
> +		if (--nr_sectors) {
> +			pgoff += sectorsize;
> +			goto next_block;
> +		}
>  	}
>  
>  	return err;
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
