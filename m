Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52620 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758088AbcJYNF4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 09:05:56 -0400
Date: Tue, 25 Oct 2016 15:05:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: imporve delayed refs iterations
Message-ID: <20161025130554.GN22935@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161021090507.28425-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161021090507.28425-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 21, 2016 at 05:05:07PM +0800, Wang Xiaoguang wrote:
> This issue was found when I tried to delete a heavily reflinked file,
> when deleting such files, other transaction operation will not have a
> chance to make progress, for example, start_transaction() will blocked
> in wait_current_trans(root) for long time, sometimes it even triggers
> soft lockups, and the time taken to delete such heavily reflinked file
> is also very large, often hundreds of seconds. Using perf top, it reports
> that:
> 
> PerfTop:    7416 irqs/sec  kernel:99.8%  exact:  0.0% [4000Hz cpu-clock],  (all, 4 CPUs)
> ---------------------------------------------------------------------------------------
>     84.37%  [btrfs]             [k] __btrfs_run_delayed_refs.constprop.80
>     11.02%  [kernel]            [k] delay_tsc
>      0.79%  [kernel]            [k] _raw_spin_unlock_irq
>      0.78%  [kernel]            [k] _raw_spin_unlock_irqrestore
>      0.45%  [kernel]            [k] do_raw_spin_lock
>      0.18%  [kernel]            [k] __slab_alloc
> It seems __btrfs_run_delayed_refs() took most cpu time, after some debug
> work, I found it's select_delayed_ref() causing this issue, for a delayed
> head, in our case, it'll be full of BTRFS_DROP_DELAYED_REF nodes, but
> select_delayed_ref() will firstly try to iterate node list to find
> BTRFS_ADD_DELAYED_REF nodes, obviously it's a disaster in this case, and
> waste much time.
> 
> To fix this issue, we introduce a new ref_add_list in struct btrfs_delayed_ref_head,
> then in select_delayed_ref(), if this list is not empty, we can directly use
> nodes in this list. With this patch, it just took about 10~15 seconds to
> delte the same file. Now using perf top, it reports that:
> 
> PerfTop:    2734 irqs/sec  kernel:99.5%  exact:  0.0% [4000Hz cpu-clock],  (all, 4 CPUs)
> ----------------------------------------------------------------------------------------
> 
>     20.74%  [kernel]          [k] _raw_spin_unlock_irqrestore
>     16.33%  [kernel]          [k] __slab_alloc
>      5.41%  [kernel]          [k] lock_acquired
>      4.42%  [kernel]          [k] lock_acquire
>      4.05%  [kernel]          [k] lock_release
>      3.37%  [kernel]          [k] _raw_spin_unlock_irq
> 
> For normal files, this patch also gives help, at least we do not need to
> iterate whole list to found BTRFS_ADD_DELAYED_REF nodes.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/delayed-ref.c | 14 ++++++++++++++
>  fs/btrfs/delayed-ref.h |  8 ++++++++
>  fs/btrfs/disk-io.c     |  2 ++
>  fs/btrfs/extent-tree.c | 15 +++++++++------
>  4 files changed, 33 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 8d93854..39c28e0 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -189,6 +189,8 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
>  	} else {
>  		assert_spin_locked(&head->lock);
>  		list_del(&ref->list);
> +		if (!list_empty(&ref->add_list))
> +			list_del(&ref->add_list);
>  	}
>  	ref->in_tree = 0;
>  	btrfs_put_delayed_ref(ref);
> @@ -431,6 +433,11 @@ add_delayed_ref_tail_merge(struct btrfs_trans_handle *trans,
>  			exist->action = ref->action;
>  			mod = -exist->ref_mod;
>  			exist->ref_mod = ref->ref_mod;
> +			if (ref->action == BTRFS_ADD_DELAYED_REF)
> +				list_add_tail(&exist->add_list,
> +					      &href->ref_add_list);
> +			else if (!list_empty(&exist->add_list))
> +				list_del(&exist->add_list);

The value of 'action' is set to more values, in other code. I'm not sure
if it's really necessary, but I'd rather keep the check for DROP action
and catch anything else as a verbose assert. The whole delayed ref code
could be more defensive about the action values.

>  		} else
>  			mod = -ref->ref_mod;
>  	}
> @@ -444,6 +451,8 @@ add_delayed_ref_tail_merge(struct btrfs_trans_handle *trans,
>  
>  add_tail:
>  	list_add_tail(&ref->list, &href->ref_list);
> +	if (ref->action == BTRFS_ADD_DELAYED_REF)
> +		list_add_tail(&ref->add_list, &href->ref_add_list);
>  	atomic_inc(&root->num_entries);
>  	trans->delayed_ref_updates++;
>  	spin_unlock(&href->lock);
> @@ -590,6 +599,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>  	head_ref->must_insert_reserved = must_insert_reserved;
>  	head_ref->is_data = is_data;
>  	INIT_LIST_HEAD(&head_ref->ref_list);
> +	INIT_LIST_HEAD(&head_ref->ref_add_list);
>  	head_ref->processing = 0;
>  	head_ref->total_ref_mod = count_mod;
>  	head_ref->qgroup_reserved = 0;
> @@ -671,6 +681,8 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>  	ref->is_head = 0;
>  	ref->in_tree = 1;
>  	ref->seq = seq;
> +	INIT_LIST_HEAD(&ref->list);
> +	INIT_LIST_HEAD(&ref->add_list);
>  
>  	full_ref = btrfs_delayed_node_to_tree_ref(ref);
>  	full_ref->parent = parent;
> @@ -726,6 +738,8 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>  	ref->is_head = 0;
>  	ref->in_tree = 1;
>  	ref->seq = seq;
> +	INIT_LIST_HEAD(&ref->list);
> +	INIT_LIST_HEAD(&ref->add_list);
>  
>  	full_ref = btrfs_delayed_node_to_data_ref(ref);
>  	full_ref->parent = parent;
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index 43f3629..dba9784 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -42,6 +42,12 @@ struct btrfs_delayed_ref_node {
>  
>  	/*data/tree ref use list, stored in ref_head->ref_list. */
>  	struct list_head list;
> +	/*
> +	 * If action is BTRFS_ADD_DELAYED_REF, also link this node to
> +	 * ref_head->ref_add_list, then we do not need to iterate the
> +	 * whole ref_head->ref_list to find BTRFS_ADD_DELAYED_REF nodes.
> +	 */
> +	struct list_head add_list;
>  
>  	/* the starting bytenr of the extent */
>  	u64 bytenr;
> @@ -99,6 +105,8 @@ struct btrfs_delayed_ref_head {
>  
>  	spinlock_t lock;
>  	struct list_head ref_list;
> +	/* accumulate add BTRFS_ADD_DELAYED_REF nodes to this ref_add_list. */
> +	struct list_head ref_add_list;
>  
>  	struct rb_node href_node;
>  
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 3a57f99..bc2edaf 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4354,6 +4354,8 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>  						 list) {
>  			ref->in_tree = 0;
>  			list_del(&ref->list);
> +			if (!list_empty(&ref->add_list))
> +				list_del(&ref->add_list);
>  			atomic_dec(&delayed_refs->num_entries);
>  			btrfs_put_delayed_ref(ref);
>  		}
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 210c94a..1284222 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2454,13 +2454,14 @@ select_delayed_ref(struct btrfs_delayed_ref_head *head)
>  	 * the extent item from the extent tree, when there still are references
>  	 * to add, which would fail because they would not find the extent item.
>  	 */
> -	list_for_each_entry(ref, &head->ref_list, list) {
> -		if (ref->action == BTRFS_ADD_DELAYED_REF)
> -			return ref;
> -	}
> +	if (!list_empty(&head->ref_add_list))
> +		return list_entry(head->ref_add_list.next,

Please use list_first_entry

> +				struct btrfs_delayed_ref_node, add_list);
>  
> -	return list_entry(head->ref_list.next, struct btrfs_delayed_ref_node,
> -			  list);
> +	ref = list_entry(head->ref_list.next, struct btrfs_delayed_ref_node,

Same here.

> +			 list);
> +	WARN_ON(!list_empty(&ref->add_list));
> +	return ref;
>  }
>  
>  /*
> @@ -2620,6 +2621,8 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  			actual_count++;
>  			ref->in_tree = 0;
>  			list_del(&ref->list);
> +			if (!list_empty(&ref->add_list))
> +				list_del(&ref->add_list);
>  		}
>  		atomic_dec(&delayed_refs->num_entries);
