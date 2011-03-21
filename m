From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] btrfs: Simplify locking
Date: Mon, 21 Mar 2011 17:59:55 +0100
Message-ID: <20110321165955.GG12003@htj.dyndns.org>
References: <20110320174433.GA12003@htj.dyndns.org>
 <1300665355-sup-1698@think>
 <20110321082942.GD12003@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110321082942.GD12003@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Here are the results with voluntary preemption.  I've moved to a
beefier machine for testing.  It's dual Opteron 2347, so dual socket,
eight core.  The memory is limited to 1GiB to force IOs and the disk
is the same OCZ Vertex 60gig SSD.  /proc/stat is captured before and
after "dbench 50".

I ran the following four setups.

DFL	The current custom locking implementation.
SIMPLE	Simple mutex conversion.  The first patch in this thread.
SPIN	SIMPLE + mutex_tryspin().  The second patch in this thread.
SPIN2	SPIN + mutex_tryspin() in btrfs_tree_lock().  Patch below.

SPIN2 should alleviate the voluntary preemption by might_sleep() in
mutex_lock().

       USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
DFL    49427  458210   1433  7683488     642.947
SIMPLE 52836  471398   1427  3055384     705.369
SPIN   52267  473115   1467  3005603     705.369
SPIN2  52063  470453   1446  3092091     701.826

I'm running DFL again just in case but SIMPLE or SPIN seems to be a
much better choice.

Thanks.

NOT-Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/btrfs/locking.h |    2 ++
 1 file changed, 2 insertions(+)

Index: work/fs/btrfs/locking.h
===================================================================
--- work.orig/fs/btrfs/locking.h
+++ work/fs/btrfs/locking.h
@@ -28,6 +28,8 @@ static inline bool btrfs_try_spin_lock(s
 
 static inline void btrfs_tree_lock(struct extent_buffer *eb)
 {
+	if (mutex_tryspin(&eb->lock))
+		return;
 	mutex_lock(&eb->lock);
 }
 
