Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43344 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab3DPJQe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 05:16:34 -0400
Message-ID: <516D17F1.4070208@cn.fujitsu.com>
Date: Tue, 16 Apr 2013 17:20:49 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] Btrfs: split btrfs_qgroup_account_ref into four
 functions
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net> <1366101920-13083-2-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1366101920-13083-2-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan,

> The function is separated into a preparation part and the three accounting
> steps mentioned in the qgroups documentation. The goal is to make steps two
> and three usable by the rescan functionality. A side effect is that the
> function is restructured into readable subunits.


How about renaming the three functions like:

1> qgroup_walk_old_roots()
2> qgroup_walk_new_root()
3> qgroup_rewalk_old_root()

I'd like this function to be meaningful, but not just step1,2,3.
Maybe you can think out better function name.

Thanks,
Wang

> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/qgroup.c |  212 ++++++++++++++++++++++++++++++-----------------------
>  1 files changed, 121 insertions(+), 91 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index b44124d..c38a0c5 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1075,6 +1075,122 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
>  	return 0;
>  }
>  
> +static void qgroup_account_ref_step1(struct btrfs_fs_info *fs_info,
> +				     struct ulist *roots, struct ulist *tmp,
> +				     u64 seq)
> +{
> +	struct ulist_node *unode;
> +	struct ulist_iterator uiter;
> +	struct ulist_node *tmp_unode;
> +	struct ulist_iterator tmp_uiter;
> +	struct btrfs_qgroup *qg;
> +
> +	ULIST_ITER_INIT(&uiter);
> +	while ((unode = ulist_next(roots, &uiter))) {
> +		qg = find_qgroup_rb(fs_info, unode->val);
> +		if (!qg)
> +			continue;
> +
> +		ulist_reinit(tmp);
> +						/* XXX id not needed */
> +		ulist_add(tmp, qg->qgroupid, (u64)(uintptr_t)qg, GFP_ATOMIC);
> +		ULIST_ITER_INIT(&tmp_uiter);
> +		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
> +			struct btrfs_qgroup_list *glist;
> +
> +			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
> +			if (qg->refcnt < seq)
> +				qg->refcnt = seq + 1;
> +			else
> +				++qg->refcnt;
> +
> +			list_for_each_entry(glist, &qg->groups, next_group) {
> +				ulist_add(tmp, glist->group->qgroupid,
> +					  (u64)(uintptr_t)glist->group,
> +					  GFP_ATOMIC);
> +			}
> +		}
> +	}
> +}
> +
> +static void qgroup_account_ref_step2(struct btrfs_fs_info *fs_info,
> +				     struct ulist *roots, struct ulist *tmp,
> +				     u64 seq, int sgn, u64 num_bytes,
> +				     struct btrfs_qgroup *qgroup)
> +{
> +	struct ulist_node *unode;
> +	struct ulist_iterator uiter;
> +	struct btrfs_qgroup *qg;
> +	struct btrfs_qgroup_list *glist;
> +
> +	ulist_reinit(tmp);
> +	ulist_add(tmp, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
> +
> +	ULIST_ITER_INIT(&uiter);
> +	while ((unode = ulist_next(tmp, &uiter))) {
> +
> +		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
> +		if (qg->refcnt < seq) {
> +			/* not visited by step 1 */
> +			qg->rfer += sgn * num_bytes;
> +			qg->rfer_cmpr += sgn * num_bytes;
> +			if (roots->nnodes == 0) {
> +				qg->excl += sgn * num_bytes;
> +				qg->excl_cmpr += sgn * num_bytes;
> +			}
> +			qgroup_dirty(fs_info, qg);
> +		}
> +		WARN_ON(qg->tag >= seq);
> +		qg->tag = seq;
> +
> +		list_for_each_entry(glist, &qg->groups, next_group) {
> +			ulist_add(tmp, glist->group->qgroupid,
> +				  (uintptr_t)glist->group, GFP_ATOMIC);
> +		}
> +	}
> +}
> +
> +static void qgroup_account_ref_step3(struct btrfs_fs_info *fs_info,
> +				     struct ulist *roots, struct ulist *tmp,
> +				     u64 seq, int sgn, u64 num_bytes)
> +{
> +	struct ulist_node *unode;
> +	struct ulist_iterator uiter;
> +	struct btrfs_qgroup *qg;
> +	struct ulist_node *tmp_unode;
> +	struct ulist_iterator tmp_uiter;
> +
> +	ULIST_ITER_INIT(&uiter);
> +	while ((unode = ulist_next(roots, &uiter))) {
> +		qg = find_qgroup_rb(fs_info, unode->val);
> +		if (!qg)
> +			continue;
> +
> +		ulist_reinit(tmp);
> +		ulist_add(tmp, qg->qgroupid, (uintptr_t)qg, GFP_ATOMIC);
> +		ULIST_ITER_INIT(&tmp_uiter);
> +		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
> +			struct btrfs_qgroup_list *glist;
> +
> +			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
> +			if (qg->tag == seq)
> +				continue;
> +
> +			if (qg->refcnt - seq == roots->nnodes) {
> +				qg->excl -= sgn * num_bytes;
> +				qg->excl_cmpr -= sgn * num_bytes;
> +				qgroup_dirty(fs_info, qg);
> +			}
> +
> +			list_for_each_entry(glist, &qg->groups, next_group) {
> +				ulist_add(tmp, glist->group->qgroupid,
> +					  (uintptr_t)glist->group,
> +					  GFP_ATOMIC);
> +			}
> +		}
> +	}
> +}
> +
>  /*
>   * btrfs_qgroup_account_ref is called for every ref that is added to or deleted
>   * from the fs. First, all roots referencing the extent are searched, and
> @@ -1090,10 +1206,8 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
>  	struct btrfs_root *quota_root;
>  	u64 ref_root;
>  	struct btrfs_qgroup *qgroup;
> -	struct ulist_node *unode;
>  	struct ulist *roots = NULL;
>  	struct ulist *tmp = NULL;
> -	struct ulist_iterator uiter;
>  	u64 seq;
>  	int ret = 0;
>  	int sgn;
> @@ -1175,103 +1289,19 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
>  	seq = fs_info->qgroup_seq;
>  	fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
>  
> -	ULIST_ITER_INIT(&uiter);
> -	while ((unode = ulist_next(roots, &uiter))) {
> -		struct ulist_node *tmp_unode;
> -		struct ulist_iterator tmp_uiter;
> -		struct btrfs_qgroup *qg;
> -
> -		qg = find_qgroup_rb(fs_info, unode->val);
> -		if (!qg)
> -			continue;
> -
> -		ulist_reinit(tmp);
> -						/* XXX id not needed */
> -		ulist_add(tmp, qg->qgroupid, (u64)(uintptr_t)qg, GFP_ATOMIC);
> -		ULIST_ITER_INIT(&tmp_uiter);
> -		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
> -			struct btrfs_qgroup_list *glist;
> -
> -			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
> -			if (qg->refcnt < seq)
> -				qg->refcnt = seq + 1;
> -			else
> -				++qg->refcnt;
> -
> -			list_for_each_entry(glist, &qg->groups, next_group) {
> -				ulist_add(tmp, glist->group->qgroupid,
> -					  (u64)(uintptr_t)glist->group,
> -					  GFP_ATOMIC);
> -			}
> -		}
> -	}
> +	qgroup_account_ref_step1(fs_info, roots, tmp, seq);
>  
>  	/*
>  	 * step 2: walk from the new root
>  	 */
> -	ulist_reinit(tmp);
> -	ulist_add(tmp, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
> -	ULIST_ITER_INIT(&uiter);
> -	while ((unode = ulist_next(tmp, &uiter))) {
> -		struct btrfs_qgroup *qg;
> -		struct btrfs_qgroup_list *glist;
> -
> -		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
> -		if (qg->refcnt < seq) {
> -			/* not visited by step 1 */
> -			qg->rfer += sgn * node->num_bytes;
> -			qg->rfer_cmpr += sgn * node->num_bytes;
> -			if (roots->nnodes == 0) {
> -				qg->excl += sgn * node->num_bytes;
> -				qg->excl_cmpr += sgn * node->num_bytes;
> -			}
> -			qgroup_dirty(fs_info, qg);
> -		}
> -		WARN_ON(qg->tag >= seq);
> -		qg->tag = seq;
> -
> -		list_for_each_entry(glist, &qg->groups, next_group) {
> -			ulist_add(tmp, glist->group->qgroupid,
> -				  (uintptr_t)glist->group, GFP_ATOMIC);
> -		}
> -	}
> +	qgroup_account_ref_step2(fs_info, roots, tmp, seq, sgn,
> +				 node->num_bytes, qgroup);
>  
>  	/*
>  	 * step 3: walk again from old refs
>  	 */
> -	ULIST_ITER_INIT(&uiter);
> -	while ((unode = ulist_next(roots, &uiter))) {
> -		struct btrfs_qgroup *qg;
> -		struct ulist_node *tmp_unode;
> -		struct ulist_iterator tmp_uiter;
> -
> -		qg = find_qgroup_rb(fs_info, unode->val);
> -		if (!qg)
> -			continue;
> -
> -		ulist_reinit(tmp);
> -		ulist_add(tmp, qg->qgroupid, (uintptr_t)qg, GFP_ATOMIC);
> -		ULIST_ITER_INIT(&tmp_uiter);
> -		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
> -			struct btrfs_qgroup_list *glist;
> -
> -			qg = (struct btrfs_qgroup *)(uintptr_t)tmp_unode->aux;
> -			if (qg->tag == seq)
> -				continue;
> -
> -			if (qg->refcnt - seq == roots->nnodes) {
> -				qg->excl -= sgn * node->num_bytes;
> -				qg->excl_cmpr -= sgn * node->num_bytes;
> -				qgroup_dirty(fs_info, qg);
> -			}
> -
> -			list_for_each_entry(glist, &qg->groups, next_group) {
> -				ulist_add(tmp, glist->group->qgroupid,
> -					  (uintptr_t)glist->group,
> -					  GFP_ATOMIC);
> -			}
> -		}
> -	}
> +	qgroup_account_ref_step3(fs_info, roots, tmp, seq, sgn,
> +				 node->num_bytes);
>  	ret = 0;
>  unlock:
>  	spin_unlock(&fs_info->qgroup_lock);



