Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbbJAMzZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 08:55:25 -0400
Date: Thu, 1 Oct 2015 14:54:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 6/9] Btrfs: implement the free space B-tree
Message-ID: <20151001125423.GB5885@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1443583874.git.osandov@osandov.com>
 <3319d371e22491b6901af33842b57db37b77c52c.1443583874.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3319d371e22491b6901af33842b57db37b77c52c.1443583874.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a few minor comments, I haven't reviewed the changes in depth.

On Tue, Sep 29, 2015 at 08:50:35PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> +static int btrfs_search_prev_slot(struct btrfs_trans_handle *trans,
> +				  struct btrfs_root *root,
> +				  struct btrfs_key *key, struct btrfs_path *p,

Please don't use single letter variables, eg. 'path' is commonly used
elsewere.

> +				  int ins_len, int cow)
> +{
> +	int ret;
> +
> +	ret = btrfs_search_slot(trans, root, key, p, ins_len, cow);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret == 0) {
> +		ASSERT(0);
> +		return -EIO;
> +	}
> +
> +	if (p->slots[0] == 0) {
> +		ASSERT(0);
> +		return -EIO;
> +	}
> +	p->slots[0]--;
> +
> +	return 0;
> +}
> +
> +static unsigned long *alloc_bitmap(u32 bitmap_size)
> +{
> +	return __vmalloc(bitmap_size, GFP_NOFS | __GFP_HIGHMEM | __GFP_ZERO,

Why is GFP_HIGHMEM here?

> +			 PAGE_KERNEL);
> +}
> +
> +int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
> +				  struct btrfs_fs_info *fs_info,
> +				  struct btrfs_block_group_cache *block_group,
> +				  struct btrfs_path *path)
> +{
> +	struct btrfs_root *root = fs_info->free_space_root;
> +	struct btrfs_free_space_info *info;
> +	struct btrfs_key key, found_key;
> +	struct extent_buffer *leaf;
> +	unsigned long *bitmap;
> +	char *bitmap_cursor;
> +	u64 start, end;
> +	u64 bitmap_range, i;
> +	u32 bitmap_size, flags, expected_extent_count;
> +	u32 extent_count = 0;
> +	int done = 0, nr;
> +	int ret;
> +
> +	bitmap_size = free_space_bitmap_size(block_group->key.offset,
> +					     block_group->sectorsize);
> +	bitmap = alloc_bitmap(bitmap_size);
> +	if (!bitmap) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}

Can we get rid of this potential allocation failure site? You free the
buffer in the same function, no recursion, so it should be ok to
preallocate the buffer at the mount time and just reuse here. Converting
to bitmap is not a frequent operation but IMO is critical enough to make
it more robust.

> +
> +	start = block_group->key.objectid;
> +	end = block_group->key.objectid + block_group->key.offset;
> +
> +	key.objectid = end - 1;
> +	key.type = (u8)-1;
> +	key.offset = (u64)-1;
> +
> +	while (!done) {
> +		ret = btrfs_search_prev_slot(trans, root, &key, path, -1, 1);
> +		if (ret)
> +			goto out;
> +
> +		leaf = path->nodes[0];
> +		nr = 0;
> +		path->slots[0]++;
> +		while (path->slots[0] > 0) {
> +			btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0] - 1);
> +
> +			if (found_key.type == BTRFS_FREE_SPACE_INFO_KEY) {
> +				ASSERT(found_key.objectid == block_group->key.objectid);
> +				ASSERT(found_key.offset == block_group->key.offset);
> +				done = 1;
> +				break;
> +			} else if (found_key.type == BTRFS_FREE_SPACE_EXTENT_KEY) {
> +				u64 first, last;
> +
> +				ASSERT(found_key.objectid >= start);
> +				ASSERT(found_key.objectid < end);
> +				ASSERT(found_key.objectid + found_key.offset <= end);
> +
> +				first = div_u64(found_key.objectid - start,
> +						block_group->sectorsize);
> +				last = div_u64(found_key.objectid + found_key.offset - start,
> +					       block_group->sectorsize);
> +				bitmap_set(bitmap, first, last - first);
> +
> +				extent_count++;
> +				nr++;
> +				path->slots[0]--;
> +			} else {
> +				ASSERT(0);
> +			}
> +		}
> +
> +		ret = btrfs_del_items(trans, root, path, path->slots[0], nr);
> +		if (ret)
> +			goto out;
> +		btrfs_release_path(path);
> +	}
> +
> +	info = search_free_space_info(trans, fs_info, block_group, path, 1);
> +	if (IS_ERR(info)) {
> +		ret = PTR_ERR(info);
> +		goto out;
> +	}
> +	leaf = path->nodes[0];
> +	flags = btrfs_free_space_flags(leaf, info);
> +	flags |= BTRFS_FREE_SPACE_USING_BITMAPS;
> +	btrfs_set_free_space_flags(leaf, info, flags);
> +	expected_extent_count = btrfs_free_space_extent_count(leaf, info);
> +	btrfs_mark_buffer_dirty(leaf);
> +	btrfs_release_path(path);
> +
> +	if (extent_count != expected_extent_count) {
> +		btrfs_err(fs_info, "incorrect extent count for %llu; counted %u, expected %u",
> +			  block_group->key.objectid, extent_count,
> +			  expected_extent_count);
> +		ASSERT(0);
> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	bitmap_cursor = (char *)bitmap;
> +	bitmap_range = block_group->sectorsize * BTRFS_FREE_SPACE_BITMAP_BITS;
> +	i = start;
> +	while (i < end) {
> +		unsigned long ptr;
> +		u64 extent_size;
> +		u32 data_size;
> +
> +		extent_size = min(end - i, bitmap_range);
> +		data_size = free_space_bitmap_size(extent_size,
> +						   block_group->sectorsize);
> +
> +		key.objectid = i;
> +		key.type = BTRFS_FREE_SPACE_BITMAP_KEY;
> +		key.offset = extent_size;
> +
> +		ret = btrfs_insert_empty_item(trans, root, path, &key,
> +					      data_size);
> +		if (ret)
> +			goto out;
> +
> +		leaf = path->nodes[0];
> +		ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +		write_extent_buffer(leaf, bitmap_cursor, ptr,
> +				    data_size);
> +		btrfs_mark_buffer_dirty(leaf);
> +		btrfs_release_path(path);
> +
> +		i += extent_size;
> +		bitmap_cursor += data_size;
> +	}
> +
> +	ret = 0;
> +out:
> +	vfree(bitmap);
> +	if (ret)
> +		btrfs_abort_transaction(trans, root, ret);

A general comment to the transaction aborts: the call should happen at
the location of the error and not in the common exit block. Otherwise we
lose the information what caused the failure.

This applies to the remaining functions as well, I won't point it out
specifically.
