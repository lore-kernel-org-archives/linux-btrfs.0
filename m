Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:58617 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbbJBMU1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 08:20:27 -0400
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 2 Oct 2015 17:50:24 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id F287B125801D
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2015 17:49:58 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t92CKK4n45547570
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Oct 2015 17:50:20 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t92CKIJ3026816
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Oct 2015 17:50:19 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, bo.li.liu@oracle.com,
        dsterba@suse.cz, quwenruo@cn.fujitsu.com, chandan@mykolab.com
Subject: Re: [PATCH V5 02/13] Btrfs: Compute and look up csums based on sectorsized blocks
Date: Fri, 02 Oct 2015 17:50:16 +0530
Message-ID: <6506408.mhIJzHGTWO@localhost.localdomain>
In-Reply-To: <560D45A1.9020804@fb.com>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com> <1443608912-31667-3-git-send-email-chandan@linux.vnet.ibm.com> <560D45A1.9020804@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 01 Oct 2015 10:39:29 Josef Bacik wrote:
> On 09/30/2015 06:28 AM, Chandan Rajendra wrote:
> > Checksums are applicable to sectorsize units. The current code uses
> > bio->bv_len units to compute and look up checksums. This works on machines
> > where sectorsize == PAGE_SIZE. This patch makes the checksum computation
> > and look up code to work with sectorsize units.
> > 
> > Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> > Reviewed-by: Josef Bacik <jbacik@fb.com>
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> > 
> >   fs/btrfs/file-item.c | 93
> >   +++++++++++++++++++++++++++++++++------------------- 1 file changed, 59
> >   insertions(+), 34 deletions(-)
> > 
> > diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> > index 58ece65..818c859 100644
> > --- a/fs/btrfs/file-item.c
> > +++ b/fs/btrfs/file-item.c
> > @@ -172,6 +172,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root
> > *root,> 
> >   	u64 item_start_offset = 0;
> >   	u64 item_last_offset = 0;
> >   	u64 disk_bytenr;
> > 
> > +	u64 page_bytes_left;
> > 
> >   	u32 diff;
> >   	int nblocks;
> >   	int bio_index = 0;
> > 
> > @@ -220,6 +221,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root
> > *root,> 
> >   	disk_bytenr = (u64)bio->bi_iter.bi_sector << 9;
> >   	if (dio)
> >   	
> >   		offset = logical_offset;
> > 
> > +
> > +	page_bytes_left = bvec->bv_len;
> > 
> >   	while (bio_index < bio->bi_vcnt) {
> >   	
> >   		if (!dio)
> >   		
> >   			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
> > 
> > @@ -243,7 +246,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root
> > *root,> 
> >   				if (BTRFS_I(inode)->root->root_key.objectid ==
> >   				
> >   				    BTRFS_DATA_RELOC_TREE_OBJECTID) {
> >   					
> >   					set_extent_bits(io_tree, offset,
> > 
> > -						offset + bvec->bv_len - 1,
> > +						offset + root->sectorsize - 1,
> > 
> >   						EXTENT_NODATASUM, GFP_NOFS);
> >   				
> >   				} else {
> >   				
> >   					btrfs_info(BTRFS_I(inode)->root-
>fs_info,
> > 
> > @@ -281,11 +284,17 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root
> > *root,> 
> >   found:
> >   		csum += count * csum_size;
> >   		nblocks -= count;
> > 
> > -		bio_index += count;
> > +
> > 
> >   		while (count--) {
> > 
> > -			disk_bytenr += bvec->bv_len;
> > -			offset += bvec->bv_len;
> > -			bvec++;
> > +			disk_bytenr += root->sectorsize;
> > +			offset += root->sectorsize;
> > +			page_bytes_left -= root->sectorsize;
> > +			if (!page_bytes_left) {
> > +				bio_index++;
> > +				bvec++;
> > +				page_bytes_left = bvec->bv_len;
> > +			}
> > +
> >
> I don't understand why this needs to be changed, bv_len is still the
> amount we're copying, irrespective of the page size.

Josef, assume bvec[0] has 2 blocks worth of data and bvec[1] has 4 blocks of
worth of data. For the first iteration of the loop, assume that
btrfs_find_ordered_sum() returned 4 csums i.e. csums associated with first 4
blocks of the bio. In such a scenario, the first of the several csums returned
during the second iteration of the loop applies to the the 3rd block mapped by
bvec[1]. Knowing this wouldn't be possible by only using bvec->bv_len. Hence
page_bytes_left helps us figure out the block inside a bvec for which the
first of the new set of csums found applies and also to decide whether to move
to the next bvec or not.

> > 
> >   		}
> >   	
> >   	}
> >   	btrfs_free_path(path);
> > 
> > @@ -432,6 +441,8 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct
> > inode *inode,> 
> >   	struct bio_vec *bvec = bio->bi_io_vec;
> >   	int bio_index = 0;
> >   	int index;
> > 
> > +	int nr_sectors;
> > +	int i;
> > 
> >   	unsigned long total_bytes = 0;
> >   	unsigned long this_sum_bytes = 0;
> >   	u64 offset;
> > 
> > @@ -451,7 +462,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct
> > inode *inode,> 
> >   		offset = page_offset(bvec->bv_page) + bvec->bv_offset;
> >   	
> >   	ordered = btrfs_lookup_ordered_extent(inode, offset);
> > 
> > -	BUG_ON(!ordered); /* Logic error */
> > +	ASSERT(ordered); /* Logic error */
> >
> 
> Don't worry about converting existing BUG_ON()'s, just don't add new ones.

Ok. 

> >   	sums->bytenr = (u64)bio->bi_iter.bi_sector << 9;
> >   	index = 0;
> > 
> > @@ -459,41 +470,55 @@ int btrfs_csum_one_bio(struct btrfs_root *root,
> > struct inode *inode,> 
> >   		if (!contig)
> >   		
> >   			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
> > 
> > -		if (offset >= ordered->file_offset + ordered->len ||
> > -		    offset < ordered->file_offset) {
> > -			unsigned long bytes_left;
> > -			sums->len = this_sum_bytes;
> > -			this_sum_bytes = 0;
> > -			btrfs_add_ordered_sum(inode, ordered, sums);
> > -			btrfs_put_ordered_extent(ordered);
> > +		data = kmap_atomic(bvec->bv_page);
> > 
> > -			bytes_left = bio->bi_iter.bi_size - total_bytes;
> > +		nr_sectors = (bvec->bv_len + root->sectorsize - 1)
> > +			>> inode->i_blkbits;
> > +
> So I've seen similar sort of math in the previous patch for this as
> well, lets make this into a helper.

I agree. I will add a helper function to do that and invoke it in appropriate
place.

> > +		for (i = 0; i < nr_sectors; i++) {
> > +			if (offset >= ordered->file_offset + ordered->len ||
> > +				offset < ordered->file_offset) {
> > +				unsigned long bytes_left;
> > +
> > +				kunmap_atomic(data);
> > +				sums->len = this_sum_bytes;
> > +				this_sum_bytes = 0;
> > +				btrfs_add_ordered_sum(inode, ordered, sums);
> > +				btrfs_put_ordered_extent(ordered);
> > +
> > +				bytes_left = bio->bi_iter.bi_size - 
total_bytes;
> > +
> > +				sums = kzalloc(btrfs_ordered_sum_size(root, 
bytes_left),
> > +					GFP_NOFS);
> > +				BUG_ON(!sums); /* -ENOMEM */
> > +				sums->len = bytes_left;
> > +				ordered = btrfs_lookup_ordered_extent(inode,
> > +								offset);
> > +				ASSERT(ordered); /* Logic error */
> > +				sums->bytenr = ((u64)bio->bi_iter.bi_sector << 
9)
> > +					+ total_bytes;
> > +				index = 0;
> > +
> > +				data = kmap_atomic(bvec->bv_page);
> > +			}
> >
> > -			sums = kzalloc(btrfs_ordered_sum_size(root, 
bytes_left),
> > -				       GFP_NOFS);
> > -			BUG_ON(!sums); /* -ENOMEM */
> > -			sums->len = bytes_left;
> > -			ordered = btrfs_lookup_ordered_extent(inode, offset);
> > -			BUG_ON(!ordered); /* Logic error */
> > -			sums->bytenr = ((u64)bio->bi_iter.bi_sector << 9) +
> > -				       total_bytes;
> > -			index = 0;
> > +			sums->sums[index] = ~(u32)0;
> > +			sums->sums[index]
> > +				= btrfs_csum_data(data + bvec->bv_offset
> > +						+ (i * root->sectorsize),
> > +						sums->sums[index],
> > +						root->sectorsize);
> > +			btrfs_csum_final(sums->sums[index],
> > +					(char *)(sums->sums + index));
> > +			index++;
> > +			offset += root->sectorsize;
> > +			this_sum_bytes += root->sectorsize;
> > +			total_bytes += root->sectorsize;
> > 
> >   		}
> 
> What I said about this area in the other email I sent just ignore, I
> misread the patch.  The other stuff is still valid tho.  Thanks,
> 
> Josef

-- 
chandan

