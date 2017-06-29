Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35802 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752545AbdF2WJ2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 18:09:28 -0400
Received: by mail-pf0-f178.google.com with SMTP id c73so56964785pfk.2
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Jun 2017 15:09:27 -0700 (PDT)
Date: Thu, 29 Jun 2017 15:09:25 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2 1/2] btrfs: account for pinned bytes in
 should_alloc_chunk
Message-ID: <20170629220925.GC20229@vader.DHCP.thefacebook.com>
References: <20170622135148.16730-1-jeffm@suse.com>
 <20170629192141.GA20229@vader.DHCP.thefacebook.com>
 <b431385d-049f-5972-b5f2-367b7d3e4c7c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b431385d-049f-5972-b5f2-367b7d3e4c7c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 29, 2017 at 03:49:05PM -0400, Jeff Mahoney wrote:
> On 6/29/17 3:21 PM, Omar Sandoval wrote:
> > On Thu, Jun 22, 2017 at 09:51:47AM -0400, jeffm@suse.com wrote:
> >> From: Jeff Mahoney <jeffm@suse.com>
> >>
> >> In a heavy write scenario, we can end up with a large number of pinned bytes.
> >> This can translate into (very) premature ENOSPC because pinned bytes
> >> must be accounted for when allowing a reservation but aren't accounted for
> >> when deciding whether to create a new chunk.
> >>
> >> This patch adds the accounting to should_alloc_chunk so that we can
> >> create the chunk.
> > 
> > Hey, Jeff,
> 
> Hi Omar -
> 
> > Does this fix your ENOSPC problem on a fresh filesystem? I just tracked
> 
> No, it didn't.  It helped somewhat, but we were still hitting it
> frequently.  What did help was reverting "Btrfs: skip commit transaction
> if we don't have enough pinned bytes" (not upstream yet, on the list).
> 
> > down an ENOSPC issue someone here reported when doing a btrfs send to a
> > fresh filesystem and it sounds a lot like your issue: metadata
> > bytes_may_use shoots up but we don't allocate any chunks for it. I'm not
> > seeing how including bytes_pinned will help for this case. We won't have
> > any pinned bytes when populating a new fs, right?
> 
> Our test environment is just installing the OS.  That means lots of
> creates, writes, and then renames, so there's a fair amount of metadata
> churn that results in elevated pinned_bytes.  Rsync can cause the same
> workload pretty easily too.  Nikolay was going to look into coming up
> with a configuration for fsstress that would emulate it.
> 
> > I don't have a good solution. Allocating chunks based on bytes_may_use
> > is going to way over-allocate because of our worst-case estimations. I'm
> > double-checking now that the flusher is doing the right thing and not
> > missing anything. I'll keep digging, just wanted to know if you had any
> > thoughts.
> 
> My suspicion is that it all just happens to work and that there are
> several bugs working together that approximate a correct result.  My
> reasoning is that the patch I referenced above is correct.  The logic in
> may_commit_transaction is inverted and causing a ton of additional
> transaction commits.  I think that having the additional transaction
> commits is serving to free pinned bytes more quickly so things just work
> for the most part and pinned bytes doesn't play as much of a role.  But
> once the transaction count comes down, that pinned bytes count gets
> elevated and becomes more important.  I think it should be taken into
> account to determine whether committing a transaction early will result
> in releasing enough space to honor the reservation without allocating a
> new chunk.  If the answer is yes, flush it.  If no, there's no point in
> flushing it now, so just allocate the chunk and move on.
> 
> The big question is where this 80% number comes into play.
> 
> There is a caveat here: almost all of our testing has been on 4.4 with a
> bunch of these patches backported.  I believe the same issue will still
> be there on mainline, but we're in release crunch mode and I haven't had
> a chance to test more fully.
> 
> -Jeff

Jeff, can you try this and see if it helps?

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 33d979e9ea2a..83eecd33ad96 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4776,10 +4776,6 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 		else
 			flush = BTRFS_RESERVE_NO_FLUSH;
 		spin_lock(&space_info->lock);
-		if (can_overcommit(root, space_info, orig, flush)) {
-			spin_unlock(&space_info->lock);
-			break;
-		}
 		if (list_empty(&space_info->tickets) &&
 		    list_empty(&space_info->priority_tickets)) {
 			spin_unlock(&space_info->lock);

In my test case, it looks like what's happening is that most of the
metadata reservation we have comes from delalloc extents. When someone
comes along that isn't allowed to overcommit anymore, they queue up
their ticket and kick the flusher. Then the flusher comes along and
flushes a little bit of delalloc and sees "oh, we can overcommit now,
we're good", but it still didn't free enough to actually fulfill the
ticket, so the guy waiting still gets an ENOSPC.

This fixes it for my reproducer, but I need to put together a smaller
test case.
