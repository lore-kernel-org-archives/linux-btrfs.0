Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:45101 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030529Ab3DSPIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 11:08:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp2) (RZmta 31.27 OK)
	with ESMTP id g00d5bp3JExacH for <linux-btrfs@vger.kernel.org>;
	Fri, 19 Apr 2013 17:08:05 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: delete unused parameter to btrfs_read_root_item()
Date: Fri, 19 Apr 2013 17:08:04 +0200
Message-Id: <1366384085-26890-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h     | 5 ++---
 fs/btrfs/disk-io.c   | 2 +-
 fs/btrfs/root-tree.c | 7 +++----
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 412c306..84be717 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3361,9 +3361,8 @@ int __must_check btrfs_update_root(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct btrfs_key *key,
 				   struct btrfs_root_item *item);
-void btrfs_read_root_item(struct btrfs_root *root,
-			 struct extent_buffer *eb, int slot,
-			 struct btrfs_root_item *item);
+void btrfs_read_root_item(struct extent_buffer *eb, int slot,
+			  struct btrfs_root_item *item);
 int btrfs_find_last_root(struct btrfs_root *root, u64 objectid, struct
 			 btrfs_root_item *item, struct btrfs_key *key);
 int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fa8438f..a284421 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1514,7 +1514,7 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
 	if (ret == 0) {
 		l = path->nodes[0];
 		slot = path->slots[0];
-		btrfs_read_root_item(tree_root, l, slot, &root->root_item);
+		btrfs_read_root_item(l, slot, &root->root_item);
 		memcpy(&root->root_key, location, sizeof(*location));
 	}
 	btrfs_free_path(path);
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 668af53..5bf1ed5 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -29,9 +29,8 @@
  * generation numbers as then we know the root was once mounted with an older
  * kernel that was not aware of the root item structure change.
  */
-void btrfs_read_root_item(struct btrfs_root *root,
-			 struct extent_buffer *eb, int slot,
-			 struct btrfs_root_item *item)
+void btrfs_read_root_item(struct extent_buffer *eb, int slot,
+			  struct btrfs_root_item *item)
 {
 	uuid_le uuid;
 	int len;
@@ -104,7 +103,7 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
 		goto out;
 	}
 	if (item)
-		btrfs_read_root_item(root, l, slot, item);
+		btrfs_read_root_item(l, slot, item);
 	if (key)
 		memcpy(key, &found_key, sizeof(found_key));
 
-- 
1.8.2.1

