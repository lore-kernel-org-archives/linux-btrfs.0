From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make shrink_delalloc a little friendlier
Date: Fri, 21 Jan 2011 16:10:01 -0500
Message-ID: <1295644201-22093-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Xfstests 224 will just sit there and spin for ever until eventually we give up
flushing delalloc and exit.  On my box this took several hours.  I could not
interrupt this process either, even though we use INTERRUPTIBLE.  So do 2 things

1) Keep us from looping over and over again without reclaiming anything
2) If we get interrupted exit the loop

I tested this and the test now exits in a reasonable amount of time, and can be
interrupted with ctrl+c.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b552693..7ad7bf2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3344,8 +3344,10 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 	u64 reserved;
 	u64 max_reclaim;
 	u64 reclaimed = 0;
+	long time_left;
 	int pause = 1;
 	int nr_pages = (2 * 1024 * 1024) >> PAGE_CACHE_SHIFT;
+	int loops = 0;
 
 	block_rsv = &root->fs_info->delalloc_block_rsv;
 	space_info = block_rsv->space_info;
@@ -3358,7 +3360,7 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 
 	max_reclaim = min(reserved, to_reclaim);
 
-	while (1) {
+	while (loops < 3) {
 		/* have the flusher threads jump in and do some IO */
 		smp_mb();
 		nr_pages = min_t(unsigned long, nr_pages,
@@ -3366,8 +3368,12 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 		writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages);
 
 		spin_lock(&space_info->lock);
-		if (reserved > space_info->bytes_reserved)
+		if (reserved > space_info->bytes_reserved) {
+			loops = 0;
 			reclaimed += reserved - space_info->bytes_reserved;
+		} else {
+			loops++;
+		}
 		reserved = space_info->bytes_reserved;
 		spin_unlock(&space_info->lock);
 
@@ -3378,7 +3384,12 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 			return -EAGAIN;
 
 		__set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(pause);
+		time_left = schedule_timeout(pause);
+
+		/* We were interrupted, exit */
+		if (time_left)
+			break;
+
 		pause <<= 1;
 		if (pause > HZ / 10)
 			pause = HZ / 10;
-- 
1.6.6.1

