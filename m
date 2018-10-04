Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9682DC64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 18:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 301BF2083F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 18:34:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 301BF2083F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbeJEB2k (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 21:28:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:43756 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727407AbeJEB2k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Oct 2018 21:28:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2B253B03A;
        Thu,  4 Oct 2018 18:34:03 +0000 (UTC)
Subject: Re: [PATCH 05/10] btrfs-progs: Pull free space tree related code from
 kernel
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
 <1538405181-25231-6-git-send-email-nborisov@suse.com>
 <20181004182636.GE25437@vader>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <33367247-9a7b-bbfa-66c7-1404f6db656a@suse.com>
Date:   Thu, 4 Oct 2018 21:34:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181004182636.GE25437@vader>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On  4.10.2018 21:26, Omar Sandoval wrote:
> On Mon, Oct 01, 2018 at 05:46:16PM +0300, Nikolay Borisov wrote:
>> To help implement free space tree checker in user space some kernel
>> function are necessary, namely iterating/deleting/adding freespace
>> items, some internal search functions. Functions to populate a block
>> group based on the extent tree. The code is largely copy/paste from
>> the kernel with locking eliminated (i.e free_space_lock). It supports
>> reading/writing of both bitmap and extent based FST trees.
> 
> For some reason, a lot of this added code uses spaces instead of tabs,
> so I had to fix that in order to compare it to the kernel code (some of
> the functions were reordered, too).
> 
> The only functional difference I noticed was that this is missing the
> code to insert the block group header in the free space tree:
> 
> 	if (block_group->needs_free_space) {
> 		ret = __add_block_group_free_space(trans, block_group, path);
> 		if (ret)
> 			return ret;
> 	}
> 
> Was that intentionally omitted? Without it, the free space tree is
> pretty broken :(

Yes, it was intentional. If you remember I even emailed you about this
particular piece of code and you said you needed to have it this way in
case delayed refs were run before the space tree was initialized.

In user space AFAIK we don't have that problem since
add_new_free_space_info/__add_to_free_space_tree is called via

btrfs_Create_free_space_tree
   populate_free_space_tree
     add_new_free_space_info
     __add_to_free_space_tree



> 
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  ctree.c           |   77 ++++
>>  ctree.h           |   15 +
>>  free-space-tree.c | 1253 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  free-space-tree.h |   13 +-
>>  kerncompat.h      |    6 +
>>  5 files changed, 1357 insertions(+), 7 deletions(-)
>>
>> diff --git a/ctree.c b/ctree.c
>> index d8a6883aa85f..aa1568620205 100644
>> --- a/ctree.c
>> +++ b/ctree.c
>> @@ -1226,6 +1226,83 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
>>  }
>>  
>>  /*
>> + * helper to use instead of search slot if no exact match is needed but
>> + * instead the next or previous item should be returned.
>> + * When find_higher is true, the next higher item is returned, the next lower
>> + * otherwise.
>> + * When return_any and find_higher are both true, and no higher item is found,
>> + * return the next lower instead.
>> + * When return_any is true and find_higher is false, and no lower item is found,
>> + * return the next higher instead.
>> + * It returns 0 if any item is found, 1 if none is found (tree empty), and
>> + * < 0 on error
>> + */
>> +int btrfs_search_slot_for_read(struct btrfs_root *root,
>> +                               const struct btrfs_key *key,
>> +                               struct btrfs_path *p, int find_higher,
>> +                               int return_any)
>> +{
>> +        int ret;
>> +        struct extent_buffer *leaf;
>> +
>> +again:
>> +        ret = btrfs_search_slot(NULL, root, key, p, 0, 0);
>> +        if (ret <= 0)
>> +                return ret;
>> +        /*
>> +         * a return value of 1 means the path is at the position where the
>> +         * item should be inserted. Normally this is the next bigger item,
>> +         * but in case the previous item is the last in a leaf, path points
>> +         * to the first free slot in the previous leaf, i.e. at an invalid
>> +         * item.
>> +         */
>> +        leaf = p->nodes[0];
>> +
>> +        if (find_higher) {
>> +                if (p->slots[0] >= btrfs_header_nritems(leaf)) {
>> +                        ret = btrfs_next_leaf(root, p);
>> +                        if (ret <= 0)
>> +                                return ret;
>> +                        if (!return_any)
>> +                                return 1;
>> +                        /*
>> +                         * no higher item found, return the next
>> +                         * lower instead
>> +                         */
>> +                        return_any = 0;
>> +                        find_higher = 0;
>> +                        btrfs_release_path(p);
>> +                        goto again;
>> +                }
>> +        } else {
>> +                if (p->slots[0] == 0) {
>> +                        ret = btrfs_prev_leaf(root, p);
>> +                        if (ret < 0)
>> +                                return ret;
>> +                        if (!ret) {
>> +                                leaf = p->nodes[0];
>> +                                if (p->slots[0] == btrfs_header_nritems(leaf))
>> +                                        p->slots[0]--;
>> +                                return 0;
>> +                        }
>> +                        if (!return_any)
>> +                                return 1;
>> +                        /*
>> +                         * no lower item found, return the next
>> +                         * higher instead
>> +                         */
>> +                        return_any = 0;
>> +                        find_higher = 1;
>> +                        btrfs_release_path(p);
>> +                        goto again;
>> +                } else {
>> +                        --p->slots[0];
>> +                }
>> +        }
>> +        return 0;
>> +}
>> +
>> +/*
>>   * adjust the pointers going up the tree, starting at level
>>   * making sure the right key of each node is points to 'key'.
>>   * This is used after shifting pointers to the left, so it stops
>> diff --git a/ctree.h b/ctree.h
>> index 49f0f5181512..a6d6c3decd87 100644
>> --- a/ctree.h
>> +++ b/ctree.h
>> @@ -1071,6 +1071,17 @@ struct btrfs_block_group_cache {
>>  	u64 flags;
>>  	int cached;
>>  	int ro;
>> +	/*
>> +         * If the free space extent count exceeds this number, convert the block
>> +         * group to bitmaps.
>> +         */
>> +        u32 bitmap_high_thresh;
>> +        /*
>> +         * If the free space extent count drops below this number, convert the
>> +         * block group back to extents.
>> +         */
>> +        u32 bitmap_low_thresh;
>> +
>>  };
>>  
>>  struct btrfs_device;
>> @@ -2596,6 +2607,10 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
>>  int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
>>  		      *root, struct btrfs_key *key, struct btrfs_path *p, int
>>  		      ins_len, int cow);
>> +int btrfs_search_slot_for_read(struct btrfs_root *root,
>> +                               const struct btrfs_key *key,
>> +                               struct btrfs_path *p, int find_higher,
>> +                               int return_any);
>>  int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *found_path,
>>  		u64 iobjectid, u64 ioff, u8 key_type,
>>  		struct btrfs_key *found_key);
>> diff --git a/free-space-tree.c b/free-space-tree.c
>> index b439b6b43146..3b7e8a3fe4f5 100644
>> --- a/free-space-tree.c
>> +++ b/free-space-tree.c
>> @@ -21,6 +21,37 @@
>>  #include "free-space-cache.h"
>>  #include "free-space-tree.h"
>>  #include "transaction.h"
>> +#include "bitops.h"
>> +#include "internal.h"
>> +
>> +void set_free_space_tree_thresholds(struct btrfs_block_group_cache *cache,
>> +				    u64 sectorsize)
>> +{
>> +	u32 bitmap_range;
>> +	size_t bitmap_size;
>> +	u64 num_bitmaps, total_bitmap_size;
>> +
>> +	/*
>> +	 * We convert to bitmaps when the disk space required for using extents
>> +	 * exceeds that required for using bitmaps.
>> +	 */
>> +	bitmap_range = sectorsize * BTRFS_FREE_SPACE_BITMAP_BITS;
>> +	num_bitmaps = div_u64(cache->key.offset + bitmap_range - 1,
>> +			      bitmap_range);
>> +	bitmap_size = sizeof(struct btrfs_item) + BTRFS_FREE_SPACE_BITMAP_SIZE;
>> +	total_bitmap_size = num_bitmaps * bitmap_size;
>> +	cache->bitmap_high_thresh = div_u64(total_bitmap_size,
>> +					    sizeof(struct btrfs_item));
>> +
>> +	/*
>> +	 * We allow for a small buffer between the high threshold and low
>> +	 * threshold to avoid thrashing back and forth between the two formats.
>> +	 */
>> +	if (cache->bitmap_high_thresh > 100)
>> +		cache->bitmap_low_thresh = cache->bitmap_high_thresh - 100;
>> +	else
>> +		cache->bitmap_low_thresh = 0;
>> +}
>>  
>>  static struct btrfs_free_space_info *
>>  search_free_space_info(struct btrfs_trans_handle *trans,
>> @@ -47,8 +78,7 @@ search_free_space_info(struct btrfs_trans_handle *trans,
>>  }
>>  
>>  static int free_space_test_bit(struct btrfs_block_group_cache *block_group,
>> -			       struct btrfs_path *path, u64 offset,
>> -			       u64 sectorsize)
>> +			       struct btrfs_path *path, u64 offset)
>>  {
>>  	struct extent_buffer *leaf;
>>  	struct btrfs_key key;
>> @@ -64,10 +94,1085 @@ static int free_space_test_bit(struct btrfs_block_group_cache *block_group,
>>  	ASSERT(offset >= found_start && offset < found_end);
>>  
>>  	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
>> -	i = (offset - found_start) / sectorsize;
>> +	i = (offset - found_start) / leaf->fs_info->sectorsize;
>>  	return !!extent_buffer_test_bit(leaf, ptr, i);
>>  }
>>  
>> +/*
>> + * btrfs_search_slot() but we're looking for the greatest key less than the
>> + * passed key.
>> + */
>> +static int btrfs_search_prev_slot(struct btrfs_trans_handle *trans,
>> +                                  struct btrfs_root *root,
>> +                                  struct btrfs_key *key, struct btrfs_path *p,
>> +                                  int ins_len, int cow)
>> +{
>> +	int ret;
>> +
>> +	ret = btrfs_search_slot(trans, root, key, p, ins_len, cow);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (ret == 0) {
>> +		ASSERT(0);
>> +		return -EIO;
>> +	}
>> +
>> +	if (p->slots[0] == 0) {
>> +		ASSERT(0);
>> +		return -EIO;
>> +	}
>> +	p->slots[0]--;
>> +
>> +	return 0;
>> +}
>> +
>> +static int add_new_free_space_info(struct btrfs_trans_handle *trans,
>> +                                   struct btrfs_block_group_cache *block_group,
>> +                                   struct btrfs_path *path)
>> +{
>> +	struct btrfs_root *root = trans->fs_info->free_space_root;
>> +	struct btrfs_free_space_info *info;
>> +	struct btrfs_key key;
>> +	struct extent_buffer *leaf;
>> +	int ret;
>> +
>> +	key.objectid = block_group->key.objectid;
>> +	key.type = BTRFS_FREE_SPACE_INFO_KEY;
>> +	key.offset = block_group->key.offset;
>> +
>> +	ret = btrfs_insert_empty_item(trans, root, path, &key, sizeof(*info));
>> +	if (ret)
>> +		goto out;
>> +
>> +	leaf = path->nodes[0];
>> +	info = btrfs_item_ptr(leaf, path->slots[0],
>> +	                      struct btrfs_free_space_info);
>> +	btrfs_set_free_space_extent_count(leaf, info, 0);
>> +	btrfs_set_free_space_flags(leaf, info, 0);
>> +	btrfs_mark_buffer_dirty(leaf);
>> +
>> +	ret = 0;
>> +out:
>> +	btrfs_release_path(path);
>> +	return ret;
>> +}
>> +
>> +static inline u32 free_space_bitmap_size(u64 size, u32 sectorsize)
>> +{
>> +	return DIV_ROUND_UP((u32)div_u64(size, sectorsize), BITS_PER_BYTE);
>> +}
>> +
>> +static unsigned long *alloc_bitmap(u32 bitmap_size)
>> +{
>> +	unsigned long *ret;
>> +	unsigned int nofs_flag;
>> +	u32 bitmap_rounded_size = round_up(bitmap_size, sizeof(unsigned long));
>> +
>> +	/*
>> +	 * GFP_NOFS doesn't work with kvmalloc(), but we really can't recurse
>> +	 * into the filesystem as the free space bitmap can be modified in the
>> +	 * critical section of a transaction commit.
>> +	 *
>> +	 * TODO: push the memalloc_nofs_{save,restore}() to the caller where we
>> +	 * know that recursion is unsafe.
>> +	 */
>> +	nofs_flag = memalloc_nofs_save();
>> +	ret = kvzalloc(bitmap_rounded_size, GFP_KERNEL);
>> +	memalloc_nofs_restore(nofs_flag);
>> +	return ret;
>> +}
>> +
>> +static void le_bitmap_set(unsigned long *map, unsigned int start, int len)
>> +{
>> +	u8 *p = ((u8 *)map) + BIT_BYTE(start);
>> +	const unsigned int size = start + len;
>> +	int bits_to_set = BITS_PER_BYTE - (start % BITS_PER_BYTE);
>> +	u8 mask_to_set = BITMAP_FIRST_BYTE_MASK(start);
>> +
>> +	while (len - bits_to_set >= 0) {
>> +		*p |= mask_to_set;
>> +		len -= bits_to_set;
>> +		bits_to_set = BITS_PER_BYTE;
>> +		mask_to_set = ~0;
>> +		p++;
>> +	}
>> +	if (len) {
>> +		mask_to_set &= BITMAP_LAST_BYTE_MASK(size);
>> +		*p |= mask_to_set;
>> +	}
>> +}
>> +
>> +int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
>> +				  struct btrfs_block_group_cache *block_group,
>> +				  struct btrfs_path *path)
>> +{
>> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>> +	struct btrfs_root *root = fs_info->free_space_root;
>> +	struct btrfs_free_space_info *info;
>> +	struct btrfs_key key, found_key;
>> +	struct extent_buffer *leaf;
>> +	unsigned long *bitmap;
>> +	char *bitmap_cursor;
>> +	u64 start, end;
>> +	u64 bitmap_range, i;
>> +	u32 bitmap_size, flags, expected_extent_count;
>> +	u32 extent_count = 0;
>> +	int done = 0, nr;
>> +	int ret;
>> +
>> +	bitmap_size = free_space_bitmap_size(block_group->key.offset,
>> +					     fs_info->sectorsize);
>> +	bitmap = alloc_bitmap(bitmap_size);
>> +	if (!bitmap) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	start = block_group->key.objectid;
>> +	end = block_group->key.objectid + block_group->key.offset;
>> +
>> +	key.objectid = end - 1;
>> +	key.type = (u8)-1;
>> +	key.offset = (u64)-1;
>> +
>> +	while (!done) {
>> +		ret = btrfs_search_prev_slot(trans, root, &key, path, -1, 1);
>> +		if (ret)
>> +			goto out;
>> +
>> +		leaf = path->nodes[0];
>> +		nr = 0;
>> +		path->slots[0]++;
>> +		while (path->slots[0] > 0) {
>> +			btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0] - 1);
>> +
>> +			if (found_key.type == BTRFS_FREE_SPACE_INFO_KEY) {
>> +				ASSERT(found_key.objectid == block_group->key.objectid);
>> +				ASSERT(found_key.offset == block_group->key.offset);
>> +				done = 1;
>> +				break;
>> +			} else if (found_key.type == BTRFS_FREE_SPACE_EXTENT_KEY) {
>> +				u64 first, last;
>> +
>> +				ASSERT(found_key.objectid >= start);
>> +				ASSERT(found_key.objectid < end);
>> +				ASSERT(found_key.objectid + found_key.offset <= end);
>> +
>> +				first = div_u64(found_key.objectid - start,
>> +						fs_info->sectorsize);
>> +				last = div_u64(found_key.objectid + found_key.offset - start,
>> +					       fs_info->sectorsize);
>> +				le_bitmap_set(bitmap, first, last - first);
>> +
>> +				extent_count++;
>> +				nr++;
>> +				path->slots[0]--;
>> +			} else {
>> +				ASSERT(0);
>> +			}
>> +		}
>> +
>> +		ret = btrfs_del_items(trans, root, path, path->slots[0], nr);
>> +		if (ret)
>> +			goto out;
>> +		btrfs_release_path(path);
>> +	}
>> +
>> +	info = search_free_space_info(trans, fs_info, block_group, path, 1);
>> +	if (IS_ERR(info)) {
>> +		ret = PTR_ERR(info);
>> +		goto out;
>> +	}
>> +	leaf = path->nodes[0];
>> +	flags = btrfs_free_space_flags(leaf, info);
>> +	flags |= BTRFS_FREE_SPACE_USING_BITMAPS;
>> +	btrfs_set_free_space_flags(leaf, info, flags);
>> +	expected_extent_count = btrfs_free_space_extent_count(leaf, info);
>> +	btrfs_mark_buffer_dirty(leaf);
>> +	btrfs_release_path(path);
>> +
>> +	if (extent_count != expected_extent_count) {
>> +		fprintf(stderr,
>> +			"incorrect extent count for %llu; counted %u, expected %u",
>> +			block_group->key.objectid, extent_count,
>> +			expected_extent_count);
>> +		ASSERT(0);
>> +		ret = -EIO;
>> +		goto out;
>> +	}
>> +
>> +	bitmap_cursor = (char *)bitmap;
>> +	bitmap_range = fs_info->sectorsize * BTRFS_FREE_SPACE_BITMAP_BITS;
>> +	i = start;
>> +	while (i < end) {
>> +		unsigned long ptr;
>> +		u64 extent_size;
>> +		u32 data_size;
>> +
>> +		extent_size = min(end - i, bitmap_range);
>> +		data_size = free_space_bitmap_size(extent_size,
>> +						   fs_info->sectorsize);
>> +
>> +		key.objectid = i;
>> +		key.type = BTRFS_FREE_SPACE_BITMAP_KEY;
>> +		key.offset = extent_size;
>> +
>> +		ret = btrfs_insert_empty_item(trans, root, path, &key,
>> +					      data_size);
>> +		if (ret)
>> +			goto out;
>> +
>> +		leaf = path->nodes[0];
>> +		ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
>> +		write_extent_buffer(leaf, bitmap_cursor, ptr,
>> +				    data_size);
>> +		btrfs_mark_buffer_dirty(leaf);
>> +		btrfs_release_path(path);
>> +
>> +		i += extent_size;
>> +		bitmap_cursor += data_size;
>> +	}
>> +
>> +	ret = 0;
>> +out:
>> +	kvfree(bitmap);
>> +	if (ret)
>> +		btrfs_abort_transaction(trans, ret);
>> +	return ret;
>> +}
>> +
>> +int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
>> +				  struct btrfs_block_group_cache *block_group,
>> +				  struct btrfs_path *path)
>> +{
>> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>> +	struct btrfs_root *root = fs_info->free_space_root;
>> +	struct btrfs_free_space_info *info;
>> +	struct btrfs_key key, found_key;
>> +	struct extent_buffer *leaf;
>> +	unsigned long *bitmap;
>> +	u64 start, end;
>> +	u32 bitmap_size, flags, expected_extent_count;
>> +	unsigned long nrbits, start_bit, end_bit;
>> +	u32 extent_count = 0;
>> +	int done = 0, nr;
>> +	int ret;
>> +
>> +	bitmap_size = free_space_bitmap_size(block_group->key.offset,
>> +					     fs_info->sectorsize);
>> +	bitmap = alloc_bitmap(bitmap_size);
>> +	if (!bitmap) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	start = block_group->key.objectid;
>> +	end = block_group->key.objectid + block_group->key.offset;
>> +
>> +	key.objectid = end - 1;
>> +	key.type = (u8)-1;
>> +	key.offset = (u64)-1;
>> +
>> +	while (!done) {
>> +		ret = btrfs_search_prev_slot(trans, root, &key, path, -1, 1);
>> +		if (ret)
>> +			goto out;
>> +
>> +		leaf = path->nodes[0];
>> +		nr = 0;
>> +		path->slots[0]++;
>> +		while (path->slots[0] > 0) {
>> +			btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0] - 1);
>> +
>> +			if (found_key.type == BTRFS_FREE_SPACE_INFO_KEY) {
>> +				ASSERT(found_key.objectid == block_group->key.objectid);
>> +				ASSERT(found_key.offset == block_group->key.offset);
>> +				done = 1;
>> +				break;
>> +			} else if (found_key.type == BTRFS_FREE_SPACE_BITMAP_KEY) {
>> +				unsigned long ptr;
>> +				char *bitmap_cursor;
>> +				u32 bitmap_pos, data_size;
>> +
>> +				ASSERT(found_key.objectid >= start);
>> +				ASSERT(found_key.objectid < end);
>> +				ASSERT(found_key.objectid + found_key.offset <= end);
>> +
>> +				bitmap_pos = div_u64(found_key.objectid - start,
>> +						     fs_info->sectorsize *
>> +						     BITS_PER_BYTE);
>> +				bitmap_cursor = ((char *)bitmap) + bitmap_pos;
>> +				data_size = free_space_bitmap_size(found_key.offset,
>> +								   fs_info->sectorsize);
>> +
>> +				ptr = btrfs_item_ptr_offset(leaf, path->slots[0] - 1);
>> +				read_extent_buffer(leaf, bitmap_cursor, ptr,
>> +						   data_size);
>> +
>> +				nr++;
>> +				path->slots[0]--;
>> +			} else {
>> +				ASSERT(0);
>> +			}
>> +		}
>> +
>> +		ret = btrfs_del_items(trans, root, path, path->slots[0], nr);
>> +		if (ret)
>> +			goto out;
>> +		btrfs_release_path(path);
>> +	}
>> +
>> +	info = search_free_space_info(trans, fs_info, block_group, path, 1);
>> +	if (IS_ERR(info)) {
>> +		ret = PTR_ERR(info);
>> +		goto out;
>> +	}
>> +	leaf = path->nodes[0];
>> +	flags = btrfs_free_space_flags(leaf, info);
>> +	flags &= ~BTRFS_FREE_SPACE_USING_BITMAPS;
>> +	btrfs_set_free_space_flags(leaf, info, flags);
>> +	expected_extent_count = btrfs_free_space_extent_count(leaf, info);
>> +	btrfs_mark_buffer_dirty(leaf);
>> +	btrfs_release_path(path);
>> +
>> +	nrbits = div_u64(block_group->key.offset, fs_info->sectorsize);
>> +	start_bit = find_next_bit_le(bitmap, nrbits, 0);
>> +
>> +	while (start_bit < nrbits) {
>> +		end_bit = find_next_zero_bit_le(bitmap, nrbits, start_bit);
>> +		ASSERT(start_bit < end_bit);
>> +
>> +		key.objectid = start + start_bit * fs_info->sectorsize;
>> +		key.type = BTRFS_FREE_SPACE_EXTENT_KEY;
>> +		key.offset = (end_bit - start_bit) * fs_info->sectorsize;
>> +
>> +		ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
>> +		if (ret)
>> +			goto out;
>> +		btrfs_release_path(path);
>> +
>> +		extent_count++;
>> +
>> +		start_bit = find_next_bit_le(bitmap, nrbits, end_bit);
>> +	}
>> +
>> +	if (extent_count != expected_extent_count) {
>> +		fprintf(stderr,
>> +			"incorrect extent count for %llu; counted %u, expected %u",
>> +			block_group->key.objectid, extent_count,
>> +			expected_extent_count);
>> +		ASSERT(0);
>> +		ret = -EIO;
>> +		goto out;
>> +	}
>> +
>> +	ret = 0;
>> +out:
>> +	kvfree(bitmap);
>> +	if (ret)
>> +		btrfs_abort_transaction(trans, ret);
>> +	return ret;
>> +}
>> +
>> +static int update_free_space_extent_count(struct btrfs_trans_handle *trans,
>> +                                          struct btrfs_block_group_cache *block_group,
>> +                                          struct btrfs_path *path,
>> +                                          int new_extents)
>> +{
>> +	struct btrfs_free_space_info *info;
>> +	u32 flags;
>> +	u32 extent_count;
>> +	int ret = 0;
>> +
>> +	if (new_extents == 0)
>> +		return 0;
>> +
>> +	info = search_free_space_info(trans, trans->fs_info, block_group, path,
>> +				1);
>> +	if (IS_ERR(info)) {
>> +		ret = PTR_ERR(info);
>> +		goto out;
>> +	}
>> +	flags = btrfs_free_space_flags(path->nodes[0], info);
>> +	extent_count = btrfs_free_space_extent_count(path->nodes[0], info);
>> +
>> +	extent_count += new_extents;
>> +	btrfs_set_free_space_extent_count(path->nodes[0], info, extent_count);
>> +	btrfs_mark_buffer_dirty(path->nodes[0]);
>> +	btrfs_release_path(path);
>> +
>> +	if (!(flags & BTRFS_FREE_SPACE_USING_BITMAPS) &&
>> +	    extent_count > block_group->bitmap_high_thresh) {
>> +		ret = convert_free_space_to_bitmaps(trans, block_group, path);
>> +	} else if ((flags & BTRFS_FREE_SPACE_USING_BITMAPS) &&
>> +		   extent_count < block_group->bitmap_low_thresh) {
>> +		ret = convert_free_space_to_extents(trans, block_group, path);
>> +	}
>> +
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> +
>> +static void free_space_set_bits(struct btrfs_block_group_cache *block_group,
>> +                                struct btrfs_path *path, u64 *start, u64 *size,
>> +                                int bit)
>> +{
>> +        struct extent_buffer *leaf = path->nodes[0];
>> +        struct btrfs_fs_info *fs_info = leaf->fs_info;
>> +        struct btrfs_key key;
>> +        u64 end = *start + *size;
>> +        u64 found_start, found_end;
>> +        unsigned long ptr, first, last;
>> +
>> +        btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
>> +        ASSERT(key.type == BTRFS_FREE_SPACE_BITMAP_KEY);
>> +
>> +        found_start = key.objectid;
>> +        found_end = key.objectid + key.offset;
>> +        ASSERT(*start >= found_start && *start < found_end);
>> +        ASSERT(end > found_start);
>> +
>> +        if (end > found_end)
>> +                end = found_end;
>> +
>> +        ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
>> +        first = (*start - found_start) / fs_info->sectorsize;
>> +        last = (end - found_start) / fs_info->sectorsize;
>> +        if (bit)
>> +                extent_buffer_bitmap_set(leaf, ptr, first, last - first);
>> +        else
>> +                extent_buffer_bitmap_clear(leaf, ptr, first, last - first);
>> +        btrfs_mark_buffer_dirty(leaf);
>> +
>> +        *size -= end - *start;
>> +        *start = end;
>> +}
>> +
>> +/*
>> + * We can't use btrfs_next_item() in modify_free_space_bitmap() because
>> + * btrfs_next_leaf() doesn't get the path for writing. We can forgo the fancy
>> + * tree walking in btrfs_next_leaf() anyways because we know exactly what we're
>> + * looking for.
>> + */
>> +static int free_space_next_bitmap(struct btrfs_trans_handle *trans,
>> +                                  struct btrfs_root *root, struct btrfs_path *p)
>> +{
>> +	struct btrfs_key key;
>> +
>> +	if (p->slots[0] + 1 < btrfs_header_nritems(p->nodes[0])) {
>> +		p->slots[0]++;
>> +		return 0;
>> +	}
>> +
>> +	btrfs_item_key_to_cpu(p->nodes[0], &key, p->slots[0]);
>> +	btrfs_release_path(p);
>> +
>> +	key.objectid += key.offset;
>> +	key.type = (u8)-1;
>> +	key.offset = (u64)-1;
>> +
>> +	return btrfs_search_prev_slot(trans, root, &key, p, 0, 1);
>> +}
>> +
>> +/*
>> + * If remove is 1, then we are removing free space, thus clearing bits in the
>> + * bitmap. If remove is 0, then we are adding free space, thus setting bits in
>> + * the bitmap.
>> + */
>> +static int modify_free_space_bitmap(struct btrfs_trans_handle *trans,
>> +                                    struct btrfs_block_group_cache *block_group,
>> +                                    struct btrfs_path *path,
>> +                                    u64 start, u64 size, int remove)
>> +{
>> +        struct btrfs_root *root = trans->fs_info->free_space_root;
>> +        struct btrfs_key key;
>> +        u64 end = start + size;
>> +        u64 cur_start, cur_size;
>> +        int prev_bit, next_bit;
>> +        int new_extents;
>> +        int ret;
>> +
>> +        /*
>> +         * Read the bit for the block immediately before the extent of space if
>> +         * that block is within the block group.
>> +         */
>> +        if (start > block_group->key.objectid) {
>> +                u64 prev_block = start - trans->fs_info->sectorsize;
>> +
>> +                key.objectid = prev_block;
>> +                key.type = (u8)-1;
>> +                key.offset = (u64)-1;
>> +
>> +                ret = btrfs_search_prev_slot(trans, root, &key, path, 0, 1);
>> +                if (ret)
>> +                        goto out;
>> +
>> +                prev_bit = free_space_test_bit(block_group, path, prev_block);
>> +
>> +                /* The previous block may have been in the previous bitmap. */
>> +                btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +                if (start >= key.objectid + key.offset) {
>> +                        ret = free_space_next_bitmap(trans, root, path);
>> +                        if (ret)
>> +                                goto out;
>> +                }
>> +        } else {
>> +                key.objectid = start;
>> +                key.type = (u8)-1;
>> +                key.offset = (u64)-1;
>> +
>> +                ret = btrfs_search_prev_slot(trans, root, &key, path, 0, 1);
>> +                if (ret)
>> +                        goto out;
>> +
>> +                prev_bit = -1;
>> +        }
>> +
>> +        /*
>> +         * Iterate over all of the bitmaps overlapped by the extent of space,
>> +         * clearing/setting bits as required.
>> +         */
>> +        cur_start = start;
>> +        cur_size = size;
>> +        while (1) {
>> +                free_space_set_bits(block_group, path, &cur_start, &cur_size,
>> +                                    !remove);
>> +                if (cur_size == 0)
>> +                        break;
>> +                ret = free_space_next_bitmap(trans, root, path);
>> +                if (ret)
>> +                        goto out;
>> +        }
>> +
>> +	/*
>> +         * Read the bit for the block immediately after the extent of space if
>> +         * that block is within the block group.
>> +         */
>> +        if (end < block_group->key.objectid + block_group->key.offset) {
>> +                /* The next block may be in the next bitmap. */
>> +                btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +                if (end >= key.objectid + key.offset) {
>> +                        ret = free_space_next_bitmap(trans, root, path);
>> +                        if (ret)
>> +                                goto out;
>> +                }
>> +
>> +                next_bit = free_space_test_bit(block_group, path, end);
>> +        } else {
>> +                next_bit = -1;
>> +        }
>> +
>> +        if (remove) {
>> +                new_extents = -1;
>> +                if (prev_bit == 1) {
>> +                        /* Leftover on the left. */
>> +                        new_extents++;
>> +                }
>> +                if (next_bit == 1) {
>> +                        /* Leftover on the right. */
>> +                        new_extents++;
>> +                }
>> +        } else {
>> +                new_extents = 1;
>> +                if (prev_bit == 1) {
>> +                        /* Merging with neighbor on the left. */
>> +                        new_extents--;
>> +                }
>> +                if (next_bit == 1) {
>> +                        /* Merging with neighbor on the right. */
>> +                        new_extents--;
>> +                }
>> +        }
>> +
>> +        btrfs_release_path(path);
>> +        ret = update_free_space_extent_count(trans, block_group, path,
>> +                                             new_extents);
>> +
>> +out:
>> +        return ret;
>> +}
>> +
>> +static int remove_free_space_extent(struct btrfs_trans_handle *trans,
>> +				    struct btrfs_block_group_cache *block_group,
>> +				    struct btrfs_path *path,
>> +				    u64 start, u64 size)
>> +{
>> +	struct btrfs_root *root = trans->fs_info->free_space_root;
>> +	struct btrfs_key key;
>> +	u64 found_start, found_end;
>> +	u64 end = start + size;
>> +	int new_extents = -1;
>> +	int ret;
>> +
>> +	key.objectid = start;
>> +	key.type = (u8)-1;
>> +	key.offset = (u64)-1;
>> +
>> +	ret = btrfs_search_prev_slot(trans, root, &key, path, -1, 1);
>> +	if (ret)
>> +		goto out;
>> +
>> +	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +
>> +	ASSERT(key.type == BTRFS_FREE_SPACE_EXTENT_KEY);
>> +
>> +	found_start = key.objectid;
>> +	found_end = key.objectid + key.offset;
>> +	ASSERT(start >= found_start && end <= found_end);
>> +
>> +	/*
>> +	 * Okay, now that we've found the free space extent which contains the
>> +	 * free space that we are removing, there are four cases:
>> +	 *
>> +	 * 1. We're using the whole extent: delete the key we found and
>> +	 * decrement the free space extent count.
>> +	 * 2. We are using part of the extent starting at the beginning: delete
>> +	 * the key we found and insert a new key representing the leftover at
>> +	 * the end. There is no net change in the number of extents.
>> +	 * 3. We are using part of the extent ending at the end: delete the key
>> +	 * we found and insert a new key representing the leftover at the
>> +	 * beginning. There is no net change in the number of extents.
>> +	 * 4. We are using part of the extent in the middle: delete the key we
>> +	 * found and insert two new keys representing the leftovers on each
>> +	 * side. Where we used to have one extent, we now have two, so increment
>> +	 * the extent count. We may need to convert the block group to bitmaps
>> +	 * as a result.
>> +	 */
>> +
>> +	/* Delete the existing key (cases 1-4). */
>> +	ret = btrfs_del_item(trans, root, path);
>> +	if (ret)
>> +		goto out;
>> +
>> +	/* Add a key for leftovers at the beginning (cases 3 and 4). */
>> +	if (start > found_start) {
>> +		key.objectid = found_start;
>> +		key.type = BTRFS_FREE_SPACE_EXTENT_KEY;
>> +		key.offset = start - found_start;
>> +
>> +		btrfs_release_path(path);
>> +		ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
>> +		if (ret)
>> +			goto out;
>> +		new_extents++;
>> +	}
>> +
>> +	/* Add a key for leftovers at the end (cases 2 and 4). */
>> +	if (end < found_end) {
>> +		key.objectid = end;
>> +		key.type = BTRFS_FREE_SPACE_EXTENT_KEY;
>> +		key.offset = found_end - end;
>> +
>> +		btrfs_release_path(path);
>> +		ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
>> +		if (ret)
>> +			goto out;
>> +		new_extents++;
>> +	}
>> +
>> +	btrfs_release_path(path);
>> +	ret = update_free_space_extent_count(trans, block_group, path,
>> +					     new_extents);
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> +int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
>> +                                  struct btrfs_block_group_cache *block_group,
>> +                                  struct btrfs_path *path, u64 start, u64 size)
>> +{
>> +	struct btrfs_free_space_info *info;
>> +	u32 flags;
>> +
>> +	info = search_free_space_info(NULL, trans->fs_info, block_group, path,
>> +	                              0);
>> +	if (IS_ERR(info))
>> +		return PTR_ERR(info);
>> +	flags = btrfs_free_space_flags(path->nodes[0], info);
>> +	btrfs_release_path(path);
>> +
>> +	if (flags & BTRFS_FREE_SPACE_USING_BITMAPS) {
>> +		return modify_free_space_bitmap(trans, block_group, path,
>> +	                                        start, size, 1);
>> +	} else {
>> +		return remove_free_space_extent(trans, block_group, path,
>> +	                                        start, size);
>> +	}
>> +}
>> +
>> +int remove_from_free_space_tree(struct btrfs_trans_handle *trans,
>> +				u64 start, u64 size)
>> +{
>> +	struct btrfs_block_group_cache *block_group;
>> +	struct btrfs_path *path;
>> +	int ret;
>> +
>> +	if (!btrfs_fs_compat_ro(trans->fs_info, FREE_SPACE_TREE))
>> +		return 0;
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	block_group = btrfs_lookup_block_group(trans->fs_info, start);
>> +	if (!block_group) {
>> +		ASSERT(0);
>> +		ret = -ENOENT;
>> +		goto out;
>> +	}
>> +
>> +	ret = __remove_from_free_space_tree(trans, block_group, path, start,
>> +					    size);
>> +out:
>> +	btrfs_free_path(path);
>> +	if (ret)
>> +		btrfs_abort_transaction(trans, ret);
>> +	return ret;
>> +}
>> +
>> +static int add_free_space_extent(struct btrfs_trans_handle *trans,
>> +                                 struct btrfs_block_group_cache *block_group,
>> +                                 struct btrfs_path *path,
>> +                                 u64 start, u64 size)
>> +{
>> +        struct btrfs_root *root = trans->fs_info->free_space_root;
>> +        struct btrfs_key key, new_key;
>> +        u64 found_start, found_end;
>> +        u64 end = start + size;
>> +        int new_extents = 1;
>> +        int ret;
>> +
>> +        /*
>> +         * We are adding a new extent of free space, but we need to merge
>> +         * extents. There are four cases here:
>> +         *
>> +         * 1. The new extent does not have any immediate neighbors to merge
>> +         * with: add the new key and increment the free space extent count. We
>> +         * may need to convert the block group to bitmaps as a result.
>> +         * 2. The new extent has an immediate neighbor before it: remove the
>> +         * previous key and insert a new key combining both of them. There is no
>> +         * net change in the number of extents.
>> +         * 3. The new extent has an immediate neighbor after it: remove the next
>> +         * key and insert a new key combining both of them. There is no net
>> +         * change in the number of extents.
>> +         * 4. The new extent has immediate neighbors on both sides: remove both
>> +         * of the keys and insert a new key combining all of them. Where we used
>> +         * to have two extents, we now have one, so decrement the extent count.
>> +         */
>> +
>> +        new_key.objectid = start;
>> +        new_key.type = BTRFS_FREE_SPACE_EXTENT_KEY;
>> +        new_key.offset = size;
>> +
>> +        /* Search for a neighbor on the left. */
>> +        if (start == block_group->key.objectid)
>> +                goto right;
>> +        key.objectid = start - 1;
>> +        key.type = (u8)-1;
>> +        key.offset = (u64)-1;
>> +
>> +        ret = btrfs_search_prev_slot(trans, root, &key, path, -1, 1);
>> +        if (ret)
>> +                goto out;
>> +
>> +        btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +
>> +        if (key.type != BTRFS_FREE_SPACE_EXTENT_KEY) {
>> +                ASSERT(key.type == BTRFS_FREE_SPACE_INFO_KEY);
>> +                btrfs_release_path(path);
>> +                goto right;
>> +        }
>> +
>> +        found_start = key.objectid;
>> +        found_end = key.objectid + key.offset;
>> +        ASSERT(found_start >= block_group->key.objectid &&
>> +               found_end > block_group->key.objectid);
>> +        ASSERT(found_start < start && found_end <= start);
>> +
>> +        /*
>> +         * Delete the neighbor on the left and absorb it into the new key (cases
>> +         * 2 and 4).
>> +         */
>> +        if (found_end == start) {
>> +                ret = btrfs_del_item(trans, root, path);
>> +                if (ret)
>> +                        goto out;
>> +                new_key.objectid = found_start;
>> +                new_key.offset += key.offset;
>> +                new_extents--;
>> +        }
>> +        btrfs_release_path(path);
>> +right:
>> +        /* Search for a neighbor on the right. */
>> +        if (end == block_group->key.objectid + block_group->key.offset)
>> +                goto insert;
>> +        key.objectid = end;
>> +        key.type = (u8)-1;
>> +        key.offset = (u64)-1;
>> +
>> +        ret = btrfs_search_prev_slot(trans, root, &key, path, -1, 1);
>> +        if (ret)
>> +                goto out;
>> +
>> +        btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +
>> +        if (key.type != BTRFS_FREE_SPACE_EXTENT_KEY) {
>> +                ASSERT(key.type == BTRFS_FREE_SPACE_INFO_KEY);
>> +                btrfs_release_path(path);
>> +                goto insert;
>> +        }
>> +
>> +        found_start = key.objectid;
>> +        found_end = key.objectid + key.offset;
>> +        ASSERT(found_start >= block_group->key.objectid &&
>> +               found_end > block_group->key.objectid);
>> +        ASSERT((found_start < start && found_end <= start) ||
>> +               (found_start >= end && found_end > end));
>> +
>> +        /*
>> +         * Delete the neighbor on the right and absorb it into the new key
>> +         * (cases 3 and 4).
>> +         */
>> +        if (found_start == end) {
>> +                ret = btrfs_del_item(trans, root, path);
>> +                if (ret)
>> +                        goto out;
>> +                new_key.offset += key.offset;
>> +                new_extents--;
>> +        }
>> +        btrfs_release_path(path);
>> +
>> +insert:
>> +        /* Insert the new key (cases 1-4). */
>> +        ret = btrfs_insert_empty_item(trans, root, path, &new_key, 0);
>> +        if (ret)
>> +                goto out;
>> +
>> +        btrfs_release_path(path);
>> +        ret = update_free_space_extent_count(trans, block_group, path,
>> +                                             new_extents);
>> +
>> +out:
>> +        return ret;
>> +}
>> +
>> +int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
>> +                             struct btrfs_block_group_cache *block_group,
>> +                             struct btrfs_path *path, u64 start, u64 size)
>> +{
>> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>> +	struct btrfs_free_space_info *info;
>> +	u32 flags;
>> +
>> +	info = search_free_space_info(NULL, fs_info, block_group, path, 0);
>> +	if (IS_ERR(info))
>> +	        return PTR_ERR(info);
>> +	flags = btrfs_free_space_flags(path->nodes[0], info);
>> +	btrfs_release_path(path);
>> +
>> +	if (flags & BTRFS_FREE_SPACE_USING_BITMAPS) {
>> +	        return modify_free_space_bitmap(trans, block_group, path,
>> +	                                        start, size, 0);
>> +	} else {
>> +	        return add_free_space_extent(trans, block_group, path, start,
>> +	                                     size);
>> +	}
>> +}
>> +
>> +
>> +int add_to_free_space_tree(struct btrfs_trans_handle *trans,
>> +			   u64 start, u64 size)
>> +{
>> +	struct btrfs_block_group_cache *block_group;
>> +	struct btrfs_path *path;
>> +	int ret;
>> +
>> +	if (!btrfs_fs_compat_ro(trans->fs_info, FREE_SPACE_TREE))
>> +		return 0;
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	block_group = btrfs_lookup_block_group(trans->fs_info, start);
>> +	if (!block_group) {
>> +		ASSERT(0);
>> +		ret = -ENOENT;
>> +		goto out;
>> +	}
>> +
>> +	ret = __add_to_free_space_tree(trans, block_group, path, start, size);
>> +out:
>> +	btrfs_free_path(path);
>> +	if (ret)
>> +		btrfs_abort_transaction(trans, ret);
>> +	return ret;
>> +}
>> +
>> +int populate_free_space_tree(struct btrfs_trans_handle *trans,
>> +			     struct btrfs_block_group_cache *block_group)
>> +{
>> +        struct btrfs_root *extent_root = trans->fs_info->extent_root;
>> +        struct btrfs_path *path, *path2;
>> +        struct btrfs_key key;
>> +        u64 start, end;
>> +        int ret;
>> +
>> +        path = btrfs_alloc_path();
>> +        if (!path)
>> +                return -ENOMEM;
>> +        path->reada = READA_FORWARD;
>> +
>> +        path2 = btrfs_alloc_path();
>> +        if (!path2) {
>> +                btrfs_free_path(path);
>> +                return -ENOMEM;
>> +        }
>> +
>> +        ret = add_new_free_space_info(trans, block_group, path2);
>> +        if (ret)
>> +                goto out;
>> +
>> +        /*
>> +         * Iterate through all of the extent and metadata items in this block
>> +         * group, adding the free space between them and the free space at the
>> +         * end. Note that EXTENT_ITEM and METADATA_ITEM are less than
>> +         * BLOCK_GROUP_ITEM, so an extent may precede the block group that it's
>> +         * contained in.
>> +         */
>> +        key.objectid = block_group->key.objectid;
>> +        key.type = BTRFS_EXTENT_ITEM_KEY;
>> +        key.offset = 0;
>> +
>> +        ret = btrfs_search_slot_for_read(extent_root, &key, path, 1, 0);
>> +        if (ret < 0)
>> +                goto out;
>> +        ASSERT(ret == 0);
>> +
>> +        start = block_group->key.objectid;
>> +        end = block_group->key.objectid + block_group->key.offset;
>> +        while (1) {
>> +                btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +
>> +                if (key.type == BTRFS_EXTENT_ITEM_KEY ||
>> +                    key.type == BTRFS_METADATA_ITEM_KEY) {
>> +                        if (key.objectid >= end)
>> +                                break;
>> +
>> +                        if (start < key.objectid) {
>> +                                ret = __add_to_free_space_tree(trans,
>> +                                                               block_group,
>> +                                                               path2, start,
>> +                                                               key.objectid -
>> +                                                               start);
>> +                                if (ret)
>> +                                        goto out;
>> +                        }
>> +                        start = key.objectid;
>> +                        if (key.type == BTRFS_METADATA_ITEM_KEY)
>> +                                start += trans->fs_info->nodesize;
>> +                        else
>> +                                start += key.offset;
>> +                } else if (key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
>> +                        if (key.objectid != block_group->key.objectid)
>> +                                break;
>> +                }
>> +
>> +                ret = btrfs_next_item(extent_root, path);
>> +                if (ret < 0)
>> +                        goto out;
>> +                if (ret)
>> +                        break;
>> +        }
>> +        if (start < end) {
>> +                ret = __add_to_free_space_tree(trans, block_group, path2,
>> +                                               start, end - start);
>> +                if (ret)
>> +                        goto out;
>> +        }
>> +
>> +        ret = 0;
>> +out:
>> +        btrfs_free_path(path2);
>> +        btrfs_free_path(path);
>> +        return ret;
>> +}
>> +
>> +int remove_block_group_free_space(struct btrfs_trans_handle *trans,
>> +				  struct btrfs_block_group_cache *block_group)
>> +{
>> +	struct btrfs_root *root = trans->fs_info->free_space_root;
>> +	struct btrfs_path *path;
>> +	struct btrfs_key key, found_key;
>> +	struct extent_buffer *leaf;
>> +	u64 start, end;
>> +	int done = 0, nr;
>> +	int ret;
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	start = block_group->key.objectid;
>> +	end = block_group->key.objectid + block_group->key.offset;
>> +
>> +	key.objectid = end - 1;
>> +	key.type = (u8)-1;
>> +	key.offset = (u64)-1;
>> +
>> +	while (!done) {
>> +		ret = btrfs_search_prev_slot(trans, root, &key, path, -1, 1);
>> +		if (ret)
>> +			goto out;
>> +
>> +		leaf = path->nodes[0];
>> +		nr = 0;
>> +		path->slots[0]++;
>> +		while (path->slots[0] > 0) {
>> +			btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0] - 1);
>> +
>> +			if (found_key.type == BTRFS_FREE_SPACE_INFO_KEY) {
>> +				ASSERT(found_key.objectid == block_group->key.objectid);
>> +				ASSERT(found_key.offset == block_group->key.offset);
>> +				done = 1;
>> +				nr++;
>> +				path->slots[0]--;
>> +				break;
>> +			} else if (found_key.type == BTRFS_FREE_SPACE_EXTENT_KEY ||
>> +				   found_key.type == BTRFS_FREE_SPACE_BITMAP_KEY) {
>> +				ASSERT(found_key.objectid >= start);
>> +				ASSERT(found_key.objectid < end);
>> +				ASSERT(found_key.objectid + found_key.offset <= end);
>> +				nr++;
>> +				path->slots[0]--;
>> +			} else {
>> +				ASSERT(0);
>> +			}
>> +		}
>> +
>> +		ret = btrfs_del_items(trans, root, path, path->slots[0], nr);
>> +		if (ret)
>> +			goto out;
>> +		btrfs_release_path(path);
>> +	}
>> +
>> +	ret = 0;
>> +out:
>> +	btrfs_free_path(path);
>> +	if (ret)
>> +		btrfs_abort_transaction(trans, ret);
>> +	return ret;
>> +}
>>  static int clear_free_space_tree(struct btrfs_trans_handle *trans,
>>  				 struct btrfs_root *root)
>>  {
>> @@ -204,8 +1309,8 @@ static int load_free_space_bitmaps(struct btrfs_fs_info *fs_info,
>>  
>>  		offset = key.objectid;
>>  		while (offset < key.objectid + key.offset) {
>> -			bit = free_space_test_bit(block_group, path, offset,
>> -						  fs_info->sectorsize);
>> +			bit = free_space_test_bit(block_group, path, offset);
>> +
>>  			if (prev_bit == 0 && bit == 1) {
>>  				extent_start = offset;
>>  			} else if (prev_bit == 1 && bit == 0) {
>> @@ -320,6 +1425,142 @@ static int load_free_space_extents(struct btrfs_fs_info *fs_info,
>>  	return ret;
>>  }
>>  
>> +struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
>> +                                     struct btrfs_fs_info *fs_info,
>> +                                     u64 objectid)
>> +{
>> +	struct extent_buffer *leaf;
>> +	struct btrfs_root *tree_root = fs_info->tree_root;
>> +	struct btrfs_root *root;
>> +	struct btrfs_key key;
>> +	int ret = 0;
>> +
>> +	root = kzalloc(sizeof(*root), GFP_KERNEL);
>> +	if (!root)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	btrfs_setup_root(root, fs_info, objectid);
>> +	root->root_key.objectid = objectid;
>> +	root->root_key.type = BTRFS_ROOT_ITEM_KEY;
>> +	root->root_key.offset = 0;
>> +
>> +	leaf = btrfs_alloc_free_block(trans, root, fs_info->nodesize, objectid, NULL, 0, 0, 0);
>> +	if (IS_ERR(leaf)) {
>> +		ret = PTR_ERR(leaf);
>> +		leaf = NULL;
>> +		goto fail;
>> +	}
>> +
>> +	memset_extent_buffer(leaf, 0, 0, sizeof(struct btrfs_header));
>> +	btrfs_set_header_bytenr(leaf, leaf->start);
>> +	btrfs_set_header_generation(leaf, trans->transid);
>> +	btrfs_set_header_backref_rev(leaf, BTRFS_MIXED_BACKREF_REV);
>> +	btrfs_set_header_owner(leaf, objectid);
>> +	root->node = leaf;
>> +	write_extent_buffer(leaf, fs_info->fsid, btrfs_header_fsid(), BTRFS_FSID_SIZE);
>> +	write_extent_buffer(leaf, fs_info->chunk_tree_uuid,
>> +			    btrfs_header_chunk_tree_uuid(leaf),
>> +			    BTRFS_UUID_SIZE);
>> +	btrfs_mark_buffer_dirty(leaf);
>> +
>> +	extent_buffer_get(root->node);
>> +	root->commit_root = root->node;
>> +	root->track_dirty = 1;
>> +
>> +	root->root_item.flags = 0;
>> +	root->root_item.byte_limit = 0;
>> +	btrfs_set_root_bytenr(&root->root_item, leaf->start);
>> +	btrfs_set_root_generation(&root->root_item, trans->transid);
>> +	btrfs_set_root_level(&root->root_item, 0);
>> +	btrfs_set_root_refs(&root->root_item, 1);
>> +	btrfs_set_root_used(&root->root_item, leaf->len);
>> +	btrfs_set_root_last_snapshot(&root->root_item, 0);
>> +	btrfs_set_root_dirid(&root->root_item, 0);
>> +	memset(root->root_item.uuid, 0, BTRFS_UUID_SIZE);
>> +	root->root_item.drop_level = 0;
>> +
>> +	key.objectid = objectid;
>> +	key.type = BTRFS_ROOT_ITEM_KEY;
>> +	key.offset = 0;
>> +	ret = btrfs_insert_root(trans, tree_root, &key, &root->root_item);
>> +	if (ret)
>> +		goto fail;
>> +
>> +	return root;
>> +
>> +fail:
>> +	if (leaf)
>> +		free_extent_buffer(leaf);
>> +
>> +	kfree(root);
>> +	return ERR_PTR(ret);
>> +}
>> +
>> +#define btrfs_set_fs_compat_ro(__fs_info, opt) \
>> +        __btrfs_set_fs_compat_ro((__fs_info), BTRFS_FEATURE_COMPAT_RO_##opt)
>> +
>> +static inline void __btrfs_set_fs_compat_ro(struct btrfs_fs_info *fs_info,
>> +                                            u64 flag)
>> +{
>> +	struct btrfs_super_block *disk_super;
>> +	u64 features;
>> +
>> +	disk_super = fs_info->super_copy;
>> +	features = btrfs_super_compat_ro_flags(disk_super);
>> +	if (!(features & flag)) {
>> +		features = btrfs_super_compat_ro_flags(disk_super);
>> +		if (!(features & flag)) {
>> +			features |= flag;
>> +			btrfs_set_super_compat_ro_flags(disk_super, features);
>> +		}
>> +	}
>> +}
>> +
>> +int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
>> +{
>> +	struct btrfs_trans_handle *trans;
>> +	struct btrfs_root *tree_root = fs_info->tree_root;
>> +	struct btrfs_root *free_space_root;
>> +	struct btrfs_block_group_cache *block_group;
>> +	u64 start = BTRFS_SUPER_INFO_OFFSET + BTRFS_SUPER_INFO_SIZE;
>> +	int ret;
>> +
>> +	trans = btrfs_start_transaction(tree_root, 0);
>> +	if (IS_ERR(trans))
>> +		return PTR_ERR(trans);
>> +
>> +	free_space_root = btrfs_create_tree(trans, fs_info,
>> +					    BTRFS_FREE_SPACE_TREE_OBJECTID);
>> +	if (IS_ERR(free_space_root)) {
>> +		ret = PTR_ERR(free_space_root);
>> +		goto abort;
>> +	}
>> +	fs_info->free_space_root = free_space_root;
>> +
>> +	do {
>> +		block_group = btrfs_lookup_first_block_group(fs_info, start);
>> +		if (!block_group)
>> +			break;
>> +		start = block_group->key.objectid + block_group->key.offset;
>> +		ret = populate_free_space_tree(trans, block_group);
>> +		if (ret)
>> +			goto abort;
>> +	} while (block_group);
>> +
>> +	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
>> +	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID);
>> +
>> +	ret = btrfs_commit_transaction(trans, tree_root);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return 0;
>> +
>> +abort:
>> +	btrfs_abort_transaction(trans, ret);
>> +	return ret;
>> +}
>> +
>>  int load_free_space_tree(struct btrfs_fs_info *fs_info,
>>  			 struct btrfs_block_group_cache *block_group)
>>  {
>> @@ -332,7 +1573,7 @@ int load_free_space_tree(struct btrfs_fs_info *fs_info,
>>  	path = btrfs_alloc_path();
>>  	if (!path)
>>  		return -ENOMEM;
>> -	path->reada = 1;
>> +	path->reada = READA_BACK;
>>  
>>  	info = search_free_space_info(NULL, fs_info, block_group, path, 0);
>>  	if (IS_ERR(info)) {
>> diff --git a/free-space-tree.h b/free-space-tree.h
>> index 4845f13e6808..9530c2882358 100644
>> --- a/free-space-tree.h
>> +++ b/free-space-tree.h
>> @@ -19,8 +19,19 @@
>>  #ifndef __BTRFS_FREE_SPACE_TREE_H__
>>  #define __BTRFS_FREE_SPACE_TREE_H__
>>  
>> +#define BTRFS_FREE_SPACE_BITMAP_SIZE 256
>> +#define BTRFS_FREE_SPACE_BITMAP_BITS (BTRFS_FREE_SPACE_BITMAP_SIZE * BITS_PER_BYTE)
>> +
>>  int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info);
>>  int load_free_space_tree(struct btrfs_fs_info *fs_info,
>>  			 struct btrfs_block_group_cache *block_group);
>> -
>> +int populate_free_space_tree(struct btrfs_trans_handle *trans,
>> +			     struct btrfs_block_group_cache *block_group);
>> +int remove_block_group_free_space(struct btrfs_trans_handle *trans,
>> +				  struct btrfs_block_group_cache *block_group);
>> +int add_to_free_space_tree(struct btrfs_trans_handle *trans, u64 start,
>> +			   u64 size);
>> +int remove_from_free_space_tree(struct btrfs_trans_handle *trans, u64 start,
>> +				u64 size);
>> +int btrfs_create_free_space_tree(struct btrfs_fs_info *info);
>>  #endif
>> diff --git a/kerncompat.h b/kerncompat.h
>> index 1a2bc18c3ac2..a223a7f009bd 100644
>> --- a/kerncompat.h
>> +++ b/kerncompat.h
>> @@ -263,6 +263,8 @@ static inline int IS_ERR_OR_NULL(const void *ptr)
>>  	return !ptr || IS_ERR(ptr);
>>  }
>>  
>> +#define div_u64(x, y) ((x) / (y))
>> +
>>  /**
>>   * swap - swap values of @a and @b
>>   * @a: first value
>> @@ -297,6 +299,10 @@ static inline int IS_ERR_OR_NULL(const void *ptr)
>>  #define kfree(x) free(x)
>>  #define vmalloc(x) malloc(x)
>>  #define vfree(x) free(x)
>> +#define kvzalloc(x, y) kzalloc(x,y)
>> +#define kvfree(x) free(x)
>> +#define memalloc_nofs_save() (0)
>> +#define memalloc_nofs_restore(x)
>>  
>>  #ifndef BTRFS_DISABLE_BACKTRACE
>>  static inline void assert_trace(const char *assertion, const char *filename,
>> -- 
>> 2.7.4
>>
> 
