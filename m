Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18937 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbbGAOhT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 10:37:19 -0400
Date: Wed, 1 Jul 2015 22:37:00 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: Re: [RFC PATCH V11 08/21] Btrfs: subpagesize-blocksize: Compute and
 look up csums based on sectorsized blocks.
Message-ID: <20150701143659.GB7847@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1433172176-8742-9-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433172176-8742-9-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 01, 2015 at 08:52:43PM +0530, Chandan Rajendra wrote:
> Checksums are applicable to sectorsize units. The current code uses
> bio->bv_len units to compute and look up checksums. This works on machines
> where sectorsize == PAGE_SIZE. This patch makes the checksum computation and
> look up code to work with sectorsize units.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/btrfs/file-item.c | 87 ++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 54 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 58ece65..65ab9c3 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -172,6 +172,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
>  	u64 item_start_offset = 0;
>  	u64 item_last_offset = 0;
>  	u64 disk_bytenr;
> +	u64 page_bytes_left;
>  	u32 diff;
>  	int nblocks;
>  	int bio_index = 0;
> @@ -220,6 +221,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
>  	disk_bytenr = (u64)bio->bi_iter.bi_sector << 9;
>  	if (dio)
>  		offset = logical_offset;
> +
> +	page_bytes_left = bvec->bv_len;
>  	while (bio_index < bio->bi_vcnt) {
>  		if (!dio)
>  			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
> @@ -243,7 +246,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
>  				if (BTRFS_I(inode)->root->root_key.objectid ==
>  				    BTRFS_DATA_RELOC_TREE_OBJECTID) {
>  					set_extent_bits(io_tree, offset,
> -						offset + bvec->bv_len - 1,
> +						offset + root->sectorsize - 1,
>  						EXTENT_NODATASUM, GFP_NOFS);
>  				} else {
>  					btrfs_info(BTRFS_I(inode)->root->fs_info,
> @@ -281,11 +284,17 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
>  found:
>  		csum += count * csum_size;
>  		nblocks -= count;
> -		bio_index += count;
> +
>  		while (count--) {
> -			disk_bytenr += bvec->bv_len;
> -			offset += bvec->bv_len;
> -			bvec++;
> +			disk_bytenr += root->sectorsize;
> +			offset += root->sectorsize;
> +			page_bytes_left -= root->sectorsize;
> +			if (!page_bytes_left) {
> +				bio_index++;
> +				bvec++;
> +				page_bytes_left = bvec->bv_len;
> +			}
> +
>  		}
>  	}
>  	btrfs_free_path(path);
> @@ -432,6 +441,8 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
>  	struct bio_vec *bvec = bio->bi_io_vec;
>  	int bio_index = 0;
>  	int index;
> +	int nr_sectors;
> +	int i;
>  	unsigned long total_bytes = 0;
>  	unsigned long this_sum_bytes = 0;
>  	u64 offset;
> @@ -459,41 +470,51 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
>  		if (!contig)
>  			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
>  
> -		if (offset >= ordered->file_offset + ordered->len ||
> -		    offset < ordered->file_offset) {
> -			unsigned long bytes_left;
> -			sums->len = this_sum_bytes;
> -			this_sum_bytes = 0;
> -			btrfs_add_ordered_sum(inode, ordered, sums);
> -			btrfs_put_ordered_extent(ordered);
> +		data = kmap_atomic(bvec->bv_page);
>  
> -			bytes_left = bio->bi_iter.bi_size - total_bytes;
>  
> -			sums = kzalloc(btrfs_ordered_sum_size(root, bytes_left),
> -				       GFP_NOFS);
> -			BUG_ON(!sums); /* -ENOMEM */
> -			sums->len = bytes_left;
> -			ordered = btrfs_lookup_ordered_extent(inode, offset);
> -			BUG_ON(!ordered); /* Logic error */
> -			sums->bytenr = ((u64)bio->bi_iter.bi_sector << 9) +
> -				       total_bytes;
> -			index = 0;
> +		nr_sectors = (bvec->bv_len + root->sectorsize - 1)
> +			>> root->fs_info->sb->s_blocksize_bits;
> +
> +
> +		for (i = 0; i < nr_sectors; i++) {
> +			if (offset >= ordered->file_offset + ordered->len ||
> +				offset < ordered->file_offset) {
> +				unsigned long bytes_left;
> +				sums->len = this_sum_bytes;
> +				this_sum_bytes = 0;
> +				btrfs_add_ordered_sum(inode, ordered, sums);
> +				btrfs_put_ordered_extent(ordered);
> +
> +				bytes_left = bio->bi_iter.bi_size - total_bytes;
> +
> +				sums = kzalloc(btrfs_ordered_sum_size(root, bytes_left),
> +					GFP_NOFS);
> +				BUG_ON(!sums); /* -ENOMEM */
> +				sums->len = bytes_left;
> +				ordered = btrfs_lookup_ordered_extent(inode, offset);
> +				BUG_ON(!ordered); /* Logic error */
> +				sums->bytenr = ((u64)bio->bi_iter.bi_sector << 9) +
> +					total_bytes;
> +				index = 0;
> +			}
> +
> +			sums->sums[index] = ~(u32)0;
> +			sums->sums[index]
> +				= btrfs_csum_data(data + bvec->bv_offset + (i * root->sectorsize),
> +						sums->sums[index],
> +						root->sectorsize);
> +			btrfs_csum_final(sums->sums[index],
> +					(char *)(sums->sums + index));
> +			index++;
> +			offset += root->sectorsize;
> +			this_sum_bytes += root->sectorsize;
> +			total_bytes += root->sectorsize;
>  		}
>  
> -		data = kmap_atomic(bvec->bv_page);
> -		sums->sums[index] = ~(u32)0;
> -		sums->sums[index] = btrfs_csum_data(data + bvec->bv_offset,
> -						    sums->sums[index],
> -						    bvec->bv_len);
>  		kunmap_atomic(data);
> -		btrfs_csum_final(sums->sums[index],
> -				 (char *)(sums->sums + index));
>  
>  		bio_index++;
> -		index++;
> -		total_bytes += bvec->bv_len;
> -		this_sum_bytes += bvec->bv_len;
> -		offset += bvec->bv_len;
>  		bvec++;
>  	}
>  	this_sum_bytes = 0;
> -- 
> 2.1.0
> 
