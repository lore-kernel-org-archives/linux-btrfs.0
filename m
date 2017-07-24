Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43316 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752853AbdGXOEg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 10:04:36 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3E9C1ABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 14:04:34 +0000 (UTC)
Date: Mon, 24 Jul 2017 16:03:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix lockup in find_free_extent with read-only
 block groups
Message-ID: <20170724140318.GV2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <90eaab22-1431-715a-17bb-06ffe686e5cf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <90eaab22-1431-715a-17bb-06ffe686e5cf@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 19, 2017 at 11:25:51PM -0400, Jeff Mahoney wrote:
> If we have a block group that is all of the following:
> 1) uncached in memory
> 2) is read-only
> 3) has a disk cache state that indicates we need to recreate the cache
> 
> AND the file system has enough free space fragmentation such that the
> request for an extent of a given size can't be honored;
> 
> AND have a single CPU core;
> 
> AND it's the block group with the highest starting offset such that
> there are no opportunities (like reading from disk) for the loop to
> yield the CPU;
> 
> We can end up with a lockup.

What a nice corner case. Thanks for tracking it down.

> The root cause is simple.  Once we're in the position that we've read in
> all of the other block groups directly and none of those block groups
> can honor the request, there are no more opportunities to sleep.  We end
> up trying to start a caching thread which never gets run if we only have
> one core.  This *should* present as a hung task waiting on the caching
> thread to make some progress, but it doesn't.  Instead, it degrades into
> a busy loop because of the placement of the read-only check.
> 
> During the first pass through the loop, block_group->cached will be set
> to BTRFS_CACHE_STARTED and have_caching_bg will be set.  Then we hit the
> read-only check and short circuit the loop.  We're not yet in
> LOOP_CACHING_WAIT, so we skip that loop back before going through the
> loop again for other raid groups.
> 
> Then we move to LOOP_CACHING_WAIT state.
> 
> During the this pass through the loop, ->cached will still be
> BTRFS_CACHE_STARTED, which means it's not cached, so we'll enter
> cache_block_group, do a lot of nothing, and return, and also set
> have_caching_bg again.  Then we hit the read-only check and short circuit
> the loop.  The same thing happens as before except now we DO trigger
> the LOOP_CACHING_WAIT && have_caching_bg check and loop back up to the
> top.  We do this forever.
> 
> There are two fixes in this patch since they address the same underlying
> bug.
> 
> The first is to add a cond_resched to the end of the loop to ensure
> that the caching thread always has an opportunity to run.  This will
> fix the soft lockup issue, but find_free_extent will still loop doing
> nothing until the thread has completed.

I've looked if there are similar block group traversal patterns that
could use cond_resched but did not find any. Mostly simple operations,
nothing complex as the one in find_free_extent.

> The second is to move the read-only check to the top of the loop.  We're
> never going to return an allocation within a read-only block group so
> we may as well skip it early.  The check for ->cached == BTRFS_CACHE_ERROR
> would cause the same problem except that BTRFS_CACHE_ERROR is considered
> a "done" state and we won't re-set have_caching_bg again.
> 
> Many thanks to Stephan Kulow <coolo@suse.de> for his excellent help in
> the testing process.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Regarding the change itself,

Reviewed-by: David Sterba <dsterba@suse.com>

but not much chance I could see all the consequences without the
detailed changelog.
