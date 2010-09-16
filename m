From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: stop trying to shrink delalloc if there are no inodes to reclaim
Date: Thu, 16 Sep 2010 14:32:28 -0400
Message-ID: <1284661948-20204-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In very severe ENOSPC cases we can run out of inodes to do delalloc on, which
means we'll just keep looping trying to shrink delalloc.  Instead, if we fail to
shrink delalloc 3 times in a row break out since we're not likely to make any
progress.  Tested this with a 100mb fs an xfstests test 13.  Before the patch it
would hang the box, with the patch we get -ENOSPC like we should.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8db9330..8ef6aa6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3327,6 +3327,7 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 	u64 reserved;
 	u64 max_reclaim;
 	u64 reclaimed = 0;
+	int no_reclaim = 0;
 	int pause = 1;
 	int ret;
 
@@ -3343,12 +3344,16 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 	while (1) {
 		ret = btrfs_start_one_delalloc_inode(root, trans ? 1 : 0);
 		if (!ret) {
+			if (no_reclaim > 2)
+				break;
+			no_reclaim++;
 			__set_current_state(TASK_INTERRUPTIBLE);
 			schedule_timeout(pause);
 			pause <<= 1;
 			if (pause > HZ / 10)
 				pause = HZ / 10;
 		} else {
+			no_reclaim = 0;
 			pause = 1;
 		}
 
-- 
1.6.6.1

