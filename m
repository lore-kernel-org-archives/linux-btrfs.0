Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935174AbeBMNVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 08:21:45 -0500
Subject: Re: [PATCH] btrfs: Verify extent allocated by find_free_extent()
 won't overlap with extents from previous transaction
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180213011332.13287-1-wqu@suse.com>
 <505e5ab3-f520-64a8-f502-0031fa40bdca@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <969486de-44f6-847a-67b7-d65354b67226@suse.com>
Date: Tue, 13 Feb 2018 15:21:41 +0200
MIME-Version: 1.0
In-Reply-To: <505e5ab3-f520-64a8-f502-0031fa40bdca@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.02.2018 13:07, Qu Wenruo wrote:
> 
> 
> On 2018年02月13日 09:13, Qu Wenruo wrote:
>> There are reports in mail list, even with latest mainline kernel, btrfs
>> can't survive a power loss.
>>
>> Unlike journal based filesystem, btrfs doesn't use journal for such
>> work. (log tree is an optimization for fsync, not to keep fs healthy)
>> In btrfs we use metadata CoW to ensure all tree blocks are as atomic as
>> superblock.
>>
>> This leads to an obvious assumption, some code breaks such metadata CoW
>> makes btrfs no longer bullet-proof against power loss.
>>
>> This patch adds extra runtime selftest to find_free_extent(), which
>> will check the range in commit root of extent tree to ensure there is no
>> overlap at all.
>>
>> And hopes this could help us to catch the cause of the problem.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Unfortunately, no new problem exposed yet.
> 
> Interestingly, I hit a bug during looping xfstest, where
> btrfs_free_path() in check_extent_conflicts() caused rcu error.
> 
> This seems quite interesting and may be the clue to the problem.
> 
> BTW, for anyone interesting with this problem, the backtrace is:
> 
> ODEBUG: activate active (active state 1) object type: rcu_head hint:
>       (null)
> WARNING: CPU: 2 PID: 15435 at lib/debugobjects.c:291
> debug_print_object+0xc1/0xe0
> Modules linked in: dm_flakey ext4 mbcache jbd2 btrfs(O) xor
> zstd_decompress zstd_compress xxhash raid6_pq efivarfs xfs dm_mod
> virtio_scsi
> CPU: 2 PID: 15435 Comm: kworker/u16:12 Tainted: G           O
> 4.15.0+ #32
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> Workqueue: writeback wb_workfn (flush-btrfs-367)
> RIP: 0010:debug_print_object+0xc1/0xe0
> RSP: 0018:ffff88001819d1c0 EFLAGS: 00010086
> RAX: dffffc0000000008 RBX: 0000000000000003 RCX: 0000000000000006
> RDX: 0000000000000007 RSI: 1ffff10003033a01 RDI: ffff88006abde6d0
> RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000001
> R10: ffff88001819d0b0 R11: 0000000000000000 R12: ffffffff82472120
> R13: ffffffff8255cae0 R14: 0000000000000000 R15: ffff880054737268
> FS:  0000000000000000(0000) GS:ffff88006aa00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f5e42c8d6c0 CR3: 00000000608aa000 CR4: 00000000003406e0
> Call Trace:
>  debug_object_activate+0x309/0x360

Can you get a line number of that function? So in release_extent_buffer
you call_rcu which calls debug_rc_head_queue in __call_rcu. So what
those debug checks are supposed to do (I haven't looked too deeply into
the code) seems to be to detect if we are doing double free i.e. calling
call_rcu twice for the same extent buffer.

Looking at debug_object_activate it seems there are 2 cases where we can
print the ODEBUG stuff if the object is already in STATE_ACTIVE and if
the object has been free i.e state ODEBUG_STATE_DESTROYED. However
judging by the "activate active" I'd say we hit the ODEBUG_STATE_ACTIV
case. And since we don't have a ->fixup_activate function then we should
return -EINVAL and the following WARN_ONCE should be triggered:

WARN_ONCE(1, "__call_rcu(): Double-freed CB %p->%pF()!!!\n",
                          head, head->func);



>  __call_rcu.constprop.72+0x135/0xc50
>  release_extent_buffer+0xf0/0x280 [btrfs]
>  free_extent_buffer+0x16d/0x210 [btrfs]
>  btrfs_release_path+0x2d/0xe0 [btrfs]
>  btrfs_free_path.part.28+0xe/0x30 [btrfs]
>  find_free_extent+0x1082/0x2440 [btrfs]
>  btrfs_reserve_extent+0xda/0x1f0 [btrfs]
>  cow_file_range.isra.67+0x223/0x5d0 [btrfs]
>  run_delalloc_range+0x1cc/0x610 [btrfs]
>  writepage_delalloc+0x1bb/0x2c0 [btrfs]
>  __extent_writepage+0x422/0x630 [btrfs]
>  extent_write_cache_pages.constprop.56+0x2f7/0x7b0 [btrfs]
>  extent_writepages+0xce/0x110 [btrfs]
>  do_writepages+0x8e/0xb0
>  __writeback_single_inode+0x155/0xbf0
>  writeback_sb_inodes+0x462/0x8e0
>  wb_writeback+0x313/0x970
>  wb_workfn+0x217/0xc80
>  process_one_work+0x740/0xe40
>  worker_thread+0x1c6/0xce0
>  kthread+0x1ba/0x1e0
>  ret_from_fork+0x24/0x30
> 
> Thanks,
> Qu
> 
>> ---
>>  fs/btrfs/extent-tree.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 118 insertions(+)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 2f4328511ac8..3b3cd82bce3a 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7458,6 +7458,114 @@ btrfs_release_block_group(struct btrfs_block_group_cache *cache,
>>  	btrfs_put_block_group(cache);
>>  }
>>  
>> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>> +/*
>> + * Verify if the given extent range [@start, @start + @len) conflicts any
>> + * existing extent in commit root.
>> + *
>> + * Btrfs doesn't use journal, but depends on metadata (and data) CoW to keep
>> + * the whole filesystem consistent against powerloss.
>> + * If we have overwritten any extent used by previous trans (commit root),
>> + * and powerloss happen we will corrupt our filesystem.
>> + *
>> + * Return 0 if nothing wrong.
>> + * Return <0 (including ENOMEM) means we have something wrong.
>> + * Except NOEMEM, this normally means we have extent conflicts with previous
>> + * transaction.
>> + */
>> +static int check_extent_conflicts(struct btrfs_fs_info *fs_info,
>> +				  u64 start, u64 len)
>> +{
>> +	struct btrfs_key key;
>> +	struct btrfs_path *path;
>> +	struct btrfs_root *extent_root = fs_info->extent_root;
>> +	u64 extent_start;
>> +	u64 extent_len;
>> +	int ret;
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path)
>> +		return -ENOMEM;
>> +
>> +
>> +	key.objectid = start + len;
>> +	key.type = 0;
>> +	key.offset = 0;
>> +
>> +	/*
>> +	 * Here we use extent commit root to search for any conflicts.
>> +	 * If extent commit tree is already overwritten, we will get transid
>> +	 * error and error out any way.
>> +	 * If extent commit tree is OK, but other extent conflicts, we will
>> +	 * find it.
>> +	 * So anyway, such search should be OK to find the conflicts.
>> +	 */
>> +	path->search_commit_root = true;
>> +	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
>> +
>> +	if (ret < 0)
>> +		goto out;
>> +	/* Impossible as no type/offset should be (u64)-1 */
>> +	if (ret == 0) {
>> +		ret = -EUCLEAN;
>> +		goto out;
>> +	}
>> +	ret = btrfs_previous_extent_item(extent_root, path, start);
>> +	if (ret < 0)
>> +		goto out;
>> +	if (ret == 0) {
>> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +		extent_start = key.objectid;
>> +		if (key.type == BTRFS_EXTENT_ITEM_KEY)
>> +			extent_len = key.offset;
>> +		else
>> +			extent_len = fs_info->nodesize;
>> +		goto report;
>> +	}
>> +	/*
>> +	 * Even we didn't found extent starts after @start, we still need to
>> +	 * ensure previous extent doesn't overlap with [@start, @start + @len)
>> +	 */
>> +	while (1) {
>> +		extent_len = 0;
>> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +		if (key.type == BTRFS_EXTENT_ITEM_KEY)
>> +			extent_len = key.offset;
>> +		else if (key.type == BTRFS_METADATA_ITEM_KEY)
>> +			extent_len = fs_info->nodesize;
>> +
>> +		if (extent_len) {
>> +			if (extent_len + key.objectid <= start) {
>> +				ret = 0;
>> +				goto out;
>> +			}
>> +			extent_start = key.objectid;
>> +			goto report;
>> +		}
>> +		if (path->slots[0] == 0) {
>> +			ret = btrfs_prev_leaf(extent_root, path);
>> +			if (ret > 0) {
>> +				ret = 0;
>> +				goto out;
>> +			}
>> +			if (ret < 0)
>> +				goto out;
>> +		} else {
>> +			path->slots[0]--;
>> +		}
>> +	}
>> +out:
>> +	btrfs_free_path(path);
>> +	return ret;
>> +report:
>> +	WARN(1,
>> +"broken CoW detected: old extent [%llu, %llu) new extent [%llu, %llu)\n",
>> +	     extent_start, extent_start + extent_len, start, start + len);
>> +	btrfs_free_path(path);
>> +	return -EEXIST;
>> +}
>> +#endif
>> +
>>  /*
>>   * walks the btree of allocated extents and find a hole of a given size.
>>   * The key ins is changed to record the hole:
>> @@ -7949,6 +8057,16 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>>  		spin_unlock(&space_info->lock);
>>  		ins->offset = max_extent_size;
>>  	}
>> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>> +	if (!ret) {
>> +		/*
>> +		 * Any extent allocated must not conflict with any extent in
>> +		 * commit root
>> +		 */
>> +		ret = check_extent_conflicts(fs_info, ins->objectid,
>> +					     ins->offset);
>> +	}
>> +#endif
>>  	return ret;
>>  }
>>  
>>
> 
