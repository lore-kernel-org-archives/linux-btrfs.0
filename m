From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: allow shrink_delalloc flush the needed reclaimed pages
Date: Fri, 14 Oct 2011 14:02:34 -0400
Message-ID: <1318615354-16774-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently we only allow a maximum of 2 megabytes of pages to be flushed at a
time.  This was ok before, but now we have overcommit which will screw us in a
heartbeat if we are quickly filling the disk.  So instead pick either 2
megabytes or the number of pages we need to reclaim to be safe again, which ever
is larger.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 96cbc51..424ae82 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3343,7 +3343,7 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 	u64 max_reclaim;
 	u64 reclaimed = 0;
 	long time_left;
-	int nr_pages = (2 * 1024 * 1024) >> PAGE_CACHE_SHIFT;
+	unsigned long nr_pages = (2 * 1024 * 1024) >> PAGE_CACHE_SHIFT;
 	int loops = 0;
 	unsigned long progress;
 
@@ -3366,7 +3366,8 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 	}
 
 	max_reclaim = min(reserved, to_reclaim);
-
+	nr_pages = max_t(unsigned long, nr_pages,
+			 max_reclaim >> PAGE_CACHE_SHIFT);
 	while (loops < 1024) {
 		/* have the flusher threads jump in and do some IO */
 		smp_mb();
-- 
1.7.5.2

