From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix small race with delalloc flushing waitqueue's
Date: Fri, 12 Mar 2010 14:28:18 -0500
Message-ID: <20100312192817.GA2332@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Everytime we start a new flushing thread, we init the waitqueue if there isn't a
flushing thread running.  The problem with this is we check
space_info->flushing, which we clear right before doing a wake_up on the
flushing waitqueue, which causes problems if we init the waitqueue in the middle
of clearing the flushing flagh and calling wake_up.  This is hard to hit, but
the code is wrong anyway, so init the flushing/allocating waitqueue when
creating the space info and let it be.  I haven't seen the panic since I've been
using this patch.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9c6fbd0..73ac69b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2678,6 +2678,8 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	INIT_LIST_HEAD(&found->block_groups);
 	init_waitqueue_head(&found->flush_wait);
 	init_rwsem(&found->groups_sem);
+	init_waitqueue_head(&found->flush_wait);
+	init_waitqueue_head(&found->allocate_wait);
 	spin_lock_init(&found->lock);
 	found->flags = flags;
 	found->total_bytes = total_bytes;
@@ -2929,12 +2931,10 @@ static void flush_delalloc(struct btrfs_root *root,
 
 	spin_lock(&info->lock);
 
-	if (!info->flushing) {
+	if (!info->flushing)
 		info->flushing = 1;
-		init_waitqueue_head(&info->flush_wait);
-	} else {
+	else
 		wait = true;
-	}
 
 	spin_unlock(&info->lock);
 
@@ -2997,7 +2997,6 @@ static int maybe_allocate_chunk(struct btrfs_root *root,
 	if (!info->allocating_chunk) {
 		info->force_alloc = 1;
 		info->allocating_chunk = 1;
-		init_waitqueue_head(&info->allocate_wait);
 	} else {
 		wait = true;
 	}
-- 
1.6.6

