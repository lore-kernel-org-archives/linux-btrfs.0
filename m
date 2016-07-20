Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37718 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbcGTNfY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jul 2016 09:35:24 -0400
Subject: Re: [PATCH 4/4] btrfs: update btrfs_space_info's bytes_may_use timely
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <20160720055637.7275-1-wangxg.fnst@cn.fujitsu.com>
 <20160720055637.7275-5-wangxg.fnst@cn.fujitsu.com>
CC: <dsterba@suse.cz>, <holger@applied-asynchrony.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <8e602903-3e20-fa6c-3d00-4c22519d66e1@fb.com>
Date: Wed, 20 Jul 2016 09:35:05 -0400
MIME-Version: 1.0
In-Reply-To: <20160720055637.7275-5-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/2016 01:56 AM, Wang Xiaoguang wrote:
> This patch can fix some false ENOSPC errors, below test script can
> reproduce one false ENOSPC error:
> 	#!/bin/bash
> 	dd if=/dev/zero of=fs.img bs=$((1024*1024)) count=128
> 	dev=$(losetup --show -f fs.img)
> 	mkfs.btrfs -f -M $dev
> 	mkdir /tmp/mntpoint
> 	mount $dev /tmp/mntpoint
> 	cd /tmp/mntpoint
> 	xfs_io -f -c "falloc 0 $((64*1024*1024))" testfile
>
> Above script will fail for ENOSPC reason, but indeed fs still has free
> space to satisfy this request. Please see call graph:
> btrfs_fallocate()
> |-> btrfs_alloc_data_chunk_ondemand()
> |   bytes_may_use += 64M
> |-> btrfs_prealloc_file_range()
>     |-> btrfs_reserve_extent()
>         |-> btrfs_add_reserved_bytes()
>         |   alloc_type is RESERVE_ALLOC_NO_ACCOUNT, so it does not
>         |   change bytes_may_use, and bytes_reserved += 64M. Now
>         |   bytes_may_use + bytes_reserved == 128M, which is greater
>         |   than btrfs_space_info's total_bytes, false enospc occurs.
>         |   Note, the bytes_may_use decrease operation will done in
>         |   end of btrfs_fallocate(), which is too late.
>
> Here is another simple case for buffered write:
>                     CPU 1              |              CPU 2
>                                        |
> |-> cow_file_range()                   |-> __btrfs_buffered_write()
>     |-> btrfs_reserve_extent()         |   |
>     |                                  |   |
>     |                                  |   |
>     |    .....                         |   |-> btrfs_check_data_free_space()
>     |                                  |
>     |                                  |
>     |-> extent_clear_unlock_delalloc() |
>
> In CPU 1, btrfs_reserve_extent()->find_free_extent()->
> btrfs_add_reserved_bytes() do not decrease bytes_may_use, the decrease
> operation will be delayed to be done in extent_clear_unlock_delalloc().
> Assume in this case, btrfs_reserve_extent() reserved 128MB data, CPU2's
> btrfs_check_data_free_space() tries to reserve 100MB data space.
> If
> 	100MB > data_sinfo->total_bytes - data_sinfo->bytes_used -
> 		data_sinfo->bytes_reserved - data_sinfo->bytes_pinned -
> 		data_sinfo->bytes_readonly - data_sinfo->bytes_may_use
> btrfs_check_data_free_space() will try to allcate new data chunk or call
> btrfs_start_delalloc_roots(), or commit current transaction inorder to
> reserve some free space, obviously a lot of work. But indeed it's not
> necessary as long as decreasing bytes_may_use timely, we still have
> free space, decreasing 128M from bytes_may_use.
>
> To fix this issue, this patch chooses to update bytes_may_use for both
> data and metadata in btrfs_add_reserved_bytes(). For compress path, real
> extent length may not be equal to file content length, so introduce a
> ram_bytes argument for btrfs_reserve_extent(), find_free_extent() and
> btrfs_add_reserved_bytes(), it's becasue bytes_may_use is increased by
> file content length. Then compress path can update bytes_may_use
> correctly. Also now we can discard RESERVE_ALLOC_NO_ACCOUNT, RESERVE_ALLOC
> and RESERVE_FREE.
>
> For inode marked as NODATACOW or extent marked as PREALLOC, we can
> directly call btrfs_free_reserved_data_space() to adjust bytes_may_use.
>
> Meanwhile __btrfs_prealloc_file_range() will call
> btrfs_free_reserved_data_space() internally for both sucessful and failed
> path, btrfs_prealloc_file_range()'s callers does not need to call
> btrfs_free_reserved_data_space() any more.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/ctree.h       |  2 +-
>  fs/btrfs/extent-tree.c | 56 +++++++++++++++++---------------------------------
>  fs/btrfs/file.c        | 26 +++++++++++++----------
>  fs/btrfs/inode-map.c   |  3 +--
>  fs/btrfs/inode.c       | 37 ++++++++++++++++++++++++---------
>  fs/btrfs/relocation.c  | 11 ++++++++--
>  6 files changed, 72 insertions(+), 63 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 4274a7b..7eb2913 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2556,7 +2556,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
>  				   struct btrfs_root *root,
>  				   u64 root_objectid, u64 owner, u64 offset,
>  				   struct btrfs_key *ins);
> -int btrfs_reserve_extent(struct btrfs_root *root, u64 num_bytes,
> +int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes, u64 num_bytes,
>  			 u64 min_alloc_size, u64 empty_size, u64 hint_byte,
>  			 struct btrfs_key *ins, int is_data, int delalloc);
>  int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 8eaac39..5447973 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -60,21 +60,6 @@ enum {
>  	CHUNK_ALLOC_FORCE = 2,
>  };
>
> -/*
> - * Control how reservations are dealt with.
> - *
> - * RESERVE_FREE - freeing a reservation.
> - * RESERVE_ALLOC - allocating space and we need to update bytes_may_use for
> - *   ENOSPC accounting
> - * RESERVE_ALLOC_NO_ACCOUNT - allocating space and we should not update
> - *   bytes_may_use as the ENOSPC accounting is done elsewhere
> - */
> -enum {
> -	RESERVE_FREE = 0,
> -	RESERVE_ALLOC = 1,
> -	RESERVE_ALLOC_NO_ACCOUNT = 2,
> -};
> -
>  static int update_block_group(struct btrfs_trans_handle *trans,
>  			      struct btrfs_root *root, u64 bytenr,
>  			      u64 num_bytes, int alloc);
> @@ -105,7 +90,7 @@ static int find_next_key(struct btrfs_path *path, int level,
>  static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
>  			    int dump_block_groups);
>  static int btrfs_add_reserved_bytes(struct btrfs_block_group_cache *cache,
> -				    u64 num_bytes, int reserve, int delalloc);
> +				    u64 ram_bytes, u64 num_bytes, int delalloc);
>  static int btrfs_free_reserved_bytes(struct btrfs_block_group_cache *cache,
>  				     u64 num_bytes, int delalloc);
>  static int block_rsv_use_bytes(struct btrfs_block_rsv *block_rsv,
> @@ -3491,7 +3476,6 @@ again:
>  		dcs = BTRFS_DC_SETUP;
>  	else if (ret == -ENOSPC)
>  		set_bit(BTRFS_TRANS_CACHE_ENOSPC, &trans->transaction->flags);
> -	btrfs_free_reserved_data_space(inode, 0, num_pages);
>
>  out_put:
>  	iput(inode);
> @@ -6300,8 +6284,9 @@ void btrfs_wait_block_group_reservations(struct btrfs_block_group_cache *bg)
>  /**
>   * btrfs_add_reserved_bytes - update the block_group and space info counters
>   * @cache:	The cache we are manipulating
> + * @ram_bytes:  The number of bytes of file content, and will be same to
> + *              @num_bytes except for the compress path.
>   * @num_bytes:	The number of bytes in question
> - * @reserve:	One of the reservation enums
>   * @delalloc:   The blocks are allocated for the delalloc write
>   *
>   * This is called by the allocator when it reserves space. Metadata
> @@ -6316,7 +6301,7 @@ void btrfs_wait_block_group_reservations(struct btrfs_block_group_cache *bg)
>   * succeeds.
>   */
>  static int btrfs_add_reserved_bytes(struct btrfs_block_group_cache *cache,
> -				    u64 num_bytes, int reserve, int delalloc)
> +				    u64 ram_bytes, u64 num_bytes, int delalloc)
>  {
>  	struct btrfs_space_info *space_info = cache->space_info;
>  	int ret = 0;
> @@ -6328,13 +6313,11 @@ static int btrfs_add_reserved_bytes(struct btrfs_block_group_cache *cache,
>  	} else {
>  		cache->reserved += num_bytes;
>  		space_info->bytes_reserved += num_bytes;
> -		if (reserve == RESERVE_ALLOC) {
> -			trace_btrfs_space_reservation(cache->fs_info,
> -					"space_info", space_info->flags,
> -					num_bytes, 0);
> -			space_info->bytes_may_use -= num_bytes;
> -		}
>
> +		trace_btrfs_space_reservation(cache->fs_info,
> +				"space_info", space_info->flags,
> +				num_bytes, 0);

This needs to be ram_bytes to keep the accounting consistent for tools that use 
these tracepoints.  Thanks,

Josef
