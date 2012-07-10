Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:33891 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751981Ab2GJTjb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 15:39:31 -0400
Message-ID: <4FFC84FE.7000302@gmx.net>
Date: Tue, 10 Jul 2012 21:39:42 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, daniel@quora.org, clmason@fusionio.com,
        list.btrfs@jan-o-sch.net
Subject: Re: [PATCH] Btrfs: allow delayed refs to be merged
References: <1341946331-18058-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1341946331-18058-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/10/2012 08:52 PM, Josef Bacik wrote:
> Daniel Blueman reported a bug with fio+balance on a ramdisk setup.
> Basically what happens is the balance relocates a tree block which will drop
> the implicit refs for all of its children and adds a full backref.  Once the
> block is relocated we have to add the implicit refs back, so when we cow the
> block again we add the implicit refs for its children back.  The problem
> comes when the original drop ref doesn't get run before we add the implicit
> refs back.  The delayed ref stuff will specifically prefer ADD operations
> over DROP to keep us from freeing up an extent that will have references to
> it, so we try to add the implicit ref before it is actually removed and we
> panic.  This worked fine before because the add would have just canceled the
> drop out and we would have been fine.  But the backref walking work needs to
> be able to freeze the delayed ref stuff in time so we have this ever
> increasing sequence number that gets attached to all new delayed ref updates
> which makes us not merge refs and we run into this issue.
> 
> So since the backref walking stuff doesn't get run all that often we just
> ignore the sequence updates until somebody actually tries to do the freeze.
> Then if we try to run the delayed refs we go back and try to merge them in
> case we get a sequence like this again so we do not panic.

Subvolume quota will also use it, so it might get used _very_ often.
Please give me some time to understand the problem deeper. This patch
adds a lot of complexity, and I'd prefer to find a solution that adds
none :)

Thanks,
Arne

> 
> I need the consumers of the backref resolution code to test this heavily and
> make sure it doesn't break them.  It makes Daniels original problem go away.
> Thanks,
> 
> Reported-by: Daniel J Blueman <daniel@quora.org>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/ctree.c       |    2 +-
>  fs/btrfs/ctree.h       |    4 +-
>  fs/btrfs/delayed-ref.c |  146 ++++++++++++++++++++++++++++++++++++++++--------
>  fs/btrfs/delayed-ref.h |    6 ++-
>  fs/btrfs/extent-tree.c |   20 +++++-
>  5 files changed, 146 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 8206b39..a914580 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -846,7 +846,7 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
>  		if (new_flags != 0) {
>  			ret = btrfs_set_disk_extent_flags(trans, root,
>  							  buf->start,
> -							  buf->len,
> +							  buf->len, owner,
>  							  new_flags, 0);
>  			if (ret)
>  				return ret;
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index fa5c45b..1b527bc 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2574,8 +2574,8 @@ int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  		  struct extent_buffer *buf, int full_backref, int for_cow);
>  int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
>  				struct btrfs_root *root,
> -				u64 bytenr, u64 num_bytes, u64 flags,
> -				int is_data);
> +				u64 bytenr, u64 num_bytes, u64 ref_root,
> +				u64 flags, int is_data);
>  int btrfs_free_extent(struct btrfs_trans_handle *trans,
>  		      struct btrfs_root *root,
>  		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 13ae7b0..93b7df1 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -85,7 +85,8 @@ static int comp_data_refs(struct btrfs_delayed_data_ref *ref2,
>   * type of the delayed backrefs and content of delayed backrefs.
>   */
>  static int comp_entry(struct btrfs_delayed_ref_node *ref2,
> -		      struct btrfs_delayed_ref_node *ref1)
> +		      struct btrfs_delayed_ref_node *ref1,
> +		      bool compare_seq)
>  {
>  	if (ref1->bytenr < ref2->bytenr)
>  		return -1;
> @@ -102,10 +103,12 @@ static int comp_entry(struct btrfs_delayed_ref_node *ref2,
>  	if (ref1->type > ref2->type)
>  		return 1;
>  	/* merging of sequenced refs is not allowed */
> -	if (ref1->seq < ref2->seq)
> -		return -1;
> -	if (ref1->seq > ref2->seq)
> -		return 1;
> +	if (compare_seq) {
> +		if (ref1->seq < ref2->seq)
> +			return -1;
> +		if (ref1->seq > ref2->seq)
> +			return 1;
> +	}
>  	if (ref1->type == BTRFS_TREE_BLOCK_REF_KEY ||
>  	    ref1->type == BTRFS_SHARED_BLOCK_REF_KEY) {
>  		return comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref2),
> @@ -139,7 +142,7 @@ static struct btrfs_delayed_ref_node *tree_insert(struct rb_root *root,
>  		entry = rb_entry(parent_node, struct btrfs_delayed_ref_node,
>  				 rb_node);
>  
> -		cmp = comp_entry(entry, ins);
> +		cmp = comp_entry(entry, ins, 1);
>  		if (cmp < 0)
>  			p = &(*p)->rb_left;
>  		else if (cmp > 0)
> @@ -233,6 +236,101 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
>  	return 0;
>  }
>  
> +static void inline drop_delayed_ref(struct btrfs_trans_handle *trans,
> +				    struct btrfs_delayed_ref_root *delayed_refs,
> +				    struct btrfs_delayed_ref_node *ref)
> +{
> +	rb_erase(&ref->rb_node, &delayed_refs->root);
> +	ref->in_tree = 0;
> +	btrfs_put_delayed_ref(ref);
> +	delayed_refs->num_entries--;
> +	if (trans->delayed_ref_updates)
> +		trans->delayed_ref_updates--;
> +}
> +
> +static int merge_ref(struct btrfs_trans_handle *trans,
> +		     struct btrfs_delayed_ref_root *delayed_refs,
> +		     struct btrfs_delayed_ref_node *ref,
> +		     u64 seq)
> +{
> +	struct rb_node *node;
> +	int merged = 0;
> +
> +again:
> +	node = rb_prev(&ref->rb_node);
> +	while (node) {
> +		struct btrfs_delayed_ref_node *next;
> +
> +		next = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
> +		node = rb_prev(node);
> +		if (next->bytenr != ref->bytenr)
> +			break;
> +		if (seq && next->seq > seq)
> +			break;
> +		if (comp_entry(ref, next, 0))
> +			continue;
> +
> +		/*
> +		 * We don't care about multiple adds, we just want to cancel out
> +		 * a drop+add
> +		 */
> +		if (ref->action == next->action)
> +			continue;
> +
> +		merged++;
> +		drop_delayed_ref(trans, delayed_refs, next);
> +		if (--ref->ref_mod == 0) {
> +			drop_delayed_ref(trans, delayed_refs, ref);
> +			break;
> +		}
> +		goto again;
> +	}
> +
> +	return merged;
> +}
> +
> +int btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
> +			     struct btrfs_delayed_ref_root *delayed_refs,
> +			     struct btrfs_delayed_ref_head *head)
> +{
> +	struct rb_node *node;
> +	int merged = 0;
> +	u64 seq = 0;
> +
> +	/* We didn't span seq counts for this ref head */
> +	if (likely(!head->need_merge))
> +		return 0;
> +
> +	if (!list_empty(&delayed_refs->seq_head)) {
> +		struct seq_list *elem;
> +
> +		elem = list_first_entry(&delayed_refs->seq_head,
> +					struct seq_list, list);
> +		seq = elem->seq;
> +	}
> +
> +	node = rb_prev(&head->node.rb_node);
> +	while (node) {
> +		struct btrfs_delayed_ref_node *ref;
> +
> +		ref = rb_entry(node, struct btrfs_delayed_ref_node,
> +			       rb_node);
> +		if (ref->bytenr != head->node.bytenr)
> +			break;
> +		/* We can't merge refs that are outside of our seq count */
> +		if (seq && ref->seq > seq)
> +			break;
> +		if (merge_ref(trans, delayed_refs, ref, seq)) {
> +			merged = 1;
> +			node = rb_prev(&head->node.rb_node);
> +		} else {
> +			node = rb_prev(node);
> +		}
> +	}
> +
> +	return merged;
> +}
> +
>  int btrfs_check_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs,
>  			    u64 seq)
>  {
> @@ -332,18 +430,11 @@ update_existing_ref(struct btrfs_trans_handle *trans,
>  		 * every changing the extent allocation tree.
>  		 */
>  		existing->ref_mod--;
> -		if (existing->ref_mod == 0) {
> -			rb_erase(&existing->rb_node,
> -				 &delayed_refs->root);
> -			existing->in_tree = 0;
> -			btrfs_put_delayed_ref(existing);
> -			delayed_refs->num_entries--;
> -			if (trans->delayed_ref_updates)
> -				trans->delayed_ref_updates--;
> -		} else {
> +		if (existing->ref_mod == 0)
> +			drop_delayed_ref(trans, delayed_refs, existing);
> +		else
>  			WARN_ON(existing->type == BTRFS_TREE_BLOCK_REF_KEY ||
>  				existing->type == BTRFS_SHARED_BLOCK_REF_KEY);
> -		}
>  	} else {
>  		WARN_ON(existing->type == BTRFS_TREE_BLOCK_REF_KEY ||
>  			existing->type == BTRFS_SHARED_BLOCK_REF_KEY);
> @@ -423,7 +514,7 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
>  static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>  					struct btrfs_trans_handle *trans,
>  					struct btrfs_delayed_ref_node *ref,
> -					u64 bytenr, u64 num_bytes,
> +					u64 bytenr, u64 num_bytes, u64 ref_root,
>  					int action, int is_data)
>  {
>  	struct btrfs_delayed_ref_node *existing;
> @@ -431,6 +522,7 @@ static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>  	struct btrfs_delayed_ref_root *delayed_refs;
>  	int count_mod = 1;
>  	int must_insert_reserved = 0;
> +	int need_merge = 0;
>  
>  	/*
>  	 * the head node stores the sum of all the mods, so dropping a ref
> @@ -469,6 +561,8 @@ static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>  	ref->is_head = 1;
>  	ref->in_tree = 1;
>  	ref->seq = 0;
> +	if (is_fstree(ref_root) && !list_empty(&delayed_refs->seq_head))
> +		need_merge = 1;
>  
>  	head_ref = btrfs_delayed_node_to_head(ref);
>  	head_ref->must_insert_reserved = must_insert_reserved;
> @@ -488,12 +582,16 @@ static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>  		 * allocated ref
>  		 */
>  		kfree(head_ref);
> +		head_ref = btrfs_delayed_node_to_head(existing);
>  	} else {
>  		delayed_refs->num_heads++;
>  		delayed_refs->num_heads_ready++;
>  		delayed_refs->num_entries++;
>  		trans->delayed_ref_updates++;
>  	}
> +
> +	if (!head_ref->need_merge)
> +		head_ref->need_merge = need_merge;
>  }
>  
>  /*
> @@ -525,7 +623,7 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>  	ref->is_head = 0;
>  	ref->in_tree = 1;
>  
> -	if (is_fstree(ref_root))
> +	if (is_fstree(ref_root) && !list_empty(&delayed_refs->seq_head))
>  		seq = inc_delayed_seq(delayed_refs);
>  	ref->seq = seq;
>  
> @@ -584,7 +682,7 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>  	ref->is_head = 0;
>  	ref->in_tree = 1;
>  
> -	if (is_fstree(ref_root))
> +	if (is_fstree(ref_root) && !list_empty(&delayed_refs->seq_head))
>  		seq = inc_delayed_seq(delayed_refs);
>  	ref->seq = seq;
>  
> @@ -653,7 +751,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>  	 * the spin lock
>  	 */
>  	add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
> -				   num_bytes, action, 0);
> +				   num_bytes, ref_root, action, 0);
>  
>  	add_delayed_tree_ref(fs_info, trans, &ref->node, bytenr,
>  				   num_bytes, parent, ref_root, level, action,
> @@ -702,7 +800,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>  	 * the spin lock
>  	 */
>  	add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
> -				   num_bytes, action, 1);
> +				   num_bytes, ref_root, action, 1);
>  
>  	add_delayed_data_ref(fs_info, trans, &ref->node, bytenr,
>  				   num_bytes, parent, ref_root, owner, offset,
> @@ -717,7 +815,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>  
>  int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
>  				struct btrfs_trans_handle *trans,
> -				u64 bytenr, u64 num_bytes,
> +				u64 bytenr, u64 num_bytes, u64 ref_root,
>  				struct btrfs_delayed_extent_op *extent_op)
>  {
>  	struct btrfs_delayed_ref_head *head_ref;
> @@ -733,8 +831,8 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
>  	spin_lock(&delayed_refs->lock);
>  
>  	add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
> -				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
> -				   extent_op->is_data);
> +			     num_bytes, ref_root, BTRFS_UPDATE_DELAYED_HEAD,
> +			     extent_op->is_data);
>  
>  	if (waitqueue_active(&delayed_refs->seq_wait))
>  		wake_up(&delayed_refs->seq_wait);
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index 413927f..f3cad4a 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -97,6 +97,7 @@ struct btrfs_delayed_ref_head {
>  	 */
>  	unsigned int must_insert_reserved:1;
>  	unsigned int is_data:1;
> +	unsigned int need_merge:1;
>  };
>  
>  struct btrfs_delayed_tree_ref {
> @@ -185,8 +186,11 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>  			       int for_cow);
>  int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
>  				struct btrfs_trans_handle *trans,
> -				u64 bytenr, u64 num_bytes,
> +				u64 bytenr, u64 num_bytes, u64 ref_root,
>  				struct btrfs_delayed_extent_op *extent_op);
> +int btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
> +			     struct btrfs_delayed_ref_root *delayed_refs,
> +			     struct btrfs_delayed_ref_head *head);
>  
>  struct btrfs_delayed_ref_head *
>  btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 5e552f9..fa25ca9 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2271,6 +2271,16 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>  		}
>  
>  		/*
> +		 * We need to try and merge add/drops of the same ref since we
> +		 * can run into issues with relocate dropping the implicit ref
> +		 * and then it being added back again before the drop can
> +		 * finish.  If we merged anything we need to re-loop so we can
> +		 * get a good ref.
> +		 */
> +		if (btrfs_merge_delayed_refs(trans, delayed_refs, locked_ref))
> +			continue;
> +
> +		/*
>  		 * record the must insert reserved flag before we
>  		 * drop the spin lock.
>  		 */
> @@ -2507,8 +2517,8 @@ out:
>  
>  int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
>  				struct btrfs_root *root,
> -				u64 bytenr, u64 num_bytes, u64 flags,
> -				int is_data)
> +				u64 bytenr, u64 num_bytes, u64 ref_root,
> +				u64 flags, int is_data)
>  {
>  	struct btrfs_delayed_extent_op *extent_op;
>  	int ret;
> @@ -2523,7 +2533,7 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
>  	extent_op->is_data = is_data ? 1 : 0;
>  
>  	ret = btrfs_add_delayed_extent_op(root->fs_info, trans, bytenr,
> -					  num_bytes, extent_op);
> +					  num_bytes, ref_root, extent_op);
>  	if (ret)
>  		kfree(extent_op);
>  	return ret;
> @@ -6464,7 +6474,9 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
>  		ret = btrfs_dec_ref(trans, root, eb, 0, wc->for_reloc);
>  		BUG_ON(ret); /* -ENOMEM */
>  		ret = btrfs_set_disk_extent_flags(trans, root, eb->start,
> -						  eb->len, flag, 0);
> +						  eb->len,
> +						  btrfs_header_owner(eb),
> +						  flag, 0);
>  		BUG_ON(ret); /* -ENOMEM */
>  		wc->flags[level] |= flag;
>  	}

