Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55474 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab3DWUyo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 16:54:44 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 7D72B9A0403
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 14:54:38 -0600 (MDT)
Date: Tue, 23 Apr 2013 16:54:35 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>, Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH V2 2/2] Btrfs: remove btrfs_sector_sum structure
Message-ID: <20130423205435.GD2631@localhost.localdomain>
References: <5153FB3A.10507@cn.fujitsu.com>
 <515BF310.4070904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <515BF310.4070904@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 03, 2013 at 03:14:56AM -0600, Miao Xie wrote:
> Using the structure btrfs_sector_sum to keep the checksum value is
> unnecessary, because the extents that btrfs_sector_sum points to are
> continuous, we can find out the expected checksums by btrfs_ordered_sum's
> bytenr and the offset, so we can remove btrfs_sector_sum's bytenr. After
> removing bytenr, there is only one member in the structure, so it makes
> no sense to keep the structure, just remove it, and use a u32 array to
> store the checksum value.
> 
> By this change, we don't use the while loop to get the checksums one by
> one. Now, we can get several checksum value at one time, it improved the
> performance by ~74% on my SSD (31MB/s -> 54MB/s).
> 
> test command:
>  # dd if=/dev/zero of=/mnt/btrfs/file0 bs=1M count=1024 oflag=sync
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> Changelog v1 -> v2:
> - modify the changelog and the title which can not explain this patch clearly
> - fix the 64bit division problem on 32bit machine
> ---
>  fs/btrfs/file-item.c    | 144 ++++++++++++++++++------------------------------
>  fs/btrfs/ordered-data.c |  19 +++----
>  fs/btrfs/ordered-data.h |  25 ++-------
>  fs/btrfs/relocation.c   |  10 ----
>  fs/btrfs/scrub.c        |  16 ++----
>  5 files changed, 71 insertions(+), 143 deletions(-)
> 
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 484017a..8d653c2 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -34,8 +34,7 @@
> 
>  #define MAX_ORDERED_SUM_BYTES(r) ((PAGE_SIZE - \
>                                    sizeof(struct btrfs_ordered_sum)) / \
> -                                  sizeof(struct btrfs_sector_sum) * \
> -                                  (r)->sectorsize - (r)->sectorsize)
> +                                  sizeof(u32) * (r)->sectorsize)
> 
>  int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
>                              struct btrfs_root *root,
> @@ -313,7 +312,6 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
>         struct btrfs_path *path;
>         struct extent_buffer *leaf;
>         struct btrfs_ordered_sum *sums;
> -       struct btrfs_sector_sum *sector_sum;
>         struct btrfs_csum_item *item;
>         LIST_HEAD(tmplist);
>         unsigned long offset;
> @@ -387,34 +385,28 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
>                                       struct btrfs_csum_item);
>                 while (start < csum_end) {
>                         size = min_t(size_t, csum_end - start,
> -                                       MAX_ORDERED_SUM_BYTES(root));
> +                                    MAX_ORDERED_SUM_BYTES(root));
>                         sums = kzalloc(btrfs_ordered_sum_size(root, size),
> -                                       GFP_NOFS);
> +                                      GFP_NOFS);
>                         if (!sums) {
>                                 ret = -ENOMEM;
>                                 goto fail;
>                         }
> 
> -                       sector_sum = sums->sums;
>                         sums->bytenr = start;
> -                       sums->len = size;
> +                       sums->len = (int)size;
> 
>                         offset = (start - key.offset) >>
>                                 root->fs_info->sb->s_blocksize_bits;
>                         offset *= csum_size;
> +                       size >>= root->fs_info->sb->s_blocksize_bits;
> 
> -                       while (size > 0) {
> -                               read_extent_buffer(path->nodes[0],
> -                                               &sector_sum->sum,
> -                                               ((unsigned long)item) +
> -                                               offset, csum_size);
> -                               sector_sum->bytenr = start;
> -
> -                               size -= root->sectorsize;
> -                               start += root->sectorsize;
> -                               offset += csum_size;
> -                               sector_sum++;
> -                       }
> +                       read_extent_buffer(path->nodes[0],
> +                                          sums->sums,
> +                                          ((unsigned long)item) + offset,
> +                                          csum_size * size);
> +
> +                       start += root->sectorsize * size;
>                         list_add_tail(&sums->list, &tmplist);
>                 }
>                 path->slots[0]++;
> @@ -436,23 +428,20 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
>                        struct bio *bio, u64 file_start, int contig)
>  {
>         struct btrfs_ordered_sum *sums;
> -       struct btrfs_sector_sum *sector_sum;
>         struct btrfs_ordered_extent *ordered;
>         char *data;
>         struct bio_vec *bvec = bio->bi_io_vec;
>         int bio_index = 0;
> +       int index;
>         unsigned long total_bytes = 0;
>         unsigned long this_sum_bytes = 0;
>         u64 offset;
> -       u64 disk_bytenr;
> 
>         WARN_ON(bio->bi_vcnt <= 0);
>         sums = kzalloc(btrfs_ordered_sum_size(root, bio->bi_size), GFP_NOFS);
>         if (!sums)
>                 return -ENOMEM;
> 
> -       sector_sum = sums->sums;
> -       disk_bytenr = (u64)bio->bi_sector << 9;
>         sums->len = bio->bi_size;
>         INIT_LIST_HEAD(&sums->list);
> 
> @@ -463,7 +452,8 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
> 
>         ordered = btrfs_lookup_ordered_extent(inode, offset);
>         BUG_ON(!ordered); /* Logic error */
> -       sums->bytenr = ordered->start;
> +       sums->bytenr = (u64)bio->bi_sector << 9;
> +       index = 0;
> 
>         while (bio_index < bio->bi_vcnt) {
>                 if (!contig)
> @@ -482,29 +472,28 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
>                         sums = kzalloc(btrfs_ordered_sum_size(root, bytes_left),
>                                        GFP_NOFS);
>                         BUG_ON(!sums); /* -ENOMEM */
> -                       sector_sum = sums->sums;
>                         sums->len = bytes_left;
>                         ordered = btrfs_lookup_ordered_extent(inode, offset);
>                         BUG_ON(!ordered); /* Logic error */
> -                       sums->bytenr = ordered->start;
> +                       sums->bytenr = ((u64)bio->bi_sector << 9) +
> +                                      total_bytes;
> +                       index = 0;
>                 }
> 
>                 data = kmap_atomic(bvec->bv_page);
> -               sector_sum->sum = ~(u32)0;
> -               sector_sum->sum = btrfs_csum_data(root,
> -                                                 data + bvec->bv_offset,
> -                                                 sector_sum->sum,
> -                                                 bvec->bv_len);
> +               sums->sums[index] = ~(u32)0;
> +               sums->sums[index] = btrfs_csum_data(root,
> +                                                   data + bvec->bv_offset,
> +                                                   sums->sums[index],
> +                                                   bvec->bv_len);
>                 kunmap_atomic(data);
> -               btrfs_csum_final(sector_sum->sum,
> -                                (char *)&sector_sum->sum);
> -               sector_sum->bytenr = disk_bytenr;
> +               btrfs_csum_final(sums->sums[index],
> +                                (char *)(sums->sums + index));
> 
> -               sector_sum++;
>                 bio_index++;
> +               index++;
>                 total_bytes += bvec->bv_len;
>                 this_sum_bytes += bvec->bv_len;
> -               disk_bytenr += bvec->bv_len;
>                 offset += bvec->bv_len;
>                 bvec++;
>         }
> @@ -693,63 +682,42 @@ out:
>         return ret;
>  }
> 
> -static u64 btrfs_sector_sum_left(struct btrfs_ordered_sum *sums,
> -                                struct btrfs_sector_sum *sector_sum,
> -                                u64 total_bytes, u64 sectorsize)
> -{
> -       u64 tmp = sectorsize;
> -       u64 next_sector = sector_sum->bytenr;
> -       struct btrfs_sector_sum *next = sector_sum + 1;
> -
> -       while ((tmp + total_bytes) < sums->len) {
> -               if (next_sector + sectorsize != next->bytenr)
> -                       break;
> -               tmp += sectorsize;
> -               next_sector = next->bytenr;
> -               next++;
> -       }
> -       return tmp;
> -}
> -
>  int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
>                            struct btrfs_root *root,
>                            struct btrfs_ordered_sum *sums)
>  {
> -       u64 bytenr;
> -       int ret;
>         struct btrfs_key file_key;
>         struct btrfs_key found_key;
> -       u64 next_offset;
> -       u64 total_bytes = 0;
> -       int found_next;
>         struct btrfs_path *path;
>         struct btrfs_csum_item *item;
>         struct btrfs_csum_item *item_end;
>         struct extent_buffer *leaf = NULL;
> +       u64 next_offset;
> +       u64 total_bytes = 0;
>         u64 csum_offset;
> -       struct btrfs_sector_sum *sector_sum;
> +       u64 bytenr;
>         u32 nritems;
>         u32 ins_size;
> +       int index = 0;
> +       int found_next;
> +       int ret;
>         u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
> 
>         path = btrfs_alloc_path();
>         if (!path)
>                 return -ENOMEM;
> -
> -       sector_sum = sums->sums;
>  again:
>         next_offset = (u64)-1;
>         found_next = 0;
> +       bytenr = sums->bytenr + total_bytes;
>         file_key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
> -       file_key.offset = sector_sum->bytenr;
> -       bytenr = sector_sum->bytenr;
> +       file_key.offset = bytenr;
>         btrfs_set_key_type(&file_key, BTRFS_EXTENT_CSUM_KEY);
> 
> -       item = btrfs_lookup_csum(trans, root, path, sector_sum->bytenr, 1);
> +       item = btrfs_lookup_csum(trans, root, path, bytenr, 1);
>         if (!IS_ERR(item)) {
> -               leaf = path->nodes[0];
> -               ret = 0;
> -               goto found;
> +               csum_offset = 0;
> +               goto csum;

Ok I've just spent the last 3 hours tracking down an fsync() problem that turned
out to be because of this patch.  btrfs_lookup_csum() assumes you are just going
in 4k chunks, but we could be going in larger chunks.  So as long as the bytenr
falls inside of this csum item it thinks its good.  So what I'm seeing is this,
we have item

[0-8k]

and we are csumming

[4k-12k]

and then we're adding our new csum into the old one, the sizes match but the
bytenrs don't match.  If you want a reproducer just run my fsync xfstest that I
just posted.  I'm dropping this patch for now and I'll wait for you to fix it.
Thanks,

Josef
