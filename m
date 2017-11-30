Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38538 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752771AbdK3SIe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 13:08:34 -0500
Date: Thu, 30 Nov 2017 19:06:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: don't bug_on with enomem in __clear_state_bit
Message-ID: <20171130180636.GP3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1510249994-6023-1-git-send-email-josef@toxicpanda.com>
 <0b0f6873-8aa8-898b-a007-3820f66d8e8b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0b0f6873-8aa8-898b-a007-3820f66d8e8b@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 10, 2017 at 09:38:01AM +0200, Nikolay Borisov wrote:
> On  9.11.2017 19:53, Josef Bacik wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > Since we're allocating under atomic we could every easily enomem, so if
> > that's the case and we can block then loop around and try to allocate
> > the prealloc not under a lock.
> > 
> > We also saw this happen during try_to_release_page in production, in
> > which case it's completely valid to return ENOMEM so we can tell
> > try_to_release_page that we can't release this page.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/extent_io.c | 26 ++++++++++++++++++++++----
> >  1 file changed, 22 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index dd941885b9c3..6d1de1a81dc8 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -590,8 +590,9 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
> >  	struct extent_state *prealloc = NULL;
> >  	struct rb_node *node;
> >  	u64 last_end;
> > -	int err;
> > +	int err = 0;
> >  	int clear = 0;
> > +	bool need_prealloc = false;
> >  
> >  	btrfs_debug_check_extent_io_range(tree, start, end);
> >  
> > @@ -614,6 +615,9 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
> >  		 * If we end up needing a new extent state we allocate it later.
> >  		 */
> >  		prealloc = alloc_extent_state(mask);
> > +		if (!prealloc && need_prealloc)
> > +			return -ENOMEM;
> > +		need_prealloc = false;
> >  	}
> >  
> >  	spin_lock(&tree->lock);
> > @@ -673,7 +677,14 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
> >  
> >  	if (state->start < start) {
> >  		prealloc = alloc_extent_state_atomic(prealloc);
> > -		BUG_ON(!prealloc);
> > +		if (!prealloc) {
> > +			if (gfpflags_allow_blocking(mask)) {
> > +				need_prealloc = true;
> > +				goto again;
> 
> At this point we already hold spin_lock(&tree->lock); so when we go to
> again: directly we will deadlock. At the very least you'd want to unlock
> the tree->lock spinlock.
> 
> In any case I hate how this function is structured. Can't we just make a
> GFP_NOFAIL allocation for prealloc without if the gfp mask allows
> holding the lock and ensure we alway have 1 preallocated extent_state
> even if we don't need it when we can. So when we go into one of the
> branches which require a prealloc if we don't have it then we know there
> was no way to get it upfront and just return enomem straight away?

The "nofail" semantics would be a big win for the extent bit
manipulation helpers, but could be hard to achieve. Using GFP_NOFAIL
can cause deadlocks, if one thread is waiting for memory that is going
to be flushed by another thread that also asks to clear the ranges and
goes NOFAIL.

One preallocated structure does not cover all cases, as we might need to
repeatedly split the range that gets unlocked but must keep other parts
intact.
