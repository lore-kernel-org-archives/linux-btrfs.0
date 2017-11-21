Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37330 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751123AbdKUH7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 02:59:51 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6F6A2AD57
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 07:59:50 +0000 (UTC)
Subject: Re: [PATCH 2/3] btrfs: update some code documentation
To: Edmund Nadolski <enadolski@suse.com>, linux-btrfs@vger.kernel.org
References: <20171120202449.22947-1-enadolski@suse.com>
 <20171120202449.22947-3-enadolski@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <068ef359-4183-762c-c73e-faa0b9cfd6fa@suse.com>
Date: Tue, 21 Nov 2017 09:59:48 +0200
MIME-Version: 1.0
In-Reply-To: <20171120202449.22947-3-enadolski@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.11.2017 22:24, Edmund Nadolski wrote:
> Improve code documentation by adding/expanding comments in
> several places.
> 
> Signed-off-by: Edmund Nadolski <enadolski@suse.com>
> ---
>  fs/btrfs/ctree.c                | 31 +++++++++++++++-------
>  fs/btrfs/ctree.h                | 28 +++++++++++++++-----
>  fs/btrfs/extent_map.h           | 58 ++++++++++++++++++++++++++++-------------
>  fs/btrfs/file-item.c            |  3 +++
>  fs/btrfs/inode.c                | 21 +++++++++++----
>  include/uapi/linux/btrfs_tree.h |  1 +
>  6 files changed, 104 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 531e0a8..9331d02 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2654,17 +2654,30 @@ int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
>  }
>  
>  /*
> - * look for key in the tree.  path is filled in with nodes along the way
> - * if key is found, we return zero and you can find the item in the leaf
> - * level of the path (level 0)
> + * Search a btree for a specific key. Optionally update the btree for
> + * item insertion or removal.
>   *
> - * If the key isn't found, the path points to the slot where it should
> - * be inserted, and 1 is returned.  If there are other errors during the
> - * search a negative error number is returned.
> + *   @trans - Transaction handle (NULL for none, requires @cow == 0).
> + *   @root - The btree to be searched.
> + *   @key - key for search.
> + *   @p - Points to a btrfs_path to be populated with btree node and index
> + *      values encountered during traversal. (See also struct btrfs_path.)
> + *   @ins_len - byte length of item as follows:
> + *      >0: byte length of item for insertion.  Btree nodes/leaves are
> + *          split as required.
> + *      <0: byte length of item for deletion.  Btree nodes/leaves are
> + *          merged as required.
> + *       0: Do not modify the btree (search only).
> + *   @cow - 0 to nocow, or !0 to cow for btree update.
>   *
> - * if ins_len > 0, nodes and leaves will be split as we walk down the
> - * tree.  if ins_len < 0, nodes will be merged as we walk down the tree (if
> - * possible)
> + * Return values:
> + *   0: @key was found and @p was updated to indicate the leaf and item
> + *       slot where the item may be accessed.
> + *   1: @key was not found and @p was updated to indicate the leaf and
> + *       item slot where the item may be inserted.
> + *  <0: an error occurred.
> + *
> + * Note, insertion/removal updates will re-balance the btree as needed.
>   */
>  int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  		      const struct btrfs_key *key, struct btrfs_path *p,
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2154b5a..e980caa 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -318,20 +318,36 @@ struct btrfs_node {
>  } __attribute__ ((__packed__));
>  
>  /*
> - * btrfs_paths remember the path taken from the root down to the leaf.
> - * level 0 is always the leaf, and nodes[1...BTRFS_MAX_LEVEL] will point
> - * to any other levels that are present.
> - *
> - * The slots array records the index of the item or block pointer
> - * used while walking the tree.
> + * Used with btrfs_search_slot() to record a btree search path traversed from a
> + * root down to a leaf.
>   */
>  enum { READA_NONE = 0, READA_BACK, READA_FORWARD };
>  struct btrfs_path {
> +	/*
> +	 * The nodes[] and slots[] arrays are indexed according to btree
> +	 * levels. Index 0 corresponds to the lowest (leaf) level. Increasing
> +	 * indexes correspond to interior btree nodes at subsequently higher
> +	 * levels.
> +	 *
> +	 * nodes[0] always points to a leaf. nodes[1] points to a btree node
> +	 * which contains a block pointer referencing that leaf. For higher
> +	 * indexes, node[n] points to a btree node which contains a block
> +	 * pointer referencing node[n-1].
> +	 */
>  	struct extent_buffer *nodes[BTRFS_MAX_LEVEL];
> +
> +	/*
> +	 * The slots[0] value identifies an item index in the leaf at nodes[0].
> +	 * Each slots[n] value identifies a block pointer index in the
> +	 * corresponding tree node at nodes[n].
> +	 */
>  	int slots[BTRFS_MAX_LEVEL];
> +
>  	/* if there is real range locking, this locks field will change */
>  	u8 locks[BTRFS_MAX_LEVEL];
> +
>  	u8 reada;
> +
>  	/* keep some upper locks as we walk down */
>  	u8 lowest_level;
>  
> diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
> index 64365bb..34ea85c3 100644
> --- a/fs/btrfs/extent_map.h
> +++ b/fs/btrfs/extent_map.h
> @@ -5,35 +5,57 @@
>  #include <linux/rbtree.h>
>  #include <linux/refcount.h>
>  
> -#define EXTENT_MAP_LAST_BYTE ((u64)-4)
> -#define EXTENT_MAP_HOLE ((u64)-3)
> -#define EXTENT_MAP_INLINE ((u64)-2)
> -#define EXTENT_MAP_DELALLOC ((u64)-1)
> -
> -/* bits for the flags field */
> -#define EXTENT_FLAG_PINNED 0 /* this entry not yet on disk, don't free it */
> -#define EXTENT_FLAG_COMPRESSED 1
> -#define EXTENT_FLAG_VACANCY 2 /* no file extent item found */
> -#define EXTENT_FLAG_PREALLOC 3 /* pre-allocated extent */
> -#define EXTENT_FLAG_LOGGING 4 /* Logging this extent */
> -#define EXTENT_FLAG_FILLING 5 /* Filling in a preallocated extent */
> -#define EXTENT_FLAG_FS_MAPPING 6 /* filesystem extent mapping type */
> +/*
> + * Reserve some special-case values for the extent_map .start, .block_start,
> + *: and .orig_start fields.
     ^ extra :
> + */
> +#define EXTENT_MAP_LAST_BYTE	((u64)-4)	/* Lowest reserved value */
> +#define EXTENT_MAP_HOLE		((u64)-3)	/* Unwritten extent */
> +#define EXTENT_MAP_INLINE	((u64)-2)	/* Inlined file data */
> +#define EXTENT_MAP_DELALLOC	((u64)-1)	/* Delayed block allocation */

These values are only set/checked on the .block_start parameter so you
can possibly remove the .start/.orig_start from the above comment.

>  
> +/*
> + * Bit flags for the extent_map .flags field.
> + */
> +#define EXTENT_FLAG_PINNED	0 /* entry not yet on disk, don't free it */
> +#define EXTENT_FLAG_COMPRESSED	1
> +#define EXTENT_FLAG_VACANCY	2 /* no file extent item found */
> +#define EXTENT_FLAG_PREALLOC	3 /* pre-allocated extent */
> +#define EXTENT_FLAG_LOGGING	4 /* Logging this extent */
> +#define EXTENT_FLAG_FILLING	5 /* Filling in a preallocated extent */
> +#define EXTENT_FLAG_FS_MAPPING	6 /* filesystem extent mapping type */
> +
> +/*
> + * In-memory representation of a file extent (regular/prealloc/inline).
> + */

<rant>
I just realise how badly named this struct is. Because we really have
on-disk extents and in-memory extents (similar to XFS nomenclature) and
the extent_map name doesn't really bring those 2 things together
</rant>

>  struct extent_map {
>  	struct rb_node rb_node;
>  
>  	/* all of these are in bytes */
> -	u64 start;
> -	u64 len;
> +	u64 start;	/* logical byte offset in the file */
> +	u64 len;	/* byte length of extent in the file */
>  	u64 mod_start;
>  	u64 mod_len;
>  	u64 orig_start;
>  	u64 orig_block_len;
> +
> +	/* max. bytes needed to hold the (uncompressed) extent in memory. */
>  	u64 ram_bytes;
> +
> +	/*
> +	 * For regular/prealloc, block_start is a logical address denoting the
> +	 * start of the extent data, and block_len is the on-disk byte length
> +	 * of the extent (which may be comressed). block_start may be
> +	 * EXTENT_MAP_HOLE if the extent is unwritten.  For inline, block_start
> +	 * is EXTENT_MAP_INLINE and block_len is (u64)-1.  See also
> +	 * btrfs_extent_item_to_extent_map() and btrfs_get_extent().
> +	 */
>  	u64 block_start;
>  	u64 block_len;
> -	u64 generation;
> -	unsigned long flags;
> +
> +	u64 generation;		/* transaction id */
> +	unsigned long flags;	/* EXTENT_FLAG_* bit flags as above */
> +
>  	union {
>  		struct block_device *bdev;
>  
> @@ -44,7 +66,7 @@ struct extent_map {
>  		struct map_lookup *map_lookup;
>  	};
>  	refcount_t refs;
> -	unsigned int compress_type;
> +	unsigned int compress_type;	/* BTRFS_COMPRESS_* */
>  	struct list_head list;
>  };
>  
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index fdcb410..5d63172 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -929,6 +929,9 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
>  	goto out;
>  }
>  
> +/*
> + * Populate an extent_map from the btrfs_file_extent_item contents.
> + */
>  void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
>  				     const struct btrfs_path *path,
>  				     struct btrfs_file_extent_item *fi,
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 72c7b38..b6d5d94 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6916,17 +6916,28 @@ static noinline int uncompress_inline(struct btrfs_path *path,
>  }
>  
>  /*
> - * a bit scary, this does extent mapping from logical file offset to the disk.
> - * the ugly parts come from merging extents from the disk with the in-ram
> + * btrfs_get_extent - find or create an extent_map for the (@start, @len) range.
> + *
> + *  @inode - inode containing the desired extent.
> + *  @page - page for inlined extent (NULL if none)
> + *  @page_offset - byte offset within @page
> + *  @start - logical byte offset in the file.
> + *  @len - byte length of the range.
> + *  @create - for inlined extents: 0 to update @page with extent data from
> + *            the item; 1 to bypass the update.
> + *
> + * A bit scary, this does extent mapping from logical file offset to the disk.
> + * The ugly parts come from merging extents from the disk with the in-ram
>   * representation.  This gets more complex because of the data=ordered code,
>   * where the in-ram extents might be locked pending data=ordered completion.
>   *
>   * This also copies inline extents directly into the page.
> + *
> + * Returns the extent_map, or error code.
>   */>  struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
> -		struct page *page,
> -	    size_t pg_offset, u64 start, u64 len,
> -		int create)
> +				    struct page *page, size_t pg_offset,
> +				    u64 start, u64 len, int create)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
>  	int ret;
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> index 6d6e5da..693636a 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -730,6 +730,7 @@ struct btrfs_balance_item {
>  	__le64 unused[4];
>  } __attribute__ ((__packed__));
>  
> +/* Values for .type field in btrfs_file_extent_item */
>  #define BTRFS_FILE_EXTENT_INLINE 0
>  #define BTRFS_FILE_EXTENT_REG 1
>  #define BTRFS_FILE_EXTENT_PREALLOC 2
> 
