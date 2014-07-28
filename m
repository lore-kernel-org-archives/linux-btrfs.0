Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35174 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaG1Ra4 (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 28 Jul 2014 13:30:56 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: [PATCH] Btrfs: race free update of commit root for ro snapshots
Date: Mon, 28 Jul 2014 19:30:38 +0100
Message-Id: <1406572238-28804-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a better solution for the problem addressed in the following
commit:

    Btrfs: update commit root on snapshot creation after orphan cleanup
    (3821f348889e506efbd268cc8149e0ebfa47c4e5)

The previous solution wasn't the best because of 2 reasons:

    1) It added another full transaction commit, which is more expensive
       than just swapping the commit root with the root;

    2) Not completely race-free. As soon as the transaction commits, the
       snapshots becomes visible from user space, and before we do the
       orphan cleanup, user space can ask for a send operation that uses
       the new snapshot.

This change addresses those 2 issues. Special thanks to Alex Lyakas for
spotting the second issue.

Cc: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 29 +++++++++++++++++++++++++++++
 fs/btrfs/ioctl.c | 29 -----------------------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1d5f0b3..982a8f7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5227,6 +5227,35 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 			iput(inode);
 			inode = ERR_PTR(ret);
 		}
+		/*
+		 * If orphan cleanup did remove any orphans, it means the tree
+		 * was modified and therefore the commit root is not the same as
+		 * the current root anymore. This is a problem, because send
+		 * uses the commit root and therefore can see inode items that
+		 * don't exist in the current root anymore, and for example make
+		 * calls to btrfs_iget, which will do tree lookups based on the
+		 * current root and not on the commit root. Those lookups will
+		 * fail, returning a -ESTALE error, and making send fail with
+		 * that error. So make sure a send does not see any orphans we
+		 * have just removed, and that it will see the same inodes
+		 * regardless of whether a transaction commit happened before
+		 * it started (meaning that the commit root will be the same as
+		 * the current root) or not.
+		 */
+		if (sub_root->node != sub_root->commit_root) {
+			u64 sub_flags = btrfs_root_flags(&sub_root->root_item);
+
+			if (sub_flags & BTRFS_ROOT_SUBVOL_RDONLY) {
+				struct extent_buffer *eb;
+
+				down_write(&root->fs_info->commit_root_sem);
+				eb = sub_root->commit_root;
+				sub_root->commit_root =
+					btrfs_root_node(sub_root);
+				up_write(&root->fs_info->commit_root_sem);
+				free_extent_buffer(eb);
+			}
+		}
 	}
 
 	return inode;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2a30ac1..d44abc0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -715,35 +715,6 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (ret)
 		goto fail;
 
-	/*
-	 * If orphan cleanup did remove any orphans, it means the tree was
-	 * modified and therefore the commit root is not the same as the
-	 * current root anymore. This is a problem, because send uses the
-	 * commit root and therefore can see inode items that don't exist
-	 * in the current root anymore, and for example make calls to
-	 * btrfs_iget, which will do tree lookups based on the current root
-	 * and not on the commit root. Those lookups will fail, returning a
-	 * -ESTALE error, and making send fail with that error. So make sure
-	 * a send does not see any orphans we have just removed, and that it
-	 * will see the same inodes regardless of whether a transaction
-	 * commit happened before it started (meaning that the commit root
-	 * will be the same as the current root) or not.
-	 */
-	if (readonly && pending_snapshot->snap->node !=
-	    pending_snapshot->snap->commit_root) {
-		trans = btrfs_join_transaction(pending_snapshot->snap);
-		if (IS_ERR(trans) && PTR_ERR(trans) != -ENOENT) {
-			ret = PTR_ERR(trans);
-			goto fail;
-		}
-		if (!IS_ERR(trans)) {
-			ret = btrfs_commit_transaction(trans,
-						       pending_snapshot->snap);
-			if (ret)
-				goto fail;
-		}
-	}
-
 	inode = btrfs_lookup_dentry(dentry->d_parent->d_inode, dentry);
 	if (IS_ERR(inode)) {
 		ret = PTR_ERR(inode);
-- 
1.9.1

