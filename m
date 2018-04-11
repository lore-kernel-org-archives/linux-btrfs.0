Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47948 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752095AbeDKHSL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 03:18:11 -0400
Subject: Re: [PATCH] btrfs: Fix race condition between delayed refs and
 blockgroup removal
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com, dsterba@suse.com
References: <1523430289-29145-1-git-send-email-nborisov@suse.com>
 <20180411070952.GA29155@vader>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0ddf511f-5690-a24d-94e7-d5d2bd48b759@suse.com>
Date: Wed, 11 Apr 2018 10:18:08 +0300
MIME-Version: 1.0
In-Reply-To: <20180411070952.GA29155@vader>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.04.2018 10:09, Omar Sandoval wrote:
> On Wed, Apr 11, 2018 at 10:04:49AM +0300, Nikolay Borisov wrote:
>> When the delayed refs for a head are all run, eventually
>> cleanup_ref_head is called which (in case of deletion) obtains a
>> reference for the relevant btrfs_space_info struct by querying the bg
>> for the range. This is problematic because when the last extent of a
>> bg is deleted a race window emerges between removal of that bg and the
>> subsequent invocation of cleanup_ref_head. This can result in cache being null
>> and either a null pointer dereference or assertion failure.
>>
>> 	task: ffff8d04d31ed080 task.stack: ffff9e5dc10cc000
>> 	RIP: 0010:assfail.constprop.78+0x18/0x1a [btrfs]
>> 	RSP: 0018:ffff9e5dc10cfbe8 EFLAGS: 00010292
>> 	RAX: 0000000000000044 RBX: 0000000000000000 RCX: 0000000000000000
>> 	RDX: ffff8d04ffc1f868 RSI: ffff8d04ffc178c8 RDI: ffff8d04ffc178c8
>> 	RBP: ffff8d04d29e5ea0 R08: 00000000000001f0 R09: 0000000000000001
>> 	R10: ffff9e5dc0507d58 R11: 0000000000000001 R12: ffff8d04d29e5ea0
>> 	R13: ffff8d04d29e5f08 R14: ffff8d04efe29b40 R15: ffff8d04efe203e0
>> 	FS:  00007fbf58ead500(0000) GS:ffff8d04ffc00000(0000) knlGS:0000000000000000
>> 	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> 	CR2: 00007fe6c6975648 CR3: 0000000013b2a000 CR4: 00000000000006f0
>> 	DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> 	DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> 	Call Trace:
>> 	 __btrfs_run_delayed_refs+0x10e7/0x12c0 [btrfs]
>> 	 btrfs_run_delayed_refs+0x68/0x250 [btrfs]
>> 	 btrfs_should_end_transaction+0x42/0x60 [btrfs]
>> 	 btrfs_truncate_inode_items+0xaac/0xfc0 [btrfs]
>> 	 btrfs_evict_inode+0x4c6/0x5c0 [btrfs]
>> 	 evict+0xc6/0x190
>> 	 do_unlinkat+0x19c/0x300
>> 	 do_syscall_64+0x74/0x140
>> 	 entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>> 	RIP: 0033:0x7fbf589c57a7
>>
>> To fix this, introduce a new flag "is_system" to head_ref structs,
>> which is populated at insertion time. This allows to decouple the
>> querying for the spaceinfo from querying the possibly deleted bg.
>>
>> Fixes: d7eae3403f46 ("Btrfs: rework delayed ref total_bytes_pinned accounting")
>> Suggested-by: Omar Sandoval <osandov@osandov.com>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  fs/btrfs/delayed-ref.c | 19 ++++++++++++++-----
>>  fs/btrfs/delayed-ref.h |  1 +
>>  fs/btrfs/extent-tree.c | 20 +++++++++++++++-----
>>  3 files changed, 30 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index 5ac2d7909782..20fa7b4c132d 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -550,8 +550,10 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>>  		     struct btrfs_delayed_ref_head *head_ref,
>>  		     struct btrfs_qgroup_extent_record *qrecord,
>>  		     u64 bytenr, u64 num_bytes, u64 ref_root, u64 reserved,
>> -		     int action, int is_data, int *qrecord_inserted_ret,
>> +		     int action, int is_data, int is_system,
>> +		     int *qrecord_inserted_ret,
>>  		     int *old_ref_mod, int *new_ref_mod)
>> +
>>  {
>>  	struct btrfs_delayed_ref_head *existing;
>>  	struct btrfs_delayed_ref_root *delayed_refs;
>> @@ -595,6 +597,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>>  	head_ref->ref_mod = count_mod;
>>  	head_ref->must_insert_reserved = must_insert_reserved;
>>  	head_ref->is_data = is_data;
>> +	head_ref->is_system = is_system;
>>  	head_ref->ref_tree = RB_ROOT;
>>  	INIT_LIST_HEAD(&head_ref->ref_add_list);
>>  	RB_CLEAR_NODE(&head_ref->href_node);
>> @@ -782,6 +785,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>>  	struct btrfs_delayed_ref_root *delayed_refs;
>>  	struct btrfs_qgroup_extent_record *record = NULL;
>>  	int qrecord_inserted;
>> +	int is_system = ref_root == BTRFS_CHUNK_TREE_OBJECTID;
>>  
>>  	BUG_ON(extent_op && extent_op->is_data);
>>  	ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
>> @@ -810,8 +814,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>>  	 */
>>  	head_ref = add_delayed_ref_head(fs_info, trans, head_ref, record,
>>  					bytenr, num_bytes, 0, 0, action, 0,
>> -					&qrecord_inserted, old_ref_mod,
>> -					new_ref_mod);
>> +					is_system, &qrecord_inserted,
>> +					old_ref_mod, new_ref_mod);
>>  
>>  	add_delayed_tree_ref(fs_info, trans, head_ref, &ref->node, bytenr,
>>  			     num_bytes, parent, ref_root, level, action);
>> @@ -878,7 +882,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>>  	 */
>>  	head_ref = add_delayed_ref_head(fs_info, trans, head_ref, record,
>>  					bytenr, num_bytes, ref_root, reserved,
>> -					action, 1, &qrecord_inserted,
>> +					action, 1, 0,  &qrecord_inserted,
>>  					old_ref_mod, new_ref_mod);
>>  
>>  	add_delayed_data_ref(fs_info, trans, head_ref, &ref->node, bytenr,
>> @@ -908,9 +912,14 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
>>  	delayed_refs = &trans->transaction->delayed_refs;
>>  	spin_lock(&delayed_refs->lock);
>>  
>> +	/*
>> +	 * extent_ops just modify the flags of an extent and they don't result
>> +	 * in ref count changes, hence it's safe to pass false/0 for is_system
>> +	 * argument
>> +	 */
>>  	add_delayed_ref_head(fs_info, trans, head_ref, NULL, bytenr,
>>  			     num_bytes, 0, 0, BTRFS_UPDATE_DELAYED_HEAD,
>> -			     extent_op->is_data, NULL, NULL, NULL);
>> +			     extent_op->is_data, 0, NULL, NULL, NULL);
>>  
>>  	spin_unlock(&delayed_refs->lock);
>>  	return 0;
>> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
>> index cdf4a94ce5c1..7e7bf4e66d48 100644
>> --- a/fs/btrfs/delayed-ref.h
>> +++ b/fs/btrfs/delayed-ref.h
>> @@ -139,6 +139,7 @@ struct btrfs_delayed_ref_head {
>>  	 */
>>  	unsigned int must_insert_reserved:1;
>>  	unsigned int is_data:1;
>> +	unsigned int is_system:1;
>>  	unsigned int processing:1;
>>  };
>>  
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 9a05e5b5089f..ba3468a84f57 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -2616,13 +2616,23 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>>  	trace_run_delayed_ref_head(fs_info, head, 0);
>>  
>>  	if (head->total_ref_mod < 0) {
>> -		struct btrfs_block_group_cache *cache;
>> +		struct btrfs_space_info *space_info;
>>  
>> -		cache = btrfs_lookup_block_group(fs_info, head->bytenr);
>> -		ASSERT(cache);
>> -		percpu_counter_add(&cache->space_info->total_bytes_pinned,
>> +		if (head->is_data) {
>> +			space_info = __find_space_info(fs_info,
>> +						       BTRFS_BLOCK_GROUP_DATA);
>> +		} else {
>> +			if (head->is_system) {
>> +				space_info = __find_space_info(fs_info,
>> +						BTRFS_BLOCK_GROUP_SYSTEM);
>> +			} else {
>> +				space_info = __find_space_info(fs_info,
>> +						BTRFS_BLOCK_GROUP_METADATA);
>> +			}
> 
> Could you collapse the nested if/else into a big if (head->is_data) else
> if (head->is_system) else?
> 
> Were you able to reproduce this on demand?

I wasn't. The problem is that even if the last extent in a bg is deleted
but the delayed refs are run from the helper thread and not directly
from truncate_inode_items it seems that this is not triggerable. And I
couldn't figure out why delayed refs weren't being run straight from
that function (That code is a mess btw butI have some pending cleanups
in that area).

> 
> Besides that,
> 
> Reviewed-by: Omar Sandoval <osandov@fb.com>
> 
> Thanks for fixing this!
> 
>> +		}
>> +		ASSERT(space_info);
>> +		percpu_counter_add(&space_info->total_bytes_pinned,
>>  				   -head->num_bytes);
>> -		btrfs_put_block_group(cache);
>>  
>>  		if (head->is_data) {
>>  			spin_lock(&delayed_refs->lock);
>> -- 
>> 2.7.4
>>
> 
