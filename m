Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:39424 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953Ab3DWNDz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 09:03:55 -0400
Message-ID: <517686B9.8090100@jan-o-sch.net>
Date: Tue, 23 Apr 2013 15:03:53 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        wangshilong1991@gmail.com, dsterba@suse.cz
Subject: Re: [PATCH v3 2/3] Btrfs: rescan for qgroups
References: <1366716411-9750-1-git-send-email-list.btrfs@jan-o-sch.net> <1366716411-9750-3-git-send-email-list.btrfs@jan-o-sch.net> <5176791D.9030209@cn.fujitsu.com>
In-Reply-To: <5176791D.9030209@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, April 23, 2013 at 14:05 (+0200), Wang Shilong wrote:
> Hello Jan,
> 
> [..snip..]
> 
> 
> 
>>  	/*
>>  	 * the delayed ref sequence number we pass depends on the direction of
>>  	 * the operation. for add operations, we pass (node->seq - 1) to skip
>> @@ -1401,7 +1428,17 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
>>  	if (ret < 0)
>>  		return ret;
>>  
>> +	mutex_lock(&fs_info->qgroup_rescan_lock);
>>  	spin_lock(&fs_info->qgroup_lock);
>> +	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
>> +		if (fs_info->qgroup_rescan_progress.objectid <= node->bytenr) {
>> +			ret = 0;
>> +			mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +			goto unlock;
>> +		}
>> +	}
>> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
>> +
>>  	quota_root = fs_info->quota_root;
>>  	if (!quota_root)
>>  		goto unlock;
>> @@ -1820,3 +1857,250 @@ void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
>>  		trans->delayed_ref_elem.seq);
>>  	BUG();
>>  }
>> +
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
> 
> 
> If ulist_add() fails, we still need to call ulist_free(roots)..
> 
>> +			if (ret < 0) {
>> +				spin_unlock(&fs_info->qgroup_lock);
> 
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
> 
> 
> If ulist_add() fails, we still need to call ulist_free(roots)..
> 
>> +				if (ret < 0) {
>> +					spin_unlock(&fs_info->qgroup_lock);
>> +					goto out;
>> +				}
>> +			}
>> +		}
>> +
>> +		qgroup_account_ref_step3(fs_info, roots, tmp, seq, -1,
>> +					 found.offset);
> 
> please check return value of qgroup_account_ref_step3()... As -ENOMEM may happen.

ugh. You're right, also in your previous (separate) mail. Thanks. I'll wait for
more comments before v4.

Jan


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
>>
> 
> [..snip..]
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
