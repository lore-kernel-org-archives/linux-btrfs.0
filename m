Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42918 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751440AbbHQBeM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Aug 2015 21:34:12 -0400
Subject: Re: Major qgroup regression in 4.2?
To: Mark Fasheh <mfasheh@suse.de>, <linux-btrfs@vger.kernel.org>
References: <20150813231307.GA1145@wotan.suse.de>
 <20150814211448.GB1145@wotan.suse.de>
CC: <clm@fb.com>, <jbacik@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55D13A02.2050400@cn.fujitsu.com>
Date: Mon, 17 Aug 2015 09:33:54 +0800
MIME-Version: 1.0
In-Reply-To: <20150814211448.GB1145@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mark,

Thanks for pointing out the problem.
But it's already known and we didn't have a good idea to solve it yet.

BTW, the old framework won't handle it well either.
Liu Bo's testcase (btrfs/017) can easily trigger it.
So it's not a regression.

Let me explain the problem a little and then introduce the fixing plan.

[Qgroup for subvolume delete]
Here are two subvolumes, sharing the whole tree.
The whole trees are consistent with 8 tree blocks.
A B are the tree root of subv 257 and 258 respectively.
C~H are all shared by the two subvolumes.
And I is one data extent which is recorded in tree block H.


subv 257(A)    subv258(B)
    |     \       /    |
    C                  D
   / \                / \
   E F                G H
                        :
                        :
                        I

Let's assume the tree block are all in 4K size(just for easy 
calculation), and I is in 16K size.

Now qgroup info should be:
257: excl: 4K, rfer: 44K (6 shared tree block + 1 data + 1 tree root)
258: excl: 4K, rfer: 44K

If we are going to delete subvolume 258, then expected qgroup should be:
257: excl 44K, rfer 44K

Which means we need to recalculate all the reference relation of tree 
block C~H and data extent I.

[[The real problem]]
Now the real problem is, we need to mark *ALL* metadata and data extent 
of a subvolume dirty to make subvolume deletion work.
Forgot to say, that's at transaction commit time, if we really do that,
commit time consumption is not acceptable if the subvolume is huge.

Let's take a extreme example, here is a 4 level tree, with 16K block size.
All their contents are file extents.
The math will be, for 3 level nodes, 16K node can contain at most 161 slots.

161 ^ 3 = 4173281

That's the number of leaves that 3 level nodes can contain.

And for file extent, it's 53 bytes large + 9 bytes of key
So one leaf can contain at most 16283 / 62 = 262 file extents.

At last, 4 level tree can contain 4173281 * 262 = 1093399622 file extents.

This means, at the worst case, a subvolume delete will need to mark
1,093,399,622 data extent dirty at commit time.
That's definitely unacceptable, as such operation won't only happen in 
memory, but also may kick read to find the correct ref number.

And that's just 4 level case, btrfs support max to 8 level.
And I just counts the data extent, don't forget to add tree blocks.

[[Possible fix plan]]
As you can see the biggest problem is the number of child metadata/data 
extents can be quite large, it's not possible to mark them all and 
account at commit transaction time.

But the good news is, we can keep the snapshot and account them in 
several commits.
The new extent-orient accounting is quite accurate as it happens at 
commit time.

So one possible fix is, if we want to delete a subvolume, we put the 
subvolume into an orphan status, and let qgroup account to ignore that 
qgroup from then on, and mark some extent dirty in one transaction, and 
continue marking in next transaction until we mark all extents in that 
subvolume dirty.
Then free the subvolume.

That's the ideal method for both snapshot creation and deletion, but 
takes the most time.

And we need to change existing snapshot deletion routine to delay it and 
add new facility to ignore given id(s) in new_roots accounting.
Anyway, it's not an easy work and it's already there before my qgroup 
rework.

[Hot fix idea]
So far, the best and easiest method I come up with is, if we found 
qgroup is enabled and the snapshot to delete is above level 1(level 
starts from 0), then mark the QGROUP_INCONSISTENT flag to info user to 
do a rescan.


Other comments will be inlined below.

Mark Fasheh wrote on 2015/08/14 14:14 -0700:
> On Thu, Aug 13, 2015 at 04:13:08PM -0700, Mark Fasheh wrote:
>> If there *is* a plan to make this all work again, can I please hear it? The
>> comment mentions something about adding those nodes to a dirty_extent_root.
>> Why wasn't that done?
>
> Ok so I had more time to look through the changes today and came up with
> this naive patch, it simply inserts dirty extent records where we were doing
> our qgroup refs before. This passes my micro-test but I'm unclear on whether
> there's some pitfall I'm unaware of (I'm guessing there must be?). Please
> advise.
Overall neat and easy fix, but only lacks scalability.

As we are doing qgroup accounting at commit transaction time, it will 
stuck for a long time.
BTW, if we don't do it at that time, qgroup number can easily go crazy 
like the old days.

>
> Thanks,
> 	--Mark
>
> --
> Mark Fasheh
>
>
> From: Mark Fasheh <mfasheh@suse.de>
>
> btrfs: qgroup: account shared subtree during snapshot delete (again)
>
> Commit 0ed4792 ('btrfs: qgroup: Switch to new extent-oriented qgroup
> mechanism.') removed our qgroup accounting during
> btrfs_drop_snapshot(). Predictably, this results in qgroup numbers
> going bad shortly after a snapshot is removed.
>
> Fix this by adding a dirty extent record when we encounter extents
> during our shared subtree walk. This effectively restores the
> functionality we had with the original shared subtree walkign code in
> commit 1152651 (btrfs: qgroup: account shared subtrees during snapshot
> delete)
>
> This patch also moves the open coded allocation handling for
> qgroup_extent_record into their own functions.
>
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
>
> qdiff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index ac3e81d..8156f50 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -486,7 +486,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>   		qexisting = btrfs_qgroup_insert_dirty_extent(delayed_refs,
>   							     qrecord);
>   		if (qexisting)
> -			kfree(qrecord);
> +			btrfs_qgroup_free_extent_record(qrecord);
Good cleanup.

I hope it can be extracted into one standalone patch.
As the fix may still need some discussion.
>   	}
>
>   	spin_lock_init(&head_ref->lock);
> @@ -654,7 +654,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>   		goto free_ref;
>
>   	if (fs_info->quota_enabled && is_fstree(ref_root)) {
> -		record = kmalloc(sizeof(*record), GFP_NOFS);
> +		record = btrfs_qgroup_alloc_extent_record();
>   		if (!record)
>   			goto free_head_ref;
>   	}
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 07204bf..ab81135 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7756,18 +7756,31 @@ reada:
>   	wc->reada_slot = slot;
>   }
>
> -/*
> - * TODO: Modify related function to add related node/leaf to dirty_extent_root,
> - * for later qgroup accounting.
> - *
> - * Current, this function does nothing.
> - */
> +static int record_one_item(struct btrfs_trans_handle *trans, u64 bytenr,
> +			   u64 num_bytes)
> +{
> +	struct btrfs_qgroup_extent_record *qrecord = btrfs_qgroup_alloc_extent_record();
> +	struct btrfs_delayed_ref_root *delayed_refs = &trans->transaction->delayed_refs;
> +
> +	if (!qrecord)
> +		return -ENOMEM;
> +
> +	qrecord->bytenr = bytenr;
> +	qrecord->num_bytes = num_bytes;
> +	qrecord->old_roots = NULL;
> +
> +	if (btrfs_qgroup_insert_dirty_extent(delayed_refs, qrecord))
> +		btrfs_qgroup_free_extent_record(qrecord);
> +
> +	return 0;
> +}
> +
>   static int account_leaf_items(struct btrfs_trans_handle *trans,
>   			      struct btrfs_root *root,
>   			      struct extent_buffer *eb)
>   {
>   	int nr = btrfs_header_nritems(eb);
> -	int i, extent_type;
> +	int i, extent_type, ret;
>   	struct btrfs_key key;
>   	struct btrfs_file_extent_item *fi;
>   	u64 bytenr, num_bytes;
> @@ -7790,6 +7803,10 @@ static int account_leaf_items(struct btrfs_trans_handle *trans,
>   			continue;
>
>   		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
> +
> +		ret = record_one_item(trans, bytenr, num_bytes);
> +		if (ret)
> +			return ret;
>   	}
>   	return 0;
>   }
> @@ -7858,8 +7875,6 @@ static int adjust_slots_upwards(struct btrfs_root *root,
>
>   /*
>    * root_eb is the subtree root and is locked before this function is called.
> - * TODO: Modify this function to mark all (including complete shared node)
> - * to dirty_extent_root to allow it get accounted in qgroup.
>    */
>   static int account_shared_subtree(struct btrfs_trans_handle *trans,
>   				  struct btrfs_root *root,
> @@ -7937,6 +7952,11 @@ walk_down:
>   			btrfs_tree_read_lock(eb);
>   			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>   			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
> +
> +			ret = record_one_item(trans, child_bytenr,
> +					      root->nodesize);
> +			if (ret)
> +				goto out;
The problem is scalability, see the extreme case I mentioned above.
So I didn't do it at that time.

Would you please try to make a complicated and large fs, whose root 
level is 3 (debug-tree can help you to determine if it's large enough),
and do a snapshot of it.

And then delete it, to see how much time it takes to commit transaction.
So from this respect, I'd like to rescan, as when rescanning, we can 
still do other things without "stuck" transaction.

Thanks,
Qu
>   		}
>
>   		if (level == 0) {
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 8a82029..27ec405 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1452,6 +1452,17 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
>   	return ret;
>   }
>
> +struct btrfs_qgroup_extent_record *btrfs_qgroup_alloc_extent_record(void)
> +{
> +	return kmalloc(sizeof(struct btrfs_qgroup_extent_record), GFP_NOFS);
> +}
> +
> +void btrfs_qgroup_free_extent_record(struct btrfs_qgroup_extent_record *record)
> +{
> +	if (record)
> +		kfree(record);
> +}
> +
I'd like to move them into headers, as they are quite small, inline them 
should reduce the function call overhead.

Thanks,
Qu
>   struct btrfs_qgroup_extent_record
>   *btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
>   				  struct btrfs_qgroup_extent_record *record)
> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
> index 6387dcf..dfba663 100644
> --- a/fs/btrfs/qgroup.h
> +++ b/fs/btrfs/qgroup.h
> @@ -59,6 +59,9 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
>   struct btrfs_qgroup_extent_record
>   *btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
>   				  struct btrfs_qgroup_extent_record *record);
> +struct btrfs_qgroup_extent_record
> +*btrfs_qgroup_alloc_extent_record(void);
> +void btrfs_qgroup_free_extent_record(struct btrfs_qgroup_extent_record *record);
>   int
>   btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
>   			    struct btrfs_fs_info *fs_info,
>
