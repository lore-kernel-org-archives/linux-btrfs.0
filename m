Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22608 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab3DXLMJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 07:12:09 -0400
Message-ID: <5177BB51.8030400@cn.fujitsu.com>
Date: Wed, 24 Apr 2013 19:00:33 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        wangshilong1991@gmail.com, dsterba@suse.cz
Subject: Re: [PATCH v3 2/3] Btrfs: rescan for qgroups
References: <1366716411-9750-1-git-send-email-list.btrfs@jan-o-sch.net> <1366716411-9750-3-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1366716411-9750-3-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan,

[snip]

> +/*
> + * returns < 0 on error, 0 when more leafs are to be scanned.
> + * returns 1 when done, 2 when done and FLAG_INCONSISTENT was cleared.
> + */
> +static int
> +qgroup_rescan_leaf(struct qgroup_rescan *qscan, struct btrfs_path *path,
> +		   struct btrfs_trans_handle *trans, struct ulist *tmp,
> +		   struct extent_buffer *scratch_leaf)
> +{
> +	struct btrfs_key found;
> +	struct btrfs_fs_info *fs_info = qscan->fs_info;
> +	struct ulist *roots = NULL;
> +	struct ulist_node *unode;
> +	struct ulist_iterator uiter;
> +	struct seq_list tree_mod_seq_elem = {};
> +	u64 seq;
> +	int slot;
> +	int ret;
> +
> +	path->leave_spinning = 1;
> +	mutex_lock(&fs_info->qgroup_rescan_lock);
> +	ret = btrfs_search_slot_for_read(fs_info->extent_root,
> +					 &fs_info->qgroup_rescan_progress,
> +					 path, 1, 0);
> +
> +	pr_debug("current progress key (%llu %u %llu), search_slot ret %d\n",
> +		 (unsigned long long)fs_info->qgroup_rescan_progress.objectid,
> +		 fs_info->qgroup_rescan_progress.type,
> +		 (unsigned long long)fs_info->qgroup_rescan_progress.offset,
> +		 ret);
> +
> +	if (ret) {
> +		/*
> +		 * The rescan is about to end, we will not be scanning any
> +		 * further blocks. We cannot unset the RESCAN flag here, because
> +		 * we want to commit the transaction if everything went well.
> +		 * To make the live accounting work in this phase, we set our
> +		 * scan progress pointer such that every real extent objectid
> +		 * will be smaller.
> +		 */
> +		fs_info->qgroup_rescan_progress.objectid = (u64)-1;
> +		btrfs_release_path(path);
> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
> +		return ret;
> +	}
> +
> +	btrfs_item_key_to_cpu(path->nodes[0], &found,
> +			      btrfs_header_nritems(path->nodes[0]) - 1);
> +	fs_info->qgroup_rescan_progress.objectid = found.objectid + 1;
> +
> +	btrfs_get_tree_mod_seq(fs_info, &tree_mod_seq_elem);
> +	memcpy(scratch_leaf, path->nodes[0], sizeof(*scratch_leaf));
> +	slot = path->slots[0];
> +	btrfs_release_path(path);
> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
> +
> +	for (; slot < btrfs_header_nritems(scratch_leaf); ++slot) {
> +		btrfs_item_key_to_cpu(scratch_leaf, &found, slot);
> +		if (found.type != BTRFS_EXTENT_ITEM_KEY)
> +			continue;
> +		ret = btrfs_find_all_roots(trans, fs_info, found.objectid,
> +					   tree_mod_seq_elem.seq, &roots);
> +		if (ret < 0)
> +			break;
> +		spin_lock(&fs_info->qgroup_lock);
> +		seq = fs_info->qgroup_seq;
> +		fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
> +
> +		ulist_reinit(tmp);
> +		ULIST_ITER_INIT(&uiter);
> +		while ((unode = ulist_next(roots, &uiter))) {
> +			struct btrfs_qgroup *qg;
> +
> +			qg = find_qgroup_rb(fs_info, unode->val);
> +			if (!qg)
> +				continue;
> +
> +			ret = ulist_add(tmp, qg->qgroupid, (uintptr_t)qg,
> +					GFP_ATOMIC);
> +			if (ret < 0) {
> +				spin_unlock(&fs_info->qgroup_lock);
> +				goto out;
> +			}
> +		}
> +
> +		/* this is similar to step 2 of btrfs_qgroup_account_ref */
> +		ULIST_ITER_INIT(&uiter);
> +		while ((unode = ulist_next(tmp, &uiter))) {
> +			struct btrfs_qgroup *qg;
> +			struct btrfs_qgroup_list *glist;
> +
> +			qg = (struct btrfs_qgroup *)(uintptr_t) unode->aux;
> +			qg->rfer += found.offset;
> +			qg->rfer_cmpr += found.offset;
> +			WARN_ON(qg->tag >= seq);
> +			WARN_ON(qg->refcnt >= seq);
> +			if (qg->refcnt < seq)
> +				qg->refcnt = seq + 1;
> +			else
> +				qg->refcnt = qg->refcnt + 1;
> +			qgroup_dirty(fs_info, qg);
> +
> +			list_for_each_entry(glist, &qg->groups, next_group) {
> +				ret = ulist_add(tmp, glist->group->qgroupid,
> +						(uintptr_t)glist->group,
> +						GFP_ATOMIC);
> +				if (ret < 0) {
> +					spin_unlock(&fs_info->qgroup_lock);
> +					goto out;
> +				}
> +			}
> +		}


Here i think we can resue arne's 3 steps algorithm to make qgroup accounting correct.
However, your first step just find all the root qgroups and their parent qgroups.
And in second step, you walk these qgroups, and change every qgroup's referenced,
and update qgroup->refcnt. However, i don't think this is right.

Considering in your second step: ulist_add() can gurantee thant we only update
every qgroup's refcnt only once..

So if there are several roots found, i am wondering your codes still can work well?
Are there any reasons that you change arne's tree steps?
Or am i missing something...

Thanks,
Wang

> +
> +		qgroup_account_ref_step3(fs_info, roots, tmp, seq, -1,
> +					 found.offset);
> +
> +		spin_unlock(&fs_info->qgroup_lock);
> +		ulist_free(roots);
> +		ret = 0;
> +	}
> +
> +out:
> +	btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
> +
> +	return ret;
> +}
> +

[snip]

