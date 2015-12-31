Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50426 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbbLaSYx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 13:24:53 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: send, don't BUG_ON() when an empty symlink is found
Date: Thu, 31 Dec 2015 18:24:45 +0000
Message-Id: <1451586285-23658-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

When a symlink is successfully created it always has an inline extent
containing the source path. However if an error happens when creating
the symlink, we can leave in the subvolume's tree a symlink inode without
any such inline extent item - this happens if after btrfs_symlink() calls
btrfs_end_transaction() and before it calls the inode eviction handler
(through the final iput() call), the transaction gets committed and a
crash happens before the eviction handler gets called, or if a snapshot
of the subvolume is made before the eviction handler gets called. Sadly
we can't just avoid this by making btrfs_symlink() call
btrfs_end_transaction() after it calls the eviction handler, because the
later can commit the current transaction before it removes any items from
the subvolume tree (if it encounters ENOSPC errors while reserving space
for removing all the items).

So make send fail more gracefully, with an -EIO error, and print a
message to dmesg/syslog informing that there's an empty symlink inode,
so that the user can delete the empty symlink or do something else
about it.

Reported-by: Stephen R. van den Berg <srb@cuci.nl>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/send.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 355a458..63a6152 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1469,7 +1469,21 @@ static int read_symlink(struct btrfs_root *root,
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
-	BUG_ON(ret);
+	if (ret) {
+		/*
+		 * An empty symlink inode. Can happen in rare error paths when
+		 * creating a symlink (transaction committed before the inode
+		 * eviction handler removed the symlink inode items and a crash
+		 * happened in between or the subvol was snapshoted in between).
+		 * Print an informative message to dmesg/syslog so that the user
+		 * can delete the symlink.
+		 */
+		btrfs_err(root->fs_info,
+			  "Found empty symlink inode %llu at root %llu",
+			  ino, root->root_key.objectid);
+		ret = -EIO;
+		goto out;
+	}
 
 	ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
 			struct btrfs_file_extent_item);
-- 
2.1.3

