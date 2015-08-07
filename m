Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27296 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946113AbbHGSal (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Aug 2015 14:30:41 -0400
Message-ID: <55C4F93D.3010605@fb.com>
Date: Fri, 7 Aug 2015 14:30:21 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-btrfs@vger.kernel.org>
CC: <clm@fb.com>, <bo.li.liu@oracle.com>, <dsterba@suse.cz>,
        <chandan@mykolab.com>, <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH V2 02/11] Btrfs: Compute and look up csums based on sectorsized
 blocks
References: <1438931158-20888-1-git-send-email-chandan@linux.vnet.ibm.com> <1438931158-20888-3-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1438931158-20888-3-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/07/2015 03:05 AM, Chandan Rajendra wrote:
> Checksums are applicable to sectorsize units. The current code uses
> bio->bv_len units to compute and look up checksums. This works on machines
> where sectorsize == PAGE_SIZE. This patch makes the checksum computation and
> look up code to work with sectorsize units.
>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>   fs/btrfs/file-item.c | 90 +++++++++++++++++++++++++++++++++-------------------
>   1 file changed, 57 insertions(+), 33 deletions(-)
>
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 58ece65..d752051 100644
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
> @@ -459,41 +470,54 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
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

I don't think we can have something kmap_atomic()'ed and then do 
allocations under it right?  That's why we only kmap_atomic(), do the 
copy, and then unmap, unless I'm forgetting something?  Thanks,

Josef
