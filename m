Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38891 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab3DXIM3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 04:12:29 -0400
Date: Wed, 24 Apr 2013 16:12:36 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: separate sequence numbers for delayed ref
 tracking and tree mod log
Message-ID: <20130424081236.GE19283@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1366740027-27627-1-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366740027-27627-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 23, 2013 at 08:00:27PM +0200, Jan Schmidt wrote:
> Sequence numbers for delayed refs have been introduced in the first version
> of the qgroup patch set. To solve the problem of find_all_roots on a busy
> file system, the tree mod log was introduced. The sequence numbers for that
> were simply shared between those two users.

Can't we just separate them with two vars?

thanks,
liubo

> 
> However, at one point in qgroup's quota accounting, there's a statement
> accessing the previous sequence number, that's still just doing (seq - 1)
> just as it had to in the very first version.
> 
> To satisfy that requirement, this patch makes the sequence number counter 64
> bit and splits it into a major part (used for qgroup sequence number
> counting) and a minor part (incremented for each tree modification in the
> log). This enables us to go exactly one major step backwards, as required
> for qgroups, while still incrementing the sequence counter for tree mod log
> insertions to keep track of their order. Keeping them in a single variable
> means there's no need to change all the code dealing with comparisons of two
> sequence numbers.
> 
> The sequence number is reset to 0 on commit (not new in this patch), which
> ensures we won't overflow the two 32 bit counters.
> 
> Without this fix, the qgroup tracking can occasionally go wrong and WARN_ONs
> from the tree mod log code may happen.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/ctree.c       |   36 +++++++++++++++++++++++++++++++++---
>  fs/btrfs/ctree.h       |    7 ++-----
>  fs/btrfs/delayed-ref.c |    6 ++++--
>  fs/btrfs/disk-io.c     |    2 +-
>  fs/btrfs/extent-tree.c |    5 +++--
>  fs/btrfs/qgroup.c      |   13 ++++++++-----
>  fs/btrfs/transaction.c |    2 +-
>  7 files changed, 52 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 566d99b..b74136e 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -361,6 +361,36 @@ static inline void tree_mod_log_write_unlock(struct btrfs_fs_info *fs_info)
>  }
>  
>  /*
> + * increment the upper half of tree_mod_seq, set lower half zero
> + *
> + * must be called with fs_info->tree_mod_seq_lock held
> + */
> +static inline u64 btrfs_inc_tree_mod_seq_major(struct btrfs_fs_info *fs_info)
> +{
> +	u64 seq = atomic64_read(&fs_info->tree_mod_seq);
> +	seq &= 0xffffffff00000000ull;
> +	seq += 1ull << 32;
> +	atomic64_set(&fs_info->tree_mod_seq, seq);
> +	return seq;
> +}
> +
> +/*
> + * increment the lower half of tree_mod_seq
> + */
> +static inline u64 btrfs_inc_tree_mod_seq_minor(struct btrfs_fs_info *fs_info)
> +{
> +	return atomic64_inc_return(&fs_info->tree_mod_seq);
> +}
> +
> +/*
> + * return the last minor in the previous major tree_mod_seq number
> + */
> +u64 btrfs_tree_mod_seq_prev(u64 seq)
> +{
> +	return (seq & 0xffffffff00000000ull) - 1ull;
> +}
> +
> +/*
>   * This adds a new blocker to the tree mod log's blocker list if the @elem
>   * passed does not already have a sequence number set. So when a caller expects
>   * to record tree modifications, it should ensure to set elem->seq to zero
> @@ -376,10 +406,10 @@ u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
>  	tree_mod_log_write_lock(fs_info);
>  	spin_lock(&fs_info->tree_mod_seq_lock);
>  	if (!elem->seq) {
> -		elem->seq = btrfs_inc_tree_mod_seq(fs_info);
> +		elem->seq = btrfs_inc_tree_mod_seq_major(fs_info);
>  		list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
>  	}
> -	seq = btrfs_inc_tree_mod_seq(fs_info);
> +	seq = btrfs_inc_tree_mod_seq_minor(fs_info);
>  	spin_unlock(&fs_info->tree_mod_seq_lock);
>  	tree_mod_log_write_unlock(fs_info);
>  
> @@ -524,7 +554,7 @@ static inline int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
>  	if (!tm)
>  		return -ENOMEM;
>  
> -	tm->seq = btrfs_inc_tree_mod_seq(fs_info);
> +	tm->seq = btrfs_inc_tree_mod_seq_minor(fs_info);
>  	return tm->seq;
>  }
>  
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 412c306..5f34f89 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1422,7 +1422,7 @@ struct btrfs_fs_info {
>  
>  	/* this protects tree_mod_seq_list */
>  	spinlock_t tree_mod_seq_lock;
> -	atomic_t tree_mod_seq;
> +	atomic64_t tree_mod_seq;
>  	struct list_head tree_mod_seq_list;
>  	struct seq_list tree_mod_seq_elem;
>  
> @@ -3334,10 +3334,7 @@ u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
>  			   struct seq_list *elem);
>  void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
>  			    struct seq_list *elem);
> -static inline u64 btrfs_inc_tree_mod_seq(struct btrfs_fs_info *fs_info)
> -{
> -	return atomic_inc_return(&fs_info->tree_mod_seq);
> -}
> +u64 btrfs_tree_mod_seq_prev(u64 seq);
>  int btrfs_old_root_level(struct btrfs_root *root, u64 time_seq);
>  
>  /* root-item.c */
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 116abec..c219463 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -361,8 +361,10 @@ int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
>  		elem = list_first_entry(&fs_info->tree_mod_seq_list,
>  					struct seq_list, list);
>  		if (seq >= elem->seq) {
> -			pr_debug("holding back delayed_ref %llu, lowest is "
> -				 "%llu (%p)\n", seq, elem->seq, delayed_refs);
> +			pr_debug("holding back delayed_ref %#x.%x, lowest is %#x.%x (%p)\n",
> +				 (u32)(seq >> 32), (u32)seq,
> +				 (u32)(elem->seq >> 32), (u32)elem->seq,
> +				 delayed_refs);
>  			ret = 1;
>  		}
>  	}
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index f4628c7..0207132 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2147,7 +2147,7 @@ int open_ctree(struct super_block *sb,
>  	atomic_set(&fs_info->async_submit_draining, 0);
>  	atomic_set(&fs_info->nr_async_bios, 0);
>  	atomic_set(&fs_info->defrag_running, 0);
> -	atomic_set(&fs_info->tree_mod_seq, 0);
> +	atomic64_set(&fs_info->tree_mod_seq, 0);
>  	fs_info->sb = sb;
>  	fs_info->max_inline = 8192 * 1024;
>  	fs_info->metadata_ratio = 0;
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index b441be3..f2f1654 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2523,9 +2523,10 @@ int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
>  	    !trans->delayed_ref_elem.seq) {
>  		/* list without seq or seq without list */
>  		btrfs_err(fs_info,
> -			"qgroup accounting update error, list is%s empty, seq is %llu",
> +			"qgroup accounting update error, list is%s empty, seq is %#x.%x",
>  			list_empty(&trans->qgroup_ref_list) ? "" : " not",
> -			trans->delayed_ref_elem.seq);
> +			(u32)(trans->delayed_ref_elem.seq >> 32),
> +			(u32)trans->delayed_ref_elem.seq);
>  		BUG();
>  	}
>  
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index f175471..e5c5623 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1242,9 +1242,11 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
>  	case BTRFS_ADD_DELAYED_REF:
>  	case BTRFS_ADD_DELAYED_EXTENT:
>  		sgn = 1;
> +		seq = btrfs_tree_mod_seq_prev(node->seq);
>  		break;
>  	case BTRFS_DROP_DELAYED_REF:
>  		sgn = -1;
> +		seq = node->seq;
>  		break;
>  	case BTRFS_UPDATE_DELAYED_HEAD:
>  		return 0;
> @@ -1254,14 +1256,14 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
>  
>  	/*
>  	 * the delayed ref sequence number we pass depends on the direction of
> -	 * the operation. for add operations, we pass (node->seq - 1) to skip
> +	 * the operation. for add operations, we pass
> +	 * tree_mod_log_prev_seq(node->seq) to skip
>  	 * the delayed ref's current sequence number, because we need the state
>  	 * of the tree before the add operation. for delete operations, we pass
>  	 * (node->seq) to include the delayed ref's current sequence number,
>  	 * because we need the state of the tree after the delete operation.
>  	 */
> -	ret = btrfs_find_all_roots(trans, fs_info, node->bytenr,
> -				   sgn > 0 ? node->seq - 1 : node->seq, &roots);
> +	ret = btrfs_find_all_roots(trans, fs_info, node->bytenr, seq, &roots);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -1772,8 +1774,9 @@ void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
>  {
>  	if (list_empty(&trans->qgroup_ref_list) && !trans->delayed_ref_elem.seq)
>  		return;
> -	printk(KERN_ERR "btrfs: qgroups not uptodate in trans handle %p: list is%s empty, seq is %llu\n",
> +	pr_err("btrfs: qgroups not uptodate in trans handle %p: list is%s empty, seq is %#x.%x\n",
>  		trans, list_empty(&trans->qgroup_ref_list) ? "" : " not",
> -		trans->delayed_ref_elem.seq);
> +		(u32)(trans->delayed_ref_elem.seq >> 32),
> +		(u32)trans->delayed_ref_elem.seq);
>  	BUG();
>  }
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 94cbd10..d9edff7 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -163,7 +163,7 @@ loop:
>  	if (!RB_EMPTY_ROOT(&fs_info->tree_mod_log))
>  		WARN(1, KERN_ERR "btrfs: tree_mod_log rb tree not empty when "
>  			"creating a fresh transaction\n");
> -	atomic_set(&fs_info->tree_mod_seq, 0);
> +	atomic64_set(&fs_info->tree_mod_seq, 0);
>  
>  	spin_lock_init(&cur_trans->commit_lock);
>  	spin_lock_init(&cur_trans->delayed_refs.lock);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
