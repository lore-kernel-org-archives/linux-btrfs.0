Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B736AC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53F7920663
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:11:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="mEXzbMpj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53F7920663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbeK1GKr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:10:47 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38483 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727462AbeK1GKr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:10:47 -0500
Received: by mail-qt1-f194.google.com with SMTP id p17so23032310qtl.5
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 11:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=k5zGeaEy5cI5W1Iw7+6dLRWpnElv2lNBS3xtUoKwKz0=;
        b=mEXzbMpj0VqLByACpdH2ok7i1QSt8GG32fuLFPxhweYnEO2Q+HP0l2ymZEsmoajdYx
         yXEp6jVinMD/5XYMjxklZJ65QhPts2jEkcrf6/e9Y26mxNzjOL4nVUNiiQipxpGlJ1d7
         JUqn02258br7zHzQ7qq7HiQ5Ntsm7cf8/Av09u8JKcyk1NDvASXBS2qTXaA3gHK0bsUu
         XhS9vFvbvu6bC+EEWpZGDz49+uf3MlXe+fVI5Ik8hss/BtvUL1dDJp43NVRVNeCvD8ph
         4eFBpXgMhCu68JrnwmvyoDAVub0UvmL3V1w4sffl1C7L8J6NAxztPH/2BnxExR5Ao7aR
         WI/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=k5zGeaEy5cI5W1Iw7+6dLRWpnElv2lNBS3xtUoKwKz0=;
        b=ZBJzEQNozkY9zBgbeQ3DqGN1v2eYrnCE4rNsWG3xrp/BGTyNBTIois4WsvGmR9Lgpf
         zudGpNeau0QNjnt30JnZw5DANll9RPMuqFIQbDhrq6Sk6ebStCuQM42CVjRgI2YY8CoW
         E8AtBcWIp46lyIzEX+EZaKYGqQAVRzNQroog44gteerSaFbt341mVr1+mkL3FooF5052
         /a6t3thGQRSxJzphP6HmRDlF0YsCeMY+NRdQ/RwtXKmrB9yrqPNoYZOb3X3uKKxVk4po
         vE+f73e0VH5iLhlKqm2iZwO1PYNX8YsHRa/sZgX7zBZY6BBppppEtSTRaTreqcFZpxOp
         /27Q==
X-Gm-Message-State: AGRZ1gJDu4FIpmhxae0cRBg082wE0tBKAxwjxteUL1mkUAd5NjkjmCDJ
        4xk8WpxaV9Ma0qw+f9NppQHPi+BlCzI=
X-Google-Smtp-Source: AJdET5eHCgcwUQjxvr/ft5bfByjGU6kBlj+hs3AJ6Fy3lk2sIdZi8p/QtOJiP6JVOVmyMGWd5Nw5LA==
X-Received: by 2002:ac8:3181:: with SMTP id h1mr32812269qte.14.1543345913552;
        Tue, 27 Nov 2018 11:11:53 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:4c40])
        by smtp.gmail.com with ESMTPSA id q72sm2775875qki.24.2018.11.27.11.11.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 11:11:52 -0800 (PST)
Date:   Tue, 27 Nov 2018 14:11:51 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 5/6] btrfs: introduce delayed_refs_rsv
Message-ID: <20181127191150.ramktjag3ifsnny4@macbook-pro-91.dhcp.thefacebook.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
 <20181121185912.24288-6-josef@toxicpanda.com>
 <3ca2ff06-6efa-e371-28ad-fb2ccf387f35@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ca2ff06-6efa-e371-28ad-fb2ccf387f35@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 11:14:12AM +0200, Nikolay Borisov wrote:
> 
> 
> On 21.11.18 г. 20:59 ч., Josef Bacik wrote:
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
> 
> Couldn't the same "no premature ENOSPC in critical section" effect be
> achieved if we simply allocate 2* num bytes in start transaction without
> adding the additional granularity for delayd refs? There seems to be a
> lot of supporting code added  and this obfuscates the simple idea that
> now we do 2* reservation and put it in a separate block_rsv structure.
> 
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/ctree.h             |  26 ++--
> >  fs/btrfs/delayed-ref.c       |  28 ++++-
> >  fs/btrfs/disk-io.c           |   4 +
> >  fs/btrfs/extent-tree.c       | 279 +++++++++++++++++++++++++++++++++++--------
> >  fs/btrfs/inode.c             |   4 +-
> >  fs/btrfs/transaction.c       |  77 ++++++------
> >  include/trace/events/btrfs.h |   2 +
> >  7 files changed, 313 insertions(+), 107 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 8b41ec42f405..0c6d589c8ce4 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -448,8 +448,9 @@ struct btrfs_space_info {
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
> > @@ -812,6 +813,8 @@ struct btrfs_fs_info {
> >  	struct btrfs_block_rsv chunk_block_rsv;
> >  	/* block reservation for delayed operations */
> >  	struct btrfs_block_rsv delayed_block_rsv;
> > +	/* block reservation for delayed refs */
> > +	struct btrfs_block_rsv delayed_refs_rsv;
> >  
> >  	struct btrfs_block_rsv empty_block_rsv;
> >  
> > @@ -2628,7 +2631,7 @@ static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_fs_info *fs_info,
> >  }
> >  
> >  int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans);
> > -int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans);
> > +bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info);
> >  void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
> >  					 const u64 start);
> >  void btrfs_wait_block_group_reservations(struct btrfs_block_group_cache *bg);
> > @@ -2742,10 +2745,12 @@ enum btrfs_reserve_flush_enum {
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
> > @@ -2796,6 +2801,13 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
> >  void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
> >  			     struct btrfs_block_rsv *block_rsv,
> >  			     u64 num_bytes);
> > +void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int nr);
> > +void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans);
> > +int btrfs_throttle_delayed_refs(struct btrfs_fs_info *fs_info,
> > +				enum btrfs_reserve_flush_enum flush);
> > +void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
> > +				       struct btrfs_block_rsv *src,
> > +				       u64 num_bytes);
> >  int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache);
> >  void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache);
> >  void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
> > diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> > index 48725fa757a3..96de92588f06 100644
> > --- a/fs/btrfs/delayed-ref.c
> > +++ b/fs/btrfs/delayed-ref.c
> > @@ -474,11 +474,14 @@ static int insert_delayed_ref(struct btrfs_trans_handle *trans,
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
> > @@ -536,10 +539,18 @@ update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
> >  	 * versa we need to make sure to adjust pending_csums accordingly.
> >  	 */
> >  	if (existing->is_data) {
> > -		if (existing->total_ref_mod >= 0 && old_ref_mod < 0)
> > +		u64 csum_items =
> 
> The name is a bit of misnomer, what csum_items really holds is the
> number of btree leaves require to store them.
> 
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
> 
> Now with addition to tracking the number of delayed heads/ref,
> delayed_ref_updates now also tracks the number of csum leaves. Doesn't
> this make the number in delayed_ref_updates a bit of a mess?
> 
> Additionally, shouldn't delayed_ref_updates really track only refs
> otherwise double accounting occurs. I.e for a brand-new ref insertion we
> create a head so increment delayed_ref_updates once in
> add_delayed_ref_head, then we create the ref and increment it again in
> insert_delayed_ref?
>

No, update_existing_head_ref() only gets called if we tried to insert the ref
head and found another one.  We only update the delayed_ref_updates if we go
from a positive ref_mod to a negative, ie we delete an existing one which means
we'll need to delete csum items.  If we add a brand new one the accounting is
done there appropriately.

> 
> > +		}
> >  	}
> >  	spin_unlock(&existing->lock);
> >  }
> > @@ -645,7 +656,7 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
> >  			&& head_ref->qgroup_reserved
> >  			&& existing->qgroup_ref_root
> >  			&& existing->qgroup_reserved);
> > -		update_existing_head_ref(delayed_refs, existing, head_ref,
> > +		update_existing_head_ref(trans, existing, head_ref,
> >  					 old_ref_mod);
> >  		/*
> >  		 * we've updated the existing ref, free the newly
> > @@ -656,8 +667,12 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
> >  	} else {
> >  		if (old_ref_mod)
> >  			*old_ref_mod = 0;
> > -		if (head_ref->is_data && head_ref->ref_mod < 0)
> > +		if (head_ref->is_data && head_ref->ref_mod < 0) {
> 
> nit: I think for the sake of consistency you must really check
> head_ref->total_ref_mod as per the code in:
> 
> 1262133b8d6f ("Btrfs: account for crcs in delayed ref processing")
> 
> Additionally the comment above total_ref_mod also documents this.
> 
> Here it's guaranteed that head_ref->ref_mod and ->total_ref_mod are
> identical.
> 

I agree, but it's unrelated to this work so I don't want to touch it here.

> >  			delayed_refs->pending_csums += head_ref->num_bytes;
> > +			trans->delayed_ref_updates +=
> > +				btrfs_csum_bytes_to_leaves(trans->fs_info,
> > +							   head_ref->num_bytes);
> > +		}
> >  		delayed_refs->num_heads++;
> >  		delayed_refs->num_heads_ready++;
> >  		atomic_inc(&delayed_refs->num_entries);
> > @@ -792,6 +807,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
> >  
> >  	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
> >  	spin_unlock(&delayed_refs->lock);
> > +	btrfs_update_delayed_refs_rsv(trans);
> >  
> >  	trace_add_delayed_tree_ref(fs_info, &ref->node, ref,
> >  				   action == BTRFS_ADD_DELAYED_EXTENT ?
> > @@ -873,6 +889,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
> >  
> >  	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
> >  	spin_unlock(&delayed_refs->lock);
> > +	btrfs_update_delayed_refs_rsv(trans);
> 
> As stated previously this call to btrfs_update_delayed_refs_rsv is
> really paired with the code that was executed in add_delayed_ref_head.
> Since it's not really obvious from first look at least a comment would
> be fine. Or better yet (as suggested previously) just make updating the
> delayed_refs_updates and the resv one operation. I don't see how this
> function adds much to the critical section of delayed_refs->lock. The
> interface you give is really error-prone.
> 

I'm going to re-arrange this in a new patchset, so I'm going to leave this as is
for now.  I'll just comment here for now.

> >  
> >  	trace_add_delayed_data_ref(trans->fs_info, &ref->node, ref,
> >  				   action == BTRFS_ADD_DELAYED_EXTENT ?
> > @@ -910,6 +927,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
> >  			     NULL, NULL, NULL);
> >  
> >  	spin_unlock(&delayed_refs->lock);
> > +	btrfs_update_delayed_refs_rsv(trans);
> Ditto
> 
> >  	return 0;
> >  }
> >  
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 55e8ca782b98..beaa58e742b5 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -2666,6 +2666,9 @@ int open_ctree(struct super_block *sb,
> >  	btrfs_init_block_rsv(&fs_info->empty_block_rsv, BTRFS_BLOCK_RSV_EMPTY);
> >  	btrfs_init_block_rsv(&fs_info->delayed_block_rsv,
> >  			     BTRFS_BLOCK_RSV_DELOPS);
> > +	btrfs_init_block_rsv(&fs_info->delayed_refs_rsv,
> > +			     BTRFS_BLOCK_RSV_DELREFS);
> > +
> >  	atomic_set(&fs_info->async_delalloc_pages, 0);
> >  	atomic_set(&fs_info->defrag_running, 0);
> >  	atomic_set(&fs_info->qgroup_op_seq, 0);
> > @@ -4413,6 +4416,7 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
> >  
> >  		spin_unlock(&cur_trans->dirty_bgs_lock);
> >  		btrfs_put_block_group(cache);
> > +		btrfs_delayed_refs_rsv_release(fs_info, 1);
> >  		spin_lock(&cur_trans->dirty_bgs_lock);
> >  	}
> >  	spin_unlock(&cur_trans->dirty_bgs_lock);
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 8a776dc9cb38..8af68b13fa27 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -2463,6 +2463,7 @@ static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
> >  	struct btrfs_fs_info *fs_info = trans->fs_info;
> >  	struct btrfs_delayed_ref_root *delayed_refs =
> >  		&trans->transaction->delayed_refs;
> > +	int nr_items = 1;
> 
> This 1 is a magic value, where does it come from?
> 
> >  
> >  	if (head->total_ref_mod < 0) {
> >  		struct btrfs_space_info *space_info;
> > @@ -2484,12 +2485,15 @@ static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
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
> > @@ -2831,40 +2835,22 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes)
> >  	return num_csums;
> >  }
> >  
> > -int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans)
> > +bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info)
> >  {
> > -	struct btrfs_fs_info *fs_info = trans->fs_info;
> > -	struct btrfs_block_rsv *global_rsv;
> > -	u64 num_heads = trans->transaction->delayed_refs.num_heads_ready;
> > -	u64 csum_bytes = trans->transaction->delayed_refs.pending_csums;
> > -	unsigned int num_dirty_bgs = trans->transaction->num_dirty_bgs;
> > -	u64 num_bytes, num_dirty_bgs_bytes;
> > -	int ret = 0;
> > -
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
> > +	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
> > +	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
> > +	u64 reserved;
> > +	bool ret = false;
> 
> nit: Reverse christmas tree:
> 
> delayed_refs_rsv
> global_rsv
> bool ret
> reserved
> 
> >  
> >  	spin_lock(&global_rsv->lock);
> > -	if (global_rsv->reserved <= num_bytes + num_dirty_bgs_bytes)
> > -		ret = 1;
> > +	reserved = global_rsv->reserved;
> >  	spin_unlock(&global_rsv->lock);
> > +
> > +	spin_lock(&delayed_refs_rsv->lock);
> > +	reserved += delayed_refs_rsv->reserved;
> > +	if (delayed_refs_rsv->size >= reserved)
> > +		ret = true;
> 
> Essentially you want to throttle every time there is enough available
> reserved space, no?

If we're at the amount in the delayed refs rsv + the global reserve then we're
in murky territory and want to back off and run things.  I'll add a comment.
I'll address the rest of this stuff as well.  Thanks,

Josef
