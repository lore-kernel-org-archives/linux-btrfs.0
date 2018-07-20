Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:37505 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731546AbeGTPHL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 11:07:11 -0400
Received: by mail-qk0-f193.google.com with SMTP id t79-v6so6281768qke.4
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 07:18:40 -0700 (PDT)
Date: Fri, 20 Jul 2018 10:18:38 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 01/22] btrfs: add btrfs_delete_ref_head helper
Message-ID: <20180720141837.neujcg2rwo6dojpm@destiny>
References: <20180719145006.17532-1-josef@toxicpanda.com>
 <c3e460b9-0939-6fd9-954a-a8aa51a4105c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c3e460b9-0939-6fd9-954a-a8aa51a4105c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 20, 2018 at 04:11:29PM +0300, Nikolay Borisov wrote:
> 
> 
> On 19.07.2018 17:49, Josef Bacik wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > We do this dance in cleanup_ref_head and check_ref_cleanup, unify it
> > into a helper and cleanup the calling functions.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/delayed-ref.c | 14 ++++++++++++++
> >  fs/btrfs/delayed-ref.h |  3 ++-
> >  fs/btrfs/extent-tree.c | 24 ++++--------------------
> >  3 files changed, 20 insertions(+), 21 deletions(-)
> > 
> > diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> > index 03dec673d12a..e1b322d651dd 100644
> > --- a/fs/btrfs/delayed-ref.c
> > +++ b/fs/btrfs/delayed-ref.c
> > @@ -393,6 +393,20 @@ btrfs_select_ref_head(struct btrfs_trans_handle *trans)
> >  	return head;
> >  }
> >  
> > +void btrfs_delete_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
> > +			   struct btrfs_delayed_ref_head *head)
> > +{
> > +	lockdep_assert_held(&delayed_refs->lock);
> > +	lockdep_assert_held(&head->lock);
> > +
> > +	rb_erase(&head->href_node, &delayed_refs->href_root);
> > +	RB_CLEAR_NODE(&head->href_node);
> > +	atomic_dec(&delayed_refs->num_entries);
> > +	delayed_refs->num_heads--;
> > +	if (head->processing == 0)
> > +		delayed_refs->num_heads_ready--;
> > +}
> > +
> >  /*
> >   * Helper to insert the ref_node to the tail or merge with tail.
> >   *
> > diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> > index ea1aecb6a50d..36318182e4ec 100644
> > --- a/fs/btrfs/delayed-ref.h
> > +++ b/fs/btrfs/delayed-ref.h
> > @@ -263,7 +263,8 @@ static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
> >  {
> >  	mutex_unlock(&head->mutex);
> >  }
> > -
> > +void btrfs_delete_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
> > +			   struct btrfs_delayed_ref_head *head);
> >  
> >  struct btrfs_delayed_ref_head *
> >  btrfs_select_ref_head(struct btrfs_trans_handle *trans);
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 3d9fe58c0080..ccaccd78534e 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -2577,12 +2577,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
> >  		spin_unlock(&delayed_refs->lock);
> >  		return 1;
> >  	}
> > -	delayed_refs->num_heads--;
> > -	rb_erase(&head->href_node, &delayed_refs->href_root);
> > -	RB_CLEAR_NODE(&head->href_node);
> > -	spin_unlock(&head->lock);
> > +	btrfs_delete_ref_head(delayed_refs, head);
> >  	spin_unlock(&delayed_refs->lock);
> > -	atomic_dec(&delayed_refs->num_entries);
> > +	spin_unlock(&head->lock);
> >  
> >  	trace_run_delayed_ref_head(fs_info, head, 0);
> >  
> > @@ -7122,22 +7119,9 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
> >  	if (!mutex_trylock(&head->mutex))
> >  		goto out;
> >  
> > -	/*
> > -	 * at this point we have a head with no other entries.  Go
> > -	 * ahead and process it.
> > -	 */
> > -	rb_erase(&head->href_node, &delayed_refs->href_root);
> > -	RB_CLEAR_NODE(&head->href_node);
> > -	atomic_dec(&delayed_refs->num_entries);
> > -
> > -	/*
> > -	 * we don't take a ref on the node because we're removing it from the
> > -	 * tree, so we just steal the ref the tree was holding.
> > -	 */
> > -	delayed_refs->num_heads--;
> > -	if (head->processing == 0)
> > -		delayed_refs->num_heads_ready--;
> 
> In cleanup_ref_head we don't have the num_heads_ready-- code so this is
> not pure consolidation but changes the behavior to a certain extent. It
> seems this patch is also fixing a bug w.r.t num_heads_ready counts if
> so, this needs to be documented in the changelog.
> 

No it's not, because cleanup_ref_head is called when running delayed refs, so
head->processing == 1, which means there's no change.  Thanks,

Josef
