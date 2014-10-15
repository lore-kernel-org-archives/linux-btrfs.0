Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64119 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaJORhu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 13:37:50 -0400
From: Filipe Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org, clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Revert "Btrfs: race free update of commit root for ro snapshots"
Date: Wed, 15 Oct 2014 19:37:26 +0100
Message-Id: <1413398246-17324-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 9c3b306e1c9e6be4be09e99a8fe2227d1005effc.

Switching only one commit root during a transaction is wrong because it leads
the fs into an inconsistent state. All commit roots should be switched at once,
at transaction commit time, otherwise backref walking can often miss important
references that were only accessible through the old commit root.
Plus, the root item for the snapshot's root wasn't getting updated and preventing
the next transaction commit to do it.

This made several users get into random corruption issues after creation of
readonly snapshots.

A regression test for xfstests will follow soon.

Cc: stable@vger.kernel.org # 3.17
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 36 ------------------------------------
 fs/btrfs/ioctl.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fc9c043..d23362f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5261,42 +5261,6 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 			iput(inode);
 			inode = ERR_PTR(ret);
 		}
-		/*
-		 * If orphan cleanup did remove any orphans, it means the tree
-		 * was modified and therefore the commit root is not the same as
-		 * the current root anymore. This is a problem, because send
-		 * uses the commit root and therefore can see inode items that
-		 * don't exist in the current root anymore, and for example make
-		 * calls to btrfs_iget, which will do tree lookups based on the
-		 * current root and not on the commit root. Those lookups will
-		 * fail, returning a -ESTALE error, and making send fail with
-		 * that error. So make sure a send does not see any orphans we
-		 * have just removed, and that it will see the same inodes
-		 * regardless of whether a transaction commit happened before
-		 * it started (meaning that the commit root will be the same as
-		 * the current root) or not.
-		 */
-		if (sub_root->node != sub_root->commit_root) {
-			u64 sub_flags = btrfs_root_flags(&sub_root->root_item);
-
-			if (sub_flags & BTRFS_ROOT_SUBVOL_RDONLY) {
-				struct extent_buffer *eb;
-
-				/*
-				 * Assert we can't have races between dentry
-				 * lookup called through the snapshot creation
-				 * ioctl and the VFS.
-				 */
-				ASSERT(mutex_is_locked(&dir->i_mutex));
-
-				down_write(&root->fs_info->commit_root_sem);
-				eb = sub_root->commit_root;
-				sub_root->commit_root =
-					btrfs_root_node(sub_root);
-				up_write(&root->fs_info->commit_root_sem);
-				free_extent_buffer(eb);
-			}
-		}
 	}
 
 	return inode;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e732274..33c80f5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -713,6 +713,39 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (ret)
 		goto fail;
 
+	ret = btrfs_orphan_cleanup(pending_snapshot->snap);
+	if (ret)
+		goto fail;
+
+	/*
+	 * If orphan cleanup did remove any orphans, it means the tree was
+	 * modified and therefore the commit root is not the same as the
+	 * current root anymore. This is a problem, because send uses the
+	 * commit root and therefore can see inode items that don't exist
+	 * in the current root anymore, and for example make calls to
+	 * btrfs_iget, which will do tree lookups based on the current root
+	 * and not on the commit root. Those lookups will fail, returning a
+	 * -ESTALE error, and making send fail with that error. So make sure
+	 * a send does not see any orphans we have just removed, and that it
+	 * will see the same inodes regardless of whether a transaction
+	 * commit happened before it started (meaning that the commit root
+	 * will be the same as the current root) or not.
+	 */
+	if (readonly && pending_snapshot->snap->node !=
+	    pending_snapshot->snap->commit_root) {
+		trans = btrfs_join_transaction(pending_snapshot->snap);
+		if (IS_ERR(trans) && PTR_ERR(trans) != -ENOENT) {
+			ret = PTR_ERR(trans);
+			goto fail;
+		}
+		if (!IS_ERR(trans)) {
+			ret = btrfs_commit_transaction(trans,
+						       pending_snapshot->snap);
+			if (ret)
+				goto fail;
+		}
+	}
+
 	inode = btrfs_lookup_dentry(dentry->d_parent->d_inode, dentry);
 	if (IS_ERR(inode)) {
 		ret = PTR_ERR(inode);
-- 
1.9.1

