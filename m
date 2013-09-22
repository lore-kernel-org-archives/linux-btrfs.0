Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:42188 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3IVUzD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Sep 2013 16:55:03 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so2335642wes.2
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Sep 2013 13:55:02 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix tracking of orphan inode count
Date: Sun, 22 Sep 2013 21:54:55 +0100
Message-Id: <1379883295-7275-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In inode.c:btrfs_orphan_add() if we failed to insert the orphan
item, we would return without decrementing the orphan count that
we just incremented before attempting the insertion, leaving the
orphan inode count wrong.

In inode.c:btrfs_orphan_del(), we were decrementing the inode
orphan count if the bit BTRFS_INODE_ORPHAN_META_RESERVED was set,
which is logically wrong because it should be decremented if the
bit BTRFS_INODE_HAS_ORPHAN_ITEM was set - after all we increment
the count when we set the bit BTRFS_INODE_HAS_ORPHAN_ITEM elsewhere.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/inode.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 40a32ed..c462bd1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2969,6 +2969,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	if (insert >= 1) {
 		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
 		if (ret) {
+			atomic_dec(&root->orphan_inodes);
 			if (reserve) {
 				clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 					  &BTRFS_I(inode)->runtime_flags);
@@ -3018,14 +3019,16 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 		release_rsv = 1;
 	spin_unlock(&root->orphan_lock);
 
-	if (trans && delete_item)
-		ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
-
-	if (release_rsv) {
-		btrfs_orphan_release_metadata(inode);
+	if (delete_item) {
 		atomic_dec(&root->orphan_inodes);
+		if (trans)
+			ret = btrfs_del_orphan_item(trans, root,
+						    btrfs_ino(inode));
 	}
 
+	if (release_rsv)
+		btrfs_orphan_release_metadata(inode);
+
 	return ret;
 }
 
-- 
1.7.9.5

