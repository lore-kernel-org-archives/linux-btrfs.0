Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:37636 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbeHaSUp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 14:20:45 -0400
Received: by mail-qt0-f195.google.com with SMTP id n6-v6so14650383qtl.4
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 07:13:04 -0700 (PDT)
Date: Fri, 31 Aug 2018 10:13:01 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/35] btrfs: add btrfs_delete_ref_head helper
Message-ID: <20180831141300.kmcp3fami46r7rtp@destiny>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-2-josef@toxicpanda.com>
 <e8e85625-5269-23ec-4152-a96fe393f8b2@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e8e85625-5269-23ec-4152-a96fe393f8b2@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 10:57:45AM +0300, Nikolay Borisov wrote:
> 
> 
> On 30.08.2018 20:41, Josef Bacik wrote:
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
> > index 62ff545ba1f7..3a9e4ac21794 100644
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
> > index d9f2a4ebd5db..7769177b489e 100644
> > --- a/fs/btrfs/delayed-ref.h
> > +++ b/fs/btrfs/delayed-ref.h
> > @@ -261,7 +261,8 @@ static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
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
> > index f77226d8020a..6799950fa057 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -2492,12 +2492,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
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
> 
> Again, the feedback of reversed lock-order is not addressed:
> 
> https://www.spinics.net/lists/linux-btrfs/msg80482.html
> 

Oops, I'll fix this.

Josef
