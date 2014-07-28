Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57717 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaG1Rgz (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 28 Jul 2014 13:36:55 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: unlock nodes earlier when inserting items in a btree
Date: Mon, 28 Jul 2014 19:34:35 +0100
Message-Id: <1406572475-8681-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In ctree.c:setup_items_for_insert(), we can unlock all nodes in our
path before we process the leaf (shift items and data, adjust data
offsets, etc). This allows for better btree concurrency, as we're
often holding a write lock on at least the node at level 1.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 263145b..bd0ae3e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4738,6 +4738,12 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 	int slot;
 	struct btrfs_map_token token;
 
+	if (path->slots[0] == 0) {
+		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
+		fixup_low_keys(root, path, &disk_key, 1);
+	}
+	btrfs_unlock_up_safe(path, 1);
+
 	btrfs_init_map_token(&token);
 
 	leaf = path->nodes[0];
@@ -4798,12 +4804,6 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 	}
 
 	btrfs_set_header_nritems(leaf, nritems + nr);
-
-	if (slot == 0) {
-		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		fixup_low_keys(root, path, &disk_key, 1);
-	}
-	btrfs_unlock_up_safe(path, 1);
 	btrfs_mark_buffer_dirty(leaf);
 
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
-- 
1.9.1

