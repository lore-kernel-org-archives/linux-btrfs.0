Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:46812 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab3DXPUz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 11:20:55 -0400
Message-ID: <5177F83E.20003@jan-o-sch.net>
Date: Wed, 24 Apr 2013 17:20:30 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        wangshilong1991@gmail.com, dsterba@suse.cz
Subject: Re: [PATCH v3 2/3] Btrfs: rescan for qgroups
References: <1366716411-9750-1-git-send-email-list.btrfs@jan-o-sch.net> <1366716411-9750-3-git-send-email-list.btrfs@jan-o-sch.net> <5177BB51.8030400@cn.fujitsu.com>
In-Reply-To: <5177BB51.8030400@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, April 24, 2013 at 13:00 (+0200), Wang Shilong wrote:
> Hello Jan,
> 
> [snip]
> 
>> +/*
>> + * returns < 0 on error, 0 when more leafs are to be scanned.
>> + * returns 1 when done, 2 when done and FLAG_INCONSISTENT was cleared.
>> + */
>> +static int
>> +qgroup_rescan_leaf(struct qgroup_rescan *qscan, struct btrfs_path *path,
>> +		   struct btrfs_trans_handle *trans, struct ulist *tmp,
>> +		   struct extent_buffer *scratch_leaf)
>> +{
>> +	struct btrfs_key found;
>> +	struct btrfs_fs_info *fs_info = qscan->fs_info;
>> +	struct ulist *roots = NULL;
>> +	struct ulist_node *unode;
>> +	struct ulist_iterator uiter;
>> +	struct seq_list tree_mod_seq_elem = {};
>> +	u64 seq;
>> +	int slot;
>> +	int ret;
>> +
>> +	path->leave_spinning = 1;
>> +	mutex_lock(&fs_info->qgroup_rescan_lock);
>> +	ret = btrfs_search_slot_for_read(fs_info->extent_root,
>> +					 &fs_info->qgroup_rescan_progress,
>> +					 path, 1, 0);
>> +
>> +	pr_debug("current progress key (%llu %u %llu), search_slot ret %d\n",
>> +		 (unsigned long long)fs_info->qgroup_rescan_progress.objectid,
>> +		 fs_info->qgroup_rescan_progress.type,
>> +		 (unsigned long long)fs_info->qgroup_rescan_progress.offset,
>> +		 ret);
>> +
>> +	if (ret) {
>> +		/*
>> +		 * The rescan is about to end, we will not be scanning any
>> +		 * further blocks. We cannot unset the RESCAN flag here, because
>> +		 * we want to commit the transaction if everything went well.
>> +		 * To make the live accounting work in this phase, we set our
>> +		 * scan progress pointer such that every real extent objectid
>> +		 * will be smaller.
>> +		 */
>> +		fs_info->qgroup_rescan_progress.objectid = (u64)-1;
>> +		btrfs_release_path(path);
>> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +		return ret;
>> +	}
>> +
>> +	btrfs_item_key_to_cpu(path->nodes[0], &found,
>> +			      btrfs_header_nritems(path->nodes[0]) - 1);
>> +	fs_info->qgroup_rescan_progress.objectid = found.objectid + 1;
>> +
>> +	btrfs_get_tree_mod_seq(fs_info, &tree_mod_seq_elem);
>> +	memcpy(scratch_leaf, path->nodes[0], sizeof(*scratch_leaf));
>> +	slot = path->slots[0];
>> +	btrfs_release_path(path);
>> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +
>> +	for (; slot < btrfs_header_nritems(scratch_leaf); ++slot) {
>> +		btrfs_item_key_to_cpu(scratch_leaf, &found, slot);
>> +		if (found.type != BTRFS_EXTENT_ITEM_KEY)
>> +			continue;
>> +		ret = btrfs_find_all_roots(trans, fs_info, found.objectid,
>> +					   tree_mod_seq_elem.seq, &roots);
>> +		if (ret < 0)
>> +			break;
>> +		spin_lock(&fs_info->qgroup_lock);
>> +		seq = fs_info->qgroup_seq;
>> +		fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
>> +
>> +		ulist_reinit(tmp);
>> +		ULIST_ITER_INIT(&uiter);
>> +		while ((unode = ulist_next(roots, &uiter))) {
>> +			struct btrfs_qgroup *qg;
>> +
>> +			qg = find_qgroup_rb(fs_info, unode->val);
>> +			if (!qg)
>> +				continue;
>> +
>> +			ret = ulist_add(tmp, qg->qgroupid, (uintptr_t)qg,
>> +					GFP_ATOMIC);
>> +			if (ret < 0) {
>> +				spin_unlock(&fs_info->qgroup_lock);
>> +				goto out;
>> +			}
>> +		}
>> +
>> +		/* this is similar to step 2 of btrfs_qgroup_account_ref */
>> +		ULIST_ITER_INIT(&uiter);
>> +		while ((unode = ulist_next(tmp, &uiter))) {
>> +			struct btrfs_qgroup *qg;
>> +			struct btrfs_qgroup_list *glist;
>> +
>> +			qg = (struct btrfs_qgroup *)(uintptr_t) unode->aux;
>> +			qg->rfer += found.offset;
>> +			qg->rfer_cmpr += found.offset;
>> +			WARN_ON(qg->tag >= seq);
>> +			WARN_ON(qg->refcnt >= seq);
>> +			if (qg->refcnt < seq)
>> +				qg->refcnt = seq + 1;
>> +			else
>> +				qg->refcnt = qg->refcnt + 1;
>> +			qgroup_dirty(fs_info, qg);
>> +
>> +			list_for_each_entry(glist, &qg->groups, next_group) {
>> +				ret = ulist_add(tmp, glist->group->qgroupid,
>> +						(uintptr_t)glist->group,
>> +						GFP_ATOMIC);
>> +				if (ret < 0) {
>> +					spin_unlock(&fs_info->qgroup_lock);
>> +					goto out;
>> +				}
>> +			}
>> +		}
> 
> 
> Here i think we can resue arne's 3 steps algorithm to make qgroup accounting correct.
> However, your first step just find all the root qgroups and their parent qgroups.
> And in second step, you walk these qgroups, and change every qgroup's referenced,
> and update qgroup->refcnt. However, i don't think this is right.
> 
> Considering in your second step: ulist_add() can gurantee thant we only update
> every qgroup's refcnt only once..
> 
> So if there are several roots found, i am wondering your codes still can work well?
> Are there any reasons that you change arne's tree steps?
> Or am i missing something...

We cannot blindly reuse the three steps without modification. They were made for
tracking on non-empty volumes and we would do a lot of pointless work because
rescan always starts from an empty starting point.

Step 1 is: "for each old ref, visit all nodes once and inc refcnt" - we can skip
that, because we don't have any old refs.

Step 2 is: "walk from the new root" - we do that and treat every block as "not
visited by step 1", so we treat all references as added references. Note that
there are some differences which is why we cannot just call the step2 function:
- The original version only has a single qgroup, because it only adds a single
new reference, referencing only a single root. Instead, in the rescan algorithm,
we've got the loop building the "tmp" ulist before we're getting to the rescan
step 2.
- We don't increment qg->excl in the rescan step 2 because we get that part for
free in our third step.
- We set qg->refcnt along the way such that the original step 3 code will do the
right thing.

Step 3 is: "walk again from old refs" - we need that step unchanged, although
technically we don't walk from the old refs, that's why we had to fake
qg->refcnt in our modified step 2.

I admit, it's not obvious at first sight. But when you just put the code side by
side and draw some extents, roots and qgroups on a sheet of paper, everything
looks good (to me) :-)

I hope this explanation helps you to come to the same conclusion (or instead
gives you something to show me where I'm wrong).

Thanks,
-Jan

> Thanks,
> Wang
> 
>> +
>> +		qgroup_account_ref_step3(fs_info, roots, tmp, seq, -1,
>> +					 found.offset);
>> +
>> +		spin_unlock(&fs_info->qgroup_lock);
>> +		ulist_free(roots);
>> +		ret = 0;
>> +	}
>> +
>> +out:
>> +	btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
>> +
>> +	return ret;
>> +}
>> +
> 
> [snip]
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
