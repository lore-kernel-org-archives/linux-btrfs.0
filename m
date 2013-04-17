Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60015 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966477Ab3DQOST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 10:18:19 -0400
Received: by mail-pb0-f48.google.com with SMTP id xb4so903698pbc.7
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2013 07:18:19 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH V2] Btrfs: fix missing check about ulist_add() in qgroup.c
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1366207069-31505-1-git-send-email-wangshilong1991@gmail.com>
Date: Wed, 17 Apr 2013 22:18:13 +0800
Cc: "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>
Message-Id: <CCDB6585-05B9-4CC9-9C98-74F020DABAA7@gmail.com>
References: <1366207069-31505-1-git-send-email-wangshilong1991@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

	It really takes me the whole day to tack such strange regression down!
In fact, i should test every patch even for a cleanup patch carefully¡­.

Sorry for inconvenience to you. 

Wang
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> ulist_add() may return -ENOMEM, fix missing check about
> return value.
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
> Changelog v1->v2:
> 	ulist_add() may return 1, and this is ok. For this case,
> 	btrfs_qgroup_reserve() should return 0, otherwise, i get
> 	a regression when testing btrfs quota with btrfs-next.
> ---
> fs/btrfs/qgroup.c | 62 +++++++++++++++++++++++++++++++++++++++----------------
> 1 file changed, 44 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index e089fc1..5d2743d 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1261,7 +1261,10 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
> 
> 		ulist_reinit(tmp);
> 						/* XXX id not needed */
> -		ulist_add(tmp, qg->qgroupid, (u64)(uintptr_t)qg, GFP_ATOMIC);
> +		ret = ulist_add(tmp, qg->qgroupid,
> +				(u64)(uintptr_t)qg, GFP_ATOMIC);
> +		if (ret < 0)
> +			goto unlock;
> 		ULIST_ITER_INIT(&tmp_uiter);
> 		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
> 			struct btrfs_qgroup_list *glist;
> @@ -1273,9 +1276,11 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
> 				++qg->refcnt;
> 
> 			list_for_each_entry(glist, &qg->groups, next_group) {
> -				ulist_add(tmp, glist->group->qgroupid,
> -					  (u64)(uintptr_t)glist->group,
> -					  GFP_ATOMIC);
> +				ret = ulist_add(tmp, glist->group->qgroupid,
> +						(u64)(uintptr_t)glist->group,
> +						GFP_ATOMIC);
> +				if (ret < 0)
> +					goto unlock;
> 			}
> 		}
> 	}
> @@ -1284,7 +1289,10 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
> 	 * step 2: walk from the new root
> 	 */
> 	ulist_reinit(tmp);
> -	ulist_add(tmp, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
> +	ret = ulist_add(tmp, qgroup->qgroupid,
> +			(uintptr_t)qgroup, GFP_ATOMIC);
> +	if (ret < 0)
> +		goto unlock;
> 	ULIST_ITER_INIT(&uiter);
> 	while ((unode = ulist_next(tmp, &uiter))) {
> 		struct btrfs_qgroup *qg;
> @@ -1305,8 +1313,10 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
> 		qg->tag = seq;
> 
> 		list_for_each_entry(glist, &qg->groups, next_group) {
> -			ulist_add(tmp, glist->group->qgroupid,
> -				  (uintptr_t)glist->group, GFP_ATOMIC);
> +			ret = ulist_add(tmp, glist->group->qgroupid,
> +					(uintptr_t)glist->group, GFP_ATOMIC);
> +			if (ret < 0)
> +				goto unlock;
> 		}
> 	}
> 
> @@ -1324,7 +1334,10 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
> 			continue;
> 
> 		ulist_reinit(tmp);
> -		ulist_add(tmp, qg->qgroupid, (uintptr_t)qg, GFP_ATOMIC);
> +		ret = ulist_add(tmp, qg->qgroupid,
> +				(uintptr_t)qg, GFP_ATOMIC);
> +		if (ret < 0)
> +			goto unlock;
> 		ULIST_ITER_INIT(&tmp_uiter);
> 		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
> 			struct btrfs_qgroup_list *glist;
> @@ -1340,9 +1353,11 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
> 			}
> 
> 			list_for_each_entry(glist, &qg->groups, next_group) {
> -				ulist_add(tmp, glist->group->qgroupid,
> -					  (uintptr_t)glist->group,
> -					  GFP_ATOMIC);
> +				ret = ulist_add(tmp, glist->group->qgroupid,
> +						(uintptr_t)glist->group,
> +						GFP_ATOMIC);
> +				if (ret < 0)
> +					goto unlock;
> 			}
> 		}
> 	}
> @@ -1607,7 +1622,10 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
> 		ret = -ENOMEM;
> 		goto out;
> 	}
> -	ulist_add(ulist, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
> +	ret = ulist_add(ulist, qgroup->qgroupid,
> +			(uintptr_t)qgroup, GFP_ATOMIC);
> +	if (ret < 0)
> +		goto out;
> 	ULIST_ITER_INIT(&uiter);
> 	while ((unode = ulist_next(ulist, &uiter))) {
> 		struct btrfs_qgroup *qg;
> @@ -1630,11 +1648,13 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
> 		}
> 
> 		list_for_each_entry(glist, &qg->groups, next_group) {
> -			ulist_add(ulist, glist->group->qgroupid,
> -				  (uintptr_t)glist->group, GFP_ATOMIC);
> +			ret = ulist_add(ulist, glist->group->qgroupid,
> +					(uintptr_t)glist->group, GFP_ATOMIC);
> +			if (ret < 0)
> +				goto out;
> 		}
> 	}
> -
> +	ret = 0;
> 	/*
> 	 * no limits exceeded, now record the reservation into all qgroups
> 	 */
> @@ -1663,6 +1683,7 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
> 	struct ulist_node *unode;
> 	struct ulist_iterator uiter;
> 	u64 ref_root = root->root_key.objectid;
> +	int ret = 0;
> 
> 	if (!is_fstree(ref_root))
> 		return;
> @@ -1685,7 +1706,10 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
> 		btrfs_std_error(fs_info, -ENOMEM);
> 		goto out;
> 	}
> -	ulist_add(ulist, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
> +	ret = ulist_add(ulist, qgroup->qgroupid,
> +			(uintptr_t)qgroup, GFP_ATOMIC);
> +	if (ret < 0)
> +		goto out;
> 	ULIST_ITER_INIT(&uiter);
> 	while ((unode = ulist_next(ulist, &uiter))) {
> 		struct btrfs_qgroup *qg;
> @@ -1696,8 +1720,10 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
> 		qg->reserved -= num_bytes;
> 
> 		list_for_each_entry(glist, &qg->groups, next_group) {
> -			ulist_add(ulist, glist->group->qgroupid,
> -				  (uintptr_t)glist->group, GFP_ATOMIC);
> +			ret = ulist_add(ulist, glist->group->qgroupid,
> +					(uintptr_t)glist->group, GFP_ATOMIC);
> +			if (ret < 0)
> +				goto out;
> 		}
> 	}
> 
> -- 
> 1.7.11.7
> 

