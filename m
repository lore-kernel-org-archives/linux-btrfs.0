Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26654 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751020AbaKFCqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Nov 2014 21:46:36 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sA62kKjl010186
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Nov 2014 10:46:20 +0800
Message-ID: <545AE106.5080008@cn.fujitsu.com>
Date: Thu, 6 Nov 2014 10:46:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs: Add support for nocow write into prealloc
 space with compression
References: <1411012892-17481-1-git-send-email-quwenruo@cn.fujitsu.com> <1411012892-17481-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1411012892-17481-2-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ping.

Any comments?
-------- Original Message --------
Subject: [PATCH 2/2] btrfs: Add support for nocow write into prealloc 
space with compression
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年09月18日 12:01
> ******************************************************
> * WARNING: on-disk data format changes is introduced *
> ******************************************************
>
> Before this patch, when use compression, prealloc space will never be used,
> and any compression write into it will be cowed.
It seems Wang's patch fixed the behavior and now, even mount with 
compress, preallocated space will be nocow
written with uncompressed data.

But other change log is OK.

Thanks,
Qu
>
> If we just split the prealloc space and do the normal compress write
> into the preallocated space,
> a lot of new backref will be created for each compressed write, which may
> lead to performance regression.
>
> So to keep the behavior much similar to the uncompressed prealloc write,
> which will not add new backref for the write and only increase
> the original backref, we mush keep the disk_bytenr/disk_num_bytes
> the same as the prealloc range.
> Due to the above limit, we need to introduce two new members in
> btrfs_file_extent_item to record where the real compressed data lies:
> 1. data_offset
> The offset to the prealloc range start where on-disk data is.
>
> 2. data_len
> The length of the on-disk compressed data length.
>
> Other members will keep the behavior of uncompressed nocow write into
> prealloc range.
>
> The overall new btrfs_file_extent_item will acts like the following after
> a compressed write into prealloc range:
>
> 0	4K	8K	12K	16K	32K <- file offset
> 	|--------compressed-----|
> 	|disk_bytenr: A		/  \
> 	|disk_num_bytes: 32K  /	    --- Same behavior as uncompressed write
> 	|offset: 4K	   /	---/
> 	|data_offset: 4K/
> 	|data_len: 4K/
> 	|ram: 12K /
> 	|-------|	<- On disk data
> |-----------------------------------------|
> A	+4K	+8K	+12K	+16K	+32K	<-disk bytenr
>
> For the backward compatibility, current implement is to use the
> following method:
> 1) COMPPREALLOC incompatible flags.
> Add new COMPPREALLOC incompatible flag, which is determined at mkfs
> time.
> Only when COMPPREALLOC flag is set, nocow compressed write will happen.
> Seamless convert will be added later like using
> 'convert=compressed-prealloc' mount option to seamlessly convert old fs
> to use new file extent.
>
> 2) Only append the new members at nocow write, and provide fallback
> setget funcions.
> New macro BTRFS_SETGET_APPEND_FUNCS is introduced to provide set/get
> support on the new members.
> Only when given incompatible flags is set *AND* the item size is larger
> than the original item size, set/get on the new members will work.
> Or fallback function is called to get corresponding fallback value when
> get function is called, and set function will just be ignored.
>
> So old file extent format is not changed without the COMPPREALLOC flag,
> and is compatibility with old kernels.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/ctree.c        |  33 ++++++
>   fs/btrfs/ctree.h        | 112 +++++++++++++++++-
>   fs/btrfs/extent_map.c   |   1 +
>   fs/btrfs/extent_map.h   |   1 +
>   fs/btrfs/file-item.c    |  14 ++-
>   fs/btrfs/file.c         |  39 +++++-
>   fs/btrfs/inode.c        | 309 +++++++++++++++++++++++++++++++++++++++++++-----
>   fs/btrfs/ordered-data.h |   2 +
>   fs/btrfs/tree-log.c     |  99 +++++++++++++---
>   9 files changed, 556 insertions(+), 54 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 44ee5d2..d24a448 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -4721,6 +4721,39 @@ void btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
>   }
>   
>   /*
> + * resize the item pointer to by the path, may split leaf if free space
> + * is not enough, so it may return -EAGAIN.
> + *
> + * ins_len is the size to added by. can be minus, then will just truncate
> + * item size.
> + */
> +int btrfs_resize_item(struct btrfs_trans_handle *trans,
> +		      struct btrfs_root *root,
> +		      struct btrfs_path *path,
> +		      int ins_len)
> +{
> +	struct extent_buffer *leaf;
> +	int slot;
> +	int ret = 0;
> +	int item_size;
> +
> +	if (!ins_len)
> +		goto out;
> +	leaf = path->nodes[0];
> +	slot = path->slots[0];
> +	item_size = btrfs_item_size_nr(leaf, slot);
> +	if (ins_len > 0) {
> +		ret = setup_leaf_for_split(trans, root, path, ins_len);
> +		if (ret)
> +			goto out;
> +		btrfs_extend_item(root, path, ins_len);
> +	} else
> +		btrfs_truncate_item(root, path, item_size + ins_len, 1);
> +out:
> +	return ret;
> +}
> +
> +/*
>    * this is a helper for btrfs_insert_empty_items, the main goal here is
>    * to save stack depth by doing the bulk of the work in a function
>    * that doesn't call btrfs_search_slot
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2fc7908..bfd3fbd 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -524,6 +524,7 @@ struct btrfs_super_block {
>   #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
>   #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
>   #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
> +#define BTRFS_FEATURE_INCOMPAT_COMPPREALLOC	(1ULL << 10)
>   
>   #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
>   #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
> @@ -541,7 +542,8 @@ struct btrfs_super_block {
>   	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
>   	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
>   	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
> -	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
> +	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
> +	 BTRFS_FEATURE_INCOMPAT_COMPPREALLOC)
>   
>   #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
>   	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
> @@ -922,6 +924,18 @@ struct btrfs_file_extent_item {
>   
>   } __attribute__ ((__packed__));
>   
> +struct __compprealloc_data {
> +	/* extent offset where we read data from disk. */
> +	__le64 data_offset;
> +	/* extent len that we need read into memory. */
> +	__le64 data_len;
> +
> +} __attribute__ ((__packed__));
> +
> +#define BTRFS_FILE_EXTENT_SIZE_NORMAL (sizeof(struct btrfs_file_extent_item))
> +#define BTRFS_FILE_EXTENT_SIZE_MAX (sizeof(struct btrfs_file_extent_item) + \
> +				    sizeof(struct __compprealloc_data))
> +
>   struct btrfs_csum_item {
>   	u8 csum;
>   } __attribute__ ((__packed__));
> @@ -3046,6 +3060,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_num_bytes,
>   BTRFS_SETGET_STACK_FUNCS(stack_file_extent_compression,
>   			 struct btrfs_file_extent_item, compression, 8);
>   
> +
>   static inline unsigned long
>   btrfs_file_extent_inline_start(struct btrfs_file_extent_item *e)
>   {
> @@ -3497,6 +3512,10 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
>   			 struct btrfs_root *root,
>   			 struct btrfs_path *path,
>   			 struct btrfs_key *new_key);
> +int btrfs_resize_item(struct btrfs_trans_handle *trans,
> +		      struct btrfs_root *root,
> +		      struct btrfs_path *path,
> +		      int ins_len);
>   int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
>   		u64 inum, u64 ioff, u8 key_type, struct btrfs_key *found_key);
>   int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
> @@ -3905,7 +3924,8 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
>   		       struct btrfs_root *root, struct inode *inode, u64 start,
>   		       u64 end, int drop_cache);
>   int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
> -			      struct inode *inode, u64 start, u64 end);
> +			      struct inode *inode, u64 start, u64 end,
> +			      u64 disk_len, int compress_type);
>   int btrfs_release_file(struct inode *inode, struct file *file);
>   int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
>   		      struct page **pages, size_t num_pages,
> @@ -4021,6 +4041,94 @@ static inline int __btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
>   	return !!(btrfs_super_incompat_flags(disk_super) & flag);
>   }
>   
> +/* struct __compprealloc_data, don't use them directly!!! */
> +BTRFS_SETGET_FUNCS(__compprealloc_data_offset, struct __compprealloc_data,
> +		   data_offset, 64);
> +BTRFS_SETGET_FUNCS(__compprealloc_data_len, struct __compprealloc_data,
> +		   data_len, 64);
> +
> +/* functions for appended data after a original structure */
> +#define BTRFS_SETGET_APPEND_FUNCS(name, type, new_type, func, bits,	\
> +				  flag, fallback)			\
> +static inline u##bits btrfs_##name(struct extent_buffer *eb,		\
> +				   int slot, type *s)			\
> +{									\
> +	if (eb->fs_info && eb->fs_info->super_copy &&			\
> +	    btrfs_fs_incompat(eb->fs_info, flag) &&			\
> +	    btrfs_item_size_nr(eb, slot) > sizeof(*s))			\
> +		return btrfs_##func(eb, (new_type *)(s + 1));		\
> +	return fallback(eb, s);						\
> +}									\
> +static inline void btrfs_set_##name(struct extent_buffer *eb,		\
> +				    int slot, type *s, u##bits val)	\
> +{									\
> +	if (eb->fs_info && eb->fs_info->super_copy &&			\
> +	    btrfs_fs_incompat(eb->fs_info, flag) &&			\
> +	    btrfs_item_size_nr(eb, slot) > sizeof(*s))			\
> +		btrfs_set_##func(eb, (new_type *)(s + 1), val);		\
> +}									\
> +static inline u##bits btrfs_token_##name(struct extent_buffer *eb, type *s, \
> +					 int slot,			\
> +					 struct btrfs_map_token *token)	\
> +{									\
> +	if (eb->fs_info && eb->fs_info->super_copy &&			\
> +	    btrfs_fs_incompat(eb->fs_info, flag) &&			\
> +	    btrfs_item_size_nr(eb, slot) > sizeof(*s))			\
> +		return btrfs_token_##func(eb, (new_type *)(s + 1),	\
> +					      token);		\
> +	return fallback##_token(eb, s, token);				\
> +}									\
> +static inline void btrfs_set_token_##name(struct extent_buffer *eb,	\
> +					  int slot, type *s,		\
> +					  u##bits val,			\
> +					 struct btrfs_map_token *token)	\
> +{									\
> +	if (eb->fs_info && eb->fs_info->super_copy &&			\
> +	    btrfs_fs_incompat(eb->fs_info, flag) &&			\
> +	    btrfs_item_size_nr(eb, slot) > sizeof(*s))			\
> +		btrfs_set_token_##func(eb, (new_type *)(s + 1),		\
> +				       val, token);			\
> +}
> +
> +/* appended data for btrfs_file_extent_item */
> +static inline u64
> +data_offset_fallback(struct extent_buffer *eb,
> +		     struct btrfs_file_extent_item *fi)
> +{
> +	return 0;
> +}
> +static inline u64
> +data_offset_fallback_token(struct extent_buffer *eb,
> +			   struct btrfs_file_extent_item *fi,
> +			   struct btrfs_map_token *token)
> +{
> +	return 0;
> +}
> +BTRFS_SETGET_APPEND_FUNCS(ondemand_file_extent_data_offset,
> +			  struct btrfs_file_extent_item,
> +			  struct __compprealloc_data,
> +			  __compprealloc_data_offset,
> +			  64, COMPPREALLOC, data_offset_fallback);
> +
> +static inline u64
> +data_len_fallback(struct extent_buffer *eb,
> +		  struct btrfs_file_extent_item *fi)
> +{
> +	return btrfs_file_extent_disk_num_bytes(eb, fi);
> +}
> +static inline u64
> +data_len_fallback_token(struct extent_buffer *eb,
> +			struct btrfs_file_extent_item *fi,
> +			struct btrfs_map_token *token)
> +{
> +	return btrfs_token_file_extent_disk_num_bytes(eb, fi, token);
> +}
> +BTRFS_SETGET_APPEND_FUNCS(ondemand_file_extent_data_len,
> +			  struct btrfs_file_extent_item,
> +			  struct __compprealloc_data,
> +			  __compprealloc_data_len,
> +			  64, COMPPREALLOC, data_len_fallback);
> +
>   /*
>    * Call btrfs_abort_transaction as early as possible when an error condition is
>    * detected, that way the exact line number is reported.
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 225302b..c3794c6 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -237,6 +237,7 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
>   			em->len += merge->len;
>   			em->block_len += merge->block_len;
>   			em->block_start = merge->block_start;
> +			em->orig_block_start = merge->block_start;
>   			em->mod_len = (em->mod_len + em->mod_start) - merge->mod_start;
>   			em->mod_start = merge->mod_start;
>   			em->generation = max(em->generation, merge->generation);
> diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
> index b2991fd..ee2d9c3 100644
> --- a/fs/btrfs/extent_map.h
> +++ b/fs/btrfs/extent_map.h
> @@ -29,6 +29,7 @@ struct extent_map {
>   	u64 orig_block_len;
>   	u64 ram_bytes;
>   	u64 block_start;
> +	u64 orig_block_start;
>   	u64 block_len;
>   	u64 generation;
>   	unsigned long flags;
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 54c84da..fed2c71 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -931,17 +931,27 @@ void btrfs_extent_item_to_extent_map(struct inode *inode,
>   		if (compress_type != BTRFS_COMPRESS_NONE) {
>   			set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
>   			em->compress_type = compress_type;
> -			em->block_start = bytenr;
> -			em->block_len = em->orig_block_len;
> +			em->block_start = bytenr +
> +				btrfs_ondemand_file_extent_data_offset(leaf,
> +								slot, fi);
> +			em->block_len =
> +				btrfs_ondemand_file_extent_data_len(leaf,
> +								slot, fi);
> +			em->orig_block_start = bytenr;
> +			em->orig_start +=
> +				btrfs_ondemand_file_extent_data_offset(leaf,
> +								slot, fi);
>   		} else {
>   			bytenr += btrfs_file_extent_offset(leaf, fi);
>   			em->block_start = bytenr;
> +			em->orig_block_start = bytenr;
>   			em->block_len = em->len;
>   			if (type == BTRFS_FILE_EXTENT_PREALLOC)
>   				set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
>   		}
>   	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
>   		em->block_start = EXTENT_MAP_INLINE;
> +		em->orig_block_start = EXTENT_MAP_INLINE;
>   		em->start = extent_start;
>   		em->len = extent_end - extent_start;
>   		/*
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 36861b7..d44d1f4 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -598,6 +598,7 @@ void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
>   			if (em->block_start < EXTENT_MAP_LAST_BYTE) {
>   				split->orig_start = em->orig_start;
>   				split->block_start = em->block_start;
> +				split->orig_block_start = em->block_start;
>   
>   				if (compressed)
>   					split->block_len = em->block_len;
> @@ -610,6 +611,7 @@ void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
>   				split->orig_start = split->start;
>   				split->block_len = 0;
>   				split->block_start = em->block_start;
> +				split->orig_block_start = em->block_start;
>   				split->orig_block_len = 0;
>   				split->ram_bytes = split->len;
>   			}
> @@ -641,11 +643,15 @@ void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
>   				if (compressed) {
>   					split->block_len = em->block_len;
>   					split->block_start = em->block_start;
> +					split->orig_block_start =
> +							em->block_start;
>   					split->orig_start = em->orig_start;
>   				} else {
>   					split->block_len = split->len;
> -					split->block_start = em->block_start
> -						+ diff;
> +					split->block_start =
> +						em->block_start + diff;
> +					split->orig_block_start =
> +						em->block_start + diff;
>   					split->orig_start = em->orig_start;
>   				}
>   			} else {
> @@ -653,6 +659,7 @@ void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
>   				split->orig_start = split->start;
>   				split->block_len = 0;
>   				split->block_start = em->block_start;
> +				split->orig_block_start = em->block_start;
>   				split->orig_block_len = 0;
>   			}
>   
> @@ -1067,7 +1074,8 @@ static int extent_mergeable(struct extent_buffer *leaf, int slot,
>    * two or three.
>    */
>   int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
> -			      struct inode *inode, u64 start, u64 end)
> +			      struct inode *inode, u64 start, u64 end,
> +			      u64 disk_len, int compress_type)
>   {
>   	struct btrfs_root *root = BTRFS_I(inode)->root;
>   	struct extent_buffer *leaf;
> @@ -1256,11 +1264,35 @@ again:
>   		BUG_ON(ret); /* -ENOMEM */
>   	}
>   	if (del_nr == 0) {
> +		if (compress_type != BTRFS_COMPRESS_NONE) {
> +			int ins_len = BTRFS_FILE_EXTENT_SIZE_MAX -
> +				      BTRFS_FILE_EXTENT_SIZE_NORMAL;
> +			ret = btrfs_resize_item(trans, root, path, ins_len);
> +			if (ret == -EAGAIN) {
> +				/*
> +				 * Now although prealloc file extent is split,
> +				 * it's still prealloc file extent and its
> +				 * data is valid, goto again should be OK.
> +				 */
> +				btrfs_release_path(path);
> +				goto again;
> +			}
> +			if (ret < 0) {
> +				btrfs_abort_transaction(trans, root, ret);
> +				goto out;
> +			}
> +		}
> +		leaf = path->nodes[0];
>   		fi = btrfs_item_ptr(leaf, path->slots[0],
>   			   struct btrfs_file_extent_item);
> +		btrfs_set_file_extent_compression(leaf, fi, compress_type);
>   		btrfs_set_file_extent_type(leaf, fi,
>   					   BTRFS_FILE_EXTENT_REG);
>   		btrfs_set_file_extent_generation(leaf, fi, trans->transid);
> +		btrfs_set_ondemand_file_extent_data_offset(leaf,
> +				path->slots[0], fi, start - orig_offset);
> +		btrfs_set_ondemand_file_extent_data_len(leaf,
> +				path->slots[0], fi, disk_len);
>   		btrfs_mark_buffer_dirty(leaf);
>   	} else {
>   		fi = btrfs_item_ptr(leaf, del_slot - 1,
> @@ -2134,6 +2166,7 @@ out:
>   		hole_em->orig_start = offset;
>   
>   		hole_em->block_start = EXTENT_MAP_HOLE;
> +		hole_em->orig_block_start = EXTENT_MAP_HOLE;
>   		hole_em->block_len = 0;
>   		hole_em->orig_block_len = 0;
>   		hole_em->bdev = root->fs_info->fs_devices->latest_bdev;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2f61ce9..9dce029 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -323,6 +323,10 @@ struct async_cow {
>   	struct page *locked_page;
>   	u64 start;
>   	u64 end;
> +	u64 block_start;
> +	u64 orig_block_len;
> +	u64 orig_block_start;
> +	int need_end_nocow_write;
>   	struct list_head extents;
>   	struct btrfs_work work;
>   };
> @@ -650,9 +654,12 @@ static noinline int submit_compressed_extents(struct inode *inode,
>   	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
>   	struct extent_io_tree *io_tree;
>   	int ret = 0;
> +	int type = BTRFS_ORDERED_COMPRESSED;
>   
>   	if (list_empty(&async_cow->extents))
>   		return 0;
> +	if (async_cow->block_start)
> +		type = BTRFS_ORDERED_COMPRESS_PREALLOC;
>   
>   again:
>   	while (!list_empty(&async_cow->extents)) {
> @@ -704,6 +711,13 @@ retry:
>   		lock_extent(io_tree, async_extent->start,
>   			    async_extent->start + async_extent->ram_size - 1);
>   
> +
> +		if (type == BTRFS_ORDERED_COMPRESS_PREALLOC) {
> +			ins.objectid = async_cow->block_start +
> +				       async_extent->start - async_cow->start;
> +			ins.offset = async_extent->compressed_size;
> +			goto skip;
> +		}
>   		ret = btrfs_reserve_extent(root,
>   					   async_extent->compressed_size,
>   					   async_extent->compressed_size,
> @@ -739,7 +753,7 @@ retry:
>   			}
>   			goto out_free;
>   		}
> -
> +skip:
>   		/*
>   		 * here we're doing allocation and writeback of the
>   		 * compressed pages
> @@ -747,7 +761,6 @@ retry:
>   		btrfs_drop_extent_cache(inode, async_extent->start,
>   					async_extent->start +
>   					async_extent->ram_size - 1, 0);
> -
>   		em = alloc_extent_map();
>   		if (!em) {
>   			ret = -ENOMEM;
> @@ -758,17 +771,22 @@ retry:
>   		em->orig_start = em->start;
>   		em->mod_start = em->start;
>   		em->mod_len = em->len;
> -
>   		em->block_start = ins.objectid;
>   		em->block_len = ins.offset;
>   		em->orig_block_len = ins.offset;
> +		em->orig_block_start = em->block_start;
> +		/* use total fallocated space len */
>   		em->ram_bytes = async_extent->ram_size;
>   		em->bdev = root->fs_info->fs_devices->latest_bdev;
>   		em->compress_type = async_extent->compress_type;
> +		if (type == BTRFS_ORDERED_COMPRESS_PREALLOC) {
> +			em->orig_block_len = async_cow->orig_block_len;
> +			em->orig_block_start = async_cow->orig_block_start;
> +			set_bit(EXTENT_FLAG_FILLING, &em->flags);
> +		}
>   		set_bit(EXTENT_FLAG_PINNED, &em->flags);
>   		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
>   		em->generation = -1;
> -
>   		while (1) {
>   			write_lock(&em_tree->lock);
>   			ret = add_extent_mapping(em_tree, em, 1);
> @@ -789,8 +807,7 @@ retry:
>   						async_extent->start,
>   						ins.objectid,
>   						async_extent->ram_size,
> -						ins.offset,
> -						BTRFS_ORDERED_COMPRESSED,
> +						ins.offset, type,
>   						async_extent->compress_type);
>   		if (ret)
>   			goto out_free_reserve;
> @@ -820,7 +837,8 @@ retry:
>   out:
>   	return ret;
>   out_free_reserve:
> -	btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 1);
> +	if (!async_cow->block_start)
> +		btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 1);
>   out_free:
>   	extent_clear_unlock_delalloc(inode, async_extent->start,
>   				     async_extent->start +
> @@ -960,6 +978,7 @@ static noinline int cow_file_range(struct inode *inode,
>   		em->mod_len = em->len;
>   
>   		em->block_start = ins.objectid;
> +		em->orig_block_start = ins.objectid;
>   		em->block_len = ins.offset;
>   		em->orig_block_len = ins.offset;
>   		em->ram_bytes = ram_size;
> @@ -1071,6 +1090,9 @@ static noinline void async_cow_submit(struct btrfs_work *work)
>   
>   	if (async_cow->inode)
>   		submit_compressed_extents(async_cow->inode, async_cow);
> +
> +	if (async_cow->need_end_nocow_write)
> +		btrfs_end_nocow_write(root);
>   }
>   
>   static noinline void async_cow_free(struct btrfs_work *work)
> @@ -1084,14 +1106,17 @@ static noinline void async_cow_free(struct btrfs_work *work)
>   
>   static int cow_file_range_async(struct inode *inode, struct page *locked_page,
>   				u64 start, u64 end, int *page_started,
> -				unsigned long *nr_written)
> +				unsigned long *nr_written, u64 orig_block_start,
> +				u64 disk_num_bytes, u64 orig_extent_offset)
>   {
>   	struct async_cow *async_cow;
>   	struct btrfs_root *root = BTRFS_I(inode)->root;
>   	unsigned long nr_pages;
> -	u64 cur_end;
> +	u64 cur_end = start;
>   	int limit = 10 * 1024 * 1024;
> +	u64 orig_start = start;
>   
> +	set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT, &BTRFS_I(inode)->runtime_flags);
>   	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
>   			 1, 0, NULL, GFP_NOFS);
>   	while (start < end) {
> @@ -1102,12 +1127,30 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
>   		async_cow->locked_page = locked_page;
>   		async_cow->start = start;
>   
> +		if (orig_block_start) {
> +			async_cow->block_start = orig_block_start + cur_end -
> +						 orig_extent_offset;
> +			if (cur_end - orig_start != 0)
> +				async_cow->block_start++;
> +			async_cow->orig_block_len = disk_num_bytes;
> +			async_cow->orig_block_start = orig_block_start;
> +		} else {
> +			async_cow->block_start = 0;
> +			async_cow->orig_block_len = 0;
> +			async_cow->orig_block_start = 0;
> +		}
> +
>   		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
>   		    !btrfs_test_opt(root, FORCE_COMPRESS))
>   			cur_end = end;
>   		else
>   			cur_end = min(end, start + 512 * 1024 - 1);
>   
> +		if (cur_end == end && orig_block_start)
> +			async_cow->need_end_nocow_write = 1;
> +		else
> +			async_cow->need_end_nocow_write = 0;
> +
>   		async_cow->end = cur_end;
>   		INIT_LIST_HEAD(&async_cow->extents);
>   
> @@ -1163,6 +1206,207 @@ static noinline int csum_exist_in_range(struct btrfs_root *root,
>   	return 1;
>   }
>   
> +static noinline int run_delalloc_nocow_compress(struct inode *inode,
> +				struct page *locked_page, u64 start,
> +				u64 end, int *page_started,
> +				unsigned long *nr_written)
> +{
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_trans_handle *trans;
> +	struct extent_buffer *leaf;
> +	struct btrfs_path *path;
> +	struct btrfs_file_extent_item *fi;
> +	struct btrfs_key found_key;
> +	u64 cow_start;
> +	u64 cur_offset;
> +	u64 extent_end;
> +	u64 extent_offset;
> +	u64 disk_bytenr;
> +	u64 num_bytes;
> +	u64 disk_num_bytes;
> +	u64 ram_bytes;
> +	int extent_type;
> +	int ret, err;
> +	int nocow;
> +	int check_prev = 1;
> +	u64 ino = btrfs_ino(inode);
> +	u64 orig_disk_bytenr;
> +
> +	cow_start = (u64)-1;
> +	cur_offset = start;
> +
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		ret = -ENOMEM;
> +		goto error;
> +	}
> +
> +	while (1) {
> +		ret = btrfs_lookup_file_extent(NULL, root, path, ino,
> +					       cur_offset, 0);
> +		if (ret < 0)
> +			goto error;
> +		if (ret > 0 && path->slots[0] > 0 && check_prev) {
> +			leaf = path->nodes[0];
> +			btrfs_item_key_to_cpu(leaf, &found_key,
> +					      path->slots[0] - 1);
> +			if (found_key.objectid == ino &&
> +			    found_key.type == BTRFS_EXTENT_DATA_KEY)
> +				path->slots[0]--;
> +		}
> +		check_prev = 0;
> +next_slot:
> +		leaf = path->nodes[0];
> +		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
> +			ret = btrfs_next_leaf(root, path);
> +			if (ret < 0)
> +				goto error;
> +			if (ret > 0)
> +				break;
> +			leaf = path->nodes[0];
> +		}
> +
> +		nocow = 0;
> +		disk_bytenr = 0;
> +		num_bytes = 0;
> +		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
> +
> +		if (found_key.objectid > ino ||
> +		    found_key.type > BTRFS_EXTENT_DATA_KEY ||
> +		    found_key.offset > end)
> +			break;
> +		if (found_key.offset > cur_offset) {
> +			extent_end = found_key.offset;
> +			extent_type = 0;
> +			goto out_check;
> +		}
> +
> +		fi = btrfs_item_ptr(leaf, path->slots[0],
> +				    struct btrfs_file_extent_item);
> +		extent_type = btrfs_file_extent_type(leaf, fi);
> +		ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
> +		if (extent_type == BTRFS_FILE_EXTENT_REG ||
> +		    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
> +			disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
> +			orig_disk_bytenr = disk_bytenr;
> +			extent_offset = btrfs_file_extent_offset(leaf, fi);
> +			extent_end = found_key.offset +
> +				btrfs_file_extent_num_bytes(leaf, fi);
> +			disk_num_bytes =
> +				btrfs_file_extent_disk_num_bytes(leaf, fi);
> +			if (extent_end <= start) {
> +				path->slots[0]++;
> +				goto next_slot;
> +			}
> +			if (disk_bytenr == 0)
> +				goto out_check;
> +			if (btrfs_file_extent_compression(leaf, fi) ||
> +			    btrfs_file_extent_encryption(leaf, fi) ||
> +			    btrfs_file_extent_other_encoding(leaf, fi))
> +				goto out_check;
> +			if (extent_type == BTRFS_FILE_EXTENT_REG)
> +				goto out_check;
> +			if (btrfs_extent_readonly(root, disk_bytenr))
> +				goto out_check;
> +
> +			trans = btrfs_join_transaction(root);
> +			if (btrfs_cross_ref_exist(trans, root, ino,
> +						  found_key.offset -
> +						  extent_offset, disk_bytenr)) {
> +				err = btrfs_end_transaction(trans, root);
> +				goto out_check;
> +			}
> +			err = btrfs_end_transaction(trans, root);
> +
> +			disk_bytenr += extent_offset;
> +			disk_bytenr += cur_offset - found_key.offset;
> +			num_bytes = min(end + 1, extent_end) - cur_offset;
> +			/*
> +			 * if there are pending snapshots for this root,
> +			 * we fall into common COW way.
> +			 */
> +			err = btrfs_start_nocow_write(root);
> +			if (!err)
> +				goto out_check;
> +			/*
> +			 * force cow if csum exists in the range.
> +			 * this ensure that csum for a given extent are
> +			 * either valid or do not exist.
> +			 */
> +			if (csum_exist_in_range(root, disk_bytenr, num_bytes))
> +				goto out_check;
> +			nocow = 1;
> +		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
> +			extent_end = found_key.offset +
> +				btrfs_file_extent_inline_len(leaf,
> +						path->slots[0], fi);
> +			extent_end = ALIGN(extent_end, root->sectorsize);
> +		} else {
> +			BUG_ON(1);
> +		}
> +out_check:
> +		if (extent_end <= start) {
> +			path->slots[0]++;
> +			if (nocow)
> +				btrfs_end_nocow_write(root);
> +			goto next_slot;
> +		}
> +		if (!nocow) {
> +			if (cow_start == (u64)-1)
> +				cow_start = cur_offset;
> +			cur_offset = extent_end;
> +			if (cur_offset > end)
> +				break;
> +			path->slots[0]++;
> +			goto next_slot;
> +		}
> +
> +		btrfs_release_path(path);
> +		if (cow_start != (u64)-1) {
> +			ret = cow_file_range_async(inode, locked_page,
> +					cow_start, found_key.offset - 1,
> +					page_started, nr_written, 0, 0, 0);
> +			if (ret) {
> +				if (nocow)
> +					btrfs_end_nocow_write(root);
> +				goto error;
> +			}
> +			cow_start = (u64)-1;
> +		}
> +		WARN_ON(extent_type != BTRFS_FILE_EXTENT_PREALLOC);
> +		ret = cow_file_range_async(inode, locked_page, cur_offset,
> +					cur_offset + num_bytes - 1,
> +					page_started, nr_written,
> +					orig_disk_bytenr, disk_num_bytes,
> +					found_key.offset - extent_offset);
> +		if (ret)
> +			goto error;
> +		cur_offset = extent_end;
> +		if (cur_offset > end)
> +			break;
> +	}
> +	btrfs_release_path(path);
> +
> +	if (cur_offset <= end && cow_start == (u64)-1) {
> +		cow_start = cur_offset;
> +		cur_offset = end;
> +	}
> +	if (cow_start != (u64)-1)
> +		ret = cow_file_range_async(inode, locked_page, cow_start, end,
> +					page_started, nr_written, 0, 0, 0);
> +error:
> +	if (ret && cur_offset < end)
> +		extent_clear_unlock_delalloc(inode, cur_offset, end,
> +					     locked_page, EXTENT_LOCKED |
> +					     EXTENT_DELALLOC | EXTENT_DEFRAG |
> +					     EXTENT_DO_ACCOUNTING, PAGE_UNLOCK |
> +					     PAGE_CLEAR_DIRTY |
> +					     PAGE_SET_WRITEBACK |
> +					     PAGE_END_WRITEBACK);
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
>   /*
>    * when nowcow writeback call back.  This checks for snapshots or COW copies
>    * of the extents that exist in the file, and COWs the file as required.
> @@ -1373,6 +1617,7 @@ out_check:
>   			em->len = num_bytes;
>   			em->block_len = num_bytes;
>   			em->block_start = disk_bytenr;
> +			em->orig_block_start = disk_bytenr;
>   			em->orig_block_len = disk_num_bytes;
>   			em->ram_bytes = ram_bytes;
>   			em->bdev = root->fs_info->fs_devices->latest_bdev;
> @@ -1483,22 +1728,21 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
>   {
>   	int ret;
>   	int force_cow = need_force_cow(inode, start, end);
> +	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
>   
> -	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow)
>   		ret = run_delalloc_nocow(inode, locked_page, start, end,
>   					 page_started, 1, nr_written);
> -	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
> -		ret = run_delalloc_nocow(inode, locked_page, start, end,
> -					 page_started, 0, nr_written);
> -	} else if (!inode_need_compress(inode)) {
> +	else if (!inode_need_compress(inode))
>   		ret = cow_file_range(inode, locked_page, start, end,
>   				      page_started, nr_written, 1);
> -	} else {
> -		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
> -			&BTRFS_I(inode)->runtime_flags);
> +	else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow &&
> +		 btrfs_fs_incompat(fs_info, COMPPREALLOC))
> +		ret = run_delalloc_nocow_compress(inode, locked_page, start,
> +				      end, page_started, nr_written);
> +	else
>   		ret = cow_file_range_async(inode, locked_page, start, end,
> -					   page_started, nr_written);
> -	}
> +					   page_started, nr_written, 0, 0, 0);
>   	return ret;
>   }
>   
> @@ -2760,21 +3004,23 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>   
>   	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags))
>   		compress_type = ordered_extent->compress_type;
> -	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
> -		BUG_ON(compress_type);
> +	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags) ||
> +	    test_bit(BTRFS_ORDERED_COMPRESS_PREALLOC, &ordered_extent->flags)) {
>   		ret = btrfs_mark_extent_written(trans, inode,
>   						ordered_extent->file_offset,
>   						ordered_extent->file_offset +
> -						logical_len);
> +						logical_len,
> +						ordered_extent->disk_len,
> +						ordered_extent->compress_type);
>   	} else {
>   		BUG_ON(root == root->fs_info->tree_root);
>   		ret = insert_reserved_file_extent(trans, inode,
> -						ordered_extent->file_offset,
> -						ordered_extent->start,
> -						ordered_extent->disk_len,
> -						logical_len, logical_len,
> -						compress_type, 0, 0,
> -						BTRFS_FILE_EXTENT_REG);
> +						  ordered_extent->file_offset,
> +						  ordered_extent->start,
> +						  ordered_extent->disk_len,
> +						  logical_len, logical_len,
> +						  compress_type, 0, 0,
> +						  BTRFS_FILE_EXTENT_REG);
>   		if (!ret)
>   			btrfs_release_delalloc_bytes(root,
>   						     ordered_extent->start,
> @@ -4531,6 +4777,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
>   			hole_em->orig_start = cur_offset;
>   
>   			hole_em->block_start = EXTENT_MAP_HOLE;
> +			hole_em->orig_block_start = EXTENT_MAP_HOLE;
>   			hole_em->block_len = 0;
>   			hole_em->orig_block_len = 0;
>   			hole_em->ram_bytes = hole_size;
> @@ -6214,6 +6461,7 @@ static int merge_extent_mapping(struct extent_map_tree *em_tree,
>   	if (em->block_start < EXTENT_MAP_LAST_BYTE &&
>   	    !test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
>   		em->block_start += start_diff;
> +		em->orig_block_start += start_diff;
>   		em->block_len -= start_diff;
>   	}
>   	return add_extent_mapping(em_tree, em, 0);
> @@ -6465,6 +6713,7 @@ not_found:
>   	em->len = len;
>   not_found_em:
>   	em->block_start = EXTENT_MAP_HOLE;
> +	em->orig_block_start = EXTENT_MAP_HOLE;
>   	set_bit(EXTENT_FLAG_VACANCY, &em->flags);
>   insert:
>   	btrfs_release_path(path);
> @@ -6639,6 +6888,7 @@ struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *pag
>   			 * it is fixed at EXTENT_MAP_HOLE
>   			 */
>   			em->block_start = hole_em->block_start;
> +			em->orig_block_start = hole_em->block_start;
>   			em->block_len = hole_len;
>   			if (test_bit(EXTENT_FLAG_PREALLOC, &hole_em->flags))
>   				set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
> @@ -6647,6 +6897,7 @@ struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *pag
>   			em->len = found;
>   			em->orig_start = range_start;
>   			em->block_start = EXTENT_MAP_DELALLOC;
> +			em->orig_block_start = EXTENT_MAP_DELALLOC;
>   			em->block_len = found;
>   		}
>   	} else if (hole_em) {
> @@ -6993,6 +7244,7 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
>   	em->len = len;
>   	em->block_len = block_len;
>   	em->block_start = block_start;
> +	em->orig_block_start = block_start;
>   	em->bdev = root->fs_info->fs_devices->latest_bdev;
>   	em->orig_block_len = orig_block_len;
>   	em->ram_bytes = ram_bytes;
> @@ -8954,6 +9206,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
>   		em->orig_start = cur_offset;
>   		em->len = ins.offset;
>   		em->block_start = ins.objectid;
> +		em->orig_block_start = ins.objectid;
>   		em->block_len = ins.offset;
>   		em->orig_block_len = ins.offset;
>   		em->ram_bytes = ins.offset;
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index d81a274..98354c3 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -70,6 +70,8 @@ struct btrfs_ordered_sum {
>   #define BTRFS_ORDERED_LOGGED_CSUM 8 /* We've logged the csums on this ordered
>   				       ordered extent */
>   #define BTRFS_ORDERED_TRUNCATED 9 /* Set when we have to truncate an extent */
> +#define BTRFS_ORDERED_COMPRESS_PREALLOC 10 /* set when writting compressed
> +					    * data into preallocated extent */
>   
>   struct btrfs_ordered_extent {
>   	/* logical offset in the file */
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1ea2b10..bb40d634 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -566,12 +566,14 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
>   	u64 extent_end;
>   	u64 start = key->offset;
>   	u64 nbytes = 0;
> +	u32 log_item_size;
>   	struct btrfs_file_extent_item *item;
>   	struct inode *inode = NULL;
>   	unsigned long size;
>   	int ret = 0;
>   
>   	item = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
> +	log_item_size = btrfs_item_size_nr(eb, slot);
>   	found_type = btrfs_file_extent_type(eb, item);
>   
>   	if (found_type == BTRFS_FILE_EXTENT_REG ||
> @@ -611,27 +613,35 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
>   	if (ret == 0 &&
>   	    (found_type == BTRFS_FILE_EXTENT_REG ||
>   	     found_type == BTRFS_FILE_EXTENT_PREALLOC)) {
> -		struct btrfs_file_extent_item cmp1;
> -		struct btrfs_file_extent_item cmp2;
> +		struct btrfs_file_extent_item *cmp1;
> +		struct btrfs_file_extent_item *cmp2;
>   		struct btrfs_file_extent_item *existing;
>   		struct extent_buffer *leaf;
> +		u32 exist_item_size;
> +		u8 buf1[BTRFS_FILE_EXTENT_SIZE_MAX];
> +		u8 buf2[BTRFS_FILE_EXTENT_SIZE_MAX];
> +
> +		cmp1 = (struct btrfs_file_extent_item *)buf1;
> +		cmp2 = (struct btrfs_file_extent_item *)buf2;
>   
>   		leaf = path->nodes[0];
>   		existing = btrfs_item_ptr(leaf, path->slots[0],
>   					  struct btrfs_file_extent_item);
> +		exist_item_size = btrfs_item_size_nr(leaf, path->slots[0]);
>   
> -		if (btrfs_file_extent_type(leaf, existing) != found_type)
> +		if (btrfs_file_extent_type(leaf, existing) != found_type ||
> +		    exist_item_size != log_item_size)
>   			goto no_compare;
> -		read_extent_buffer(eb, &cmp1, (unsigned long)item,
> -				   sizeof(cmp1));
> -		read_extent_buffer(leaf, &cmp2, (unsigned long)existing,
> -				   sizeof(cmp2));
> +		read_extent_buffer(eb, cmp1, (unsigned long)item,
> +				   exist_item_size);
> +		read_extent_buffer(leaf, cmp2, (unsigned long)existing,
> +				   exist_item_size);
>   
>   		/*
>   		 * we already have a pointer to this exact extent,
>   		 * we don't have to do anything
>   		 */
> -		if (memcmp(&cmp1, &cmp2, sizeof(cmp1)) == 0) {
> +		if (memcmp(cmp1, cmp2, exist_item_size) == 0) {
>   			btrfs_release_path(path);
>   			goto out;
>   		}
> @@ -651,13 +661,13 @@ no_compare:
>   		struct btrfs_key ins;
>   
>   		ret = btrfs_insert_empty_item(trans, root, path, key,
> -					      sizeof(*item));
> +					      log_item_size);
>   		if (ret)
>   			goto out;
>   		dest_offset = btrfs_item_ptr_offset(path->nodes[0],
>   						    path->slots[0]);
>   		copy_extent_buffer(path->nodes[0], eb, dest_offset,
> -				(unsigned long)item,  sizeof(*item));
> +				(unsigned long)item,  log_item_size);
>   
>   		ins.objectid = btrfs_file_extent_disk_bytenr(eb, item);
>   		ins.offset = btrfs_file_extent_disk_num_bytes(eb, item);
> @@ -695,8 +705,12 @@ no_compare:
>   			btrfs_release_path(path);
>   
>   			if (btrfs_file_extent_compression(eb, item)) {
> -				csum_start = ins.objectid;
> -				csum_end = csum_start + ins.offset;
> +				csum_start = ins.objectid +
> +					btrfs_ondemand_file_extent_data_offset(
> +							eb, slot, item);
> +				csum_end = csum_start +
> +					btrfs_ondemand_file_extent_data_len(
> +							eb, slot, item);
>   			} else {
>   				csum_start = ins.objectid +
>   					btrfs_file_extent_offset(eb, item);
> @@ -3574,6 +3588,22 @@ static int extent_cmp(void *priv, struct list_head *a, struct list_head *b)
>   	return 0;
>   }
>   
> +static int is_em_compressed_prealloc(struct extent_map *em)
> +{
> +	if (em->compress_type != BTRFS_COMPRESS_NONE &&
> +	    (em->orig_block_start != em->block_start ||
> +	     em->block_len < em->orig_block_len))
> +		return 1;
> +	return 0;
> +}
> +
> +static u32 em_to_item_size(struct extent_map *em)
> +{
> +	if (is_em_compressed_prealloc(em))
> +		return BTRFS_FILE_EXTENT_SIZE_MAX;
> +	return BTRFS_FILE_EXTENT_SIZE_NORMAL;
> +}
> +
>   static int log_one_extent(struct btrfs_trans_handle *trans,
>   			  struct inode *inode, struct btrfs_root *root,
>   			  struct extent_map *em, struct btrfs_path *path,
> @@ -3592,13 +3622,17 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
>   	u64 csum_len;
>   	u64 extent_offset = em->start - em->orig_start;
>   	u64 block_len;
> +	int exist_item_size;
> +	int log_item_size;
>   	int ret;
> +	int slot;
>   	bool skip_csum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
>   	int extent_inserted = 0;
>   
>   	INIT_LIST_HEAD(&ordered_sums);
>   	btrfs_init_map_token(&token);
>   
> +again:
>   	ret = __btrfs_drop_extents(trans, log, inode, path, em->start,
>   				   em->start + em->len, NULL, 0, 1,
>   				   sizeof(*fi), &extent_inserted);
> @@ -3610,14 +3644,30 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
>   		key.type = BTRFS_EXTENT_DATA_KEY;
>   		key.offset = em->start;
>   
> +		log_item_size = em_to_item_size(em);
>   		ret = btrfs_insert_empty_item(trans, log, path, &key,
> -					      sizeof(*fi));
> +					      log_item_size);
>   		if (ret)
>   			return ret;
>   	}
>   	leaf = path->nodes[0];
> -	fi = btrfs_item_ptr(leaf, path->slots[0],
> -			    struct btrfs_file_extent_item);
> +	slot = path->slots[0];
> +	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
> +	exist_item_size = btrfs_item_size_nr(leaf, slot);
> +	log_item_size = em_to_item_size(em);
> +	ret = btrfs_resize_item(trans, log, path,
> +				log_item_size - exist_item_size);
> +	if (ret == -EAGAIN) {
> +		btrfs_release_path(path);
> +		goto again;
> +	}
> +	if (ret < 0) {
> +		btrfs_release_path(path);
> +		return ret;
> +	}
> +	leaf = path->nodes[0];
> +	slot = path->slots[0];
> +	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
>   
>   	btrfs_set_token_file_extent_generation(leaf, fi, em->generation,
>   					       &token);
> @@ -3637,10 +3687,15 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
>   	block_len = max(em->block_len, em->orig_block_len);
>   	if (em->compress_type != BTRFS_COMPRESS_NONE) {
>   		btrfs_set_token_file_extent_disk_bytenr(leaf, fi,
> -							em->block_start,
> +							em->orig_block_start,
>   							&token);
>   		btrfs_set_token_file_extent_disk_num_bytes(leaf, fi, block_len,
>   							   &token);
> +		btrfs_set_token_ondemand_file_extent_data_offset(leaf, slot, fi,
> +					em->block_start - em->orig_block_start,
> +					&token);
> +		btrfs_set_token_ondemand_file_extent_data_len(leaf, slot, fi,
> +						     em->block_len, &token);
>   	} else if (em->block_start < EXTENT_MAP_LAST_BYTE) {
>   		btrfs_set_token_file_extent_disk_bytenr(leaf, fi,
>   							em->block_start -
> @@ -3653,9 +3708,15 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
>   							   &token);
>   	}
>   
> -	btrfs_set_token_file_extent_offset(leaf, fi,
> -					   em->start - em->orig_start,
> -					   &token);
> +	if (is_em_compressed_prealloc(em))
> +		btrfs_set_token_file_extent_offset(leaf, fi,
> +			em->start - em->orig_start +
> +			em->block_start - em->orig_block_start, &token);
> +	else
> +		btrfs_set_token_file_extent_offset(leaf, fi,
> +						   em->start - em->orig_start,
> +						   &token);
> +
>   	btrfs_set_token_file_extent_num_bytes(leaf, fi, em->len, &token);
>   	btrfs_set_token_file_extent_ram_bytes(leaf, fi, em->ram_bytes, &token);
>   	btrfs_set_token_file_extent_compression(leaf, fi, em->compress_type,

