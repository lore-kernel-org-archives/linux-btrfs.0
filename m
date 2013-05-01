Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:41278 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3EARas (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 13:30:48 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1E1C59A0691
	for <linux-btrfs@vger.kernel.org>; Wed,  1 May 2013 11:30:48 -0600 (MDT)
Date: Wed, 1 May 2013 13:30:42 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] Btrfs: online data deduplication
Message-ID: <20130501173042.GI2580@localhost.localdomain>
References: <1367425659-10803-1-git-send-email-bo.li.liu@oracle.com>
 <1367425659-10803-3-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1367425659-10803-3-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 01, 2013 at 10:27:38AM -0600, Liu Bo wrote:
> (NOTE: This leads to a FORMAT CHANGE, DO NOT use it on real data.)
> 
> This introduce the online data deduplication feature for btrfs.
> 
> (1) WHY do we need deduplication?
>     To improve our storage effiency.
> 
> (2) WHAT is deduplication?
>     Two key ways for practical deduplication implementations,
>     *  When the data is deduplicated
>        (inband vs background)
>     *  The granularity of the deduplication.
>        (block level vs file level)
> 
>     For btrfs, we choose
>     *  inband(synchronous)
>     *  block level
> 
>     We choose them because of the same reason as how zfs does.
>     a)  To get an immediate benefit.
>     b)  To remove redundant parts within a file.
> 
>     So we have an inband, block level data deduplication here.
> 
> (3) HOW does deduplication works?
>     This makes full use of file extent back reference, the same way as
>     IOCTL_CLONE, which lets us easily store multiple copies of a set of
>     data as a single copy along with an index of references to the copy.
> 
>     Here we have
>     a)  a new dedicated tree(DEDUP tree) and
>     b)  a new key(BTRFS_DEDUP_ITEM_KEY), which consists of
>         (stop 64bits of hash, type, disk offset),
>         *  stop 64bits of hash
>            We take the stop 64bits of the sha256 as the index.
>            Also we store the whole 256bits of sha256 in its item, which is
>            very helpful on avoiding collision.
>         *  disk offset
>            It helps to find where the data is stored.
>     c)  a new key(BTRFS_DEDUP_INDEX_KEY), which is
>         (disk offset, type, stop 64bits of hash),
>         It's mainly used when we're going to free a range of space occupied by
>         an file extent.
> 
>     So the whole deduplication process works as,
>     1) write something,
>     2) calculate the hash of this "something" based on the deduplication unit,
>     3) try to find the match of hash value by searching DEDUP keys in
>        a dedicated tree, DEDUP tree.
>     4) if found, skip real IO and link to the existing copy
>        if not, do real IO and insert a DEDUP key to the DEDUP tree.
> 
>     Right now, we can
>     a) enable deduplication with mount option "-o dedup",
>     b) control the deduplication unit with mount options '-o dedup_bs=xxx'.
> 
>     The dedault deduplication unit is 8192, and the maximum allowed dedup
>     blocksize is 128k because of compressed range limit.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v3:
> * add compress support
> * add a real ioctl to enable dedup feature
> * change the maximum allowed dedup blocksize to 128k because of compressed range
>   limit
> 
> v2:
> * Make changelog more clearly.
> * To avoid enlarging the file extent item's size, add another index key used for
>   freeing dedup extent.
> * Freeing dedup extent is now like how we delete checksum.
> * Add support for alternative deduplicatin blocksize larger than PAGESIZE.
> * Add a mount option to set deduplication blocksize.
> * Add support for those writes that are smaller than deduplication blocksize.
> * Cleanups
> 
>  fs/btrfs/ctree.h           |   54 ++++
>  fs/btrfs/disk-io.c         |   34 +++-
>  fs/btrfs/extent-tree.c     |    7 +
>  fs/btrfs/extent_io.c       |   27 ++-
>  fs/btrfs/extent_io.h       |   15 ++
>  fs/btrfs/file-item.c       |  242 ++++++++++++++++++
>  fs/btrfs/inode.c           |  583 ++++++++++++++++++++++++++++++++++++++------
>  fs/btrfs/ioctl.c           |   38 +++
>  fs/btrfs/ordered-data.c    |   30 ++-
>  fs/btrfs/ordered-data.h    |   11 +-
>  fs/btrfs/super.c           |   27 ++-
>  include/uapi/linux/btrfs.h |    1 +
>  12 files changed, 983 insertions(+), 86 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0d82922..c28538a 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -32,6 +32,7 @@
>  #include <asm/kmap_types.h>
>  #include <linux/pagemap.h>
>  #include <linux/btrfs.h>
> +#include <crypto/hash.h>
>  #include "extent_io.h"
>  #include "extent_map.h"
>  #include "async-thread.h"
> @@ -94,6 +95,9 @@ struct btrfs_ordered_sum;
>  /* holds quota configuration and tracking */
>  #define BTRFS_QUOTA_TREE_OBJECTID 8ULL
> 
> +/* dedup tree(experimental) */
> +#define BTRFS_DEDUP_TREE_OBJECTID 9ULL
> +
>  /* orhpan objectid for tracking unlinked/truncated files */
>  #define BTRFS_ORPHAN_OBJECTID -5ULL
> 
> @@ -121,6 +125,9 @@ struct btrfs_ordered_sum;
>   */
>  #define BTRFS_FREE_INO_OBJECTID -12ULL
> 
> +/* dedup keys(with only disk bytenr as index) all have this objectid */
> +#define BTRFS_DEDUP_OBJECTID -13ULL
> +
>  /* dummy objectid represents multiple objectids */
>  #define BTRFS_MULTIPLE_OBJECTIDS -255ULL
> 
> @@ -890,6 +897,22 @@ struct btrfs_csum_item {
>         u8 csum;
>  } __attribute__ ((__packed__));
> 
> +/* dedup */
> +struct btrfs_dedup_item {
> +       __le64 len;     /* disk length of dedup range */
> +
> +       u8 compression;
> +       u8 encryption;
> +       __le16 other_encoding; /* spare for later use */
> +} __attribute__ ((__packed__));
> +
> +#define BTRFS_DEDUP_HASH_SIZE 32
> +#define BTRFS_DEDUP_HASH_LEN 4
> +
> +struct btrfs_dedup_hash_item {
> +       __le64 hash[BTRFS_DEDUP_HASH_LEN];
> +} __attribute__ ((__packed__));
> +

Add a hash type in here somewhere so we can change hash types later if we
discover some horrible flaw in sha256.

>  struct btrfs_dev_stats_item {
>         /*
>          * grow this item struct at the end for future enhancements and keep
> @@ -1287,6 +1310,7 @@ struct btrfs_fs_info {
>         struct btrfs_root *dev_root;
>         struct btrfs_root *fs_root;
>         struct btrfs_root *csum_root;
> +       struct btrfs_root *dedup_root;
>         struct btrfs_root *quota_root;
> 
>         /* the log root tree is a directory of all the other log roots */
> @@ -1605,6 +1629,11 @@ struct btrfs_fs_info {
>         struct btrfs_dev_replace dev_replace;
> 
>         atomic_t mutually_exclusive_operation_running;
> +
> +       /* reference to deduplication algorithm drvier via cryptoapi */
> +       struct crypto_shash *dedup_driver;
> +
> +       u64 dedup_bs;
>  };
> 
>  /*
> @@ -1866,6 +1895,9 @@ struct btrfs_ioctl_defrag_range_args {
>   */
>  #define BTRFS_DEV_REPLACE_KEY  250
> 
> +#define BTRFS_DEDUP_ITEM_KEY   251
> +#define BTRFS_DEDUP_INDEX_KEY  252
> +
>  /*
>   * string items are for debugging.  They just store a short string of
>   * data in the FS
> @@ -1900,6 +1932,7 @@ struct btrfs_ioctl_defrag_range_args {
>  #define BTRFS_MOUNT_CHECK_INTEGRITY    (1 << 20)
>  #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
>  #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR       (1 << 22)
> +#define BTRFS_MOUNT_DEDUP              (1 << 23)
> 
>  #define btrfs_clear_opt(o, opt)                ((o) &= ~BTRFS_MOUNT_##opt)
>  #define btrfs_set_opt(o, opt)          ((o) |= BTRFS_MOUNT_##opt)
> @@ -2833,6 +2866,13 @@ static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
>         return btrfs_item_size(eb, e) - offset;
>  }
> 
> +/* btrfs_dedup_item */
> +BTRFS_SETGET_FUNCS(dedup_len, struct btrfs_dedup_item, len, 64);
> +BTRFS_SETGET_FUNCS(dedup_compression, struct btrfs_dedup_item, compression, 8);
> +BTRFS_SETGET_FUNCS(dedup_encryption, struct btrfs_dedup_item, encryption, 8);
> +BTRFS_SETGET_FUNCS(dedup_other_encoding, struct btrfs_dedup_item,
> +                  other_encoding, 16);
> +
>  /* btrfs_dev_stats_item */
>  static inline u64 btrfs_dev_stats_value(struct extent_buffer *eb,
>                                         struct btrfs_dev_stats_item *ptr,
> @@ -3300,6 +3340,8 @@ static inline int btrfs_fs_closing(struct btrfs_fs_info *fs_info)
>  }
>  static inline void free_fs_info(struct btrfs_fs_info *fs_info)
>  {
> +       if (fs_info->dedup_driver)
> +               crypto_free_shash(fs_info->dedup_driver);
>         kfree(fs_info->balance_ctl);
>         kfree(fs_info->delayed_root);
>         kfree(fs_info->extent_root);
> @@ -3475,6 +3517,18 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
>                         u64 isize);
>  int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
>                              struct list_head *list, int search_commit);
> +
> +int noinline_for_stack
> +btrfs_find_dedup_extent(struct btrfs_trans_handle *trans,
> +                       struct btrfs_root *root, u64 *hash, u64 *bytenr_ret,
> +                       u64 *num_bytes_ret, int *compr_ret);
> +int noinline_for_stack
> +btrfs_insert_dedup_extent(struct btrfs_trans_handle *trans,
> +                         struct btrfs_root *root, u64 *hash, u64 bytenr,
> +                         u64 num_bytes, int compr);
> +int noinline_for_stack
> +btrfs_free_dedup_extent(struct btrfs_trans_handle *trans,
> +                       struct btrfs_root *root, u64 bytenr);
>  /* inode.c */
>  struct btrfs_delalloc_work {
>         struct inode *inode;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 6d19a0a..00b795d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1946,6 +1946,10 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
>         free_extent_buffer(info->extent_root->commit_root);
>         free_extent_buffer(info->csum_root->node);
>         free_extent_buffer(info->csum_root->commit_root);
> +       if (info->dedup_root) {
> +               free_extent_buffer(info->dedup_root->node);
> +               free_extent_buffer(info->dedup_root->commit_root);
> +       }
>         if (info->quota_root) {
>                 free_extent_buffer(info->quota_root->node);
>                 free_extent_buffer(info->quota_root->commit_root);
> @@ -1959,6 +1963,10 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
>         info->extent_root->commit_root = NULL;
>         info->csum_root->node = NULL;
>         info->csum_root->commit_root = NULL;
> +       if (info->dedup_root) {
> +               info->dedup_root->node = NULL;
> +               info->dedup_root->commit_root = NULL;
> +       }
>         if (info->quota_root) {
>                 info->quota_root->node = NULL;
>                 info->quota_root->commit_root = NULL;
> @@ -1994,6 +2002,7 @@ int open_ctree(struct super_block *sb,
>         struct btrfs_root *chunk_root;
>         struct btrfs_root *dev_root;
>         struct btrfs_root *quota_root;
> +       struct btrfs_root *dedup_root;
>         struct btrfs_root *log_tree_root;
>         int ret;
>         int err = -EINVAL;
> @@ -2006,9 +2015,10 @@ int open_ctree(struct super_block *sb,
>         chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info);
>         dev_root = fs_info->dev_root = btrfs_alloc_root(fs_info);
>         quota_root = fs_info->quota_root = btrfs_alloc_root(fs_info);
> +       dedup_root = fs_info->dedup_root = btrfs_alloc_root(fs_info);
> 
>         if (!tree_root || !extent_root || !csum_root ||
> -           !chunk_root || !dev_root || !quota_root) {
> +           !chunk_root || !dev_root || !quota_root || !dedup_root) {
>                 err = -ENOMEM;
>                 goto fail;
>         }
> @@ -2086,6 +2096,7 @@ int open_ctree(struct super_block *sb,
>         atomic_set(&fs_info->tree_mod_seq, 0);
>         fs_info->sb = sb;
>         fs_info->max_inline = 8192 * 1024;
> +       fs_info->dedup_bs = 8192;
>         fs_info->metadata_ratio = 0;
>         fs_info->defrag_inodes = RB_ROOT;
>         fs_info->trans_no_join = 0;
> @@ -2331,6 +2342,14 @@ int open_ctree(struct super_block *sb,
>                 goto fail_alloc;
>         }
> 
> +       fs_info->dedup_driver = crypto_alloc_shash("sha256", 0, 0);
> +       if (IS_ERR(fs_info->dedup_driver)) {
> +               pr_info("Cannot load sha256 driver\n");
> +               err = PTR_ERR(fs_info->dedup_driver);
> +               fs_info->dedup_driver = NULL;
> +               goto fail_alloc;
> +       }
> +
>         btrfs_init_workers(&fs_info->generic_worker,
>                            "genwork", 1, NULL);
> 
> @@ -2545,6 +2564,15 @@ retry_root_backup:
>         csum_root->track_dirty = 1;
> 
>         ret = find_and_setup_root(tree_root, fs_info,
> +                                 BTRFS_DEDUP_TREE_OBJECTID, dedup_root);
> +       if (ret) {
> +               kfree(dedup_root);
> +               dedup_root = fs_info->dedup_root = NULL;
> +       } else {
> +               dedup_root->track_dirty = 1;
> +       }
> +
> +       ret = find_and_setup_root(tree_root, fs_info,
>                                   BTRFS_QUOTA_TREE_OBJECTID, quota_root);
>         if (ret) {
>                 kfree(quota_root);
> @@ -3436,6 +3464,10 @@ int close_ctree(struct btrfs_root *root)
>         free_extent_buffer(fs_info->dev_root->commit_root);
>         free_extent_buffer(fs_info->csum_root->node);
>         free_extent_buffer(fs_info->csum_root->commit_root);
> +       if (fs_info->dedup_root) {
> +               free_extent_buffer(fs_info->dedup_root->node);
> +               free_extent_buffer(fs_info->dedup_root->commit_root);
> +       }
>         if (fs_info->quota_root) {
>                 free_extent_buffer(fs_info->quota_root->node);
>                 free_extent_buffer(fs_info->quota_root->commit_root);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0d84787..d4c96b2 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2152,6 +2152,8 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
>                                 ret = btrfs_del_csums(trans, root,
>                                                       node->bytenr,
>                                                       node->num_bytes);
> +                               ret = btrfs_free_dedup_extent(trans, root,
> +                                                             node->bytenr);
>                         }
>                 }
>                 return ret;
> @@ -5512,6 +5514,11 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
>                                 btrfs_abort_transaction(trans, extent_root, ret);
>                                 goto out;
>                         }
> +                       ret = btrfs_free_dedup_extent(trans, root, bytenr);
> +                       if (ret) {
> +                               btrfs_abort_transaction(trans, extent_root, ret);
> +                               goto out;
> +                       }
>                 }
> 
>                 ret = update_block_group(root, bytenr, num_bytes, 0);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index cdee391..0b1c05a 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1200,6 +1200,20 @@ int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
>                                 cached_state, mask);
>  }
> 
> +int set_extent_dedup(struct extent_io_tree *tree, u64 start, u64 end,
> +                    struct extent_state **cached_state, gfp_t mask)
> +{
> +       return set_extent_bit(tree, start, end, EXTENT_DEDUP, 0,
> +                             cached_state, mask);
> +}
> +
> +int clear_extent_dedup(struct extent_io_tree *tree, u64 start, u64 end,
> +                         struct extent_state **cached_state, gfp_t mask)
> +{
> +       return clear_extent_bit(tree, start, end, EXTENT_DEDUP, 0, 0,
> +                               cached_state, mask);
> +}
> +
>  /*
>   * either insert or lock state struct between start and end use mask to tell
>   * us if waiting is desired.
> @@ -2317,7 +2331,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
>   * Scheduling is not allowed, so the extent state tree is expected
>   * to have one and only one object corresponding to this IO.
>   */
> -static void end_bio_extent_writepage(struct bio *bio, int err)
> +void end_bio_extent_writepage(struct bio *bio, int err)
>  {
>         struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
>         struct extent_io_tree *tree;
> @@ -2496,8 +2510,8 @@ btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
>         return bio;
>  }
> 
> -static int __must_check submit_one_bio(int rw, struct bio *bio,
> -                                      int mirror_num, unsigned long bio_flags)
> +int __must_check submit_one_bio(int rw, struct bio *bio, int mirror_num,
> +                               unsigned long bio_flags)
>  {
>         int ret = 0;
>         struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
> @@ -2536,7 +2550,7 @@ static int merge_bio(int rw, struct extent_io_tree *tree, struct page *page,
> 
>  }
> 
> -static int submit_extent_page(int rw, struct extent_io_tree *tree,
> +int submit_extent_page(int rw, struct extent_io_tree *tree,
>                               struct page *page, sector_t sector,
>                               size_t size, unsigned long offset,
>                               struct block_device *bdev,
> @@ -3598,9 +3612,10 @@ int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
> 
>         while (start <= end) {
>                 page = find_get_page(mapping, start >> PAGE_CACHE_SHIFT);
> -               if (clear_page_dirty_for_io(page))
> +
> +               if (clear_page_dirty_for_io(page)) {
>                         ret = __extent_writepage(page, &wbc_writepages, &epd);
> -               else {
> +               } else {
>                         if (tree->ops && tree->ops->writepage_end_io_hook)
>                                 tree->ops->writepage_end_io_hook(page, start,
>                                                  start + PAGE_CACHE_SIZE - 1,
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 258c921..bf25ade 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -19,6 +19,7 @@
>  #define EXTENT_FIRST_DELALLOC (1 << 12)
>  #define EXTENT_NEED_WAIT (1 << 13)
>  #define EXTENT_DAMAGED (1 << 14)
> +#define EXTENT_DEDUP (1 << 15) /* reserved for dedup */
>  #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
>  #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
> 
> @@ -222,6 +223,10 @@ int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
>                         struct extent_state **cached_state, gfp_t mask);
>  int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
>                           struct extent_state **cached_state, gfp_t mask);
> +int set_extent_dedup(struct extent_io_tree *tree, u64 start, u64 end,
> +                    struct extent_state **cached_state, gfp_t mask);
> +int clear_extent_dedup(struct extent_io_tree *tree, u64 start, u64 end,
> +                      struct extent_state **cached_state, gfp_t mask);
>  int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
>                    gfp_t mask);
>  int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
> @@ -343,4 +348,14 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
>  int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
>  int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
>                          int mirror_num);
> +int submit_extent_page(int rw, struct extent_io_tree *tree, struct page *page,
> +                      sector_t sector, size_t size, unsigned long offset,
> +                      struct block_device *bdev, struct bio **bio_ret,
> +                      unsigned long max_pages, bio_end_io_t end_io_func,
> +                      int mirror_num, unsigned long prev_bio_flags,
> +                      unsigned long bio_flags);
> +void end_bio_extent_writepage(struct bio *bio, int err);
> +int __must_check submit_one_bio(int rw, struct bio *bio, int mirror_num,
> +                               unsigned long bio_flags);
> +
>  #endif
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index c4628a2..6221e76 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -906,3 +906,245 @@ out:
>  fail_unlock:
>         goto out;
>  }
> +
> +/* 1 means we find one, 0 means we dont. */
> +int noinline_for_stack
> +btrfs_find_dedup_extent(struct btrfs_trans_handle *trans,
> +                       struct btrfs_root *root, u64 *hash, u64 *bytenr_ret,
> +                       u64 *num_bytes_ret, int *compr_ret)
> +{
> +       struct btrfs_key key;
> +       struct btrfs_path *path;
> +       struct extent_buffer *leaf;
> +       struct btrfs_root *dedup_root = root->fs_info->dedup_root;
> +       struct btrfs_dedup_item *item;
> +       struct btrfs_dedup_hash_item *hash_item;
> +       u64 *hash_in_item[4];
> +       u64 hash_value;
> +       u64 length;
> +       int compression;
> +       int found = 0;
> +       int ret;
> +
> +       if (!dedup_root) {
> +               pr_info("%s: dedup not enabled\n", __func__);
> +               return 0;
> +       }
> +
> +       path = btrfs_alloc_path();
> +       if (!path)
> +               return found;
> +
> +       hash_value = hash[BTRFS_DEDUP_HASH_LEN - 1];
> +
> +       key.objectid = hash_value;
> +       key.offset = -1;
> +       btrfs_set_key_type(&key, BTRFS_DEDUP_ITEM_KEY);
> +
> +       ret = btrfs_search_slot(trans, dedup_root, &key, path, 0, 0);
> +       if (ret < 0)
> +               goto out;
> +       BUG_ON(ret == 0);

Do not BUG_ON() anywhere in this patch, return errors.  Only put BUG_ON()'s if
you are wanting to catch a logic error and make sure to comment the fact that
it's a logic check.  For things that can happen because we have the wrong thing
on disk (like the results from btrfs_search_slot) we should be returning errors.

> +
> +prev_slot:
> +       /* this will do match checks. */
> +       ret = btrfs_previous_item(dedup_root, path, hash_value,
> +                                 BTRFS_DEDUP_ITEM_KEY);
> +       if (ret)
> +               goto out;
> +
> +       leaf = path->nodes[0];
> +
> +       item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dedup_item);
> +       /* disk length of dedup range */
> +       length = btrfs_dedup_len(leaf, item);
> +       BUG_ON(length > root->fs_info->dedup_bs);

Error.

> +
> +       compression = btrfs_dedup_compression(leaf, item);
> +       BUG_ON(compression > BTRFS_COMPRESS_TYPES);
> +

Error.

> +       hash_item = (struct btrfs_dedup_hash_item *)(item + 1);
> +       BUG_ON(sizeof(*hash_item) != BTRFS_DEDUP_HASH_SIZE);
> +

Error.

> +       read_extent_buffer(leaf, hash_in_item, ((unsigned long)hash_item),
> +                          BTRFS_DEDUP_HASH_SIZE);
> +       if (memcmp((char *)hash_in_item, (char *)hash, sizeof(*hash_item))) {
> +               pr_info("goto prev\n");
> +               goto prev_slot;
> +       }
> +
> +       btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
> +
> +       BUG_ON(!bytenr_ret);

This is logic so it can stay, just comment that it's a logic check.

> +       *bytenr_ret = key.offset;
> +       *num_bytes_ret = length;
> +       *compr_ret = compression;
> +       found = 1;
> +out:
> +       btrfs_free_path(path);
> +       return found;
> +}
> +
> +int noinline_for_stack
> +btrfs_insert_dedup_extent(struct btrfs_trans_handle *trans,
> +                         struct btrfs_root *root, u64 *hash, u64 bytenr,
> +                         u64 num_bytes, int compr)
> +{
> +       struct btrfs_key key;
> +       struct btrfs_path *path;
> +       struct extent_buffer *leaf;
> +       struct btrfs_root *dedup_root = root->fs_info->dedup_root;
> +       struct btrfs_dedup_item *dedup_item;
> +       struct btrfs_dedup_hash_item *hash_item;
> +       u64 ins_size;
> +       int ret;
> +
> +       if (!dedup_root) {
> +               pr_info("%s: dedup not enabled\n", __func__);
> +               return 0;
> +       }
> +
> +       path = btrfs_alloc_path();
> +       if (!path)
> +               return -ENOMEM;
> +
> +       /* insert index by hash */
> +       ins_size = sizeof(*dedup_item) + sizeof(*hash_item);
> +
> +       key.objectid = hash[BTRFS_DEDUP_HASH_LEN - 1];
> +       key.offset = bytenr;
> +       btrfs_set_key_type(&key, BTRFS_DEDUP_ITEM_KEY);
> +
> +       path->leave_spinning = 1;
> +       ret = btrfs_insert_empty_item(trans, dedup_root, path, &key, ins_size);
> +       if (ret < 0)
> +               goto out;
> +       leaf = path->nodes[0];
> +
> +       dedup_item = btrfs_item_ptr(leaf, path->slots[0],
> +                                   struct btrfs_dedup_item);
> +       /* disk length of dedup range */
> +       BUG_ON(num_bytes > root->fs_info->dedup_bs);

Error.

> +       btrfs_set_dedup_len(leaf, dedup_item, num_bytes);
> +       btrfs_set_dedup_compression(leaf, dedup_item, compr);
> +       btrfs_set_dedup_encryption(leaf, dedup_item, 0);
> +       btrfs_set_dedup_other_encoding(leaf, dedup_item, 0);
> +
> +       hash_item = (struct btrfs_dedup_hash_item *)(dedup_item + 1);
> +       BUG_ON(sizeof(*hash_item) != BTRFS_DEDUP_HASH_SIZE);

Error.

> +
> +       write_extent_buffer(leaf, hash, (unsigned long)hash_item,
> +                           BTRFS_DEDUP_HASH_SIZE);
> +
> +       btrfs_mark_buffer_dirty(leaf);
> +       btrfs_release_path(path);
> +
> +       /* index by disk bytenr */
> +       ins_size = sizeof(*hash_item);
> +
> +       key.objectid = BTRFS_DEDUP_OBJECTID;
> +       key.offset = bytenr;
> +       btrfs_set_key_type(&key, BTRFS_DEDUP_INDEX_KEY);
> +
> +       path->leave_spinning = 1;
> +       ret = btrfs_insert_empty_item(trans, dedup_root, path, &key, ins_size);
> +       if (ret < 0)
> +               goto out;
> +       leaf = path->nodes[0];
> +
> +       hash_item = btrfs_item_ptr(leaf, path->slots[0],
> +                                  struct btrfs_dedup_hash_item);
> +       BUG_ON(sizeof(*hash_item) != BTRFS_DEDUP_HASH_SIZE);

Error.

> +
> +       write_extent_buffer(leaf, hash, (unsigned long)hash_item,
> +                           BTRFS_DEDUP_HASH_SIZE);
> +
> +       btrfs_mark_buffer_dirty(leaf);
> +
> +out:
> +       /* TODO: EEXIST means that we need to mark it as a dup one */
> +       WARN_ON(ret == -EEXIST);
> +       btrfs_free_path(path);
> +       return ret;
> +}
> +
> +int noinline_for_stack
> +btrfs_free_dedup_extent(struct btrfs_trans_handle *trans,
> +                       struct btrfs_root *root, u64 bytenr)
> +{
> +       struct btrfs_key key;
> +       struct btrfs_path *path;
> +       struct extent_buffer *leaf;
> +       struct btrfs_root *dedup_root = root->fs_info->dedup_root;
> +       struct btrfs_dedup_hash_item *hash_item;
> +       u64 hash_in_item[4];
> +       int ret = 0;
> +
> +       if (!dedup_root) {
> +               pr_info("%s: dedup not enabled\n", __func__);
> +               return 0;
> +       }
> +
> +       path = btrfs_alloc_path();
> +       if (!path)
> +               return ret;
> +
> +       /* index by disk_bytenr */
> +       key.objectid = BTRFS_DEDUP_OBJECTID;
> +       key.offset = bytenr;                    /* logical offset */
> +       btrfs_set_key_type(&key, BTRFS_DEDUP_INDEX_KEY);
> +
> +       ret = btrfs_search_slot(trans, dedup_root, &key, path, -1, 1);
> +       if (ret < 0)
> +               goto out;
> +       if (ret == 1) {
> +               ret = 0;
> +               goto out;
> +       }
> +
> +       leaf = path->nodes[0];
> +
> +       ret = -ENOENT;
> +       btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
> +       if (btrfs_key_type(&key) != BTRFS_DEDUP_INDEX_KEY)
> +               goto out;
> +       if (key.objectid != BTRFS_DEDUP_OBJECTID ||
> +           key.offset != bytenr)
> +               goto out;
> +
> +       hash_item = btrfs_item_ptr(leaf, path->slots[0],
> +                                  struct btrfs_dedup_hash_item);
> +       BUG_ON(sizeof(*hash_item) != BTRFS_DEDUP_HASH_SIZE);
> +       read_extent_buffer(leaf, hash_in_item, ((unsigned long)hash_item),
> +                          BTRFS_DEDUP_HASH_SIZE);
> +
> +       ret = btrfs_del_item(trans, dedup_root, path);

Need to check the return value here.

> +
> +       btrfs_release_path(path);
> +
> +       /* index by hash */
> +       key.objectid = hash_in_item[BTRFS_DEDUP_HASH_LEN - 1];
> +       key.offset = bytenr;
> +       btrfs_set_key_type(&key, BTRFS_DEDUP_ITEM_KEY);
> +
> +       ret = btrfs_search_slot(trans, dedup_root, &key, path, -1, 1);
> +       if (ret < 0)
> +               goto out;
> +       BUG_ON(ret);

Error.

> +
> +       leaf = path->nodes[0];
> +
> +       ret = -ENOENT;
> +       btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
> +       if (btrfs_key_type(&key) != BTRFS_DEDUP_ITEM_KEY)
> +               goto out;
> +       if (key.objectid != hash_in_item[BTRFS_DEDUP_HASH_LEN - 1] ||
> +           key.offset != bytenr)
> +               goto out;
> +
> +       ret = btrfs_del_item(trans, dedup_root, path);
> +out:
> +       btrfs_free_path(path);
> +       BUG_ON(ret);

Error.

> +       return 0;
> +}
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b883815..9e99f68 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -97,10 +97,19 @@ static noinline int cow_file_range(struct inode *inode,
>                                    struct page *locked_page,
>                                    u64 start, u64 end, int *page_started,
>                                    unsigned long *nr_written, int unlock);
> +static noinline int cow_file_range_dedup(struct inode *inode,
> +                                  struct page *locked_page,
> +                                  u64 start, u64 end, int *page_started,
> +                                  unsigned long *nr_written, int unlock,
> +                                  u64 *hash);
> +static int run_locked_range(struct extent_io_tree *tree, struct inode *inode,
> +                           struct page *locked_page, u64 start, u64 end,
> +                           get_extent_t *get_extent, int mode, u64 *hash);
>  static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
>                                            u64 len, u64 orig_start,
>                                            u64 block_start, u64 block_len,
>                                            u64 orig_block_len, int type);
> +static int btrfs_inode_test_compress(struct inode *inode);
> 
>  static int btrfs_init_inode_security(struct btrfs_trans_handle *trans,
>                                      struct inode *inode,  struct inode *dir,
> @@ -280,6 +289,7 @@ struct async_extent {
>         unsigned long nr_pages;
>         int compress_type;
>         struct list_head list;
> +       u64 *hash;      /* dedup hash of sha256 */
>  };
> 
>  struct async_cow {
> @@ -297,7 +307,7 @@ static noinline int add_async_extent(struct async_cow *cow,
>                                      u64 compressed_size,
>                                      struct page **pages,
>                                      unsigned long nr_pages,
> -                                    int compress_type)
> +                                    int compress_type, u64 *dedup_hash)
>  {
>         struct async_extent *async_extent;
> 
> @@ -309,10 +319,23 @@ static noinline int add_async_extent(struct async_cow *cow,
>         async_extent->pages = pages;
>         async_extent->nr_pages = nr_pages;
>         async_extent->compress_type = compress_type;
> +       async_extent->hash = NULL;
> +       if (dedup_hash) {
> +               async_extent->hash = kmalloc(sizeof(u64) * 4, GFP_NOFS);
> +               BUG_ON(!async_extent->hash);

Error.

> +               memcpy(async_extent->hash, dedup_hash, BTRFS_DEDUP_HASH_SIZE);
> +       }
> +
>         list_add_tail(&async_extent->list, &cow->extents);
>         return 0;
>  }
> 
> +static noinline void free_async_extent(struct async_extent *p)
> +{
> +       kfree(p->hash);
> +       kfree(p);
> +}
> +
>  /*
>   * we create compressed extents in two phases.  The first
>   * phase compresses a range of pages that have already been
> @@ -334,7 +357,7 @@ static noinline int compress_file_range(struct inode *inode,
>                                         struct page *locked_page,
>                                         u64 start, u64 end,
>                                         struct async_cow *async_cow,
> -                                       int *num_added)
> +                                       int *num_added, u64 *dedup_hash)
>  {
>         struct btrfs_root *root = BTRFS_I(inode)->root;
>         struct btrfs_trans_handle *trans;
> @@ -403,9 +426,7 @@ again:
>          * change at any time if we discover bad compression ratios.
>          */
>         if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS) &&
> -           (btrfs_test_opt(root, COMPRESS) ||
> -            (BTRFS_I(inode)->force_compress) ||
> -            (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))) {
> +           btrfs_inode_test_compress(inode)) {
>                 WARN_ON(pages);
>                 pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
>                 if (!pages) {
> @@ -544,7 +565,7 @@ cont:
>                  */
>                 add_async_extent(async_cow, start, num_bytes,
>                                  total_compressed, pages, nr_pages_ret,
> -                                compress_type);
> +                                compress_type, dedup_hash);
> 
>                 if (start + num_bytes < end) {
>                         start += num_bytes;
> @@ -569,7 +590,7 @@ cleanup_and_bail_uncompressed:
>                 if (redirty)
>                         extent_range_redirty_for_io(inode, start, end);
>                 add_async_extent(async_cow, start, end - start + 1,
> -                                0, NULL, 0, BTRFS_COMPRESS_NONE);
> +                                0, NULL, 0, BTRFS_COMPRESS_NONE, dedup_hash);
>                 *num_added += 1;
>         }
> 
> @@ -633,38 +654,15 @@ again:
>  retry:
>                 /* did the compression code fall back to uncompressed IO? */
>                 if (!async_extent->pages) {
> -                       int page_started = 0;
> -                       unsigned long nr_written = 0;
> -
> -                       lock_extent(io_tree, async_extent->start,
> -                                        async_extent->start +
> -                                        async_extent->ram_size - 1);
> -
> -                       /* allocate blocks */
> -                       ret = cow_file_range(inode, async_cow->locked_page,
> -                                            async_extent->start,
> -                                            async_extent->start +
> -                                            async_extent->ram_size - 1,
> -                                            &page_started, &nr_written, 0);
> -
> -                       /* JDM XXX */
> +                       ret = run_locked_range(io_tree, inode,
> +                                               async_cow->locked_page,
> +                                               async_extent->start,
> +                                               async_extent->start +
> +                                               async_extent->ram_size - 1,
> +                                               btrfs_get_extent, WB_SYNC_ALL,
> +                                               async_extent->hash);
> 
> -                       /*
> -                        * if page_started, cow_file_range inserted an
> -                        * inline extent and took care of all the unlocking
> -                        * and IO for us.  Otherwise, we need to submit
> -                        * all those pages down to the drive.
> -                        */
> -                       if (!page_started && !ret)
> -                               extent_write_locked_range(io_tree,
> -                                                 inode, async_extent->start,
> -                                                 async_extent->start +
> -                                                 async_extent->ram_size - 1,
> -                                                 btrfs_get_extent,
> -                                                 WB_SYNC_ALL);
> -                       else if (ret)
> -                               unlock_page(async_cow->locked_page);
> -                       kfree(async_extent);
> +                       free_async_extent(async_extent);
>                         cond_resched();
>                         continue;
>                 }
> @@ -753,7 +751,8 @@ retry:
>                                                 async_extent->ram_size,
>                                                 ins.offset,
>                                                 BTRFS_ORDERED_COMPRESSED,
> -                                               async_extent->compress_type);
> +                                               async_extent->compress_type,
> +                                               async_extent->hash);
>                 if (ret)
>                         goto out_free_reserve;
> 
> @@ -777,7 +776,7 @@ retry:
>                                     ins.offset, async_extent->pages,
>                                     async_extent->nr_pages);
>                 alloc_hint = ins.objectid + ins.offset;
> -               kfree(async_extent);
> +               free_async_extent(async_extent);
>                 if (ret)
>                         goto out;
>                 cond_resched();
> @@ -798,10 +797,325 @@ out_free:
>                                      EXTENT_CLEAR_DIRTY |
>                                      EXTENT_SET_WRITEBACK |
>                                      EXTENT_END_WRITEBACK);
> -       kfree(async_extent);
> +       free_async_extent(async_extent);
>         goto again;
>  }
> 
> +static int btrfs_dedup_hash_digest(struct btrfs_root *root, const char *data,
> +                                  u64 length, u64 *hash)
> +{
> +       struct crypto_shash *tfm = root->fs_info->dedup_driver;
> +       struct {
> +               struct shash_desc desc;
> +               char ctx[crypto_shash_descsize(tfm)];
> +       } sdesc;
> +
> +       sdesc.desc.tfm = tfm;
> +       sdesc.desc.flags = 0;
> +
> +       return crypto_shash_digest(&sdesc.desc, data, length, (char *)hash);
> +}
> +
> +static int btrfs_calc_dedup_hash(struct btrfs_root *root, struct inode *inode,
> +                                u64 start, u64 *hash)
> +{
> +       struct page *p;
> +       char *data;
> +       u64 length = root->fs_info->dedup_bs;
> +       u64 blocksize = root->sectorsize;
> +       int err;
> +
> +       if (length == blocksize) {
> +               p = find_get_page(inode->i_mapping,
> +                                 (start >> PAGE_CACHE_SHIFT));

Check for NULL here.

> +               data = kmap_atomic(p);
> +               err = btrfs_dedup_hash_digest(root, data, length, hash);
> +               kunmap_atomic(data);
> +               page_cache_release(p);
> +       } else {
> +               char *d;
> +               int i = 0;
> +
> +               data = kmalloc(length, GFP_NOFS);
> +               BUG_ON(!data);

Error.

> +
> +               while (blocksize * i < length) {
> +                       p = find_get_page(inode->i_mapping,
> +                                         (start >> PAGE_CACHE_SHIFT) + i);

Check for NULL.

> +                       d = kmap_atomic(p);
> +                       memcpy((data + blocksize * i), d, blocksize);
> +                       kunmap_atomic(d);
> +                       page_cache_release(p);
> +                       i++;
> +               }
> +
> +               err = btrfs_dedup_hash_digest(root, data, length, hash);
> +               kfree(data);
> +       }
> +       return err;
> +}
> +
> +static noinline int
> +run_delalloc_dedup(struct inode *inode, struct page *locked_page, u64 start,
> +                  u64 end, struct async_cow *async_cow)
> +{
> +       struct btrfs_root *root = BTRFS_I(inode)->root;
> +       struct btrfs_trans_handle *trans = NULL;
> +       struct bio *bio = NULL;
> +       struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
> +       struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
> +       struct extent_map *em;
> +       struct page *page = NULL;
> +       struct block_device *bdev;
> +       struct btrfs_key ins;
> +       u64 blocksize = root->sectorsize;
> +       u64 num_bytes;
> +       u64 cur_alloc_size;
> +       u64 cur_end;
> +       u64 alloc_hint = 0;
> +       u64 iosize;
> +       u64 dedup_bs = root->fs_info->dedup_bs;
> +       u64 dedup_bytenr;
> +       u64 dedup_len;
> +       u64 hash[4];
> +       int compr;
> +       int found;
> +       int type = 0;
> +       sector_t sector;
> +       int ret = 0;
> +       struct extent_state *cached_state = NULL;
> +
> +       BUG_ON(btrfs_is_free_space_inode(inode));
> +
> +       num_bytes = ALIGN(end - start + 1, blocksize);
> +       num_bytes = max(blocksize,  num_bytes);
> +
> +       trans = btrfs_join_transaction(root);
> +       if (IS_ERR(trans)) {
> +               ret = PTR_ERR(trans);
> +               goto out;
> +       }
> +
> +       btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
> +
> +       while (num_bytes > 0) {
> +               unsigned long op = 0;
> +
> +               /* page has been locked by caller */
> +               page = find_get_page(inode->i_mapping,
> +                                    start >> PAGE_CACHE_SHIFT);
> +               BUG_ON(!page);

Add a comment since this is a logic check.

> +
> +               /* already ordered */
> +               if (PagePrivate2(page))
> +                       goto submit;
> +
> +               /* too small data, go for normal path */
> +               if (num_bytes < dedup_bs) {
> +                       cur_end = start + num_bytes - 1;
> +
> +                       if (btrfs_inode_test_compress(inode)) {
> +                               int num_added = 0;
> +                               compress_file_range(inode, page, start, cur_end,
> +                                                   async_cow, &num_added,
> +                                                   NULL);
> +                       } else {
> +                               /* Now locked_page is not dirty. */
> +                               if (page_offset(locked_page) >= start &&
> +                                   page_offset(locked_page) <= cur_end) {
> +                                       __set_page_dirty_nobuffers(locked_page);
> +                               }
> +
> +                               ret = run_locked_range(tree, inode, page, start,
> +                                                      cur_end,
> +                                                      btrfs_get_extent,
> +                                                      WB_SYNC_ALL, NULL);
> +                       }
> +
> +                       page_cache_release(page);
> +                       page = NULL;
> +
> +                       num_bytes -= num_bytes;
> +                       start += num_bytes;
> +                       cond_resched();
> +                       continue;
> +               }
> +
> +               cur_alloc_size = min_t(u64, num_bytes, dedup_bs);
> +               BUG_ON(cur_alloc_size < dedup_bs);

Logic comment.

> +               cur_end = start + cur_alloc_size - 1;
> +
> +               /* see comments in compress_file_range */
> +               extent_range_clear_dirty_for_io(inode, start, cur_end);
> +
> +               memset(hash, 0, sizeof(u64) * 4);
> +               ret = btrfs_calc_dedup_hash(root, inode, start, hash);
> +

Deal with return value here.

> +               compr = BTRFS_COMPRESS_NONE;
> +               found = btrfs_find_dedup_extent(trans, root, hash,
> +                                               &dedup_bytenr, &dedup_len,
> +                                               &compr);
> +               if (!found) {
> +                       /*
> +                        * compress fastpath.
> +                        * so we take the original data as dedup string instead
> +                        * of compressed data as compression methods and data
> +                        * from them vary a lot.
> +                        */
> +                       if (btrfs_inode_test_compress(inode)) {
> +                               int num_added = 0;
> +
> +                               extent_range_redirty_for_io(inode, start,
> +                                                           cur_end);
> +
> +                               compress_file_range(inode, page, start, cur_end,
> +                                                   async_cow, &num_added,
> +                                                   hash);
> +
> +                               page_cache_release(page);
> +                               page = NULL;
> +
> +                               num_bytes -= cur_alloc_size;
> +                               start += cur_alloc_size;
> +                               cond_resched();
> +                               continue;
> +                       }
> +
> +                       /* no compress */
> +                       ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
> +                                          cur_alloc_size, 0, alloc_hint,
> +                                          &ins, 1);
> +                       if (ret < 0) {
> +                               btrfs_abort_transaction(trans, root, ret);
> +                               goto out_unlock;
> +                       }
> +               } else { /* found same hash */
> +                       ins.objectid = dedup_bytenr;
> +                       ins.offset = dedup_len;
> +
> +                       set_extent_dedup(tree, start, cur_end, &cached_state,
> +                                        GFP_NOFS);
> +               }
> +
> +               lock_extent(tree, start, cur_end);
> +
> +               em = alloc_extent_map();
> +               BUG_ON(!em); /* -ENOMEM */

Error;

> +               em->start = start;
> +               em->orig_start = em->start;
> +               em->len = cur_alloc_size;
> +               em->mod_start = em->start;
> +               em->mod_len = em->len;
> +
> +               em->block_start = ins.objectid;
> +               em->block_len = ins.offset;
> +               em->orig_block_len = ins.offset;
> +               em->bdev = root->fs_info->fs_devices->latest_bdev;
> +               set_bit(EXTENT_FLAG_PINNED, &em->flags);
> +               em->generation = -1;
> +
> +               while (1) {
> +                       write_lock(&em_tree->lock);
> +                       ret = add_extent_mapping(em_tree, em);
> +                       if (!ret)
> +                               list_move(&em->list,
> +                                         &em_tree->modified_extents);
> +                       write_unlock(&em_tree->lock);

Should rebase, add_extent_mapping takes a modified option so it does the list
move for you.

> +                       if (ret != -EEXIST) {
> +                               free_extent_map(em);
> +                               break;
> +                       }
> +                       btrfs_drop_extent_cache(inode, start, cur_end, 0);
> +               }
> +

Need to check if ret != 0 here.

> +               if (compr != BTRFS_COMPRESS_NONE)
> +                       type = BTRFS_ORDERED_COMPRESSED;
> +               ret = btrfs_add_ordered_extent_dedup(inode, start, ins.objectid,
> +                                                    cur_alloc_size, ins.offset,
> +                                                    type, found, hash, compr);
> +               BUG_ON(ret); /* -ENOMEM */

Error.

> +
> +               /*
> +                * Do set the Private2 bit so we know this page was properly
> +                * setup for writepage
> +                */
> +               op |= EXTENT_CLEAR_UNLOCK | EXTENT_CLEAR_DELALLOC |
> +                     EXTENT_SET_PRIVATE2 | EXTENT_CLEAR_DIRTY |
> +                     EXTENT_SET_WRITEBACK;
> +               extent_clear_unlock_delalloc(inode, tree, start, cur_end,
> +                                            NULL, op);
> +
> +submit:
> +               iosize = blocksize;
> +
> +               found = test_range_bit(tree, start, start + iosize - 1,
> +                                      EXTENT_DEDUP, 0, cached_state);
> +               if (!found) {
> +                       em = btrfs_get_extent(inode, page, 0, start, blocksize,
> +                                             1);
> +                       BUG_ON(IS_ERR_OR_NULL(em));

Error.

> +
> +                       sector = (em->block_start + start - em->start) >> 9;
> +                       bdev = em->bdev;
> +                       free_extent_map(em);
> +                       em = NULL;
> +
> +                       /* TODO: rw can be WRTIE_SYNC */
> +                       ret = submit_extent_page(WRITE, tree, page, sector,
> +                                                iosize, 0, bdev, &bio,
> +                                                0, /* max_nr is no used */
> +                                                end_bio_extent_writepage,
> +                                                0, 0, 0);
> +                       if (ret)
> +                               break;
> +               } else {
> +                       clear_extent_dedup(tree, start, start + iosize - 1,
> +                                          &cached_state, GFP_NOFS);
> +
> +                       end_extent_writepage(page, 0, start,
> +                                            start + iosize - 1);
> +                       /* we need to do this ourselves because we skip IO */
> +                       end_page_writeback(page);
> +               }
> +
> +               unlock_page(page);
> +               page_cache_release(page);
> +               page = NULL;
> +
> +               num_bytes -= blocksize;
> +               alloc_hint = ins.objectid + blocksize;
> +               start += blocksize;
> +               cond_resched();
> +       }
> +
> +       if (bio) {
> +               ret = submit_one_bio(WRITE, bio, 0, 0);
> +               BUG_ON(ret < 0);

Error.

> +               bio = NULL;
> +       }
> +
> +out_unlock:
> +       if (ret && page)
> +               SetPageError(page);
> +       if (page) {
> +               unlock_page(page);
> +               page_cache_release(page);
> +       }
> +
> +       btrfs_end_transaction(trans, root);
> +out:
> +       if (ret)
> +               extent_clear_unlock_delalloc(inode, tree,
> +                            start, start + num_bytes - 1,
> +                            NULL, EXTENT_CLEAR_UNLOCK_PAGE |
> +                            EXTENT_CLEAR_UNLOCK | EXTENT_CLEAR_DELALLOC |
> +                            EXTENT_CLEAR_DIRTY | EXTENT_SET_WRITEBACK |
> +                            EXTENT_END_WRITEBACK);
> +
> +       free_extent_state(cached_state);
> +       return ret;
> +}
> +
>  static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
>                                       u64 num_bytes)
>  {
> @@ -853,7 +1167,7 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
>                                      struct page *locked_page,
>                                      u64 start, u64 end, int *page_started,
>                                      unsigned long *nr_written,
> -                                    int unlock)
> +                                    int unlock, u64 *hash)
>  {
>         u64 alloc_hint = 0;
>         u64 num_bytes;
> @@ -952,8 +1266,16 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
>                 }
> 
>                 cur_alloc_size = ins.offset;
> -               ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
> -                                              ram_size, cur_alloc_size, 0);
> +               if (!hash)
> +                       ret = btrfs_add_ordered_extent(inode, start,
> +                                                      ins.objectid, ram_size,
> +                                                      cur_alloc_size, 0);
> +               else
> +                       ret = btrfs_add_ordered_extent_dedup(inode, start,
> +                                                      ins.objectid, ram_size,
> +                                                      cur_alloc_size, 0, 0,
> +                                                      hash,
> +                                                      BTRFS_COMPRESS_NONE);
>                 BUG_ON(ret); /* -ENOMEM */
> 
>                 if (root->root_key.objectid ==
> @@ -1031,28 +1353,97 @@ static noinline int cow_file_range(struct inode *inode,
>         trans->block_rsv = &root->fs_info->delalloc_block_rsv;
> 
>         ret = __cow_file_range(trans, inode, root, locked_page, start, end,
> -                              page_started, nr_written, unlock);
> +                              page_started, nr_written, unlock, NULL);
> 
>         btrfs_end_transaction(trans, root);
> 
>         return ret;
>  }
> 
> +static noinline int cow_file_range_dedup(struct inode *inode,
> +                                        struct page *locked_page,
> +                                        u64 start, u64 end, int *page_started,
> +                                        unsigned long *nr_written,
> +                                        int unlock, u64 *hash)
> +{
> +       struct btrfs_trans_handle *trans;
> +       struct btrfs_root *root = BTRFS_I(inode)->root;
> +       int ret;
> +
> +       trans = btrfs_join_transaction(root);
> +       if (IS_ERR(trans)) {
> +               extent_clear_unlock_delalloc(inode,
> +                            &BTRFS_I(inode)->io_tree,
> +                            start, end, locked_page,
> +                            EXTENT_CLEAR_UNLOCK_PAGE |
> +                            EXTENT_CLEAR_UNLOCK |
> +                            EXTENT_CLEAR_DELALLOC |
> +                            EXTENT_CLEAR_DIRTY |
> +                            EXTENT_SET_WRITEBACK |
> +                            EXTENT_END_WRITEBACK);
> +               return PTR_ERR(trans);
> +       }
> +       trans->block_rsv = &root->fs_info->delalloc_block_rsv;
> +
> +       ret = __cow_file_range(trans, inode, root, locked_page, start, end,
> +                              page_started, nr_written, unlock, hash);
> +
> +       btrfs_end_transaction(trans, root);
> +
> +       return ret;
> +}
> +
> +static int run_locked_range(struct extent_io_tree *tree, struct inode *inode,
> +                           struct page *locked_page, u64 start, u64 end,
> +                           get_extent_t *get_extent, int mode, u64 *hash)
> +{
> +       int page_started = 0;
> +       unsigned long nr_written = 0;
> +       int ret;
> +
> +       lock_extent(tree, start, end);
> +
> +       /* allocate blocks */
> +       ret = cow_file_range_dedup(inode, locked_page, start, end,
> +                                  &page_started, &nr_written, 0, hash);
> +
> +       /* JDM XXX */
> +
> +       /*
> +        * if page_started, cow_file_range inserted an
> +        * inline extent and took care of all the unlocking
> +        * and IO for us.  Otherwise, we need to submit
> +        * all those pages down to the drive.
> +        */
> +       if (!page_started && !ret)
> +               extent_write_locked_range(tree, inode, start, end, get_extent,
> +                                         mode);
> +       else if (ret)
> +               unlock_page(locked_page);
> +
> +       return ret;
> +}
> +
>  /*
>   * work queue call back to started compression on a file and pages
>   */
>  static noinline void async_cow_start(struct btrfs_work *work)
>  {
>         struct async_cow *async_cow;
> -       int num_added = 0;
>         async_cow = container_of(work, struct async_cow, work);
> 
> -       compress_file_range(async_cow->inode, async_cow->locked_page,
> -                           async_cow->start, async_cow->end, async_cow,
> -                           &num_added);
> -       if (num_added == 0) {
> -               btrfs_add_delayed_iput(async_cow->inode);
> -               async_cow->inode = NULL;
> +       if (btrfs_test_opt(async_cow->root, DEDUP)) {
> +               run_delalloc_dedup(async_cow->inode, async_cow->locked_page,
> +                                  async_cow->start, async_cow->end, async_cow);
> +       } else {
> +               int num_added = 0;
> +               compress_file_range(async_cow->inode, async_cow->locked_page,
> +                                   async_cow->start, async_cow->end, async_cow,
> +                                   &num_added, NULL);
> +               if (num_added == 0) {
> +                       btrfs_add_delayed_iput(async_cow->inode);
> +                       async_cow->inode = NULL;
> +               }
>         }
>  }
> 
> @@ -1353,7 +1744,8 @@ out_check:
>                 if (cow_start != (u64)-1) {
>                         ret = __cow_file_range(trans, inode, root, locked_page,
>                                                cow_start, found_key.offset - 1,
> -                                              page_started, nr_written, 1);
> +                                              page_started, nr_written, 1,
> +                                              NULL);
>                         if (ret) {
>                                 btrfs_abort_transaction(trans, root, ret);
>                                 goto error;
> @@ -1430,8 +1822,8 @@ out_check:
> 
>         if (cow_start != (u64)-1) {
>                 ret = __cow_file_range(trans, inode, root, locked_page,
> -                                      cow_start, end,
> -                                      page_started, nr_written, 1);
> +                                      cow_start, end, page_started, nr_written,
> +                                      1, NULL);
>                 if (ret) {
>                         btrfs_abort_transaction(trans, root, ret);
>                         goto error;
> @@ -1458,6 +1850,19 @@ error:
>         return ret;
>  }
> 
> +static int btrfs_inode_test_compress(struct inode *inode)
> +{
> +       struct btrfs_inode *bi = BTRFS_I(inode);
> +       struct btrfs_root *root = BTRFS_I(inode)->root;
> +
> +       if (btrfs_test_opt(root, COMPRESS) ||
> +           bi->force_compress ||
> +           bi->flags & BTRFS_INODE_COMPRESS)
> +               return 1;
> +
> +       return 0;
> +}
> +
>  /*
>   * extent_io.c call back to do delayed allocation processing
>   */
> @@ -1467,21 +1872,21 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
>  {
>         int ret;
>         struct btrfs_root *root = BTRFS_I(inode)->root;
> +       struct btrfs_inode *bi = BTRFS_I(inode);
> 
> -       if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) {
> +       if (bi->flags & BTRFS_INODE_NODATACOW) {
>                 ret = run_delalloc_nocow(inode, locked_page, start, end,
>                                          page_started, 1, nr_written);
> -       } else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC) {
> +       } else if (bi->flags & BTRFS_INODE_PREALLOC) {
>                 ret = run_delalloc_nocow(inode, locked_page, start, end,
>                                          page_started, 0, nr_written);
> -       } else if (!btrfs_test_opt(root, COMPRESS) &&
> -                  !(BTRFS_I(inode)->force_compress) &&
> -                  !(BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS)) {
> +       } else if (!btrfs_inode_test_compress(inode) &&
> +                  !btrfs_test_opt(root, DEDUP)) {
>                 ret = cow_file_range(inode, locked_page, start, end,
>                                       page_started, nr_written, 1);
>         } else {
>                 set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
> -                       &BTRFS_I(inode)->runtime_flags);
> +                       &bi->runtime_flags);
>                 ret = cow_file_range_async(inode, locked_page, start, end,
>                                            page_started, nr_written);
>         }
> @@ -1876,12 +2281,13 @@ static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
>         return -EBUSY;
>  }
> 
> -static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
> -                                      struct inode *inode, u64 file_pos,
> -                                      u64 disk_bytenr, u64 disk_num_bytes,
> -                                      u64 num_bytes, u64 ram_bytes,
> -                                      u8 compression, u8 encryption,
> -                                      u16 other_encoding, int extent_type)
> +static int __insert_reserved_file_extent(struct btrfs_trans_handle *trans,
> +                                        struct inode *inode, u64 file_pos,
> +                                        u64 disk_bytenr, u64 disk_num_bytes,
> +                                        u64 num_bytes, u64 ram_bytes,
> +                                        u8 compression, u8 encryption,
> +                                        u16 other_encoding, int extent_type,
> +                                        int dedup, u64 *hash)
>  {
>         struct btrfs_root *root = BTRFS_I(inode)->root;
>         struct btrfs_file_extent_item *fi;
> @@ -1938,15 +2344,46 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>         ins.objectid = disk_bytenr;
>         ins.offset = disk_num_bytes;
>         ins.type = BTRFS_EXTENT_ITEM_KEY;
> -       ret = btrfs_alloc_reserved_file_extent(trans, root,
> -                                       root->root_key.objectid,
> -                                       btrfs_ino(inode), file_pos, &ins);
> +
> +       if (!dedup) {
> +               if (hash)
> +                       ret = btrfs_insert_dedup_extent(trans, root, hash,
> +                                                       ins.objectid,
> +                                                       ins.offset,
> +                                                       compression);
> +
> +               ret = btrfs_alloc_reserved_file_extent(trans, root,
> +                                                      root->root_key.objectid,
> +                                                      btrfs_ino(inode),
> +                                                      file_pos, &ins);
> +       } else {
> +               ret = btrfs_inc_extent_ref(trans, root, ins.objectid,
> +                                          ins.offset, 0,
> +                                          root->root_key.objectid,
> +                                          btrfs_ino(inode),
> +                                          file_pos, /* file_pos - 0 */
> +                                          0);
> +       }
>  out:
>         btrfs_free_path(path);
> 
>         return ret;
>  }
> 
> +static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
> +                                      struct inode *inode, u64 file_pos,
> +                                      u64 disk_bytenr, u64 disk_num_bytes,
> +                                      u64 num_bytes, u64 ram_bytes,
> +                                      u8 compression, u8 encryption,
> +                                      u16 other_encoding, int extent_type)
> +{
> +       return __insert_reserved_file_extent(trans, inode, file_pos,
> +                                            disk_bytenr, disk_num_bytes,
> +                                            num_bytes, ram_bytes, compression,
> +                                            encryption, other_encoding,
> +                                            extent_type, 0, NULL);
> +}
> +
>  /* snapshot-aware defrag */
>  struct sa_defrag_extent_backref {
>         struct rb_node node;
> @@ -2671,14 +3108,16 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>                                                 ordered_extent->len);
>         } else {
>                 BUG_ON(root == root->fs_info->tree_root);
> -               ret = insert_reserved_file_extent(trans, inode,
> +               ret = __insert_reserved_file_extent(trans, inode,
>                                                 ordered_extent->file_offset,
>                                                 ordered_extent->start,
>                                                 ordered_extent->disk_len,
>                                                 ordered_extent->len,
>                                                 ordered_extent->len,
>                                                 compress_type, 0, 0,
> -                                               BTRFS_FILE_EXTENT_REG);
> +                                               BTRFS_FILE_EXTENT_REG,
> +                                               ordered_extent->dedup,
> +                                               ordered_extent->hash);
>         }
>         unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
>                            ordered_extent->file_offset, ordered_extent->len,
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 898c572..f9d0098 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4017,6 +4017,42 @@ out_unlock:
>         return ret;
>  }
> 
> +static long btrfs_ioctl_enable_dedup(struct btrfs_root *root)
> +{
> +       struct btrfs_fs_info *fs_info = root->fs_info;
> +       struct btrfs_trans_handle *trans = NULL;
> +       struct btrfs_root *dedup_root;
> +       int ret = 0;
> +
> +       if (fs_info->dedup_root) {
> +               pr_info("dedup has already been enabled\n");
> +               return 0;
> +       }
> +
> +       trans = btrfs_start_transaction(root, 2);
> +       if (IS_ERR(trans)) {
> +               ret = PTR_ERR(trans);
> +               pr_info("trans error %d\n", ret);
> +               return ret;
> +       }
> +
> +       dedup_root = btrfs_create_tree(trans, fs_info,
> +                                      BTRFS_DEDUP_TREE_OBJECTID);
> +       if (IS_ERR(dedup_root))
> +               ret = PTR_ERR(dedup_root);
> +
> +       if (ret)
> +               ret = btrfs_end_transaction(trans, root);

You lose the error value if you do this.

> +       else
> +               ret = btrfs_commit_transaction(trans, root);
> +
> +       if (!ret) {
> +               pr_info("dedup enabled\n");
> +               fs_info->dedup_root = dedup_root;
> +       }
> +       return ret;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>                 cmd, unsigned long arg)
>  {
> @@ -4121,6 +4157,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>                 return btrfs_ioctl_get_fslabel(file, argp);
>         case BTRFS_IOC_SET_FSLABEL:
>                 return btrfs_ioctl_set_fslabel(file, argp);
> +       case BTRFS_IOC_DEDUP_REGISTER:
> +               return btrfs_ioctl_enable_dedup(root);
>         }
> 
>         return -ENOTTY;
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 005c45d..ab1f5db 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -182,7 +182,8 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
>   */
>  static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
>                                       u64 start, u64 len, u64 disk_len,
> -                                     int type, int dio, int compress_type)
> +                                     int type, int dio, int compress_type,
> +                                     int dedup, u64 *hash)
>  {
>         struct btrfs_ordered_inode_tree *tree;
>         struct rb_node *node;
> @@ -201,6 +202,15 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
>                 entry->csum_bytes_left = disk_len;
>         entry->disk_len = disk_len;
>         entry->bytes_left = len;
> +       entry->dedup = dedup;
> +       entry->hash = NULL;
> +
> +       if (!dedup && hash) {
> +               entry->hash = kmalloc(sizeof(u64) * 4, GFP_NOFS);
> +               BUG_ON(!entry->hash);

Error.

> +               memcpy(entry->hash, hash, BTRFS_DEDUP_HASH_SIZE);
> +       }
> +
>         entry->inode = igrab(inode);
>         entry->compress_type = compress_type;
>         if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
> @@ -240,7 +250,16 @@ int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
>  {
>         return __btrfs_add_ordered_extent(inode, file_offset, start, len,
>                                           disk_len, type, 0,
> -                                         BTRFS_COMPRESS_NONE);
> +                                         BTRFS_COMPRESS_NONE, 0, NULL);
> +}
> +
> +int btrfs_add_ordered_extent_dedup(struct inode *inode, u64 file_offset,
> +                            u64 start, u64 len, u64 disk_len, int type,
> +                            int dedup, u64 *hash, int compress_type)
> +{
> +       return __btrfs_add_ordered_extent(inode, file_offset, start, len,
> +                                         disk_len, type, 0,
> +                                         compress_type, dedup, hash);
>  }
> 
>  int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
> @@ -248,16 +267,16 @@ int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
>  {
>         return __btrfs_add_ordered_extent(inode, file_offset, start, len,
>                                           disk_len, type, 1,
> -                                         BTRFS_COMPRESS_NONE);
> +                                         BTRFS_COMPRESS_NONE, 0, NULL);
>  }
> 
>  int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
>                                       u64 start, u64 len, u64 disk_len,
> -                                     int type, int compress_type)
> +                                     int type, int compress_type, u64 *hash)
>  {
>         return __btrfs_add_ordered_extent(inode, file_offset, start, len,
>                                           disk_len, type, 0,
> -                                         compress_type);
> +                                         compress_type, 0, hash);
>  }
> 
>  /*
> @@ -493,6 +512,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
>                         list_del(&sum->list);
>                         kfree(sum);
>                 }
> +               kfree(entry->hash);
>                 kmem_cache_free(btrfs_ordered_extent_cache, entry);
>         }
>  }
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 8eadfe4..374657b 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -114,6 +114,9 @@ struct btrfs_ordered_extent {
>         /* compression algorithm */
>         int compress_type;
> 
> +       /* if this is for dedup or not */
> +       int dedup;
> +
>         /* reference count */
>         atomic_t refs;
> 
> @@ -140,6 +143,9 @@ struct btrfs_ordered_extent {
>         struct completion completion;
>         struct btrfs_work flush_work;
>         struct list_head work_list;
> +
> +       /* dedup hash of sha256 type */
> +       u64 *hash;
>  };
> 
>  /*
> @@ -176,11 +182,14 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
>                                    int uptodate);
>  int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
>                              u64 start, u64 len, u64 disk_len, int type);
> +int btrfs_add_ordered_extent_dedup(struct inode *inode, u64 file_offset,
> +                                  u64 start, u64 len, u64 disk_len, int type,
> +                                  int dedup, u64 *hash, int compress_type);
>  int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
>                                  u64 start, u64 len, u64 disk_len, int type);
>  int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
>                                       u64 start, u64 len, u64 disk_len,
> -                                     int type, int compress_type);
> +                                     int type, int compress_type, u64 *hash);
>  void btrfs_add_ordered_sum(struct inode *inode,
>                            struct btrfs_ordered_extent *entry,
>                            struct btrfs_ordered_sum *sum);
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 68a29a1..db48ad2 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -320,7 +320,8 @@ enum {
>         Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
>         Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
>         Opt_check_integrity, Opt_check_integrity_including_extent_data,
> -       Opt_check_integrity_print_mask, Opt_fatal_errors,
> +       Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_dedup,
> +       Opt_dedup_bs,
>         Opt_err,
>  };
> 
> @@ -361,6 +362,8 @@ static match_table_t tokens = {
>         {Opt_check_integrity_including_extent_data, "check_int_data"},
>         {Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
>         {Opt_fatal_errors, "fatal_errors=%s"},
> +       {Opt_dedup_bs, "dedup_bs=%s"},
> +       {Opt_dedup, "dedup"},
>         {Opt_err, NULL},
>  };
> 
> @@ -626,6 +629,25 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>                                 goto out;
>                         }
>                         break;
> +               case Opt_dedup_bs:
> +                       num = match_strdup(&args[0]);
> +                       if (num) {
> +                               info->dedup_bs = memparse(num, NULL);
> +                               kfree(num);
> +
> +                               if (info->dedup_bs) {
> +                                       info->dedup_bs = ALIGN(info->dedup_bs,
> +                                                             root->sectorsize);
> +                                       info->dedup_bs = min_t(u64,
> +                                                              info->dedup_bs,
> +                                                              (128 * 1024ULL));
> +                               }
> +                       }
> +               case Opt_dedup:
> +                       pr_info("btrfs: use deduplication(dedup blocksize %llu)\n",
> +                               (unsigned long long)info->dedup_bs);
> +                       btrfs_set_opt(info->mount_opt, DEDUP);
> +                       break;
>                 case Opt_err:
>                         printk(KERN_INFO "btrfs: unrecognized mount option "
>                                "'%s'\n", p);
> @@ -953,6 +975,9 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
>                 seq_puts(seq, ",skip_balance");
>         if (btrfs_test_opt(root, PANIC_ON_FATAL_ERROR))
>                 seq_puts(seq, ",fatal_errors=panic");
> +       if (btrfs_test_opt(root, DEDUP))
> +               seq_printf(seq, ",dedup_bs=%llu",
> +                          (unsigned long long)info->dedup_bs);
>         return 0;
>  }
> 
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index fa3a5f9..9c01368 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -510,5 +510,6 @@ struct btrfs_ioctl_send_args {
>                                       struct btrfs_ioctl_get_dev_stats)
>  #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
>                                     struct btrfs_ioctl_dev_replace_args)
> +#define BTRFS_IOC_DEDUP_REGISTER       _IO(BTRFS_IOCTL_MAGIC, 54)
> 
>  #endif /* _UAPI_LINUX_BTRFS_H */

Please fix those things up.  Thanks,

Josef
