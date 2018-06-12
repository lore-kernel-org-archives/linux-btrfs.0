Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:32834 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbeFSFZt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 01:25:49 -0400
From: Allen Pais <allen.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbackik@fb.com, dsterba@suse.com, linux-kernel@vger.kernel.org,
        Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH] btrfs: stop using get_seconds()
Date: Tue, 12 Jun 2018 17:18:25 +0530
Message-Id: <1528804105-24100-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The get_seconds() function is deprecated as it truncates
the timestamp to 32 bits. Change to either ktime_get_seconds()
or ktime_get_real_seconds()

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 fs/btrfs/ctree.h       | 4 ++--
 fs/btrfs/dev-replace.c | 8 ++++----
 fs/btrfs/disk-io.c     | 4 ++--
 fs/btrfs/transaction.c | 2 +-
 fs/btrfs/transaction.h | 2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 118346a..e671a1f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -342,8 +342,8 @@ struct btrfs_path {
 					sizeof(struct btrfs_item))
 struct btrfs_dev_replace {
 	u64 replace_state;	/* see #define above */
-	u64 time_started;	/* seconds since 1-Jan-1970 */
-	u64 time_stopped;	/* seconds since 1-Jan-1970 */
+	time64_t time_started;	/* seconds since 1-Jan-1970 */
+	time64_t time_stopped;	/* seconds since 1-Jan-1970 */
 	atomic64_t num_write_errors;
 	atomic64_t num_uncorrectable_read_errors;
 
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index e2ba041..1b30c38 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -465,7 +465,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	 * go to the tgtdev as well (refer to btrfs_map_block()).
 	 */
 	dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED;
-	dev_replace->time_started = get_seconds();
+	dev_replace->time_started = ktime_get_real_seconds();
 	dev_replace->cursor_left = 0;
 	dev_replace->committed_cursor_left = 0;
 	dev_replace->cursor_left_last_write_of_item = 0;
@@ -618,7 +618,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 			  : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
 	dev_replace->tgtdev = NULL;
 	dev_replace->srcdev = NULL;
-	dev_replace->time_stopped = get_seconds();
+	dev_replace->time_stopped = ktime_get_real_seconds();
 	dev_replace->item_needs_writeback = 1;
 
 	/* replace old device with new one in mapping tree */
@@ -807,7 +807,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		break;
 	}
 	dev_replace->replace_state = BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED;
-	dev_replace->time_stopped = get_seconds();
+	dev_replace->time_stopped = ktime_get_real_seconds();
 	dev_replace->item_needs_writeback = 1;
 	btrfs_dev_replace_write_unlock(dev_replace);
 	btrfs_scrub_cancel(fs_info);
@@ -848,7 +848,7 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 		dev_replace->replace_state =
 			BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
-		dev_replace->time_stopped = get_seconds();
+		dev_replace->time_stopped = ktime_get_real_seconds();
 		dev_replace->item_needs_writeback = 1;
 		btrfs_info(fs_info, "suspending dev_replace for unmount");
 		break;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 205092d..f3224e2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1803,7 +1803,7 @@ static int transaction_kthread(void *arg)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_transaction *cur;
 	u64 transid;
-	unsigned long now;
+	time64_t now;
 	unsigned long delay;
 	bool cannot_commit;
 
@@ -1819,7 +1819,7 @@ static int transaction_kthread(void *arg)
 			goto sleep;
 		}
 
-		now = get_seconds();
+		now = ktime_get_real_seconds();
 		if (cur->state < TRANS_STATE_BLOCKED &&
 		    !test_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags) &&
 		    (now < cur->start_time ||
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index ff5f6c7..56c8bab 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -241,7 +241,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	refcount_set(&cur_trans->use_count, 2);
 	atomic_set(&cur_trans->pending_ordered, 0);
 	cur_trans->flags = 0;
-	cur_trans->start_time = get_seconds();
+	cur_trans->start_time = ktime_get_real_seconds();
 
 	memset(&cur_trans->delayed_refs, 0, sizeof(cur_trans->delayed_refs));
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 9443948..4cbb1b5 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -48,7 +48,7 @@ struct btrfs_transaction {
 	int aborted;
 	struct list_head list;
 	struct extent_io_tree dirty_pages;
-	unsigned long start_time;
+	time64_t start_time;
 	wait_queue_head_t writer_wait;
 	wait_queue_head_t commit_wait;
 	wait_queue_head_t pending_wait;
-- 
2.7.4

