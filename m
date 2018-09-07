Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38582 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727764AbeIGPlh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 11:41:37 -0400
Date: Fri, 7 Sep 2018 13:00:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 03/35] btrfs: use cleanup_extent_op in check_ref_cleanup
Message-ID: <20180907110053.GL24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-4-josef@toxicpanda.com>
 <20180831230029.GB17237@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180831230029.GB17237@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 04:00:29PM -0700, Omar Sandoval wrote:
> On Thu, Aug 30, 2018 at 01:41:53PM -0400, Josef Bacik wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > Unify the extent_op handling as well, just add a flag so we don't
> > actually run the extent op from check_ref_cleanup and instead return a
> > value so that we can skip cleaning up the ref head.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/extent-tree.c | 17 +++++++++--------
> >  1 file changed, 9 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 4c9fd35bca07..87c42a2c45b1 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -2443,18 +2443,23 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
> >  }
> >  
> >  static int cleanup_extent_op(struct btrfs_trans_handle *trans,
> > -			     struct btrfs_delayed_ref_head *head)
> > +			     struct btrfs_delayed_ref_head *head,
> > +			     bool run_extent_op)
> >  {
> >  	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
> >  	int ret;
> >  
> >  	if (!extent_op)
> >  		return 0;
> > +
> >  	head->extent_op = NULL;
> >  	if (head->must_insert_reserved) {
> >  		btrfs_free_delayed_extent_op(extent_op);
> >  		return 0;
> > +	} else if (!run_extent_op) {
> > +		return 1;
> >  	}
> > +
> >  	spin_unlock(&head->lock);
> >  	ret = run_delayed_extent_op(trans, head, extent_op);
> >  	btrfs_free_delayed_extent_op(extent_op);
> 
> So if cleanup_extent_op() returns 1, then the head was unlocked, unless
> run_extent_op was true. That's pretty confusing. Can we make it always
> unlock in the !must_insert_reserved case?

Agreed it's confusing. Possibly cleanup_extent_op can be split to two
helpers instead, but the locking semantics should be made more clear.
