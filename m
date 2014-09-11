Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44692 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaIKTX2 (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 11 Sep 2014 15:23:28 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: set inode's logged_trans/last_log_commit after ranged fsync
Date: Thu, 11 Sep 2014 21:22:14 +0100
Message-Id: <1410466934-26566-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a ranged fsync finishes if there are still extent maps in the modified
list, still set the inode's logged_trans and last_log_commit. This is important
in case an inode is fsync'ed and unlinked in the same transaction, to ensure its
inode ref gets deleted from the log and the respective dentries in its parent
are deleted too from the log (if the parent directory was fsync'ed in the same
transaction).

Instead make btrfs_inode_in_log() return false if the list of modified extent
maps isn't empty.

This is an incremental on top of the v4 version of the patch:

    "Btrfs: fix fsync data loss after a ranged fsync"

which was added to its v5, but didn't make it on time.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/btrfs_inode.h | 13 +++++++++++--
 fs/btrfs/tree-log.c    | 14 ++------------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 74ff403..3511031 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -246,8 +246,17 @@ static inline int btrfs_inode_in_log(struct inode *inode, u64 generation)
 	    BTRFS_I(inode)->last_sub_trans <=
 	    BTRFS_I(inode)->last_log_commit &&
 	    BTRFS_I(inode)->last_sub_trans <=
-	    BTRFS_I(inode)->root->last_log_commit)
-		return 1;
+	    BTRFS_I(inode)->root->last_log_commit) {
+		/*
+		 * After a ranged fsync we might have left some extent maps
+		 * (that fall outside the fsync's range). So return false
+		 * here if the list isn't empty, to make sure btrfs_log_inode()
+		 * will be called and process those extent maps.
+		 */
+		smp_mb();
+		if (list_empty(&BTRFS_I(inode)->extent_tree.modified_extents))
+			return 1;
+	}
 	return 0;
 }
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 82db14f..d7c1459 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4090,18 +4090,8 @@ log_extents:
 		}
 	}
 
-	write_lock(&em_tree->lock);
-	/*
-	 * If we're doing a ranged fsync and there are still modified extents
-	 * in the list, we must run on the next fsync call as it might cover
-	 * those extents (a full fsync or an fsync for other range).
-	 */
-	if (list_empty(&em_tree->modified_extents)) {
-		BTRFS_I(inode)->logged_trans = trans->transid;
-		BTRFS_I(inode)->last_log_commit =
-			BTRFS_I(inode)->last_sub_trans;
-	}
-	write_unlock(&em_tree->lock);
+	BTRFS_I(inode)->logged_trans = trans->transid;
+	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->last_sub_trans;
 out_unlock:
 	if (unlikely(err))
 		btrfs_put_logged_extents(&logged_list);
-- 
1.9.1

