Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34997 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeIDWpT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 18:45:19 -0400
Received: by mail-qt0-f195.google.com with SMTP id j7-v6so5115422qtp.2
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2018 11:19:02 -0700 (PDT)
Date: Tue, 4 Sep 2018 14:18:59 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/35] btrfs: introduce delayed_refs_rsv
Message-ID: <20180904181858.vltfvtayumw52q3y@destiny>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-6-josef@toxicpanda.com>
 <4328d79a-a3ae-be2b-7505-36ed8f7f6576@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4328d79a-a3ae-be2b-7505-36ed8f7f6576@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 04, 2018 at 06:21:23PM +0300, Nikolay Borisov wrote:
> 
> 
> On 30.08.2018 20:41, Josef Bacik wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > Traditionally we've had voodoo in btrfs to account for the space that
> > delayed refs may take up by having a global_block_rsv.  This works most
> > of the time, except when it doesn't.  We've had issues reported and seen
> > in production where sometimes the global reserve is exhausted during
> > transaction commit before we can run all of our delayed refs, resulting
> > in an aborted transaction.  Because of this voodoo we have equally
> > dubious flushing semantics around throttling delayed refs which we often
> > get wrong.
> > 
> > So instead give them their own block_rsv.  This way we can always know
> > exactly how much outstanding space we need for delayed refs.  This
> > allows us to make sure we are constantly filling that reservation up
> > with space, and allows us to put more precise pressure on the enospc
> > system.  Instead of doing math to see if its a good time to throttle,
> > the normal enospc code will be invoked if we have a lot of delayed refs
> > pending, and they will be run via the normal flushing mechanism.
> > 
> > For now the delayed_refs_rsv will hold the reservations for the delayed
> > refs, the block group updates, and deleting csums.  We could have a
> > separate rsv for the block group updates, but the csum deletion stuff is
> > still handled via the delayed_refs so that will stay there.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/ctree.h             |  24 +++-
> >  fs/btrfs/delayed-ref.c       |  28 ++++-
> >  fs/btrfs/disk-io.c           |   3 +
> >  fs/btrfs/extent-tree.c       | 268 +++++++++++++++++++++++++++++++++++--------
> >  fs/btrfs/transaction.c       |  68 +++++------
> >  include/trace/events/btrfs.h |   2 +
> >  6 files changed, 294 insertions(+), 99 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 66f1d3895bca..0a4e55703d48 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -452,8 +452,9 @@ struct btrfs_space_info {
> >  #define	BTRFS_BLOCK_RSV_TRANS		3
> >  #define	BTRFS_BLOCK_RSV_CHUNK		4
> >  #define	BTRFS_BLOCK_RSV_DELOPS		5
> > -#define	BTRFS_BLOCK_RSV_EMPTY		6
> > -#define	BTRFS_BLOCK_RSV_TEMP		7
> > +#define BTRFS_BLOCK_RSV_DELREFS		6
> > +#define	BTRFS_BLOCK_RSV_EMPTY		7
> > +#define	BTRFS_BLOCK_RSV_TEMP		8
> >  
> >  struct btrfs_block_rsv {
> >  	u64 size;
> > @@ -794,6 +795,8 @@ struct btrfs_fs_info {
> >  	struct btrfs_block_rsv chunk_block_rsv;
> >  	/* block reservation for delayed operations */
> >  	struct btrfs_block_rsv delayed_block_rsv;
> > +	/* block reservation for delayed refs */
> > +	struct btrfs_block_rsv delayed_refs_rsv;
> >  
> >  	struct btrfs_block_rsv empty_block_rsv;
> >  
> > @@ -2723,10 +2726,12 @@ enum btrfs_reserve_flush_enum {
> >  enum btrfs_flush_state {
> >  	FLUSH_DELAYED_ITEMS_NR	=	1,
> >  	FLUSH_DELAYED_ITEMS	=	2,
> > -	FLUSH_DELALLOC		=	3,
> > -	FLUSH_DELALLOC_WAIT	=	4,
> > -	ALLOC_CHUNK		=	5,
> > -	COMMIT_TRANS		=	6,
> > +	FLUSH_DELAYED_REFS_NR	=	3,
> > +	FLUSH_DELAYED_REFS	=	4,
> > +	FLUSH_DELALLOC		=	5,
> > +	FLUSH_DELALLOC_WAIT	=	6,
> > +	ALLOC_CHUNK		=	7,
> > +	COMMIT_TRANS		=	8,
> >  };
> >  
> >  int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes);
> > @@ -2777,6 +2782,13 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
> >  void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
> >  			     struct btrfs_block_rsv *block_rsv,
> >  			     u64 num_bytes);
> > +void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr);
> > +void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans);
> > +int btrfs_refill_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
> > +				  enum btrfs_reserve_flush_enum flush);
> > +void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
> > +				       struct btrfs_block_rsv *src,
> > +				       u64 num_bytes);
> >  int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache);
> >  void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache);
> >  void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
> > diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> > index 27f7dd4e3d52..96ce087747b2 100644
> > --- a/fs/btrfs/delayed-ref.c
> > +++ b/fs/btrfs/delayed-ref.c
> > @@ -467,11 +467,14 @@ static int insert_delayed_ref(struct btrfs_trans_handle *trans,
> >   * existing and update must have the same bytenr
> >   */
> >  static noinline void
> > -update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
> > +update_existing_head_ref(struct btrfs_trans_handle *trans,
> >  			 struct btrfs_delayed_ref_head *existing,
> >  			 struct btrfs_delayed_ref_head *update,
> >  			 int *old_ref_mod_ret)
> >  {
> > +	struct btrfs_delayed_ref_root *delayed_refs =
> > +		&trans->transaction->delayed_refs;
> > +	struct btrfs_fs_info *fs_info = trans->fs_info;
> >  	int old_ref_mod;
> >  
> >  	BUG_ON(existing->is_data != update->is_data);
> > @@ -529,10 +532,18 @@ update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
> >  	 * versa we need to make sure to adjust pending_csums accordingly.
> >  	 */
> >  	if (existing->is_data) {
> > -		if (existing->total_ref_mod >= 0 && old_ref_mod < 0)
> > +		u64 csum_items =
> > +			btrfs_csum_bytes_to_leaves(fs_info,
> > +						   existing->num_bytes);
> > +
> > +		if (existing->total_ref_mod >= 0 && old_ref_mod < 0) {
> >  			delayed_refs->pending_csums -= existing->num_bytes;
> > -		if (existing->total_ref_mod < 0 && old_ref_mod >= 0)
> > +			btrfs_delayed_refs_rsv_release(fs_info, csum_items);
> > +		}
> > +		if (existing->total_ref_mod < 0 && old_ref_mod >= 0) {
> >  			delayed_refs->pending_csums += existing->num_bytes;
> > +			trans->delayed_ref_updates += csum_items;
> > +		}
> >  	}
> >  	spin_unlock(&existing->lock);
> >  }
> > @@ -638,7 +649,7 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
> >  			&& head_ref->qgroup_reserved
> >  			&& existing->qgroup_ref_root
> >  			&& existing->qgroup_reserved);
> > -		update_existing_head_ref(delayed_refs, existing, head_ref,
> > +		update_existing_head_ref(trans, existing, head_ref,
> >  					 old_ref_mod);
> >  		/*
> >  		 * we've updated the existing ref, free the newly
> > @@ -649,8 +660,12 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
> >  	} else {
> >  		if (old_ref_mod)
> >  			*old_ref_mod = 0;
> > -		if (head_ref->is_data && head_ref->ref_mod < 0)
> > +		if (head_ref->is_data && head_ref->ref_mod < 0) {
> >  			delayed_refs->pending_csums += head_ref->num_bytes;
> > +			trans->delayed_ref_updates +=
> > +				btrfs_csum_bytes_to_leaves(trans->fs_info,
> > +							   head_ref->num_bytes);
> > +		}
> >  		delayed_refs->num_heads++;
> >  		delayed_refs->num_heads_ready++;
> >  		atomic_inc(&delayed_refs->num_entries);
> > @@ -785,6 +800,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
> >  
> >  	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
> >  	spin_unlock(&delayed_refs->lock);
> > +	btrfs_update_delayed_refs_rsv(trans);
> 
> So this function should really be called inside update_existing_head_ref
> since that's where trans->delayed_ref_updates is modified. 2 weeks after
> this code is merged it will be complete tera incognita why it's called
> here.

Those are all done under the delayed_refs->lock, I wanted to avoid lockdep
weirdness and have this done outside of the delayed_refs->lock, hence putting it
after the add_delayed_ref_head calls.

> 
> >  
> >  	trace_add_delayed_tree_ref(fs_info, &ref->node, ref,
> >  				   action == BTRFS_ADD_DELAYED_EXTENT ?
> > @@ -866,6 +882,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
> >  
> >  	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
> >  	spin_unlock(&delayed_refs->lock);
> > +	btrfs_update_delayed_refs_rsv(trans);
> 
> ditto
> 
> >  
> >  	trace_add_delayed_data_ref(trans->fs_info, &ref->node, ref,
> >  				   action == BTRFS_ADD_DELAYED_EXTENT ?
> > @@ -903,6 +920,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
> >  			     NULL, NULL, NULL);
> >  
> >  	spin_unlock(&delayed_refs->lock);
> > +	btrfs_update_delayed_refs_rsv(trans);
> 
> ditto. See my comment above it's definition about my proposal how this
> should be fixed.
> 
> >  	return 0;
> >  }
> >  
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 5124c15705ce..0e42401756b8 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -2692,6 +2692,9 @@ int open_ctree(struct super_block *sb,
> >  	btrfs_init_block_rsv(&fs_info->empty_block_rsv, BTRFS_BLOCK_RSV_EMPTY);
> >  	btrfs_init_block_rsv(&fs_info->delayed_block_rsv,
> >  			     BTRFS_BLOCK_RSV_DELOPS);
> > +	btrfs_init_block_rsv(&fs_info->delayed_refs_rsv,
> > +			     BTRFS_BLOCK_RSV_DELREFS);
> > +
> >  	atomic_set(&fs_info->async_delalloc_pages, 0);
> >  	atomic_set(&fs_info->defrag_running, 0);
> >  	atomic_set(&fs_info->qgroup_op_seq, 0);
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 20531389a20a..6e7f350754d2 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -2472,6 +2472,7 @@ static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
> >  	struct btrfs_fs_info *fs_info = trans->fs_info;
> >  	struct btrfs_delayed_ref_root *delayed_refs =
> >  		&trans->transaction->delayed_refs;
> > +	int nr_items = 1;
> 
> Why start at 1 ?

Because we are dropping this ref_head.

> 
> >  
> >  	if (head->total_ref_mod < 0) {
> >  		struct btrfs_space_info *space_info;
> > @@ -2493,12 +2494,15 @@ static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
> >  			spin_lock(&delayed_refs->lock);
> >  			delayed_refs->pending_csums -= head->num_bytes;
> >  			spin_unlock(&delayed_refs->lock);
> > +			nr_items += btrfs_csum_bytes_to_leaves(fs_info,
> > +				head->num_bytes);
> >  		}
> >  	}
> >  
> >  	/* Also free its reserved qgroup space */
> >  	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
> >  				      head->qgroup_reserved);
> > +	btrfs_delayed_refs_rsv_release(fs_info, nr_items);
> >  }
> >  
> >  static int cleanup_ref_head(struct btrfs_trans_handle *trans,
> > @@ -2796,37 +2800,20 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes)
> >  int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
> >  				       struct btrfs_fs_info *fs_info)
> 
> nit: This function can now be changed to take just fs_info and return bool.
> 

Agreed, I'll fix this up.

> >  {
> > -	struct btrfs_block_rsv *global_rsv;
> > -	u64 num_heads = trans->transaction->delayed_refs.num_heads_ready;
> > -	u64 csum_bytes = trans->transaction->delayed_refs.pending_csums;
> > -	unsigned int num_dirty_bgs = trans->transaction->num_dirty_bgs;
> > -	u64 num_bytes, num_dirty_bgs_bytes;
> > +	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
> > +	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
> > +	u64 reserved;
> >  	int ret = 0;
> >  
> > -	num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
> > -	num_heads = heads_to_leaves(fs_info, num_heads);
> > -	if (num_heads > 1)
> > -		num_bytes += (num_heads - 1) * fs_info->nodesize;
> > -	num_bytes <<= 1;
> > -	num_bytes += btrfs_csum_bytes_to_leaves(fs_info, csum_bytes) *
> > -							fs_info->nodesize;
> > -	num_dirty_bgs_bytes = btrfs_calc_trans_metadata_size(fs_info,
> > -							     num_dirty_bgs);
> > -	global_rsv = &fs_info->global_block_rsv;
> > -
> > -	/*
> > -	 * If we can't allocate any more chunks lets make sure we have _lots_ of
> > -	 * wiggle room since running delayed refs can create more delayed refs.
> > -	 */
> > -	if (global_rsv->space_info->full) {
> > -		num_dirty_bgs_bytes <<= 1;
> > -		num_bytes <<= 1;
> > -	}
> > -
> >  	spin_lock(&global_rsv->lock);
> > -	if (global_rsv->reserved <= num_bytes + num_dirty_bgs_bytes)
> > -		ret = 1;
> > +	reserved = global_rsv->reserved;
> >  	spin_unlock(&global_rsv->lock);
> > +
> > +	spin_lock(&delayed_refs_rsv->lock);
> > +	reserved += delayed_refs_rsv->reserved;
> > +	if (delayed_refs_rsv->size >= reserved)
> > +		ret = 1;
> > +	spin_unlock(&delayed_refs_rsv->lock);
> >  	return ret;
> >  }
> >  
> > @@ -3601,6 +3588,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
> >  	 */
> >  	mutex_lock(&trans->transaction->cache_write_mutex);
> >  	while (!list_empty(&dirty)) {
> > +		bool drop_reserve = true;
> > +
> >  		cache = list_first_entry(&dirty,
> >  					 struct btrfs_block_group_cache,
> >  					 dirty_list);
> > @@ -3673,6 +3662,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
> >  					list_add_tail(&cache->dirty_list,
> >  						      &cur_trans->dirty_bgs);
> >  					btrfs_get_block_group(cache);
> > +					drop_reserve = false;
> >  				}
> >  				spin_unlock(&cur_trans->dirty_bgs_lock);
> >  			} else if (ret) {
> > @@ -3683,6 +3673,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
> >  		/* if its not on the io list, we need to put the block group */
> >  		if (should_put)
> >  			btrfs_put_block_group(cache);
> > +		if (drop_reserve)
> > +			btrfs_delayed_refs_rsv_release(fs_info, 1);
> >  
> >  		if (ret)
> >  			break;
> > @@ -3831,6 +3823,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
> >  		/* if its not on the io list, we need to put the block group */
> >  		if (should_put)
> >  			btrfs_put_block_group(cache);
> > +		btrfs_delayed_refs_rsv_release(fs_info, 1);
> >  		spin_lock(&cur_trans->dirty_bgs_lock);
> >  	}
> >  	spin_unlock(&cur_trans->dirty_bgs_lock);
> > @@ -4807,8 +4800,10 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
> >  {
> >  	struct reserve_ticket *ticket = NULL;
> >  	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_block_rsv;
> > +	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
> >  	struct btrfs_trans_handle *trans;
> >  	u64 bytes;
> > +	u64 reclaim_bytes = 0;
> >  
> >  	trans = (struct btrfs_trans_handle *)current->journal_info;
> >  	if (trans)
> > @@ -4841,12 +4836,16 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
> >  		return -ENOSPC;
> >  
> >  	spin_lock(&delayed_rsv->lock);
> > -	if (delayed_rsv->size > bytes)
> > -		bytes = 0;
> > -	else
> > -		bytes -= delayed_rsv->size;
> > +	reclaim_bytes += delayed_rsv->reserved;
> >  	spin_unlock(&delayed_rsv->lock);
> >  
> > +	spin_lock(&delayed_refs_rsv->lock);
> > +	reclaim_bytes += delayed_refs_rsv->reserved;
> > +	spin_unlock(&delayed_refs_rsv->lock);
> > +	if (reclaim_bytes >= bytes)
> > +		goto commit;
> > +	bytes -= reclaim_bytes;
> > +
> >  	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
> >  				   bytes,
> >  				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0) {
> > @@ -4896,6 +4895,20 @@ static void flush_space(struct btrfs_fs_info *fs_info,
> >  		shrink_delalloc(fs_info, num_bytes * 2, num_bytes,
> >  				state == FLUSH_DELALLOC_WAIT);
> >  		break;
> > +	case FLUSH_DELAYED_REFS_NR:
> > +	case FLUSH_DELAYED_REFS:
> > +		trans = btrfs_join_transaction(root);
> > +		if (IS_ERR(trans)) {
> > +			ret = PTR_ERR(trans);
> > +			break;
> > +		}
> > +		if (state == FLUSH_DELAYED_REFS_NR)
> > +			nr = calc_reclaim_items_nr(fs_info, num_bytes);
> > +		else
> > +			nr = 0;
> 
> The nr argument to btrfs_run_delayed_refs seems to be a bit cumbersome.
> It can have 3 values:
> 
> some positive number - then run this many entries
> -1 - sets the run_all in btrfs_run_delayed_refs , which will run all
> delayed refs, including newly added ones + will execute some additional
> code.
> 
> 0 - will run all current (but not newly added) delayed refs. IMHO this
> needs to be documented. Currently btrfs_run_delayed_refs only documents
> 0 and a positive number.
> 
> So in case of FLUSH_DELAYED_REFS do we want 0 or -1 ?
> 

Yeah this is confusing, probably should have an enum for 0/-1 so it's clear
what's going on.  I'm not sure -1 is what we want here, we'll get down to that
if we commit the transaction, and at that point we know wether we'll get what we
want from the delayed refs rsv if we commit the transaction.  I'm inclined to
leave it as 0 here and only use -1 for commits.

> > +		btrfs_run_delayed_refs(trans, nr);
> > +		btrfs_end_transaction(trans);
> > +		break;
> >  	case ALLOC_CHUNK:
> >  		trans = btrfs_join_transaction(root);
> >  		if (IS_ERR(trans)) {
> > @@ -5368,6 +5381,93 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
> >  	return 0;
> >  }
> >  
> > +/**
> > + * btrfs_migrate_to_delayed_refs_rsv - transfer bytes to our delayed refs rsv.
> > + * @fs_info - the fs info for our fs.
> > + * @src - the source block rsv to transfer from.
> > + * @num_bytes - the number of bytes to transfer.
> > + *
> > + * This transfers up to the num_bytes amount from the src rsv to the
> > + * delayed_refs_rsv.  Any extra bytes are returned to the space info.
> > + */
> > +void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
> > +				       struct btrfs_block_rsv *src,
> > +				       u64 num_bytes)
> > +{
> > +	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
> > +	u64 to_free = 0;
> > +
> > +	spin_lock(&src->lock);
> > +	src->reserved -= num_bytes;
> > +	src->size -= num_bytes;
> > +	spin_unlock(&src->lock);
> > +
> > +	spin_lock(&delayed_refs_rsv->lock);
> > +	if (delayed_refs_rsv->size > delayed_refs_rsv->reserved) {
> > +		u64 delta = delayed_refs_rsv->size -
> > +			delayed_refs_rsv->reserved;
> > +		if (num_bytes > delta) {
> > +			to_free = num_bytes - delta;
> > +			num_bytes = delta;
> > +		}
> 
> I find this a bit dodgy. Because delta is really the amount of space we
> can still reserve in the delayed_refs_rsv. So if we want to migrate,
> say, 150kb but we only have space for 50 that is delta = 50 what will
> happen is :
> 
> to_free = 150 - 50 = 100k
> num_bytes = 50k
> 
> So we will increase the reservation by 50k because that's  how many free
> bytes are in delayed_resv_rsv and then why do we free the rest 100k,
> aren't they still reserved and required, by freeing them via
> space_info_add_old_bytes aren't you essentially overcomitting?
> 

No, you are misunderstanding what the purpose of this helper is.  We don't know
how much delayed refs space we need to refill at the transaction start time, so
instead of paying the cost of finding out for sure or trying to read rsv->size
and rsv->reserved outside of the lock and hoping you are right we just allocate
2x our requested reservation.  So then we call into migrate() with the amount we
have pre-reserved.  Now we may not need any or all of this reservation, which is
why we will free some of it.  So in your case we have come into this with 150kb
of reservation that we can hand directly over to the delayed refs rsv.  If we
are only short 50k of our reservation, iow we have a rsv->size == 150k an
rsv->reserved == 100k, then we only need 50k of that 150k reservation we are
trying to migrate.  So we take the 50k that we need to make our rsv full and we
free up the remaining 100k that is no longer needed.

> > +	} else {
> > +		to_free = num_bytes;
> > +		num_bytes = 0;
> > +	}
> > +
> > +	if (num_bytes)
> > +		delayed_refs_rsv->reserved += num_bytes;
> > +	if (delayed_refs_rsv->reserved >= delayed_refs_rsv->size)
> > +		delayed_refs_rsv->full = 1;
> > +	spin_unlock(&delayed_refs_rsv->lock);
> > +
> > +	if (num_bytes)
> > +		trace_btrfs_space_reservation(fs_info, "delayed_refs_rsv",
> > +					      0, num_bytes, 1);
> > +	if (to_free)
> > +		space_info_add_old_bytes(fs_info, delayed_refs_rsv->space_info,
> > +					 to_free);
> > +}
> > +
> > +/**
> > + * btrfs_refill_delayed_refs_rsv - refill the delayed block rsv.
> > + * @fs_info - the fs_info for our fs.
> > + * @flush - control how we can flush for this reservation.
> > + *
> > + * This will refill the delayed block_rsv up to 1 items size worth of space an> + * will return -ENOSPC if we can't make the reservation.
> > + */
> > +int btrfs_refill_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
> > +				  enum btrfs_reserve_flush_enum flush)
> > +{
> > +	struct btrfs_block_rsv *block_rsv = &fs_info->delayed_refs_rsv;
> > +	u64 limit = btrfs_calc_trans_metadata_size(fs_info, 1);
> > +	u64 num_bytes = 0;
> > +	int ret = -ENOSPC;
> > +
> > +	spin_lock(&block_rsv->lock);
> > +	if (block_rsv->reserved < block_rsv->size) {
> > +		num_bytes = block_rsv->size - block_rsv->reserved;
> > +		num_bytes = min(num_bytes, limit);
> 
> This seems arbitrary, do you have any rationale for setting the upper
> bound at 1 item?
> 

Because it's more of a throttling thing, so maybe I should rename it to
btrfs_throttle_delayed_refs_rsv().  It's used for truncate, where we can break
out and make full reservations, and for btrfs_start_transaciton(0), both cases
where we want to throttle if we're under pressure but not wait forever because
we've got shit to do.  I'll rename this to make it more clear.

> > +	}
> > +	spin_unlock(&block_rsv->lock);
> > +
> > +	if (!num_bytes)
> > +		return 0;
> > +
> > +	ret = reserve_metadata_bytes(fs_info->extent_root, block_rsv,
> > +				     num_bytes, flush);
> > +	if (!ret) {
> > +		block_rsv_add_bytes(block_rsv, num_bytes, 0);
> > +		trace_btrfs_space_reservation(fs_info, "delayed_refs_rsv",
> > +					      0, num_bytes, 1);
> > +		return 0;
> > +	}
> 
> nit: Why not if (ret) return ret for the error case and just have  the
> block_rsv_add and trace_btrfs_space reservation be on the previous
> indent level. It's just that the preferred way is to have the error
> conditions handled in the if block rather than the normal execution path.
> 

Yup I'll fix this.

> > +
> > +	return ret;
> > +}
> > +
> > +
> >  /*
> >   * This is for space we already have accounted in space_info->bytes_may_use, so
> >   * basically when we're returning space from block_rsv's.
> > @@ -5690,6 +5790,31 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
> >  	return ret;
> >  }
> >  
> > +static u64 __btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
> > +				     struct btrfs_block_rsv *block_rsv,
> > +				     u64 num_bytes, u64 *qgroup_to_release)
> > +{
> > +	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
> > +	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_refs_rsv;
> > +	struct btrfs_block_rsv *target = delayed_rsv;
> > +
> > +	if (target->full || target == block_rsv)
> > +		target = global_rsv;
> > +
> > +	if (block_rsv->space_info != target->space_info)
> > +		target = NULL;
> > +
> > +	return block_rsv_release_bytes(fs_info, block_rsv, target, num_bytes,
> > +				       qgroup_to_release);
> > +}
> > +
> > +void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
> > +			     struct btrfs_block_rsv *block_rsv,
> > +			     u64 num_bytes)
> > +{
> > +	__btrfs_block_rsv_release(fs_info, block_rsv, num_bytes, NULL);
> > +}
> > +
> >  /**
> >   * btrfs_inode_rsv_release - release any excessive reservation.
> >   * @inode - the inode we need to release from.
> > @@ -5704,7 +5829,6 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
> >  static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
> >  {
> >  	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > -	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
> >  	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
> >  	u64 released = 0;
> >  	u64 qgroup_to_release = 0;
> > @@ -5714,8 +5838,8 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
> >  	 * are releasing 0 bytes, and then we'll just get the reservation over
> >  	 * the size free'd.
> >  	 */
> > -	released = block_rsv_release_bytes(fs_info, block_rsv, global_rsv, 0,
> > -					   &qgroup_to_release);
> > +	released = __btrfs_block_rsv_release(fs_info, block_rsv, 0,
> > +					     &qgroup_to_release);
> >  	if (released > 0)
> >  		trace_btrfs_space_reservation(fs_info, "delalloc",
> >  					      btrfs_ino(inode), released, 0);
> > @@ -5726,16 +5850,25 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
> >  						   qgroup_to_release);
> >  }
> >  
> > -void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
> > -			     struct btrfs_block_rsv *block_rsv,
> > -			     u64 num_bytes)
> > +/**
> > + * btrfs_delayed_refs_rsv_release - release a ref head's reservation.
> > + * @fs_info - the fs_info for our fs.
> 
> Missing description of the nr parameter.
> 

Will fix.

> > + *
> > + * This drops the delayed ref head's count from the delayed refs rsv and free's
> > + * any excess reservation we had.
> > + */
> > +void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr)
> >  {
> > +	struct btrfs_block_rsv *block_rsv = &fs_info->delayed_refs_rsv;
> >  	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
> > +	u64 num_bytes = btrfs_calc_trans_metadata_size(fs_info, nr);
> > +	u64 released = 0;
> >  
> > -	if (global_rsv == block_rsv ||
> > -	    block_rsv->space_info != global_rsv->space_info)
> > -		global_rsv = NULL;
> > -	block_rsv_release_bytes(fs_info, block_rsv, global_rsv, num_bytes, NULL);
> > +	released = block_rsv_release_bytes(fs_info, block_rsv, global_rsv,
> > +					   num_bytes, NULL);
> > +	if (released)
> > +		trace_btrfs_space_reservation(fs_info, "delayed_refs_rsv",
> > +					      0, released, 0);
> >  }
> >  
> >  static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
> > @@ -5800,9 +5933,10 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
> >  	fs_info->trans_block_rsv.space_info = space_info;
> >  	fs_info->empty_block_rsv.space_info = space_info;
> >  	fs_info->delayed_block_rsv.space_info = space_info;
> > +	fs_info->delayed_refs_rsv.space_info = space_info;
> >  
> > -	fs_info->extent_root->block_rsv = &fs_info->global_block_rsv;
> > -	fs_info->csum_root->block_rsv = &fs_info->global_block_rsv;
> > +	fs_info->extent_root->block_rsv = &fs_info->delayed_refs_rsv;
> > +	fs_info->csum_root->block_rsv = &fs_info->delayed_refs_rsv;
> >  	fs_info->dev_root->block_rsv = &fs_info->global_block_rsv;
> >  	fs_info->tree_root->block_rsv = &fs_info->global_block_rsv;
> >  	if (fs_info->quota_root)
> > @@ -5822,8 +5956,34 @@ static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
> >  	WARN_ON(fs_info->chunk_block_rsv.reserved > 0);
> >  	WARN_ON(fs_info->delayed_block_rsv.size > 0);
> >  	WARN_ON(fs_info->delayed_block_rsv.reserved > 0);
> > +	WARN_ON(fs_info->delayed_refs_rsv.reserved > 0);
> > +	WARN_ON(fs_info->delayed_refs_rsv.size > 0);
> >  }
> >  
> > +/*
> > + * btrfs_update_delayed_refs_rsv - adjust the size of the delayed refs rsv
> > + * @trans - the trans that may have generated delayed refs
> > + *
> > + * This is to be called anytime we may have adjusted trans->delayed_ref_updates,
> > + * it'll calculate the additional size and add it to the delayed_refs_rsv.
> > + */
> 
> Why don't you make a function btrfs_trans_delayed_ref_updates or some
> such which sets ->delayed_refs_updates and runs this code. If it is
> mandatory to have both events occur together then it makes sense to have
> a setter function which does that, rather than putting the burden on
> future users of the code.
> 

Because locking weirdness.  We update the delayed_refs_updates under different
locking scenarios and I got lockdep splats because of the fucked up calls it
generated.  Plus this way we can batch a bunch of updates together.

> > +void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans)
> > +{
> > +	struct btrfs_fs_info *fs_info = trans->fs_info;
> > +	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_refs_rsv;
> > +	u64 num_bytes;
> > +
> > +	if (!trans->delayed_ref_updates)
> > +		return;
> > +
> > +	num_bytes = btrfs_calc_trans_metadata_size(fs_info,
> > +						   trans->delayed_ref_updates);
> > +	spin_lock(&delayed_rsv->lock);
> > +	delayed_rsv->size += num_bytes;
> > +	delayed_rsv->full = 0;
> > +	spin_unlock(&delayed_rsv->lock);
> > +	trans->delayed_ref_updates = 0;
> > +}
> >  
> >  /*
> >   * To be called after all the new block groups attached to the transaction
> > @@ -6117,6 +6277,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
> >  	u64 old_val;
> >  	u64 byte_in_group;
> >  	int factor;
> > +	int ret = 0;
> >  
> >  	/* block accounting for super block */
> >  	spin_lock(&info->delalloc_root_lock);
> > @@ -6130,8 +6291,10 @@ static int update_block_group(struct btrfs_trans_handle *trans,
> >  
> >  	while (total) {
> >  		cache = btrfs_lookup_block_group(info, bytenr);
> > -		if (!cache)
> > -			return -ENOENT;
> > +		if (!cache) {
> > +			ret = -ENOENT;
> > +			break;
> > +		}
> >  		factor = btrfs_bg_type_to_factor(cache->flags);
> >  
> >  		/*
> > @@ -6190,6 +6353,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
> >  			list_add_tail(&cache->dirty_list,
> >  				      &trans->transaction->dirty_bgs);
> >  			trans->transaction->num_dirty_bgs++;
> > +			trans->delayed_ref_updates++;
> >  			btrfs_get_block_group(cache);
> >  		}
> >  		spin_unlock(&trans->transaction->dirty_bgs_lock);
> > @@ -6207,7 +6371,8 @@ static int update_block_group(struct btrfs_trans_handle *trans,
> >  		total -= num_bytes;
> >  		bytenr += num_bytes;
> >  	}
> > -	return 0;
> > +	btrfs_update_delayed_refs_rsv(trans);
> 
> Here it's not even clear where exactly the trans->delayed_ref_updates
> have been modified.

I'll add a comment.

> 
> > +	return ret;
> >  }
> >  
> >  static u64 first_logical_byte(struct btrfs_fs_info *fs_info, u64 search_start)
> > @@ -8221,7 +8386,12 @@ use_block_rsv(struct btrfs_trans_handle *trans,
> >  		goto again;
> >  	}
> >  
> > -	if (btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
> > +	/*
> > +	 * The global reserve still exists to save us from ourselves, so don't
> > +	 * warn_on if we are short on our delayed refs reserve.
> > +	 */
> > +	if (block_rsv->type != BTRFS_BLOCK_RSV_DELREFS &&
> > +	    btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
> >  		static DEFINE_RATELIMIT_STATE(_rs,
> >  				DEFAULT_RATELIMIT_INTERVAL * 10,
> >  				/*DEFAULT_RATELIMIT_BURST*/ 1);
> > @@ -10251,6 +10421,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
> >  	int factor;
> >  	struct btrfs_caching_control *caching_ctl = NULL;
> >  	bool remove_em;
> > +	bool remove_rsv = false;
> >  
> >  	block_group = btrfs_lookup_block_group(fs_info, group_start);
> >  	BUG_ON(!block_group);
> > @@ -10315,6 +10486,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
> >  
> >  	if (!list_empty(&block_group->dirty_list)) {
> >  		list_del_init(&block_group->dirty_list);
> > +		remove_rsv = true;
> >  		btrfs_put_block_group(block_group);
> >  	}
> >  	spin_unlock(&trans->transaction->dirty_bgs_lock);
> > @@ -10524,6 +10696,8 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
> >  
> >  	ret = btrfs_del_item(trans, root, path);
> >  out:
> > +	if (remove_rsv)
> > +		btrfs_delayed_refs_rsv_release(fs_info, 1);
> >  	btrfs_free_path(path);
> >  	return ret;
> >  }
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 3b84f5015029..99741254e27e 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -455,7 +455,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
> >  		  bool enforce_qgroups)
> >  {
> >  	struct btrfs_fs_info *fs_info = root->fs_info;
> > -
> > +	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
> >  	struct btrfs_trans_handle *h;
> >  	struct btrfs_transaction *cur_trans;
> >  	u64 num_bytes = 0;
> > @@ -484,6 +484,9 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
> >  	 * the appropriate flushing if need be.
> >  	 */
> >  	if (num_items && root != fs_info->chunk_root) {
> > +		struct btrfs_block_rsv *rsv = &fs_info->trans_block_rsv;
> > +		u64 delayed_refs_bytes = 0;
> > +
> >  		qgroup_reserved = num_items * fs_info->nodesize;
> >  		ret = btrfs_qgroup_reserve_meta_pertrans(root, qgroup_reserved,
> >  				enforce_qgroups);
> > @@ -491,6 +494,11 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
> >  			return ERR_PTR(ret);
> >  
> >  		num_bytes = btrfs_calc_trans_metadata_size(fs_info, num_items);
> > +		if (delayed_refs_rsv->full == 0) {
> > +			delayed_refs_bytes = num_bytes;
> > +			num_bytes <<= 1;
> 
> The doubling here is needed because when you reserve doubel the
> transaction space, half of it is migrated to the delayed_refs_resv. A
> comment will be nice hinting at that voodoo.
> 
> Instead of doing this back-and-forth dance can't you call
> btrfs_block_rsv_add once for each of trans_rsv and delayed_refs_rsv,
> this will be a lot more self-documenting and explicit.

No we really don't want this.  We want to pay the price of the enospc flushing
once, so we reserve all of our potential amount up front in one go and deal with
the result after.  I'll add a comment.

Josef
