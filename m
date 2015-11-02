Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6273 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751156AbbKBB7G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 20:59:06 -0500
Subject: Re: [PATCH 4/4] btrfs: qgroup: account shared subtree during snapshot
 delete
To: Mark Fasheh <mfasheh@suse.de>, <linux-btrfs@vger.kernel.org>
References: <1442952948-21389-1-git-send-email-mfasheh@suse.de>
 <1442952948-21389-5-git-send-email-mfasheh@suse.de>
CC: <jbacik@fb.com>, <clm@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5636C365.2080908@cn.fujitsu.com>
Date: Mon, 2 Nov 2015 09:59:01 +0800
MIME-Version: 1.0
In-Reply-To: <1442952948-21389-5-git-send-email-mfasheh@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2015/09/22 13:15 -0700:
> Commit 0ed4792 ('btrfs: qgroup: Switch to new extent-oriented qgroup
> mechanism.') removed our qgroup accounting during
> btrfs_drop_snapshot(). Predictably, this results in qgroup numbers
> going bad shortly after a snapshot is removed.
>
> Fix this by adding a dirty extent record when we encounter extents during
> our shared subtree walk. This effectively restores the functionality we had
> with the original shared subtree walking code in 1152651 (btrfs: qgroup:
> account shared subtrees during snapshot delete).
>
> The idea with the original patch (and this one) is that shared subtrees can
> get skipped during drop_snapshot. The shared subtree walk then allows us a
> chance to visit those extents and add them to the qgroup work for later
> processing. This ultimately makes the accounting for drop snapshot work.
>
> The new qgroup code nicely handles all the other extents during the tree
> walk via the ref dec/inc functions so we don't have to add actions beyond
> what we had originally.
>
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Hi Mark,

Despite the performance regression reported from Stefan Priebe,
there is another problem, I'll comment inlined below.

> ---
>   fs/btrfs/extent-tree.c | 41 ++++++++++++++++++++++++++++++++++-------
>   1 file changed, 34 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 3a70e6c..89be620 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7757,17 +7757,37 @@ reada:
>   }
>
>   /*
> - * TODO: Modify related function to add related node/leaf to dirty_extent_root,
> - * for later qgroup accounting.
> - *
> - * Current, this function does nothing.
> + * These may not be seen by the usual inc/dec ref code so we have to
> + * add them here.
>    */
> +static int record_one_subtree_extent(struct btrfs_trans_handle *trans,
> +				     struct btrfs_root *root, u64 bytenr,
> +				     u64 num_bytes)
> +{
> +	struct btrfs_qgroup_extent_record *qrecord;
> +	struct btrfs_delayed_ref_root *delayed_refs;
> +
> +	qrecord = kmalloc(sizeof(*qrecord), GFP_NOFS);
> +	if (!qrecord)
> +		return -ENOMEM;
> +
> +	qrecord->bytenr = bytenr;
> +	qrecord->num_bytes = num_bytes;
> +	qrecord->old_roots = NULL;
> +
> +	delayed_refs = &trans->transaction->delayed_refs;
> +	if (btrfs_qgroup_insert_dirty_extent(delayed_refs, qrecord))
> +		kfree(qrecord);

1) Unprotected dirty_extent_root.

Unfortunately, btrfs_qgroup_insert_dirty_exntet() is not protected by 
any lock/mutex.

And I'm sorry not to add comment about that.

In fact, btrfs_qgroup_insert_dirty_extent should always be used with
delayed_refs->lock hold.
Just like add_delayed_ref_head(), where every caller of 
add_delayed_ref_head() holds delayed_refs->lock.

So here you will nned to hold delayed_refs->lock.

2) Performance regression.(Reported by Stefan Priebe)

The performance regression is not caused by your codes, at least not 
completely.

It's my fault not adding enough comment for insert_dirty_extent() 
function. (just like 1, I must say I'm a bad reviewer until there is bug 
report)

As I was only expecting it called inside add_delayed_ref_head(),
and caller of add_delayed_ref_head() has judged whether qgroup is 
enabled before calling add_delayed_ref_head().

So for qgroup disabled case, insert_dirty_extent() won't ever be called.



As a result, if you want to call btrfs_qgroup_insert_dirty_extent() out 
of add_delayed_ref_head(), you will need to handle the 
delayed_refs->lock and judge whether qgroup is enabled.

BTW, if it's OK for you, you can also further improve the performance of 
qgroup by using kmem_cache for struct btrfs_qgroup_extent_record.

I assume the kmalloc() may be one performance hot spot considering the 
amount it called in qgroup enabled case.

Thanks,
Qu

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
> @@ -7790,6 +7810,10 @@ static int account_leaf_items(struct btrfs_trans_handle *trans,
>   			continue;
>
>   		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
> +
> +		ret = record_one_subtree_extent(trans, root, bytenr, num_bytes);
> +		if (ret)
> +			return ret;
>   	}
>   	return 0;
>   }
> @@ -7858,8 +7882,6 @@ static int adjust_slots_upwards(struct btrfs_root *root,
>
>   /*
>    * root_eb is the subtree root and is locked before this function is called.
> - * TODO: Modify this function to mark all (including complete shared node)
> - * to dirty_extent_root to allow it get accounted in qgroup.
>    */
>   static int account_shared_subtree(struct btrfs_trans_handle *trans,
>   				  struct btrfs_root *root,
> @@ -7937,6 +7959,11 @@ walk_down:
>   			btrfs_tree_read_lock(eb);
>   			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>   			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
> +
> +			ret = record_one_subtree_extent(trans, root, child_bytenr,
> +							root->nodesize);
> +			if (ret)
> +				goto out;
>   		}
>
>   		if (level == 0) {
>
