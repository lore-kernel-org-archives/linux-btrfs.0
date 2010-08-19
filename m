From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 2.6.35 performance results
Date: Wed, 18 Aug 2010 21:00:31 -0400
Message-ID: <20100819010031.GI5854@think>
References: <4C5C57FB.4090003@dangyankee.net>
 <20100816200444.GJ993@think>
 <4C69B2D0.4010501@dangyankee.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <steve@dangyankee.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C69B2D0.4010501@dangyankee.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 16, 2010 at 04:51:12PM -0500, Steven Pratt wrote:
> Chris Mason wrote:
> >>This changeset introduced "btrfs_start_one_delalloc_inode" in
> >>http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commitdiff;h=5da9d01b66458b180a6bee0e637a1d0a3effc622
> >>
> >>In heavy write workloads this new function is now dominating the profiles:
> >>
> >>samples  %        app name                 symbol name
> >>8914973  65.1261  btrfs.ko                 btrfs_start_one_delalloc_inode
> >
> >Hi Steve,
> >
> >I think I know why this is a problem and how to fix it, but I'm having a
> >trouble reproducing this exact setup.  Which of your tests was this
> >oprofile from?
> 128 thread random write.  With or without nocow option.

Ok, I haven't managed to reproduce your problem exactly, but this is
faster for me here.  Could you please give it a try:

>From 8e965331de749c39f3781d581b55d2c207de060f Mon Sep 17 00:00:00 2001
From: Chris Mason <chris.mason@oracle.com>
Date: Wed, 18 Aug 2010 13:31:27 -0400
Subject: [PATCH] Btrfs: don't trigger delayed allocation throttling as often

We reserve metadata space based on the number of delayed allocation
extents that are currently pending.  As we run out of space, we start
forcing writeback to turn those reservations into physical extents.

The reservations are based on some worst case math, so the sooner we
turn them into real blocks, the better off we are.

But, the writeback is being forced too soon and too often.  This fixes
things to be less aggressive.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
---
 fs/btrfs/extent-tree.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 32d0940..55e1ee0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3681,6 +3681,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *block_rsv = &root->fs_info->delalloc_block_rsv;
 	u64 to_reserve;
+	u64 max_reserve;
 	int nr_extents;
 	int retries = 0;
 	int ret;
@@ -3717,7 +3718,11 @@ again:
 
 	block_rsv_add_bytes(block_rsv, to_reserve, 1);
 
-	if (block_rsv->size > 512 * 1024 * 1024)
+	/* 10% or 2GB */
+	max_reserve = min_t(u64, 2ULL * 1024 * 1024 * 1024,
+		    div_factor(root->fs_info->fs_devices->total_rw_bytes, 1));
+
+	if (block_rsv->size > max_reserve)
 		shrink_delalloc(NULL, root, to_reserve);
 
 	return 0;
-- 
1.7.1.1

