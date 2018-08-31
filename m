Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:44784 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727404AbeHaSMP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 14:12:15 -0400
Received: by mail-qt0-f195.google.com with SMTP id k38-v6so14601245qtk.11
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 07:04:36 -0700 (PDT)
Date: Fri, 31 Aug 2018 10:04:34 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 27/35] btrfs: handle delayed ref head accounting cleanup
 in abort
Message-ID: <20180831140432.lbnv3ortllkpkgbd@destiny>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-28-josef@toxicpanda.com>
 <0dda691d-96f1-3cd7-595e-e65075320360@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0dda691d-96f1-3cd7-595e-e65075320360@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 10:42:13AM +0300, Nikolay Borisov wrote:
> 
> 
> On 30.08.2018 20:42, Josef Bacik wrote:
> > We weren't doing any of the accounting cleanup when we aborted
> > transactions.  Fix this by making cleanup_ref_head_accounting global and
> > calling it from the abort code, this fixes the issue where our
> > accounting was all wrong after the fs aborts.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/ctree.h       |  5 +++++
> >  fs/btrfs/disk-io.c     |  1 +
> >  fs/btrfs/extent-tree.c | 13 ++++++-------
> >  3 files changed, 12 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 791e287c2292..67923b2030b8 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -35,6 +35,7 @@
> >  struct btrfs_trans_handle;
> >  struct btrfs_transaction;
> >  struct btrfs_pending_snapshot;
> > +struct btrfs_delayed_ref_root;
> >  extern struct kmem_cache *btrfs_trans_handle_cachep;
> >  extern struct kmem_cache *btrfs_bit_radix_cachep;
> >  extern struct kmem_cache *btrfs_path_cachep;
> > @@ -2624,6 +2625,10 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
> >  			   unsigned long count);
> >  int btrfs_async_run_delayed_refs(struct btrfs_fs_info *fs_info,
> >  				 unsigned long count, u64 transid, int wait);
> > +void
> > +btrfs_cleanup_ref_head_accounting(struct btrfs_fs_info *fs_info,
> > +				  struct btrfs_delayed_ref_root *delayed_refs,
> > +				  struct btrfs_delayed_ref_head *head);
> >  int btrfs_lookup_data_extent(struct btrfs_fs_info *fs_info, u64 start, u64 len);
> >  int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
> >  			     struct btrfs_fs_info *fs_info, u64 bytenr,
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 1d3f5731d616..caaca8154a1a 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -4240,6 +4240,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
> >  		if (pin_bytes)
> >  			btrfs_pin_extent(fs_info, head->bytenr,
> >  					 head->num_bytes, 1);
> > +		btrfs_cleanup_ref_head_accounting(fs_info, delayed_refs, head);
> >  		btrfs_put_delayed_ref_head(head);
> >  		cond_resched();
> >  		spin_lock(&delayed_refs->lock);
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 32579221d900..031d2b11ddee 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -2466,12 +2466,11 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
> >  	return ret ? ret : 1;
> >  }
> >  
> > -static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
> > -					struct btrfs_delayed_ref_head *head)
> > +void
> > +btrfs_cleanup_ref_head_accounting(struct btrfs_fs_info *fs_info,
> > +				  struct btrfs_delayed_ref_root *delayed_refs,
> > +				  struct btrfs_delayed_ref_head *head)
> >  {
> I don't see any reason to change the signature of the function, the new
> call sites have valid transaction handles where you can obtain
> references to fs_info/delayed_refs. Just stick with adding btrfs_ prefix
> and exporting it.
> 

We don't have a valid transaction handle in btrfs_destroy_delayed_refs because
we can call it at umount time when we no longer have a trans handle.  Thanks,

Josef
