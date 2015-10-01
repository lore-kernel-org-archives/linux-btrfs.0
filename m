Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1514 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908AbbJAOhL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 10:37:11 -0400
Subject: Re: [RFC PATCH V4 02/13] Btrfs: Compute and look up csums based on
 sectorsized blocks
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
References: <1443608309-30154-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1443608309-30154-3-git-send-email-chandan@linux.vnet.ibm.com>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <quwenruo@cn.fujitsu.com>, <chandan@mykolab.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <560D44F7.1050905@fb.com>
Date: Thu, 1 Oct 2015 10:36:39 -0400
MIME-Version: 1.0
In-Reply-To: <1443608309-30154-3-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/2015 06:18 AM, Chandan Rajendra wrote:
> Checksums are applicable to sectorsize units. The current code uses
> bio->bv_len units to compute and look up checksums. This works on machines
> where sectorsize == PAGE_SIZE. This patch makes the checksum computation and
> look up code to work with sectorsize units.
>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> Reviewed-by: Josef Bacik <jbacik@fb.com>
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

I don't understand why this needs to be changed, bv_len is still the 
amount we're copying, irrespective of the page size.

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

Don't worry about converting existing BUG_ON()'s, just don't add new ones.

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

So I've seen similar sort of math in the previous patch for this as 
well, lets make this into a helper.

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

This will fall through and kzalloc under kmap_atomic which isn't ok. 
Thanks,

Josef
