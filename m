Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36267 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756037AbcLSOx7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 09:53:59 -0500
From: Geliang Tang <geliangtang@gmail.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: use rb_entry()
Date: Mon, 19 Dec 2016 22:53:41 +0800
Message-Id: <e7f25691fb620d01df75e3526897c7fb0e0ef6f8.1482158996.git.geliangtang@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To make the code clearer, use rb_entry() instead of container_of() to
deal with rbtree.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 fs/btrfs/ctree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a426dc8..146b2dc 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -426,7 +426,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 	tm_root = &fs_info->tree_mod_log;
 	for (node = rb_first(tm_root); node; node = next) {
 		next = rb_next(node);
-		tm = container_of(node, struct tree_mod_elem, node);
+		tm = rb_entry(node, struct tree_mod_elem, node);
 		if (tm->seq > min_seq)
 			continue;
 		rb_erase(node, tm_root);
@@ -460,7 +460,7 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
 	tm_root = &fs_info->tree_mod_log;
 	new = &tm_root->rb_node;
 	while (*new) {
-		cur = container_of(*new, struct tree_mod_elem, node);
+		cur = rb_entry(*new, struct tree_mod_elem, node);
 		parent = *new;
 		if (cur->logical < tm->logical)
 			new = &((*new)->rb_left);
@@ -746,7 +746,7 @@ __tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
 	tm_root = &fs_info->tree_mod_log;
 	node = tm_root->rb_node;
 	while (node) {
-		cur = container_of(node, struct tree_mod_elem, node);
+		cur = rb_entry(node, struct tree_mod_elem, node);
 		if (cur->logical < start) {
 			node = node->rb_left;
 		} else if (cur->logical > start) {
@@ -1326,7 +1326,7 @@ __tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 		next = rb_next(&tm->node);
 		if (!next)
 			break;
-		tm = container_of(next, struct tree_mod_elem, node);
+		tm = rb_entry(next, struct tree_mod_elem, node);
 		if (tm->logical != first_tm->logical)
 			break;
 	}
-- 
2.9.3

