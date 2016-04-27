Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5899 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751772AbcD0BUE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 21:20:04 -0400
Subject: Re: [PATCH] Btrfs: fix qgroup accounting when snapshotting
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>,
        <mfasheh@suse.de>
References: <1461680685-2432-1-git-send-email-jbacik@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <1d9f9fed-8f31-04fc-66d3-41ce77ff6a94@cn.fujitsu.com>
Date: Wed, 27 Apr 2016 09:19:58 +0800
MIME-Version: 1.0
In-Reply-To: <1461680685-2432-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Josef Bacik wrote on 2016/04/26 10:24 -0400:
> The new qgroup stuff needs the quota accounting to be run before doing the
> inherit, unfortunately they need the commit root switch to happen at a specific
> time for this to work properly.  Fix this by delaying the inherit until after we
> do the qgroup accounting, and remove the inherit and accounting dance in
> create_pending_snapshot.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/transaction.c | 51 ++++++++++++++++++++++++++++++--------------------
>  fs/btrfs/transaction.h |  1 +
>  2 files changed, 32 insertions(+), 20 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 7c7671d..aa3025a 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1353,6 +1353,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  	pending->error = btrfs_find_free_objectid(tree_root, &objectid);
>  	if (pending->error)
>  		goto no_free_objectid;
> +	pending->objectid = objectid;
>
>  	/*
>  	 * Make qgroup to skip current new snapshot's qgroupid, as it is
> @@ -1559,24 +1560,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  		btrfs_abort_transaction(trans, root, ret);
>  		goto fail;
>  	}
> -
> -	/*
> -	 * account qgroup counters before qgroup_inherit()
> -	 */
> -	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
> -	if (ret)
> -		goto fail;
> -	ret = btrfs_qgroup_account_extents(trans, fs_info);
> -	if (ret)
> -		goto fail;
> -	ret = btrfs_qgroup_inherit(trans, fs_info,
> -				   root->root_key.objectid,
> -				   objectid, pending->inherit);
> -	if (ret) {
> -		btrfs_abort_transaction(trans, root, ret);
> -		goto fail;
> -	}
> -
>  fail:
>  	pending->error = ret;
>  dir_item_existed:
> @@ -1599,15 +1582,35 @@ no_free_objectid:
>  static noinline int create_pending_snapshots(struct btrfs_trans_handle *trans,
>  					     struct btrfs_fs_info *fs_info)
>  {
> +	struct btrfs_pending_snapshot *pending;
> +	struct list_head *head = &trans->transaction->pending_snapshots;
> +	int ret = 0;
> +
> +	list_for_each_entry(pending, head, list) {
> +		ret = create_pending_snapshot(trans, fs_info, pending);
> +		if (ret)
> +			break;
> +	}
> +	return ret;
> +}
> +
> +static noinline int inherit_pending_snapshots(struct btrfs_trans_handle *trans,
> +					      struct btrfs_fs_info *fs_info)
> +{
>  	struct btrfs_pending_snapshot *pending, *next;
>  	struct list_head *head = &trans->transaction->pending_snapshots;
>  	int ret = 0;
>
>  	list_for_each_entry_safe(pending, next, head, list) {
> +		struct btrfs_root *root = pending->root;
>  		list_del(&pending->list);
> -		ret = create_pending_snapshot(trans, fs_info, pending);
> -		if (ret)
> +		ret = btrfs_qgroup_inherit(trans, fs_info,
> +					   root->root_key.objectid,
> +					   pending->objectid, pending->inherit);

It's too late to call qgroup_inherit() here.
As we already inserted DIR_ITEM into parent_root.

This will cause qgroup difference, if parent_root is also the src_root.


But your fix provides a very potential fix method.
If we didn't do the DIR_ITEM insert in create_pending_snapshot, but do 
the insert after all qgroup_inherit() is done,
the problem may have a better fix.

Although I am still concerning about the DIR_ITEM insert.
As we still need to account them, and since we must run qgroup 
accounting before qgroup_inherit(), I'm afraid we still need to do the 
commit hack though.

Thanks,
Qu
> +		if (ret) {
> +			btrfs_abort_transaction(trans, root, ret);
>  			break;
> +		}
>  	}
>  	return ret;
>  }
> @@ -2084,6 +2087,14 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  		goto scrub_continue;
>  	}
>
> +	/* Inherit the qgroup information for the snapshots. */
> +	ret = inherit_pending_snapshots(trans, root->fs_info);
> +	if (ret) {
> +		mutex_unlock(&root->fs_info->reloc_mutex);
> +		goto scrub_continue;
> +	}
> +
> +
>  	ret = commit_cowonly_roots(trans, root);
>  	if (ret) {
>  		mutex_unlock(&root->fs_info->tree_log_mutex);
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 72be51f..c118e6e 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -144,6 +144,7 @@ struct btrfs_pending_snapshot {
>  	/* block reservation for the operation */
>  	struct btrfs_block_rsv block_rsv;
>  	u64 qgroup_reserved;
> +	u64 objectid;
>  	/* extra metadata reseration for relocation */
>  	int error;
>  	bool readonly;
>


