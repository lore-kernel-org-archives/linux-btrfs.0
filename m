Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50863 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946006AbbHGSrR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Aug 2015 14:47:17 -0400
Message-ID: <55C4FD23.5060500@fb.com>
Date: Fri, 7 Aug 2015 14:46:59 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <chandan@mykolab.com>, <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH V2 03/11] Btrfs: Direct I/O read: Work on sectorsized
 blocks
References: <1438931158-20888-1-git-send-email-chandan@linux.vnet.ibm.com> <1438931158-20888-4-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1438931158-20888-4-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/07/2015 03:05 AM, Chandan Rajendra wrote:
> The direct I/O read's endio and corresponding repair functions work on
> page sized blocks. This commit adds the ability for direct I/O read to work on
> subpagesized blocks.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>   fs/btrfs/inode.c | 96 ++++++++++++++++++++++++++++++++++++++++++--------------
>   1 file changed, 73 insertions(+), 23 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e33dff3..ff8b699 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7630,9 +7630,9 @@ static int btrfs_check_dio_repairable(struct inode *inode,
>   }
>
>   static int dio_read_error(struct inode *inode, struct bio *failed_bio,
> -			  struct page *page, u64 start, u64 end,
> -			  int failed_mirror, bio_end_io_t *repair_endio,
> -			  void *repair_arg)
> +			struct page *page, unsigned int pgoff,
> +			u64 start, u64 end, int failed_mirror,
> +			bio_end_io_t *repair_endio, void *repair_arg)
>   {
>   	struct io_failure_record *failrec;
>   	struct bio *bio;
> @@ -7653,7 +7653,9 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
>   		return -EIO;
>   	}
>
> -	if (failed_bio->bi_vcnt > 1)
> +	if ((failed_bio->bi_vcnt > 1)
> +		|| (failed_bio->bi_io_vec->bv_len
> +			> BTRFS_I(inode)->root->sectorsize))
>   		read_mode = READ_SYNC | REQ_FAILFAST_DEV;
>   	else
>   		read_mode = READ_SYNC;
> @@ -7661,7 +7663,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
>   	isector = start - btrfs_io_bio(failed_bio)->logical;
>   	isector >>= inode->i_sb->s_blocksize_bits;
>   	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
> -				      0, isector, repair_endio, repair_arg);
> +				pgoff, isector, repair_endio, repair_arg);
>   	if (!bio) {
>   		free_io_failure(inode, failrec);
>   		return -EIO;
> @@ -7691,12 +7693,17 @@ struct btrfs_retry_complete {
>   static void btrfs_retry_endio_nocsum(struct bio *bio, int err)
>   {
>   	struct btrfs_retry_complete *done = bio->bi_private;
> +	struct inode *inode;
>   	struct bio_vec *bvec;
>   	int i;
>
>   	if (err)
>   		goto end;
>
> +	BUG_ON(bio->bi_vcnt != 1);

Let's use ASSERT() instead of BUG_ON() for logic errors that developers 
should catch.  Thanks,

Josef
