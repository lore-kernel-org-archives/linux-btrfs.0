Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23107 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab3DPKTE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 06:19:04 -0400
Message-ID: <516D2313.6050004@cn.fujitsu.com>
Date: Tue, 16 Apr 2013 18:08:19 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] Btrfs: rescan for qgroups
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net> <1366101920-13083-3-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1366101920-13083-3-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan,
 

>  	slot = path->slots[0];
>  	ptr = btrfs_item_ptr(l, slot, struct btrfs_qgroup_status_item);
> +	spin_lock(&fs_info->qgroup_lock);


Why we need hold qgroup_lock here? would you please explain...

Thanks,
Wang

>  	btrfs_set_qgroup_status_flags(l, ptr, fs_info->qgroup_flags);
>  	btrfs_set_qgroup_status_generation(l, ptr, trans->transid);
> -	/* XXX scan */
> +	btrfs_set_qgroup_status_rescan(l, ptr,
> +				fs_info->qgroup_rescan_progress.objectid);
> +	spin_unlock(&fs_info->qgroup_lock);

>  
>  	btrfs_mark_buffer_dirty(l);
>  
> @@ -830,7 +854,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>  	fs_info->qgroup_flags = BTRFS_QGROUP_STATUS_FLAG_ON |
>  				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>  	btrfs_set_qgroup_status_flags(leaf, ptr, fs_info->qgroup_flags);
> -	btrfs_set_qgroup_status_scan(leaf, ptr, 0);
> +	btrfs_set_qgroup_status_rescan(leaf, ptr, 0);
>  
>  	btrfs_mark_buffer_dirty(leaf);
>  
> @@ -894,10 +918,11 @@ out:
>  	return ret;
>  }
>  
> -int btrfs_quota_rescan(struct btrfs_fs_info *fs_info)
> +static void qgroup_dirty(struct btrfs_fs_info *fs_info,
> +			 struct btrfs_qgroup *qgroup)
>  {
> -	/* FIXME */
> -	return 0;
> +	if (list_empty(&qgroup->dirty))
> +		list_add(&qgroup->dirty, &fs_info->dirty_qgroups);
>  }
>  
>  int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
> @@ -1045,13 +1070,6 @@ unlock:
>  	return ret;
>  }
>  
> -static void qgroup_dirty(struct btrfs_fs_info *fs_info,
> -			 struct btrfs_qgroup *qgroup)
> -{
> -	if (list_empty(&qgroup->dirty))
> -		list_add(&qgroup->dirty, &fs_info->dirty_qgroups);
> -}
> -
>  /*
>   * btrfs_qgroup_record_ref is called when the ref is added or deleted. it puts
>   * the modification into a list that's later used by btrfs_end_transaction to
> @@ -1256,6 +1274,15 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
>  		BUG();
>  	}
>  
> +	mutex_lock(&fs_info->qgroup_rescan_lock);
> +	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
> +		if (fs_info->qgroup_rescan_progress.objectid <= node->bytenr) {
> +			mutex_unlock(&fs_info->qgroup_rescan_lock);
> +			return 0;
> +		}
> +	}
> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
> +
>  	/*
>  	 * the delayed ref sequence number we pass depends on the direction of
>  	 * the operation. for add operations, we pass (node->seq - 1) to skip
> @@ -1269,7 +1296,17 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
>  	if (ret < 0)
>  		return ret;
>  
> +	mutex_lock(&fs_info->qgroup_rescan_lock);
>  	spin_lock(&fs_info->qgroup_lock);
> +	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
> +		if (fs_info->qgroup_rescan_progress.objectid <= node->bytenr) {
> +			ret = 0;
> +			mutex_unlock(&fs_info->qgroup_rescan_lock);
> +			goto unlock;
> +		}
> +	}
> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
> +
>  	quota_root = fs_info->quota_root;
>  	if (!quota_root)
>  		goto unlock;
> @@ -1652,3 +1689,233 @@ void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
>  		trans->delayed_ref_elem.seq);
>  	BUG();
>  }
> +
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
> +			ulist_add(tmp, qg->qgroupid, (uintptr_t)qg, GFP_ATOMIC);
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
> +				ulist_add(tmp, glist->group->qgroupid,
> +					  (uintptr_t)glist->group,
> +					  GFP_ATOMIC);
> +			}
> +		}
> +
> +		qgroup_account_ref_step3(fs_info, roots, tmp, seq, -1,
> +					 found.offset);
> +
> +		spin_unlock(&fs_info->qgroup_lock);
> +		ulist_free(roots);
> +	}
> +
> +	btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
> +
> +	return ret;
> +}
> +
> +static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
> +{
> +	struct qgroup_rescan *qscan = container_of(work, struct qgroup_rescan,
> +						   work);
> +	struct btrfs_path *path;
> +	struct btrfs_trans_handle *trans = NULL;
> +	struct btrfs_fs_info *fs_info = qscan->fs_info;
> +	struct ulist *tmp = NULL;
> +	struct extent_buffer *scratch_leaf = NULL;
> +	int err = -ENOMEM;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		goto out;
> +	tmp = ulist_alloc(GFP_NOFS);
> +	if (!tmp)
> +		goto out;
> +	scratch_leaf = kmalloc(sizeof(*scratch_leaf), GFP_NOFS);
> +	if (!scratch_leaf)
> +		goto out;
> +
> +	err = 0;
> +	while (!err) {
> +		trans = btrfs_start_transaction(fs_info->fs_root, 0);
> +		if (IS_ERR(trans)) {
> +			err = PTR_ERR(trans);
> +			break;
> +		}
> +		err = qgroup_rescan_leaf(qscan, path, trans, tmp, scratch_leaf);
> +		if (err > 0)
> +			btrfs_commit_transaction(trans, fs_info->fs_root);
> +		else
> +			btrfs_end_transaction(trans, fs_info->fs_root);
> +	}
> +
> +out:
> +	kfree(scratch_leaf);
> +	ulist_free(tmp);
> +	btrfs_free_path(path);
> +	kfree(qscan);
> +
> +	mutex_lock(&fs_info->qgroup_rescan_lock);
> +	fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
> +
> +	if (err == 2 &&
> +	    fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
> +		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> +	} else if (err < 0) {
> +		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> +	}
> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
> +
> +	if (err >= 0) {
> +		pr_info("btrfs: qgroup scan completed%s\n",
> +			err == 2 ? " (inconsistency flag cleared)" : "");
> +	} else {
> +		pr_err("btrfs: qgroup scan failed with %d\n", err);
> +	}
> +}
> +
> +static void
> +qgroup_rescan_start(struct btrfs_fs_info *fs_info, struct qgroup_rescan *qscan)
> +{
> +	qscan->work.func = btrfs_qgroup_rescan_worker;
> +	qscan->fs_info = fs_info;
> +
> +	pr_info("btrfs: qgroup scan started\n");
> +	btrfs_queue_worker(&fs_info->qgroup_rescan_workers, &qscan->work);
> +}
> +
> +int
> +btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
> +{
> +	int ret = 0;
> +	struct rb_node *n;
> +	struct btrfs_qgroup *qgroup;
> +	struct qgroup_rescan *qscan = kmalloc(sizeof(*qscan), GFP_NOFS);
> +
> +	if (!qscan)
> +		return -ENOMEM;
> +
> +	mutex_lock(&fs_info->qgroup_rescan_lock);
> +	spin_lock(&fs_info->qgroup_lock);
> +	if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
> +		ret = -EINPROGRESS;
> +	else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
> +		ret = -EINVAL;
> +	if (ret) {
> +		spin_unlock(&fs_info->qgroup_lock);
> +		mutex_unlock(&fs_info->qgroup_rescan_lock);
> +		kfree(qscan);
> +		return ret;
> +	}
> +
> +	fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_RESCAN;
> +	memset(&fs_info->qgroup_rescan_progress, 0,
> +		sizeof(fs_info->qgroup_rescan_progress));
> +
> +	/* clear all current qgroup tracking information */
> +	for (n = rb_first(&fs_info->qgroup_tree); n; n = rb_next(n)) {
> +		qgroup = rb_entry(n, struct btrfs_qgroup, node);
> +		qgroup->rfer = 0;
> +		qgroup->rfer_cmpr = 0;
> +		qgroup->excl = 0;
> +		qgroup->excl_cmpr = 0;
> +	}
> +	spin_unlock(&fs_info->qgroup_lock);
> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
> +
> +	qgroup_rescan_start(fs_info, qscan);
> +
> +	return 0;
> +}
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index fa3a5f9..ca70f08 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -376,12 +376,18 @@ struct btrfs_ioctl_get_dev_stats {
>  
>  #define BTRFS_QUOTA_CTL_ENABLE	1
>  #define BTRFS_QUOTA_CTL_DISABLE	2
> -#define BTRFS_QUOTA_CTL_RESCAN	3
> +#define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3
>  struct btrfs_ioctl_quota_ctl_args {
>  	__u64 cmd;
>  	__u64 status;
>  };
>  
> +struct btrfs_ioctl_quota_rescan_args {
> +	__u64	flags;
> +	__u64   progress;
> +	__u64   reserved[6];
> +};
> +
>  struct btrfs_ioctl_qgroup_assign_args {
>  	__u64 assign;
>  	__u64 src;
> @@ -502,6 +508,10 @@ struct btrfs_ioctl_send_args {
>  			       struct btrfs_ioctl_qgroup_create_args)
>  #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
>  			       struct btrfs_ioctl_qgroup_limit_args)
> +#define BTRFS_IOC_QUOTA_RESCAN _IOW(BTRFS_IOCTL_MAGIC, 44, \
> +			       struct btrfs_ioctl_quota_rescan_args)
> +#define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
> +			       struct btrfs_ioctl_quota_rescan_args)
>  #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
>  				   char[BTRFS_LABEL_SIZE])
>  #define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \



