Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:36888 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3IFNrM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Sep 2013 09:47:12 -0400
Message-ID: <5229DCDC.9080901@giantdisaster.de>
Date: Fri, 06 Sep 2013 15:47:08 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allocate the free space by the existed max extent
 size when ENOSPC
References: <1377858934-17187-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1377858934-17187-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 30 Aug 2013 18:35:34 +0800, Miao Xie wrote:
> By the current code, if the requested size is very large, and all the extents
> in the free space cache are small, we will waste lots of the cpu time to cut
> the requested size in half and search the cache again and again until it gets
> down to the size the allocator can return. In fact, we can know the max extent
> size in the cache after the first search, so we needn't cut the size in half
> repeatedly, and just use the max extent size directly. This way can save
> lots of cpu time and make the performance grow up when there are only fragments
> in the free space cache.
> 
> According to my test, if there are only 4KB free space extents in the fs,
> and the total size of those extents are 256MB, we can reduce the execute
> time of the following test from 5.4s to 1.4s.
>   dd if=/dev/zero of=<testfile> bs=1MB count=1 oflag=sync
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> Changelog v1 -> v2:
> - address the problem that we return a wrong start position when searching
>   the free space in a bitmap.
> ---
>  fs/btrfs/extent-tree.c      | 29 ++++++++++++++-------
>  fs/btrfs/free-space-cache.c | 62 +++++++++++++++++++++++++++++++--------------
>  fs/btrfs/free-space-cache.h |  5 ++--
>  3 files changed, 66 insertions(+), 30 deletions(-)

This patch makes the xfstest generic/256 lock up. It's quite reliably reproducible on one of my test boxes, and not at all visible on a second test box.

And yes, I'm using the V2 patch although you haven't tagged it as V2 in the subject line of the mail :)


# reboot
... reboot done
# cd ~/git/xfs/cmds/xfstests
# export TEST_DEV=/dev/sdc1
# export TEST_DIR=/mnt2
# export SCRATCH_DEV=/dev/sdd1
# export SCRATCH_MNT=/mnt3
# umount $TEST_DIR $SCRATCH_MNT
# mkfs.btrfs -f $TEST_DEV
# mkfs.btrfs -f $SCRATCH_DEV
# ./check generic/256
...should be finished after 20s, but it isn't, therefore after 180s:
# echo w > /proc/sysrq-trigger
root: run xfstest generic/256
SysRq : Show Blocked State
  task                        PC stack   pid father
btrfs-flush_del D 000000001a6d0000  6240 31190      2 0x00000000
 ffff880804dbfcb8 0000000000000086 ffff880804dbffd8 ffff8807ef218000
 ffff880804dbffd8 ffff880804dbffd8 ffff88080ad44520 ffff8807ef218000
 ffff880804dbfc98 ffff880784d3ca50 ffff880784d3ca18 ffff880804dbfce8
Call Trace:
 [<ffffffff81995da4>] schedule+0x24/0x60
 [<ffffffffa05235c5>] btrfs_start_ordered_extent+0x85/0x130 [btrfs]
 [<ffffffff810ac170>] ? wake_up_bit+0x40/0x40
 [<ffffffffa0523694>] btrfs_run_ordered_extent_work+0x24/0x40 [btrfs]
 [<ffffffffa0539d5f>] worker_loop+0x13f/0x5b0 [btrfs]
 [<ffffffff810b5ba3>] ? finish_task_switch+0x43/0x110
 [<ffffffff81995880>] ? __schedule+0x3f0/0x860
 [<ffffffffa0539c20>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
 [<ffffffff810abd36>] kthread+0xd6/0xe0
 [<ffffffff810e61ed>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810abc60>] ? kthread_create_on_node+0x130/0x130
 [<ffffffff8199f66c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810abc60>] ? kthread_create_on_node+0x130/0x130
xfs_io          D ffff880784d3cbc0  5008 31241  31240 0x00000000
 ffff8808036f3868 0000000000000082 ffff8808036f3fd8 ffff8807c9878000
 ffff8808036f3fd8 ffff8808036f3fd8 ffffffff82010440 ffff8807c9878000
 ffff8808036f3848 ffff880784d3cb18 ffff880784d3cb20 7fffffffffffffff
Call Trace:
 [<ffffffff81995da4>] schedule+0x24/0x60
 [<ffffffff81992dc4>] schedule_timeout+0x194/0x260
 [<ffffffff8199513a>] ? wait_for_completion+0x3a/0x110
 [<ffffffff8199513a>] ? wait_for_completion+0x3a/0x110
 [<ffffffff810e61ed>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff819951cf>] wait_for_completion+0xcf/0x110
 [<ffffffff810bb650>] ? try_to_wake_up+0x310/0x310
 [<ffffffffa0523b7a>] btrfs_wait_ordered_extents+0x1ea/0x260 [btrfs]
 [<ffffffffa0523ce5>] btrfs_wait_all_ordered_extents+0xf5/0x150 [btrfs]
 [<ffffffffa04f4b8d>] reserve_metadata_bytes+0x7bd/0xa30 [btrfs]
 [<ffffffffa04f516d>] btrfs_delalloc_reserve_metadata+0x16d/0x460 [btrfs]
 [<ffffffffa051dad6>] __btrfs_buffered_write+0x276/0x4f0 [btrfs]
 [<ffffffffa051df1a>] btrfs_file_aio_write+0x1ca/0x5a0 [btrfs]
 [<ffffffff8119a6db>] do_sync_write+0x7b/0xb0
 [<ffffffff8119b463>] vfs_write+0xc3/0x1e0
 [<ffffffff8119bad2>] SyS_pwrite64+0x92/0xb0
 [<ffffffff8199f712>] system_call_fastpath+0x16/0x1b

(gdb) list *(btrfs_start_ordered_extent+0x85)
0x4a545 is in btrfs_start_ordered_extent (fs/btrfs/ordered-data.c:747).
742              * for the flusher thread to find them
743              */
744             if (!test_bit(BTRFS_ORDERED_DIRECT, &entry->flags))
745                     filemap_fdatawrite_range(inode->i_mapping, start, end);
746             if (wait) {
747                     wait_event(entry->wait, test_bit(BTRFS_ORDERED_COMPLETE,
748                                                      &entry->flags));
749             }
750     }
751

(gdb) list *(btrfs_wait_ordered_extents+0x1ea)
0x4aafa is in btrfs_wait_ordered_extents (fs/btrfs/ordered-data.c:610).
605             list_for_each_entry_safe(ordered, next, &works, work_list) {
606                     list_del_init(&ordered->work_list);
607                     wait_for_completion(&ordered->completion);
608
609                     inode = ordered->inode;
610                     btrfs_put_ordered_extent(ordered);
611                     if (delay_iput)
612                             btrfs_add_delayed_iput(inode);
613                     else
614                             iput(inode);

# cat /proc/mounts | grep /mnt
/dev/sdc1 /mnt2 btrfs rw,relatime,ssd,space_cache 0 0
/dev/sdd1 /mnt3 btrfs rw,relatime,ssd,space_cache 0 0

# btrfs fi show
Label: none  uuid: 3dbe59c8-f4a0-4014-85f6-a6e9f5707c3a
        Total devices 1 FS bytes used 1.44GiB
        devid    1 size 1.50GiB used 1.50GiB path /dev/sdd1

Label: none  uuid: 60130e96-5fb6-4355-b81e-8113c6f5c517
        Total devices 1 FS bytes used 32.00KiB
        devid    1 size 20.00GiB used 20.00MiB path /dev/sdc1

All partitions have a size of 20971520 blocks according to fdisk:
   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048    41945087    20971520   83  Linux


With the currently pushed btrfs-next and the latest xfstests.


> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0236de7..d634dbc 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6065,10 +6065,13 @@ enum btrfs_loop_type {
>  /*
>   * walks the btree of allocated extents and find a hole of a given size.
>   * The key ins is changed to record the hole:
> - * ins->objectid == block start
> + * ins->objectid == start position
>   * ins->flags = BTRFS_EXTENT_ITEM_KEY
> - * ins->offset == number of blocks
> + * ins->offset == the size of the hole.
>   * Any available blocks before search_start are skipped.
> + *
> + * If there is no suitable free space, we will record the max size of
> + * the free space extent currently.
>   */
>  static noinline int find_free_extent(struct btrfs_trans_handle *trans,
>  				     struct btrfs_root *orig_root,
> @@ -6082,6 +6085,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
>  	struct btrfs_block_group_cache *block_group = NULL;
>  	struct btrfs_block_group_cache *used_block_group;
>  	u64 search_start = 0;
> +	u64 max_extent_size = 0;
>  	int empty_cluster = 2 * 1024 * 1024;
>  	struct btrfs_space_info *space_info;
>  	int loop = 0;
> @@ -6239,7 +6243,10 @@ have_block_group:
>  				btrfs_get_block_group(used_block_group);
>  
>  			offset = btrfs_alloc_from_cluster(used_block_group,
> -			  last_ptr, num_bytes, used_block_group->key.objectid);
> +						last_ptr,
> +						num_bytes,
> +						used_block_group->key.objectid,
> +						&max_extent_size);
>  			if (offset) {
>  				/* we have a block, we're done */
>  				spin_unlock(&last_ptr->refill_lock);
> @@ -6302,8 +6309,10 @@ refill_cluster:
>  				 * cluster
>  				 */
>  				offset = btrfs_alloc_from_cluster(block_group,
> -						  last_ptr, num_bytes,
> -						  search_start);
> +							last_ptr,
> +							num_bytes,
> +							search_start,
> +							&max_extent_size);
>  				if (offset) {
>  					/* we found one, proceed */
>  					spin_unlock(&last_ptr->refill_lock);
> @@ -6344,7 +6353,8 @@ unclustered_alloc:
>  		spin_unlock(&block_group->free_space_ctl->tree_lock);
>  
>  		offset = btrfs_find_space_for_alloc(block_group, search_start,
> -						    num_bytes, empty_size);
> +						    num_bytes, empty_size,
> +						    &max_extent_size);
>  		/*
>  		 * If we didn't find a chunk, and we haven't failed on this
>  		 * block group before, and this block group is in the middle of
> @@ -6451,7 +6461,8 @@ loop:
>  		ret = 0;
>  	}
>  out:
> -
> +	if (ret == -ENOSPC)
> +		ins->offset = max_extent_size;
>  	return ret;
>  }
>  
> @@ -6517,8 +6528,8 @@ again:
>  			       hint_byte, ins, flags);
>  
>  	if (ret == -ENOSPC) {
> -		if (!final_tried) {
> -			num_bytes = num_bytes >> 1;
> +		if (!final_tried && ins->offset) {
> +			num_bytes = min(num_bytes >> 1, ins->offset);
>  			num_bytes = round_down(num_bytes, root->sectorsize);
>  			num_bytes = max(num_bytes, min_alloc_size);
>  			if (num_bytes == min_alloc_size)
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 7517285..229c8c1 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1434,13 +1434,19 @@ static void bitmap_set_bits(struct btrfs_free_space_ctl *ctl,
>  	ctl->free_space += bytes;
>  }
>  
> +/*
> + * If we can not find suitable extent, we will use bytes to record
> + * the size of the max extent.
> + */
>  static int search_bitmap(struct btrfs_free_space_ctl *ctl,
>  			 struct btrfs_free_space *bitmap_info, u64 *offset,
>  			 u64 *bytes)
>  {
>  	unsigned long found_bits = 0;
> +	unsigned long max_bits = 0;
>  	unsigned long bits, i;
>  	unsigned long next_zero;
> +	unsigned long extent_bits;
>  
>  	i = offset_to_bit(bitmap_info->offset, ctl->unit,
>  			  max_t(u64, *offset, bitmap_info->offset));
> @@ -1449,9 +1455,12 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
>  	for_each_set_bit_from(i, bitmap_info->bitmap, BITS_PER_BITMAP) {
>  		next_zero = find_next_zero_bit(bitmap_info->bitmap,
>  					       BITS_PER_BITMAP, i);
> -		if ((next_zero - i) >= bits) {
> -			found_bits = next_zero - i;
> +		extent_bits = next_zero - i;
> +		if (extent_bits >= bits) {
> +			found_bits = extent_bits;
>  			break;
> +		} else if (extent_bits > max_bits) {
> +			max_bits = extent_bits;
>  		}
>  		i = next_zero;
>  	}
> @@ -1462,38 +1471,41 @@ static int search_bitmap(struct btrfs_free_space_ctl *ctl,
>  		return 0;
>  	}
>  
> +	*bytes = (u64)(max_bits) * ctl->unit;
>  	return -1;
>  }
>  
> +/* Cache the size of the max extent in bytes */
>  static struct btrfs_free_space *
>  find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
> -		unsigned long align)
> +		unsigned long align, u64 *max_extent_size)
>  {
>  	struct btrfs_free_space *entry;
>  	struct rb_node *node;
> -	u64 ctl_off;
>  	u64 tmp;
>  	u64 align_off;
>  	int ret;
>  
>  	if (!ctl->free_space_offset.rb_node)
> -		return NULL;
> +		goto out;
>  
>  	entry = tree_search_offset(ctl, offset_to_bitmap(ctl, *offset), 0, 1);
>  	if (!entry)
> -		return NULL;
> +		goto out;
>  
>  	for (node = &entry->offset_index; node; node = rb_next(node)) {
>  		entry = rb_entry(node, struct btrfs_free_space, offset_index);
> -		if (entry->bytes < *bytes)
> +		if (entry->bytes < *bytes) {
> +			if (entry->bytes > *max_extent_size)
> +				*max_extent_size = entry->bytes;
>  			continue;
> +		}
>  
>  		/* make sure the space returned is big enough
>  		 * to match our requested alignment
>  		 */
>  		if (*bytes >= align) {
> -			ctl_off = entry->offset - ctl->start;
> -			tmp = ctl_off + align - 1;;
> +			tmp = entry->offset - ctl->start + align - 1;
>  			do_div(tmp, align);
>  			tmp = tmp * align + ctl->start;
>  			align_off = tmp - entry->offset;
> @@ -1506,10 +1518,15 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
>  			continue;
>  
>  		if (entry->bitmap) {
> -			ret = search_bitmap(ctl, entry, &tmp, bytes);
> +			u64 size = *bytes;
> +
> +			ret = search_bitmap(ctl, entry, &tmp, &size);
>  			if (!ret) {
>  				*offset = tmp;
> +				*bytes = size;
>  				return entry;
> +			} else if (size > *max_extent_size) {
> +				*max_extent_size = size;
>  			}
>  			continue;
>  		}
> @@ -1518,7 +1535,7 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
>  		*bytes = entry->bytes - align_off;
>  		return entry;
>  	}
> -
> +out:
>  	return NULL;
>  }
>  
> @@ -2120,7 +2137,8 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
>  }
>  
>  u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
> -			       u64 offset, u64 bytes, u64 empty_size)
> +			       u64 offset, u64 bytes, u64 empty_size,
> +			       u64 *max_extent_size)
>  {
>  	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
>  	struct btrfs_free_space *entry = NULL;
> @@ -2131,7 +2149,7 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
>  
>  	spin_lock(&ctl->tree_lock);
>  	entry = find_free_space(ctl, &offset, &bytes_search,
> -				block_group->full_stripe_len);
> +				block_group->full_stripe_len, max_extent_size);
>  	if (!entry)
>  		goto out;
>  
> @@ -2141,7 +2159,6 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
>  		if (!entry->bytes)
>  			free_bitmap(ctl, entry);
>  	} else {
> -
>  		unlink_free_space(ctl, entry);
>  		align_gap_len = offset - entry->offset;
>  		align_gap = entry->offset;
> @@ -2155,7 +2172,6 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
>  		else
>  			link_free_space(ctl, entry);
>  	}
> -
>  out:
>  	spin_unlock(&ctl->tree_lock);
>  
> @@ -2210,7 +2226,8 @@ int btrfs_return_cluster_to_free_space(
>  static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
>  				   struct btrfs_free_cluster *cluster,
>  				   struct btrfs_free_space *entry,
> -				   u64 bytes, u64 min_start)
> +				   u64 bytes, u64 min_start,
> +				   u64 *max_extent_size)
>  {
>  	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
>  	int err;
> @@ -2222,8 +2239,11 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
>  	search_bytes = bytes;
>  
>  	err = search_bitmap(ctl, entry, &search_start, &search_bytes);
> -	if (err)
> +	if (err) {
> +		if (search_bytes > *max_extent_size)
> +			*max_extent_size = search_bytes;
>  		return 0;
> +	}
>  
>  	ret = search_start;
>  	__bitmap_clear_bits(ctl, entry, ret, bytes);
> @@ -2238,7 +2258,7 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
>   */
>  u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
>  			     struct btrfs_free_cluster *cluster, u64 bytes,
> -			     u64 min_start)
> +			     u64 min_start, u64 *max_extent_size)
>  {
>  	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
>  	struct btrfs_free_space *entry = NULL;
> @@ -2258,6 +2278,9 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
>  
>  	entry = rb_entry(node, struct btrfs_free_space, offset_index);
>  	while(1) {
> +		if (entry->bytes < bytes && entry->bytes > *max_extent_size)
> +			*max_extent_size = entry->bytes;
> +
>  		if (entry->bytes < bytes ||
>  		    (!entry->bitmap && entry->offset < min_start)) {
>  			node = rb_next(&entry->offset_index);
> @@ -2271,7 +2294,8 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
>  		if (entry->bitmap) {
>  			ret = btrfs_alloc_from_bitmap(block_group,
>  						      cluster, entry, bytes,
> -						      cluster->window_start);
> +						      cluster->window_start,
> +						      max_extent_size);
>  			if (ret == 0) {
>  				node = rb_next(&entry->offset_index);
>  				if (!node)
> diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
> index 894116b..a701000 100644
> --- a/fs/btrfs/free-space-cache.h
> +++ b/fs/btrfs/free-space-cache.h
> @@ -94,7 +94,8 @@ void __btrfs_remove_free_space_cache(struct btrfs_free_space_ctl *ctl);
>  void btrfs_remove_free_space_cache(struct btrfs_block_group_cache
>  				     *block_group);
>  u64 btrfs_find_space_for_alloc(struct btrfs_block_group_cache *block_group,
> -			       u64 offset, u64 bytes, u64 empty_size);
> +			       u64 offset, u64 bytes, u64 empty_size,
> +			       u64 *max_extent_size);
>  u64 btrfs_find_ino_for_alloc(struct btrfs_root *fs_root);
>  void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
>  			   u64 bytes);
> @@ -106,7 +107,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
>  void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster);
>  u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
>  			     struct btrfs_free_cluster *cluster, u64 bytes,
> -			     u64 min_start);
> +			     u64 min_start, u64 *max_extent_size);
>  int btrfs_return_cluster_to_free_space(
>  			       struct btrfs_block_group_cache *block_group,
>  			       struct btrfs_free_cluster *cluster);
> 


