Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbbJKRvg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 13:51:36 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id ED4CBAC66
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 17:51:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/6] btrfs: comment waitqueue_active implied by locks
Date: Sun, 11 Oct 2015 19:50:27 +0200
Message-Id: <33a9eca7e4a4c2c17aebbb11f0e506a48ebc30c9.1444579885.git.dsterba@suse.com>
In-Reply-To: <cover.1444579885.git.dsterba@suse.com>
References: <cover.1444579885.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Suggested-by: Chris Mason <clm@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/raid56.c   | 6 +++++-
 fs/btrfs/tree-log.c | 6 ++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index fcf7265ca46f..1a33d3eb36de 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -810,7 +810,11 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 			}
 
 			goto done_nolock;
-		} else  if (waitqueue_active(&h->wait)) {
+			/*
+			 * The barrier for this waitqueue_active is not needed,
+			 * we're protected by h->lock and can't miss a wakeup.
+			 */
+		} else if (waitqueue_active(&h->wait)) {
 			spin_unlock(&rbio->bio_list_lock);
 			spin_unlock_irqrestore(&h->lock, flags);
 			wake_up(&h->wait);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1bbaace73383..d0deb4643502 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2950,6 +2950,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	atomic_set(&log_root_tree->log_commit[index2], 0);
 	mutex_unlock(&log_root_tree->log_mutex);
 
+	/*
+	 * The barrier before waitqueue_active is implied by mutex_unlock
+	 */
 	if (waitqueue_active(&log_root_tree->log_commit_wait[index2]))
 		wake_up(&log_root_tree->log_commit_wait[index2]);
 out:
@@ -2961,6 +2964,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	atomic_set(&root->log_commit[index1], 0);
 	mutex_unlock(&root->log_mutex);
 
+	/*
+	 * The barrier before waitqueue_active is implied by mutex_unlock
+	 */
 	if (waitqueue_active(&root->log_commit_wait[index1]))
 		wake_up(&root->log_commit_wait[index1]);
 	return ret;
-- 
2.1.3

