Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbbBXQve (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 11:51:34 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 28BDFADBA
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 16:51:33 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/4] btrfs: add missing barriers before waitqueue_active
Date: Tue, 24 Feb 2015 17:51:32 +0100
Message-Id: <17483cf32d53059bb3e6aa1662fe2f35727829bc.1424795734.git.dsterba@suse.cz>
In-Reply-To: <cover.1424795734.git.dsterba@suse.cz>
References: <cover.1424795734.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The waitqueue might miss a wakeup due to memory ordering issues, the
explicit barrier is required unless there's an implicit one.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/dev-replace.c |  9 ++++++++-
 fs/btrfs/raid56.c      | 17 ++++++++++++-----
 fs/btrfs/transaction.c |  5 ++++-
 fs/btrfs/tree-log.c    |  8 ++++++++
 4 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 5ec03d999c37..30b8668396e0 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -451,6 +451,10 @@ static void btrfs_rm_dev_replace_blocked(struct btrfs_fs_info *fs_info)
 static void btrfs_rm_dev_replace_unblocked(struct btrfs_fs_info *fs_info)
 {
 	clear_bit(BTRFS_FS_STATE_DEV_REPLACING, &fs_info->fs_state);
+	/*
+	 * Make sure counter is updated before we wake up waiters.
+	 */
+	smp_mb();
 	if (waitqueue_active(&fs_info->replace_wait))
 		wake_up(&fs_info->replace_wait);
 }
@@ -916,7 +920,10 @@ void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
 void btrfs_bio_counter_sub(struct btrfs_fs_info *fs_info, s64 amount)
 {
 	percpu_counter_sub(&fs_info->bio_counter, amount);
-
+	/*
+	 * Make sure counter is updated before we wake up waiters.
+	 */
+	smp_mb();
 	if (waitqueue_active(&fs_info->replace_wait))
 		wake_up(&fs_info->replace_wait);
 }
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 5264858ed768..b460e193f324 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -809,11 +809,18 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 			}
 
 			goto done_nolock;
-		} else  if (waitqueue_active(&h->wait)) {
-			spin_unlock(&rbio->bio_list_lock);
-			spin_unlock_irqrestore(&h->lock, flags);
-			wake_up(&h->wait);
-			goto done_nolock;
+		} else {
+			/*
+			 * Make sure counter is updated before we wake up
+			 * waiters.
+			 */
+			smp_mb();
+			if (waitqueue_active(&h->wait)) {
+				spin_unlock(&rbio->bio_list_lock);
+				spin_unlock_irqrestore(&h->lock, flags);
+				wake_up(&h->wait);
+				goto done_nolock;
+			}
 		}
 	}
 done:
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 038fcf6051e0..90ba0c3c3d0d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -90,8 +90,11 @@ static void clear_btree_io_tree(struct extent_io_tree *tree)
 		/*
 		 * btree io trees aren't supposed to have tasks waiting for
 		 * changes in the flags of extent states ever.
+		 *
+		 * Barrier required to make sure counter is updated before we
+		 * wake up waiters.
 		 */
-		ASSERT(!waitqueue_active(&state->wq));
+		ASSERT(({ smp_mb(); !waitqueue_active(&state->wq); }));
 		free_extent_state(state);
 		if (need_resched()) {
 			spin_unlock(&tree->lock);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f96996a1b70c..121df0fe5128 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2739,6 +2739,10 @@ out_wake_log_root:
 	atomic_set(&log_root_tree->log_commit[index2], 0);
 	mutex_unlock(&log_root_tree->log_mutex);
 
+	/*
+	 * Make sure counter is updated before we wake up waiters.
+	 */
+	smp_mb();
 	if (waitqueue_active(&log_root_tree->log_commit_wait[index2]))
 		wake_up(&log_root_tree->log_commit_wait[index2]);
 out:
@@ -2750,6 +2754,10 @@ out:
 	atomic_set(&root->log_commit[index1], 0);
 	mutex_unlock(&root->log_mutex);
 
+	/*
+	 * Make sure counter is updated before we wake up waiters.
+	 */
+	smp_mb();
 	if (waitqueue_active(&root->log_commit_wait[index1]))
 		wake_up(&root->log_commit_wait[index1]);
 	return ret;
-- 
1.8.4.5

