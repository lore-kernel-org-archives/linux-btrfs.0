Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68347C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 09:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1917D20672
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 09:14:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1917D20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbeKZUHr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 15:07:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:37236 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726177AbeKZUHq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 15:07:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A8A5BACE3;
        Mon, 26 Nov 2018 09:14:14 +0000 (UTC)
Subject: Re: [PATCH 5/6] btrfs: introduce delayed_refs_rsv
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
 <20181121185912.24288-6-josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <3ca2ff06-6efa-e371-28ad-fb2ccf387f35@suse.com>
Date:   Mon, 26 Nov 2018 11:14:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181121185912.24288-6-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 21.11.18 г. 20:59 ч., Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Traditionally we've had voodoo in btrfs to account for the space that
> delayed refs may take up by having a global_block_rsv.  This works most
> of the time, except when it doesn't.  We've had issues reported and seen
> in production where sometimes the global reserve is exhausted during
> transaction commit before we can run all of our delayed refs, resulting
> in an aborted transaction.  Because of this voodoo we have equally
> dubious flushing semantics around throttling delayed refs which we often
> get wrong.
> 
> So instead give them their own block_rsv.  This way we can always know
> exactly how much outstanding space we need for delayed refs.  This
> allows us to make sure we are constantly filling that reservation up
> with space, and allows us to put more precise pressure on the enospc
> system.  Instead of doing math to see if its a good time to throttle,
> the normal enospc code will be invoked if we have a lot of delayed refs
> pending, and they will be run via the normal flushing mechanism.
> 
> For now the delayed_refs_rsv will hold the reservations for the delayed
> refs, the block group updates, and deleting csums.  We could have a
> separate rsv for the block group updates, but the csum deletion stuff is
> still handled via the delayed_refs so that will stay there.

Couldn't the same "no premature ENOSPC in critical section" effect be
achieved if we simply allocate 2* num bytes in start transaction without
adding the additional granularity for delayd refs? There seems to be a
lot of supporting code added  and this obfuscates the simple idea that
now we do 2* reservation and put it in a separate block_rsv structure.

> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/ctree.h             |  26 ++--
>  fs/btrfs/delayed-ref.c       |  28 ++++-
>  fs/btrfs/disk-io.c           |   4 +
>  fs/btrfs/extent-tree.c       | 279 +++++++++++++++++++++++++++++++++++--------
>  fs/btrfs/inode.c             |   4 +-
>  fs/btrfs/transaction.c       |  77 ++++++------
>  include/trace/events/btrfs.h |   2 +
>  7 files changed, 313 insertions(+), 107 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 8b41ec42f405..0c6d589c8ce4 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -448,8 +448,9 @@ struct btrfs_space_info {
>  #define	BTRFS_BLOCK_RSV_TRANS		3
>  #define	BTRFS_BLOCK_RSV_CHUNK		4
>  #define	BTRFS_BLOCK_RSV_DELOPS		5
> -#define	BTRFS_BLOCK_RSV_EMPTY		6
> -#define	BTRFS_BLOCK_RSV_TEMP		7
> +#define BTRFS_BLOCK_RSV_DELREFS		6
> +#define	BTRFS_BLOCK_RSV_EMPTY		7
> +#define	BTRFS_BLOCK_RSV_TEMP		8
>  
>  struct btrfs_block_rsv {
>  	u64 size;
> @@ -812,6 +813,8 @@ struct btrfs_fs_info {
>  	struct btrfs_block_rsv chunk_block_rsv;
>  	/* block reservation for delayed operations */
>  	struct btrfs_block_rsv delayed_block_rsv;
> +	/* block reservation for delayed refs */
> +	struct btrfs_block_rsv delayed_refs_rsv;
>  
>  	struct btrfs_block_rsv empty_block_rsv;
>  
> @@ -2628,7 +2631,7 @@ static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_fs_info *fs_info,
>  }
>  
>  int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans);
> -int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans);
> +bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info);
>  void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
>  					 const u64 start);
>  void btrfs_wait_block_group_reservations(struct btrfs_block_group_cache *bg);
> @@ -2742,10 +2745,12 @@ enum btrfs_reserve_flush_enum {
>  enum btrfs_flush_state {
>  	FLUSH_DELAYED_ITEMS_NR	=	1,
>  	FLUSH_DELAYED_ITEMS	=	2,
> -	FLUSH_DELALLOC		=	3,
> -	FLUSH_DELALLOC_WAIT	=	4,
> -	ALLOC_CHUNK		=	5,
> -	COMMIT_TRANS		=	6,
> +	FLUSH_DELAYED_REFS_NR	=	3,
> +	FLUSH_DELAYED_REFS	=	4,
> +	FLUSH_DELALLOC		=	5,
> +	FLUSH_DELALLOC_WAIT	=	6,
> +	ALLOC_CHUNK		=	7,
> +	COMMIT_TRANS		=	8,
>  };
>  
>  int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes);
> @@ -2796,6 +2801,13 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
>  void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
>  			     struct btrfs_block_rsv *block_rsv,
>  			     u64 num_bytes);
> +void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr);
> +void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans);
> +int btrfs_throttle_delayed_refs(struct btrfs_fs_info *fs_info,
> +				enum btrfs_reserve_flush_enum flush);
> +void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
> +				       struct btrfs_block_rsv *src,
> +				       u64 num_bytes);
>  int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache);
>  void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache);
>  void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 48725fa757a3..96de92588f06 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -474,11 +474,14 @@ static int insert_delayed_ref(struct btrfs_trans_handle *trans,
>   * existing and update must have the same bytenr
>   */
>  static noinline void
> -update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
> +update_existing_head_ref(struct btrfs_trans_handle *trans,
>  			 struct btrfs_delayed_ref_head *existing,
>  			 struct btrfs_delayed_ref_head *update,
>  			 int *old_ref_mod_ret)
>  {
> +	struct btrfs_delayed_ref_root *delayed_refs =
> +		&trans->transaction->delayed_refs;
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>  	int old_ref_mod;
>  
>  	BUG_ON(existing->is_data != update->is_data);
> @@ -536,10 +539,18 @@ update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
>  	 * versa we need to make sure to adjust pending_csums accordingly.
>  	 */
>  	if (existing->is_data) {
> -		if (existing->total_ref_mod >= 0 && old_ref_mod < 0)
> +		u64 csum_items =

The name is a bit of misnomer, what csum_items really holds is the
number of btree leaves require to store them.

> +			btrfs_csum_bytes_to_leaves(fs_info,
> +						   existing->num_bytes);
> +
> +		if (existing->total_ref_mod >= 0 && old_ref_mod < 0) {
>  			delayed_refs->pending_csums -= existing->num_bytes;
> -		if (existing->total_ref_mod < 0 && old_ref_mod >= 0)
> +			btrfs_delayed_refs_rsv_release(fs_info, csum_items);
> +		}
> +		if (existing->total_ref_mod < 0 && old_ref_mod >= 0) {
>  			delayed_refs->pending_csums += existing->num_bytes;
> +			trans->delayed_ref_updates += csum_items;

Now with addition to tracking the number of delayed heads/ref,
delayed_ref_updates now also tracks the number of csum leaves. Doesn't
this make the number in delayed_ref_updates a bit of a mess?

Additionally, shouldn't delayed_ref_updates really track only refs
otherwise double accounting occurs. I.e for a brand-new ref insertion we
create a head so increment delayed_ref_updates once in
add_delayed_ref_head, then we create the ref and increment it again in
insert_delayed_ref?


> +		}
>  	}
>  	spin_unlock(&existing->lock);
>  }
> @@ -645,7 +656,7 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
>  			&& head_ref->qgroup_reserved
>  			&& existing->qgroup_ref_root
>  			&& existing->qgroup_reserved);
> -		update_existing_head_ref(delayed_refs, existing, head_ref,
> +		update_existing_head_ref(trans, existing, head_ref,
>  					 old_ref_mod);
>  		/*
>  		 * we've updated the existing ref, free the newly
> @@ -656,8 +667,12 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
>  	} else {
>  		if (old_ref_mod)
>  			*old_ref_mod = 0;
> -		if (head_ref->is_data && head_ref->ref_mod < 0)
> +		if (head_ref->is_data && head_ref->ref_mod < 0) {

nit: I think for the sake of consistency you must really check
head_ref->total_ref_mod as per the code in:

1262133b8d6f ("Btrfs: account for crcs in delayed ref processing")

Additionally the comment above total_ref_mod also documents this.

Here it's guaranteed that head_ref->ref_mod and ->total_ref_mod are
identical.

>  			delayed_refs->pending_csums += head_ref->num_bytes;
> +			trans->delayed_ref_updates +=
> +				btrfs_csum_bytes_to_leaves(trans->fs_info,
> +							   head_ref->num_bytes);
> +		}
>  		delayed_refs->num_heads++;
>  		delayed_refs->num_heads_ready++;
>  		atomic_inc(&delayed_refs->num_entries);
> @@ -792,6 +807,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>  
>  	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
>  	spin_unlock(&delayed_refs->lock);
> +	btrfs_update_delayed_refs_rsv(trans);
>  
>  	trace_add_delayed_tree_ref(fs_info, &ref->node, ref,
>  				   action == BTRFS_ADD_DELAYED_EXTENT ?
> @@ -873,6 +889,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
>  
>  	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
>  	spin_unlock(&delayed_refs->lock);
> +	btrfs_update_delayed_refs_rsv(trans);

As stated previously this call to btrfs_update_delayed_refs_rsv is
really paired with the code that was executed in add_delayed_ref_head.
Since it's not really obvious from first look at least a comment would
be fine. Or better yet (as suggested previously) just make updating the
delayed_refs_updates and the resv one operation. I don't see how this
function adds much to the critical section of delayed_refs->lock. The
interface you give is really error-prone.

>  
>  	trace_add_delayed_data_ref(trans->fs_info, &ref->node, ref,
>  				   action == BTRFS_ADD_DELAYED_EXTENT ?
> @@ -910,6 +927,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
>  			     NULL, NULL, NULL);
>  
>  	spin_unlock(&delayed_refs->lock);
> +	btrfs_update_delayed_refs_rsv(trans);
Ditto

>  	return 0;
>  }
>  
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 55e8ca782b98..beaa58e742b5 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2666,6 +2666,9 @@ int open_ctree(struct super_block *sb,
>  	btrfs_init_block_rsv(&fs_info->empty_block_rsv, BTRFS_BLOCK_RSV_EMPTY);
>  	btrfs_init_block_rsv(&fs_info->delayed_block_rsv,
>  			     BTRFS_BLOCK_RSV_DELOPS);
> +	btrfs_init_block_rsv(&fs_info->delayed_refs_rsv,
> +			     BTRFS_BLOCK_RSV_DELREFS);
> +
>  	atomic_set(&fs_info->async_delalloc_pages, 0);
>  	atomic_set(&fs_info->defrag_running, 0);
>  	atomic_set(&fs_info->qgroup_op_seq, 0);
> @@ -4413,6 +4416,7 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
>  
>  		spin_unlock(&cur_trans->dirty_bgs_lock);
>  		btrfs_put_block_group(cache);
> +		btrfs_delayed_refs_rsv_release(fs_info, 1);
>  		spin_lock(&cur_trans->dirty_bgs_lock);
>  	}
>  	spin_unlock(&cur_trans->dirty_bgs_lock);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 8a776dc9cb38..8af68b13fa27 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2463,6 +2463,7 @@ static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
>  	struct btrfs_fs_info *fs_info = trans->fs_info;
>  	struct btrfs_delayed_ref_root *delayed_refs =
>  		&trans->transaction->delayed_refs;
> +	int nr_items = 1;

This 1 is a magic value, where does it come from?

>  
>  	if (head->total_ref_mod < 0) {
>  		struct btrfs_space_info *space_info;
> @@ -2484,12 +2485,15 @@ static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
>  			spin_lock(&delayed_refs->lock);
>  			delayed_refs->pending_csums -= head->num_bytes;
>  			spin_unlock(&delayed_refs->lock);
> +			nr_items += btrfs_csum_bytes_to_leaves(fs_info,
> +				head->num_bytes);
>  		}
>  	}
>  
>  	/* Also free its reserved qgroup space */
>  	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
>  				      head->qgroup_reserved);
> +	btrfs_delayed_refs_rsv_release(fs_info, nr_items);
>  }
>  
>  static int cleanup_ref_head(struct btrfs_trans_handle *trans,
> @@ -2831,40 +2835,22 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes)
>  	return num_csums;
>  }
>  
> -int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans)
> +bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info)
>  {
> -	struct btrfs_fs_info *fs_info = trans->fs_info;
> -	struct btrfs_block_rsv *global_rsv;
> -	u64 num_heads = trans->transaction->delayed_refs.num_heads_ready;
> -	u64 csum_bytes = trans->transaction->delayed_refs.pending_csums;
> -	unsigned int num_dirty_bgs = trans->transaction->num_dirty_bgs;
> -	u64 num_bytes, num_dirty_bgs_bytes;
> -	int ret = 0;
> -
> -	num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
> -	num_heads = heads_to_leaves(fs_info, num_heads);
> -	if (num_heads > 1)
> -		num_bytes += (num_heads - 1) * fs_info->nodesize;
> -	num_bytes <<= 1;
> -	num_bytes += btrfs_csum_bytes_to_leaves(fs_info, csum_bytes) *
> -							fs_info->nodesize;
> -	num_dirty_bgs_bytes = btrfs_calc_trans_metadata_size(fs_info,
> -							     num_dirty_bgs);
> -	global_rsv = &fs_info->global_block_rsv;
> -
> -	/*
> -	 * If we can't allocate any more chunks lets make sure we have _lots_ of
> -	 * wiggle room since running delayed refs can create more delayed refs.
> -	 */
> -	if (global_rsv->space_info->full) {
> -		num_dirty_bgs_bytes <<= 1;
> -		num_bytes <<= 1;
> -	}
> +	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
> +	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
> +	u64 reserved;
> +	bool ret = false;

nit: Reverse christmas tree:

delayed_refs_rsv
global_rsv
bool ret
reserved

>  
>  	spin_lock(&global_rsv->lock);
> -	if (global_rsv->reserved <= num_bytes + num_dirty_bgs_bytes)
> -		ret = 1;
> +	reserved = global_rsv->reserved;
>  	spin_unlock(&global_rsv->lock);
> +
> +	spin_lock(&delayed_refs_rsv->lock);
> +	reserved += delayed_refs_rsv->reserved;
> +	if (delayed_refs_rsv->size >= reserved)
> +		ret = true;

Essentially you want to throttle every time there is enough available
reserved space, no?

> +	spin_unlock(&delayed_refs_rsv->lock);
>  	return ret;
>  }
>  
> @@ -2883,7 +2869,7 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans)
>  	if (val >= NSEC_PER_SEC / 2)
>  		return 2;
>  
> -	return btrfs_check_space_for_delayed_refs(trans);
> +	return btrfs_check_space_for_delayed_refs(trans->fs_info);
>  }
>  
>  struct async_delayed_refs {
> @@ -3627,6 +3613,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
>  	 */
>  	mutex_lock(&trans->transaction->cache_write_mutex);
>  	while (!list_empty(&dirty)) {
> +		bool drop_reserve = true;
> +
>  		cache = list_first_entry(&dirty,
>  					 struct btrfs_block_group_cache,
>  					 dirty_list);
> @@ -3699,6 +3687,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
>  					list_add_tail(&cache->dirty_list,
>  						      &cur_trans->dirty_bgs);
>  					btrfs_get_block_group(cache);
> +					drop_reserve = false;
>  				}
>  				spin_unlock(&cur_trans->dirty_bgs_lock);
>  			} else if (ret) {
> @@ -3709,6 +3698,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
>  		/* if its not on the io list, we need to put the block group */
>  		if (should_put)
>  			btrfs_put_block_group(cache);
> +		if (drop_reserve)
> +			btrfs_delayed_refs_rsv_release(fs_info, 1);
>  
>  		if (ret)
>  			break;
> @@ -3857,6 +3848,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
>  		/* if its not on the io list, we need to put the block group */
>  		if (should_put)
>  			btrfs_put_block_group(cache);
> +		btrfs_delayed_refs_rsv_release(fs_info, 1);
>  		spin_lock(&cur_trans->dirty_bgs_lock);
>  	}
>  	spin_unlock(&cur_trans->dirty_bgs_lock);
> @@ -4829,8 +4821,10 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  {
>  	struct reserve_ticket *ticket = NULL;
>  	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_block_rsv;
> +	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
>  	struct btrfs_trans_handle *trans;
>  	u64 bytes;
> +	u64 reclaim_bytes = 0;
>  
>  	trans = (struct btrfs_trans_handle *)current->journal_info;
>  	if (trans)
> @@ -4863,12 +4857,16 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  		return -ENOSPC;
>  
>  	spin_lock(&delayed_rsv->lock);
> -	if (delayed_rsv->size > bytes)
> -		bytes = 0;
> -	else
> -		bytes -= delayed_rsv->size;
> +	reclaim_bytes += delayed_rsv->reserved;
>  	spin_unlock(&delayed_rsv->lock);
>  
> +	spin_lock(&delayed_refs_rsv->lock);
> +	reclaim_bytes += delayed_refs_rsv->reserved;
> +	spin_unlock(&delayed_refs_rsv->lock);
> +	if (reclaim_bytes >= bytes)
> +		goto commit;
> +	bytes -= reclaim_bytes;

Reading reclaim_bytes I start thinking "this must be the value we want
to reclaim in order to satisfy the allocation" but no, in reality it
holds the amount of available bytes, which  is subtracted from the
required bytes. Rename to something like "available_bytes"

> +
>  	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
>  				   bytes,
>  				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0) {

<snip>

> +/**
> + * btrfs_throttle_delayed_refs - throttle based on our delayed refs usage.
> + * @fs_info - the fs_info for our fs.
> + * @flush - control how we can flush for this reservation.
> + *
> + * This will refill the delayed block_rsv up to 1 items size worth of space and
> + * will return -ENOSPC if we can't make the reservation.
> + */
> +int btrfs_throttle_delayed_refs(struct btrfs_fs_info *fs_info,
> +				enum btrfs_reserve_flush_enum flush)
> +{

Why is this function called throttle? I don't see any throttling logic
in it?
> +	struct btrfs_block_rsv *block_rsv = &fs_info->delayed_refs_rsv;
> +	u64 limit = btrfs_calc_trans_metadata_size(fs_info, 1);
> +	u64 num_bytes = 0;
> +	int ret = -ENOSPC;
> +
> +	spin_lock(&block_rsv->lock);
> +	if (block_rsv->reserved < block_rsv->size) {
> +		num_bytes = block_rsv->size - block_rsv->reserved;
> +		num_bytes = min(num_bytes, limit);
> +	}
> +	spin_unlock(&block_rsv->lock);
> +
> +	if (!num_bytes)
> +		return 0;
> +
> +	ret = reserve_metadata_bytes(fs_info->extent_root, block_rsv,
> +				     num_bytes, flush);
> +	if (ret)
> +		return ret;
> +	block_rsv_add_bytes(block_rsv, num_bytes, 0);
> +	trace_btrfs_space_reservation(fs_info, "delayed_refs_rsv",
> +				      0, num_bytes, 1);
> +	return 0;
> +}
> +

<snip>
