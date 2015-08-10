Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60182 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752754AbbHJNwJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Aug 2015 09:52:09 -0400
Message-ID: <55C8AC72.4020804@fb.com>
Date: Mon, 10 Aug 2015 09:51:46 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <quwenruo@cn.fujitsu.com>, <chandan@mykolab.com>
Subject: Re: [PATCH V3 02/11] Btrfs: Compute and look up csums based on sectorsized
 blocks
References: <1439132972-24321-1-git-send-email-chandan@linux.vnet.ibm.com> <1439132972-24321-3-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1439132972-24321-3-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/09/2015 11:09 AM, Chandan Rajendra wrote:
> Checksums are applicable to sectorsize units. The current code uses
> bio->bv_len units to compute and look up checksums. This works on machines
> where sectorsize == PAGE_SIZE. This patch makes the checksum computation and
> look up code to work with sectorsize units.
>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>   fs/btrfs/file-item.c | 93 +++++++++++++++++++++++++++++++++-------------------
>   1 file changed, 59 insertions(+), 34 deletions(-)
>
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 58ece65..818c859 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -172,6 +172,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
>   	u64 item_start_offset = 0;
>   	u64 item_last_offset = 0;
>   	u64 disk_bytenr;
> +	u64 page_bytes_left;
>   	u32 diff;
>   	int nblocks;
>   	int bio_index = 0;
> @@ -220,6 +221,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
>   	disk_bytenr = (u64)bio->bi_iter.bi_sector << 9;
>   	if (dio)
>   		offset = logical_offset;
> +
> +	page_bytes_left = bvec->bv_len;
>   	while (bio_index < bio->bi_vcnt) {
>   		if (!dio)
>   			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
> @@ -243,7 +246,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
>   				if (BTRFS_I(inode)->root->root_key.objectid ==
>   				    BTRFS_DATA_RELOC_TREE_OBJECTID) {
>   					set_extent_bits(io_tree, offset,
> -						offset + bvec->bv_len - 1,
> +						offset + root->sectorsize - 1,
>   						EXTENT_NODATASUM, GFP_NOFS);
>   				} else {
>   					btrfs_info(BTRFS_I(inode)->root->fs_info,
> @@ -281,11 +284,17 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
>   found:
>   		csum += count * csum_size;
>   		nblocks -= count;
> -		bio_index += count;
> +
>   		while (count--) {
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
>   		}
>   	}
>   	btrfs_free_path(path);
> @@ -432,6 +441,8 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
>   	struct bio_vec *bvec = bio->bi_io_vec;
>   	int bio_index = 0;
>   	int index;
> +	int nr_sectors;
> +	int i;
>   	unsigned long total_bytes = 0;
>   	unsigned long this_sum_bytes = 0;
>   	u64 offset;
> @@ -451,7 +462,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
>   		offset = page_offset(bvec->bv_page) + bvec->bv_offset;
>
>   	ordered = btrfs_lookup_ordered_extent(inode, offset);
> -	BUG_ON(!ordered); /* Logic error */
> +	ASSERT(ordered); /* Logic error */
>   	sums->bytenr = (u64)bio->bi_iter.bi_sector << 9;
>   	index = 0;
>
> @@ -459,41 +470,55 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
>   		if (!contig)
>   			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
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
> +		nr_sectors = (bvec->bv_len + root->sectorsize - 1)
> +			>> inode->i_blkbits;
> +
> +		for (i = 0; i < nr_sectors; i++) {
> +			if (offset >= ordered->file_offset + ordered->len ||
> +				offset < ordered->file_offset) {
> +				unsigned long bytes_left;
> +
> +				kunmap_atomic(data);
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
> +				ordered = btrfs_lookup_ordered_extent(inode,
> +								offset);
> +				ASSERT(ordered); /* Logic error */
> +				sums->bytenr = ((u64)bio->bi_iter.bi_sector << 9)
> +					+ total_bytes;
> +				index = 0;
> +
> +				data = kmap_atomic(bvec->bv_page);
> +			}
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
> +			sums->sums[index] = ~(u32)0;
> +			sums->sums[index]
> +				= btrfs_csum_data(data + bvec->bv_offset
> +						+ (i * root->sectorsize),
> +						sums->sums[index],
> +						root->sectorsize);
> +			btrfs_csum_final(sums->sums[index],
> +					(char *)(sums->sums + index));
> +			index++;
> +			offset += root->sectorsize;
> +			this_sum_bytes += root->sectorsize;
> +			total_bytes += root->sectorsize;
>   		}
>
> -		data = kmap_atomic(bvec->bv_page);
> -		sums->sums[index] = ~(u32)0;
> -		sums->sums[index] = btrfs_csum_data(data + bvec->bv_offset,
> -						    sums->sums[index],
> -						    bvec->bv_len);
>   		kunmap_atomic(data);
> -		btrfs_csum_final(sums->sums[index],
> -				 (char *)(sums->sums + index));
>
>   		bio_index++;
> -		index++;
> -		total_bytes += bvec->bv_len;
> -		this_sum_bytes += bvec->bv_len;
> -		offset += bvec->bv_len;
>   		bvec++;
>   	}
>   	this_sum_bytes = 0;
>

This is fine,

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
