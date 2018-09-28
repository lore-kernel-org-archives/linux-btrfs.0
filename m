Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CB7C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37E98215E4
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:58:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="rsKfqtdz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37E98215E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbeI1SVg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:21:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43972 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbeI1SVg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 14:21:36 -0400
Received: by mail-qt1-f195.google.com with SMTP id q41-v6so1440770qtq.10
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UEnmd0z6kvNaPlxbmPFxAzvjFZMDp4i0SjpYJdq3y+s=;
        b=rsKfqtdz+zcs5y7peKGsOS3aRoUKTfqIQAIRRdAj5GUARlcLbwq2TFK+rfxwj4Z8Vl
         NZBMXpNGU1p2MCDTeQfM0YCGRLCSq59TFH68LW4vthoiSy6krasLA5lGUUj9F+tWa4KE
         nuMoWBkF+8MtLs2jRXLyeBhZC5Snqbes/p7KDypOuzc3D9WMGhPjQEzR+ybW/B5Amhda
         HnpcfPT7MP4qHY6zG3OG8Y6Bg0PsxbsFfB5Lr6m7/CyuOhpjYJSYuZa55mrkoAzOOWmU
         ScZSC4ha9wScpKYlejn0CDL+95V4digMAkRDa27CvfzXl/gZ2fYd+/jSMN7Ox6fYgQc6
         iQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UEnmd0z6kvNaPlxbmPFxAzvjFZMDp4i0SjpYJdq3y+s=;
        b=ixmFXDEJ7/npGpMSKrPbztlf10laMsg8khS/PpZrfrzUJTjBWAyem3K5B0AEKQonO1
         73XfgwLFohlbzB3PO/cN53zSfi7w4W9OYeYT5HPA9mPVaUpm7M1DRNeI6/ECyihbMLkr
         bE+27/KeC1uRubiEFhIh7H2Bqg0hRkDGhLNC6pqDlRVGKlsHbLAefyWqBxdP886I+U0B
         +mI9phwmYXqjhwSPw9cMZKH1yBPGIPUHAv/Cw9pUNxcEmKpfdxlpKEW+q+uwfBQbQxlG
         9iO1HrW9N5eeE4QTCT2iXyx6j7DpkFKE6X8wOviFw1Ea5zBJ99N1D95wRJ8pHkyoTOcP
         teSw==
X-Gm-Message-State: ABuFfoiFr9FPKeTQcItehhUiQDhZ08eHdRbn1Jv8UqM0mF6id+AvWwli
        J9r5TdUf3NHDIR79fQOXohEqug==
X-Google-Smtp-Source: ACcGV63tQGqEogyglcLIdUlXTRWQZaT4Ootzf78s+i3SQ1rcG4SbGHUXbRM/COkTBXa9oKzzsbhugQ==
X-Received: by 2002:a0c:b29d:: with SMTP id r29-v6mr4942921qve.70.1538135889199;
        Fri, 28 Sep 2018 04:58:09 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c50-v6sm3407361qtb.8.2018.09.28.04.58.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:58:08 -0700 (PDT)
Date:   Fri, 28 Sep 2018 07:58:07 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 06/42] btrfs: introduce delayed_refs_rsv
Message-ID: <20180928115805.2f747knbtvhvgfuw@destiny>
References: <20180928111821.24376-1-josef@toxicpanda.com>
 <20180928111821.24376-7-josef@toxicpanda.com>
 <9a0183be-6aa9-05b4-4058-9d14f6617795@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a0183be-6aa9-05b4-4058-9d14f6617795@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 28, 2018 at 02:51:10PM +0300, Nikolay Borisov wrote:
> 
> 
> On 28.09.2018 14:17, Josef Bacik wrote:
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
> >  fs/btrfs/ctree.h             |  27 +++--
> >  fs/btrfs/delayed-ref.c       |  28 ++++-
> >  fs/btrfs/disk-io.c           |   4 +
> >  fs/btrfs/extent-tree.c       | 279 +++++++++++++++++++++++++++++++++++--------
> >  fs/btrfs/inode.c             |   2 +-
> >  fs/btrfs/transaction.c       |  77 ++++++------
> >  include/trace/events/btrfs.h |   2 +
> >  7 files changed, 312 insertions(+), 107 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 66f1d3895bca..1a2c3b629af2 100644
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
> > @@ -2608,8 +2611,7 @@ static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_fs_info *fs_info,
> >  
> >  int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
> >  				       struct btrfs_fs_info *fs_info);
> > -int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
> > -				       struct btrfs_fs_info *fs_info);
> > +bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info);
> >  void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
> >  					 const u64 start);
> >  void btrfs_wait_block_group_reservations(struct btrfs_block_group_cache *bg);
> > @@ -2723,10 +2725,12 @@ enum btrfs_reserve_flush_enum {
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
> > @@ -2777,6 +2781,13 @@ int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
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
> You haven't adressed my initial point about merging modification of
> delayed_ref_updates and calling btrfs_update_delayed_refs_rsv into one
> function otherwise this seems error prone. I don't see why this cannot
> be made, if there is some reason which I'm missing then explain it.
> 
> As it stands this btrfs_updated_delayed_refs_rsv is paired with the
> modifications made in one of the 2nd level callees:
> 
>  btrfs_add_delayed_tree_ref
>    add_delayed_ref_head
>     update_existing_head_ref
> 
> I'd rather have btrfs_update_delayed_refs_rsv renamed to something else
> with 'inc' in its name and called everytime we modify
> delayed_ref_update. I'm willing to bet 50 bucks in 6 months time someone
> will change delayed_ref_updates and will forget to call
> btrfs_update_delayed_refs_rsv.
> 

Because we have to take the delayed_refs_rsv lock in this helper, I want to take
it as little as possible since it is a fs wide lock, so I want to batch it.
There's no reason to change it.  Thanks,

Josef
