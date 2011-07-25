From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [RFC PATCH 4/4] btrfs: Moved repair code from inode.c to extent_io.c
Date: Mon, 25 Jul 2011 10:59:19 +0200
Message-ID: <4E2D3067.70007@jan-o-sch.net>
References: <cover.1311344751.git.list.btrfs@jan-o-sch.net>	 <31a5f07325d66bd6691673eafee2c242afd8b833.1311344751.git.list.btrfs@jan-o-sch.net> <1311566280.3401.15.camel@perseus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311566280.3401.15.camel@perseus.themaw.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 25.07.2011 05:58, Ian Kent wrote:
> On Fri, 2011-07-22 at 16:58 +0200, Jan Schmidt wrote:
>> +static int bio_readpage_error(struct bio *failed_bio, struct page *page,
>> +				u64 start, u64 end, int failed_mirror,
>> +				struct extent_state *state)
>> +{
>> +	struct io_failure_record *failrec = NULL;
>> +	u64 private;
>> +	struct extent_map *em;
>> +	struct inode *inode = page->mapping->host;
>> +	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
>> +	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
>> +	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
>> +	struct bio *bio;
>> +	int num_copies;
>> +	int ret;
>> +	int read_mode;
>> +	u64 logical;
>> +
>> +	BUG_ON(failed_bio->bi_rw & REQ_WRITE);
>> +
>> +	ret = get_state_private(failure_tree, start, &private);
>> +	if (ret) {
>> +		failrec = kzalloc(sizeof(*failrec), GFP_NOFS);
>> +		if (!failrec)
>> +			return -ENOMEM;
>> +		failrec->start = start;
>> +		failrec->len = end - start + 1;
>> +		failrec->this_mirror = 0;
>> +		failrec->bio_flags = 0;
>> +		failrec->in_validation = 0;
>> +
>> +		read_lock(&em_tree->lock);
>> +		em = lookup_extent_mapping(em_tree, start, failrec->len);
>> +		if (!em) {
> 
> Looks like a missing "read_unlock(&em_tree->lock);" here to me?

Thanks, will be fixed in next version.

-Jan

>> +			kfree(failrec);
>> +			return -EIO;
>> +		}
>> +
>> +		if (em->start > start || em->start + em->len < start) {
>> +			free_extent_map(em);
>> +			em = NULL;
>> +		}
>> +		read_unlock(&em_tree->lock);
>> +
>> +		if (!em || IS_ERR(em)) {
>> +			kfree(failrec);
>> +			return -EIO;
>> +		}
>> +		logical = start - em->start;
>> +		logical = em->block_start + logical;
>> +		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
>> +			logical = em->block_start;
>> +			failrec->bio_flags = EXTENT_BIO_COMPRESSED;
>> +			extent_set_compress_type(&failrec->bio_flags,
>> +						 em->compress_type);
>> +		}
>> +		pr_debug("bio_readpage_error: (new) logical=%llu, start=%llu, "
>> +			 "len=%llu\n", logical, start, failrec->len);
>> +		failrec->logical = logical;
>> +		free_extent_map(em);
>> +
>> +		/* set the bits in the private failure tree */
>> +		ret = set_extent_bits(failure_tree, start, end,
>> +					EXTENT_LOCKED | EXTENT_DIRTY, GFP_NOFS);
>> +		if (ret >= 0)
>> +			ret = set_state_private(failure_tree, start,
>> +						(u64)(unsigned long)failrec);
>> +		/* set the bits in the inode's tree */
>> +		if (ret >= 0)
>> +			ret = set_extent_bits(tree, start, end, EXTENT_DAMAGED,
>> +						GFP_NOFS);
>> +		if (ret < 0) {
>> +			kfree(failrec);
>> +			return ret;
>> +		}
>> +	} else {
>> +		failrec = (struct io_failure_record *)(unsigned long)private;
>> +		pr_debug("bio_readpage_error: (found) logical=%llu, "
>> +			 "start=%llu, len=%llu, validation=%d\n",
>> +			 failrec->logical, failrec->start, failrec->len,
>> +			 failrec->in_validation);
>> +		/*
>> +		 * when data can be on disk more than twice, add to failrec here
>> +		 * (e.g. with a list for failed_mirror) to make
>> +		 * clean_io_failure() clean all those errors at once.
>> +		 */
>> +	}
>> +	num_copies = btrfs_num_copies(
>> +			      &BTRFS_I(inode)->root->fs_info->mapping_tree,
>> +			      failrec->logical, failrec->len);
>> +	if (num_copies == 1) {
>> +		/*
>> +		 * we only have a single copy of the data, so don't bother with
>> +		 * all the retry and error correction code that follows. no
>> +		 * matter what the error is, it is very likely to persist.
>> +		 */
>> +		pr_debug("bio_readpage_error: cannot repair, num_copies == 1. "
>> +			 "state=%p, num_copies=%d, next_mirror %d, "
>> +			 "failed_mirror %d\n", state, num_copies,
>> +			 failrec->this_mirror, failed_mirror);
>> +		free_io_failure(inode, failrec, 0);
>> +		return -EIO;
>> +	}
>> +
>> +	if (!state) {
>> +		spin_lock(&tree->lock);
>> +		state = find_first_extent_bit_state(tree, failrec->start,
>> +						    EXTENT_LOCKED);
>> +		if (state && state->start != failrec->start)
>> +			state = NULL;
>> +		spin_unlock(&tree->lock);
>> +	}
>> +
>> +	/*
>> +	 * there are two premises:
>> +	 *	a) deliver good data to the caller
>> +	 *	b) correct the bad sectors on disk
>> +	 */
>> +	if (failed_bio->bi_vcnt > 1) {
>> +		/*
>> +		 * to fulfill b), we need to know the exact failing sectors, as
>> +		 * we don't want to rewrite any more than the failed ones. thus,
>> +		 * we need separate read requests for the failed bio
>> +		 *
>> +		 * if the following BUG_ON triggers, our validation request got
>> +		 * merged. we need separate requests for our algorithm to work.
>> +		 */
>> +		BUG_ON(failrec->in_validation);
>> +		failrec->in_validation = 1;
>> +		failrec->this_mirror = failed_mirror;
>> +		read_mode = READ_SYNC | REQ_FAILFAST_DEV;
>> +	} else {
>> +		/*
>> +		 * we're ready to fulfill a) and b) alongside. get a good copy
>> +		 * of the failed sector and if we succeed, we have setup
>> +		 * everything for repair_io_failure to do the rest for us.
>> +		 */
>> +		if (failrec->in_validation) {
>> +			BUG_ON(failrec->this_mirror != failed_mirror);
>> +			failrec->in_validation = 0;
>> +			failrec->this_mirror = 0;
>> +		}
>> +		failrec->failed_mirror = failed_mirror;
>> +		failrec->this_mirror++;
>> +		if (failrec->this_mirror == failed_mirror)
>> +			failrec->this_mirror++;
>> +		read_mode = READ_SYNC;
>> +	}
>> +
>> +	if (!state || failrec->this_mirror > num_copies) {
>> +		pr_debug("bio_readpage_error: (fail) state=%p, num_copies=%d, "
>> +			 "next_mirror %d, failed_mirror %d\n", state,
>> +			 num_copies, failrec->this_mirror, failed_mirror);
>> +		free_io_failure(inode, failrec, 0);
>> +		return -EIO;
>> +	}
>> +
>> +	bio = bio_alloc(GFP_NOFS, 1);
>> +	bio->bi_private = state;
>> +	bio->bi_end_io = failed_bio->bi_end_io;
>> +	bio->bi_sector = failrec->logical >> 9;
>> +	bio->bi_bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
>> +	bio->bi_size = 0;
>> +
>> +	bio_add_page(bio, page, failrec->len, start - page_offset(page));
>> +
>> +	pr_debug("bio_readpage_error: submitting new read[%#x] to "
>> +		 "this_mirror=%d, num_copies=%d, in_validation=%d\n", read_mode,
>> +		 failrec->this_mirror, num_copies, failrec->in_validation);
>> +
>> +	tree->ops->submit_bio_hook(inode, read_mode, bio, failrec->this_mirror,
>> +					failrec->bio_flags, 0);
>> +	return 0;
>> +}
