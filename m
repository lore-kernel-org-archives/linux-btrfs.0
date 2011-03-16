From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: check items for correctness as we search
Date: Wed, 16 Mar 2011 16:50:30 -0400
Message-ID: <1300308072-sup-3886@think>
References: <1300305863-2609-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1300305863-2609-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2011-03-16 16:04:23 -0400:
> Currently if we have corrupted items things will blow up in spectacular ways.
> So as we read in blocks and they are leaves, check the entire leaf to make sure
> all of the items are correct and point to valid parts in the leaf for the item
> data the are responsible for.  If the item is corrupt we will kick back EIO and
> not read any of the copies since they are likely to not be correct either.  This
> will catch generic corruptions, it will be up to the individual callers of
> btrfs_search_slot to make sure their items are right.  Thanks,

Thanks for working on this, a few comments below.

> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 495b1ac..1694782 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -331,6 +331,14 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
>              !verify_parent_transid(io_tree, eb, parent_transid))
>              return ret;
>  
> +        /*
> +         * This buffer's crc is fine, but its contents are corrupted, so
> +         * there is no reason to read the other copies, they won't be
> +         * any less wrong.
> +         */
> +        if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags))
> +            return ret;
> +

We should make sure to clear this when read_extent_buffer_pages starts?
At the very least it should get cleared if we delete the block.

>          num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
>                            eb->start, eb->len);
>          if (num_copies == 1)
> @@ -419,6 +427,76 @@ static int check_tree_block_fsid(struct btrfs_root *root,
>      return ret;
>  }
>  
> +#define CORRUPT(reason, eb, root, slot)                \
> +    printk(KERN_CRIT "btrfs: corrupt leaf, %s: block=%llu,"    \
> +           "root=%llu, slot=%d\n", reason,            \
> +           (unsigned long long)btrfs_header_bytenr(eb),    \
> +           (unsigned long long)root->objectid, slot)
> +
> +/*
> + * extra checking to make sure all the items in a leaf are
> + * well formed and in the proper order
> + */
> +static int check_leaf(struct btrfs_root *root,
> +              struct extent_buffer *leaf, int slot)
> +{
> +    struct btrfs_key key;
> +    struct btrfs_key leaf_key;
> +    u32 nritems = btrfs_header_nritems(leaf);
> +
> +    btrfs_item_key_to_cpu(leaf, &leaf_key, slot);
> +    if (slot != 0 && slot < nritems - 1) {
> +        btrfs_item_key_to_cpu(leaf, &key, slot - 1);
> +        if (btrfs_comp_cpu_keys(&leaf_key, &key) <= 0) {
> +            CORRUPT("offset bad key", leaf, root, slot);
> +            return -EIO;
> +        }
> +        if (btrfs_item_offset_nr(leaf, slot - 1) !=
> +               btrfs_item_end_nr(leaf, slot)) {
> +            CORRUPT("slot offset bad", leaf, root, slot);
> +            return -EIO;
> +        }

Ok, this checks the item before our slot.

> +    }
> +    if (slot < nritems - 1) {
> +        btrfs_item_key_to_cpu(leaf, &key, slot + 1);
> +        if (btrfs_comp_cpu_keys(&leaf_key, &key) >= 0) {
> +            CORRUPT("offset bad key", leaf, root, slot);
> +            return -EIO;
> +        }
> +        if (btrfs_item_offset_nr(leaf, slot) !=
> +            btrfs_item_end_nr(leaf, slot + 1)) {
> +            CORRUPT("slot offset bad", leaf, root, slot);
> +            return -EIO;
> +        }

And this checks the item after our slot

> +    }
> +    if (btrfs_item_offset_nr(leaf, 0) + btrfs_item_size_nr(leaf, 0) !=
> +        BTRFS_LEAF_DATA_SIZE(root)) {
> +        CORRUPT("invalid offset size pair", leaf, root, slot);
> +        return -EIO;

And this checks item zero.  But we're not checking to make sure
the offsets of the item headers are inside the leaf.  In your code they
all have to be consistent, but they might all point into funny places
(consistently).  I'm not sure if that is possible to do and have item
zero check out, but it seems like we could add one check to make sure
the offset is inside the block itself.

> +    }
> +
> +    return 0;
> +}
> +
> +static noinline int check_block(struct btrfs_root *root,
> +                struct extent_buffer *eb)
> +{
> +    u32 nritems = btrfs_header_nritems(eb);
> +    int slot;
> +    int ret = 0;
> +
> +    if (nritems == 0)
> +        return 0;
> +
> +    for (slot = 0; slot < nritems; slot++) {
> +        ret = check_leaf(root, eb, slot);
> +        if (ret)
> +            break;
> +    }

I might be missing something, but this looks like:

	for each item in the leaf {
		check the item before
		check the item after
		check item 0
	}

Why not:
	check item 0
	for each item in the leaf {
		check the item after
	}
	check the last item

> +
> +    return ret;
> +}
> +
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  void btrfs_set_buffer_lockdep_class(struct extent_buffer *eb, int level)
>  {
> @@ -485,8 +563,20 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
>      btrfs_set_buffer_lockdep_class(eb, found_level);
>  
>      ret = csum_tree_block(root, eb, 1);
> -    if (ret)
> +    if (ret) {
> +        ret = -EIO;
> +        goto err;
> +    }
> +
> +    /*
> +     * If this is a leaf block and it is corrupt, set the corrupt bit so
> +     * that we don't try and read the other copies of this block, just
> +     * return -EIO.
> +     */
> +    if (found_level == 0 && check_block(root, eb)) {
> +        set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
>          ret = -EIO;
> +    }
>  
>      end = min_t(u64, eb->len, PAGE_CACHE_SIZE);
>      end = eb->start + end - 1;
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 9318dfe..f62c544 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -31,6 +31,7 @@
>  #define EXTENT_BUFFER_UPTODATE 0
>  #define EXTENT_BUFFER_BLOCKING 1
>  #define EXTENT_BUFFER_DIRTY 2
> +#define EXTENT_BUFFER_CORRUPT 3
>  
>  /* these are flags for extent_clear_unlock_delalloc */
>  #define EXTENT_CLEAR_UNLOCK_PAGE 0x1
