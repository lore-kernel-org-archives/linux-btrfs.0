Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18228 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754479AbdERVuS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 17:50:18 -0400
Date: Thu, 18 May 2017 14:47:24 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, jeffm@suse.com
Subject: Re: btrfs metadata reclaim behavior/performance characteristics
Message-ID: <20170518214724.GA10554@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <dc9f3787-767b-6710-9694-9eb02aa07728@suse.com>
 <20170518144532.GA28854@lim.localdomain>
 <a9c76afa-a18a-36e2-b3e8-a66bce9a0c3f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a9c76afa-a18a-36e2-b3e8-a66bce9a0c3f@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 18, 2017 at 06:41:08PM +0300, Nikolay Borisov wrote:
> 
> 
> On 18.05.2017 17:45, Liu Bo wrote:
> > On Thu, May 18, 2017 at 11:40:05AM +0300, Nikolay Borisov wrote:
> 
> <ommitted for brevity>
> 
> > 
> > Just some random thoughts here.
> > 
> > Hmm, not sure if this matters, but fstests now doesn't set --mixed even if the
> > disk size is as small as 256mb.  So are you testing a mixed btrfs or not?
> 
> You are right that fstest only sets mixed mode in case the filesystem is
> less than or equal to 100mb. IN this case the fs is 256mb which means
> mixed mode _is not_ set.
> 
> > 
> > So now we've observed there're too many 'commit transaction' happening, I think it's because via commiting transaction it doesn't reclaim enough metadata space, esp. looks like space->bytes_may_use is not reduced somehow.
> 
> You've given me the idea to basically compare the state of the various
> space_info counters after each transaction commit. Before and after the
> ticketed work. Also what makes you believe it's the commit transaction
> itself not freeing enough memory and not some of the other, "cheaper"
> flush states?
>

Firstly, commit transaction is a checkpoint, where all queued delayed refs are
supposed to be processed and this's one of the factors to update space_info
counters (bytes_may_use -> reserve, pinned -> bytes_used), secondly, it's the
last resort, if any cheaper flush works, ie. offers enough space to tickets, it
won't commit, will it?

> > 
> > The metadata space_info->bytes_may_use may come from:
> > 1) 1K file with buffered IO ends up living in btree leaf, so it will contribute to the number,
> > 2) if it's mixed btrfs, then 1k file with direct IO ends up with creating a 4k extent in mixed block group.
> > 3) while writing 1k files, metadata is reserved to make it run, and when to release depends on writeback (in the buffered IO case) or endio (in the direct IO case)
> > 
> > When running several commit transaction concurrently, if one has entered TRANS_STATE_COMMIT_START state, others just wait there, have you observed that if each commit transaction actually writes superblock in the end?
> 
> Haven't gone that far, will have to instrument the code to confirm this.
> What exactly should writing the superblock reveal?
>

On a second thinking, it shouldn't matter whether they go to the part of writing
superblock.

Commit transaction is costly for sure, I think we're trying to find
why there're so many commit transaction with ticket patch set.

In btrfs_async_reclaim_metadata_space(), flush_state++ happens when one ticket is not satisfied, and we do commit transaction only if there're enough pinned bytes, but what I don't understand is the link shows 'pinned' is 0 and I spotted something wrong (shown in the included patch).

Thanks,

-liubo

From: Liu Bo <bo.li.liu@oracle.com>

Subject: [PATCH] Btrfs: skip commit transaction if we don't have enough pinned bytes

We commit transaction in order to reclaim space from pinned bytes because it could process delayed refs, and in may_commit_transaction(), we check first if pinned bytes are enough for the required space, we then check if that plus bytes reserved for delayed insert are enough for the required space.

This changes the code to the above logic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e390451c72e6..bded1ddd1bb6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4837,7 +4837,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 
	spin_lock(&delayed_rsv->lock);
 	if (percpu_counter_compare(&space_info->total_bytes_pinned,
-			   bytes - delayed_rsv->size) >= 0) {
+			   	   		         bytes - delayed_rsv->size) < 0) {
 							       spin_unlock(&delayed_rsv->lock);
								return -ENOSPC;
 								}
-- 
2.13.0
