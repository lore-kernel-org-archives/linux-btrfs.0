Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43422 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933580AbcIVPKb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 11:10:31 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH] Btrfs: don't BUG() during drop snapshot
Date: Thu, 22 Sep 2016 17:08:24 +0200
Message-Id: <1474556904-22495-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Really there's lots of things that can go wrong here, kill all the
BUG_ON()'s and replace the logic ones with ASSERT()'s and return EIO
instead.

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c95f85c292a4..37aba7d00c8f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8884,12 +8884,15 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 				       &wc->flags[level - 1]);
 	if (ret < 0) {
 		btrfs_tree_unlock(next);
+		free_extent_buffer(next);
 		return ret;
 	}
 
 	if (unlikely(wc->refs[level - 1] == 0)) {
 		btrfs_err(root->fs_info, "Missing references.");
-		BUG();
+		btrfs_tree_unlock(next);
+		free_extent_buffer(next);
+		return -EIO;
 	}
 	*lookup_info = 0;
 
@@ -8941,7 +8944,13 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	}
 
 	level--;
-	BUG_ON(level != btrfs_header_level(next));
+	ASSERT(level == btrfs_header_level(next));
+	if (level != btrfs_header_level(next)) {
+		btrfs_err("mismatched level");
+		btrfs_tree_unlock(next);
+		free_extent_buffer(next);
+		return -EIO;
+	}
 	path->nodes[level] = next;
 	path->slots[level] = 0;
 	path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
@@ -8956,8 +8965,14 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
 			parent = path->nodes[level]->start;
 		} else {
-			BUG_ON(root->root_key.objectid !=
+			ASSERT(root->root_key.objectid ==
 			       btrfs_header_owner(path->nodes[level]));
+			if (root->root_key.objectid !=
+			    btrfs_header_owner(path->nodes[level])) {
+				btrfs_err("mismatched block owner");
+				btrfs_tree_unlock(next);
+				free_extent_buffer(next);
+			}
 			parent = 0;
 		}
 
@@ -8972,7 +8987,11 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 		}
 		ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
 				root->root_key.objectid, level - 1, 0);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret) {
+			btrfs_tree_unlock(next);
+			free_extent_buffer(next);
+			return ret;
+		}
 	}
 	btrfs_tree_unlock(next);
 	free_extent_buffer(next);
-- 
2.7.1

