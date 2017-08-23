Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43544 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932109AbdHWRO7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 13:14:59 -0400
Date: Wed, 23 Aug 2017 10:13:40 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/7] Btrfs: fix blk_status_t/errno confusion
Message-ID: <20170823161340.GA1522@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <cover.1503470354.git.osandov@fb.com>
 <f67c635fab2edc4212f0a30cdb0dfe709f1583f0.1503470354.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f67c635fab2edc4212f0a30cdb0dfe709f1583f0.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 22, 2017 at 11:45:59PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> This fixes several instances of blk_status_t and bare errno ints being
> mixed up, some of which are real bugs.
> 
> Fixes: 4e4cbee93d56 ("block: switch bios to blk_status_t")
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/disk-io.c |  4 ++--
>  fs/btrfs/inode.c   | 70 +++++++++++++++++++++++++++++-------------------------
>  fs/btrfs/raid56.c  | 34 +++++++++++++-------------
>  fs/btrfs/volumes.c | 10 ++++----
>  fs/btrfs/volumes.h |  6 ++---
>  5 files changed, 64 insertions(+), 60 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 080e2ebb8aa0..f45b61fe9a9a 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3516,7 +3516,7 @@ static blk_status_t wait_dev_flush(struct btrfs_device *device)
>  	struct bio *bio = device->flush_bio;
>  
>  	if (!device->flush_bio_sent)
> -		return 0;
> +		return BLK_STS_OK;
>  
>  	device->flush_bio_sent = 0;
>  	wait_for_completion_io(&device->flush_wait);
> @@ -3563,7 +3563,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  			continue;
>  
>  		write_dev_flush(dev);
> -		dev->last_flush_error = 0;
> +		dev->last_flush_error = BLK_STS_OK;
>  	}
>  
>  	/* wait for all the barriers */
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 95c212037095..24bcd5cd9cf2 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7924,11 +7924,12 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>  	return ret;
>  }
>  
> -static inline int submit_dio_repair_bio(struct inode *inode, struct bio *bio,
> -					int mirror_num)
> +static inline blk_status_t submit_dio_repair_bio(struct inode *inode,
> +						 struct bio *bio,
> +						 int mirror_num)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> -	int ret;
> +	blk_status_t ret;
>  
>  	BUG_ON(bio_op(bio) == REQ_OP_WRITE);
>

In this function, there is btrfs_map_bio() who returns 0 or error
code, errno_to_blk_status() is also needed for that conversion.

With that,

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> @@ -7980,10 +7981,10 @@ static int btrfs_check_dio_repairable(struct inode *inode,
>  	return 1;
>  }
>  
> -static int dio_read_error(struct inode *inode, struct bio *failed_bio,
> -			struct page *page, unsigned int pgoff,
> -			u64 start, u64 end, int failed_mirror,
> -			bio_end_io_t *repair_endio, void *repair_arg)
> +static blk_status_t dio_read_error(struct inode *inode, struct bio *failed_bio,
> +				   struct page *page, unsigned int pgoff,
> +				   u64 start, u64 end, int failed_mirror,
> +				   bio_end_io_t *repair_endio, void *repair_arg)
>  {
>  	struct io_failure_record *failrec;
>  	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
> @@ -7993,18 +7994,19 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
>  	int read_mode = 0;
>  	int segs;
>  	int ret;
> +	blk_status_t status;
>  
>  	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
>  
>  	ret = btrfs_get_io_failure_record(inode, start, end, &failrec);
>  	if (ret)
> -		return ret;
> +		return errno_to_blk_status(ret);
>  
>  	ret = btrfs_check_dio_repairable(inode, failed_bio, failrec,
>  					 failed_mirror);
>  	if (!ret) {
>  		free_io_failure(failure_tree, io_tree, failrec);
> -		return -EIO;
> +		return BLK_STS_IOERR;
>  	}
>  
>  	segs = bio_segments(failed_bio);
> @@ -8022,13 +8024,13 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
>  		    "Repair DIO Read Error: submitting new dio read[%#x] to this_mirror=%d, in_validation=%d\n",
>  		    read_mode, failrec->this_mirror, failrec->in_validation);
>  
> -	ret = submit_dio_repair_bio(inode, bio, failrec->this_mirror);
> -	if (ret) {
> +	status = submit_dio_repair_bio(inode, bio, failrec->this_mirror);
> +	if (status) {
>  		free_io_failure(failure_tree, io_tree, failrec);
>  		bio_put(bio);
>  	}
>  
> -	return ret;
> +	return status;
>  }
>  
>  struct btrfs_retry_complete {
> @@ -8065,8 +8067,8 @@ static void btrfs_retry_endio_nocsum(struct bio *bio)
>  	bio_put(bio);
>  }
>  
> -static int __btrfs_correct_data_nocsum(struct inode *inode,
> -				       struct btrfs_io_bio *io_bio)
> +static blk_status_t __btrfs_correct_data_nocsum(struct inode *inode,
> +						struct btrfs_io_bio *io_bio)
>  {
>  	struct btrfs_fs_info *fs_info;
>  	struct bio_vec bvec;
> @@ -8076,8 +8078,8 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
>  	unsigned int pgoff;
>  	u32 sectorsize;
>  	int nr_sectors;
> -	int ret;
> -	int err = 0;
> +	blk_status_t ret;
> +	blk_status_t err = BLK_STS_OK;
>  
>  	fs_info = BTRFS_I(inode)->root->fs_info;
>  	sectorsize = fs_info->sectorsize;
> @@ -8183,11 +8185,12 @@ static blk_status_t __btrfs_subio_endio_read(struct inode *inode,
>  	int csum_pos;
>  	bool uptodate = (err == 0);
>  	int ret;
> +	blk_status_t status;
>  
>  	fs_info = BTRFS_I(inode)->root->fs_info;
>  	sectorsize = fs_info->sectorsize;
>  
> -	err = 0;
> +	err = BLK_STS_OK;
>  	start = io_bio->logical;
>  	done.inode = inode;
>  	io_bio->bio.bi_iter = io_bio->iter;
> @@ -8209,12 +8212,12 @@ static blk_status_t __btrfs_subio_endio_read(struct inode *inode,
>  		done.start = start;
>  		init_completion(&done.done);
>  
> -		ret = dio_read_error(inode, &io_bio->bio, bvec.bv_page,
> -				pgoff, start, start + sectorsize - 1,
> -				io_bio->mirror_num,
> -				btrfs_retry_endio, &done);
> -		if (ret) {
> -			err = errno_to_blk_status(ret);
> +		status = dio_read_error(inode, &io_bio->bio, bvec.bv_page,
> +					pgoff, start, start + sectorsize - 1,
> +					io_bio->mirror_num, btrfs_retry_endio,
> +					&done);
> +		if (status) {
> +			err = status;
>  			goto next;
>  		}
>  
> @@ -8250,7 +8253,7 @@ static blk_status_t btrfs_subio_endio_read(struct inode *inode,
>  		if (unlikely(err))
>  			return __btrfs_correct_data_nocsum(inode, io_bio);
>  		else
> -			return 0;
> +			return BLK_STS_OK;
>  	} else {
>  		return __btrfs_subio_endio_read(inode, io_bio, err);
>  	}
> @@ -8423,9 +8426,9 @@ static inline blk_status_t btrfs_lookup_and_bind_dio_csum(struct inode *inode,
>  	return 0;
>  }
>  
> -static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
> -					 u64 file_offset, int skip_sum,
> -					 int async_submit)
> +static inline blk_status_t
> +__btrfs_submit_dio_bio(struct bio *bio, struct inode *inode, u64 file_offset,
> +		       int skip_sum, int async_submit)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  	struct btrfs_dio_private *dip = bio->bi_private;
> @@ -8488,6 +8491,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
>  	int clone_offset = 0;
>  	int clone_len;
>  	int ret;
> +	blk_status_t status;
>  
>  	map_length = orig_bio->bi_iter.bi_size;
>  	submit_len = map_length;
> @@ -8537,9 +8541,9 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
>  		 */
>  		atomic_inc(&dip->pending_bios);
>  
> -		ret = __btrfs_submit_dio_bio(bio, inode, file_offset, skip_sum,
> -					     async_submit);
> -		if (ret) {
> +		status = __btrfs_submit_dio_bio(bio, inode, file_offset, skip_sum,
> +						async_submit);
> +		if (status) {
>  			bio_put(bio);
>  			atomic_dec(&dip->pending_bios);
>  			goto out_err;
> @@ -8557,9 +8561,9 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
>  	} while (submit_len > 0);
>  
>  submit:
> -	ret = __btrfs_submit_dio_bio(bio, inode, file_offset, skip_sum,
> -				     async_submit);
> -	if (!ret)
> +	status = __btrfs_submit_dio_bio(bio, inode, file_offset, skip_sum,
> +					async_submit);
> +	if (!status)
>  		return 0;
>  
>  	bio_put(bio);
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 208638384cd2..2cf6ba40f7c4 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -905,7 +905,7 @@ static void raid_write_end_io(struct bio *bio)
>  	if (!atomic_dec_and_test(&rbio->stripes_pending))
>  		return;
>  
> -	err = 0;
> +	err = BLK_STS_OK;
>  
>  	/* OK, we have read all the stripes we need to. */
>  	max_errors = (rbio->operation == BTRFS_RBIO_PARITY_SCRUB) ?
> @@ -1324,7 +1324,7 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
>  	return;
>  
>  cleanup:
> -	rbio_orig_end_io(rbio, -EIO);
> +	rbio_orig_end_io(rbio, BLK_STS_IOERR);
>  }
>  
>  /*
> @@ -1475,7 +1475,7 @@ static void raid_rmw_end_io(struct bio *bio)
>  
>  cleanup:
>  
> -	rbio_orig_end_io(rbio, -EIO);
> +	rbio_orig_end_io(rbio, BLK_STS_IOERR);
>  }
>  
>  static void async_rmw_stripe(struct btrfs_raid_bio *rbio)
> @@ -1579,7 +1579,7 @@ static int raid56_rmw_stripe(struct btrfs_raid_bio *rbio)
>  	return 0;
>  
>  cleanup:
> -	rbio_orig_end_io(rbio, -EIO);
> +	rbio_orig_end_io(rbio, BLK_STS_IOERR);
>  	return -EIO;
>  
>  finish:
> @@ -1795,12 +1795,12 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
>  	void **pointers;
>  	int faila = -1, failb = -1;
>  	struct page *page;
> -	int err;
> +	blk_status_t err;
>  	int i;
>  
>  	pointers = kcalloc(rbio->real_stripes, sizeof(void *), GFP_NOFS);
>  	if (!pointers) {
> -		err = -ENOMEM;
> +		err = BLK_STS_RESOURCE;
>  		goto cleanup_io;
>  	}
>  
> @@ -1856,7 +1856,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
>  					 * a bad data or Q stripe.
>  					 * TODO, we should redo the xor here.
>  					 */
> -					err = -EIO;
> +					err = BLK_STS_IOERR;
>  					goto cleanup;
>  				}
>  				/*
> @@ -1882,7 +1882,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
>  			if (rbio->bbio->raid_map[failb] == RAID6_Q_STRIPE) {
>  				if (rbio->bbio->raid_map[faila] ==
>  				    RAID5_P_STRIPE) {
> -					err = -EIO;
> +					err = BLK_STS_IOERR;
>  					goto cleanup;
>  				}
>  				/*
> @@ -1954,13 +1954,13 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
>  		}
>  	}
>  
> -	err = 0;
> +	err = BLK_STS_OK;
>  cleanup:
>  	kfree(pointers);
>  
>  cleanup_io:
>  	if (rbio->operation == BTRFS_RBIO_READ_REBUILD) {
> -		if (err == 0)
> +		if (err == BLK_STS_OK)
>  			cache_rbio_pages(rbio);
>  		else
>  			clear_bit(RBIO_CACHE_READY_BIT, &rbio->flags);
> @@ -1968,7 +1968,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
>  		rbio_orig_end_io(rbio, err);
>  	} else if (rbio->operation == BTRFS_RBIO_REBUILD_MISSING) {
>  		rbio_orig_end_io(rbio, err);
> -	} else if (err == 0) {
> +	} else if (err == BLK_STS_OK) {
>  		rbio->faila = -1;
>  		rbio->failb = -1;
>  
> @@ -2005,7 +2005,7 @@ static void raid_recover_end_io(struct bio *bio)
>  		return;
>  
>  	if (atomic_read(&rbio->error) > rbio->bbio->max_errors)
> -		rbio_orig_end_io(rbio, -EIO);
> +		rbio_orig_end_io(rbio, BLK_STS_IOERR);
>  	else
>  		__raid_recover_end_io(rbio);
>  }
> @@ -2104,7 +2104,7 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
>  cleanup:
>  	if (rbio->operation == BTRFS_RBIO_READ_REBUILD ||
>  	    rbio->operation == BTRFS_RBIO_REBUILD_MISSING)
> -		rbio_orig_end_io(rbio, -EIO);
> +		rbio_orig_end_io(rbio, BLK_STS_IOERR);
>  	return -EIO;
>  }
>  
> @@ -2431,7 +2431,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
>  	nr_data = bio_list_size(&bio_list);
>  	if (!nr_data) {
>  		/* Every parity is right */
> -		rbio_orig_end_io(rbio, 0);
> +		rbio_orig_end_io(rbio, BLK_STS_OK);
>  		return;
>  	}
>  
> @@ -2451,7 +2451,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
>  	return;
>  
>  cleanup:
> -	rbio_orig_end_io(rbio, -EIO);
> +	rbio_orig_end_io(rbio, BLK_STS_IOERR);
>  }
>  
>  static inline int is_data_stripe(struct btrfs_raid_bio *rbio, int stripe)
> @@ -2519,7 +2519,7 @@ static void validate_rbio_for_parity_scrub(struct btrfs_raid_bio *rbio)
>  	return;
>  
>  cleanup:
> -	rbio_orig_end_io(rbio, -EIO);
> +	rbio_orig_end_io(rbio, BLK_STS_IOERR);
>  }
>  
>  /*
> @@ -2633,7 +2633,7 @@ static void raid56_parity_scrub_stripe(struct btrfs_raid_bio *rbio)
>  	return;
>  
>  cleanup:
> -	rbio_orig_end_io(rbio, -EIO);
> +	rbio_orig_end_io(rbio, BLK_STS_IOERR);
>  	return;
>  
>  finish:
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e8b9a269fdde..bd679bc7a1a9 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6212,8 +6212,8 @@ static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
>  	}
>  }
>  
> -int btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
> -		  int mirror_num, int async_submit)
> +blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
> +			   int mirror_num, int async_submit)
>  {
>  	struct btrfs_device *dev;
>  	struct bio *first_bio = bio;
> @@ -6233,7 +6233,7 @@ int btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
>  				&map_length, &bbio, mirror_num, 1);
>  	if (ret) {
>  		btrfs_bio_counter_dec(fs_info);
> -		return ret;
> +		return errno_to_blk_status(ret);
>  	}
>  
>  	total_devs = bbio->num_stripes;
> @@ -6256,7 +6256,7 @@ int btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
>  		}
>  
>  		btrfs_bio_counter_dec(fs_info);
> -		return ret;
> +		return errno_to_blk_status(ret);
>  	}
>  
>  	if (map_length < length) {
> @@ -6283,7 +6283,7 @@ int btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
>  				  dev_nr, async_submit);
>  	}
>  	btrfs_bio_counter_dec(fs_info);
> -	return 0;
> +	return BLK_STS_OK;
>  }
>  
>  struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 6f45fd60d15a..93277fc60930 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -74,7 +74,7 @@ struct btrfs_device {
>  	int missing;
>  	int can_discard;
>  	int is_tgtdev_for_dev_replace;
> -	int last_flush_error;
> +	blk_status_t last_flush_error;
>  	int flush_bio_sent;
>  
>  #ifdef __BTRFS_NEED_DEVICE_DATA_ORDERED
> @@ -416,8 +416,8 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  		      struct btrfs_fs_info *fs_info, u64 type);
>  void btrfs_mapping_init(struct btrfs_mapping_tree *tree);
>  void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree);
> -int btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
> -		  int mirror_num, int async_submit);
> +blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
> +			   int mirror_num, int async_submit);
>  int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  		       fmode_t flags, void *holder);
>  int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
