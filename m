Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44823 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753587AbdF0VLj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 17:11:39 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BF45FABB1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 21:11:37 +0000 (UTC)
Subject: [PATCH] btrfs: backref, properly iterate the missing keys
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
References: <20170620160653.19907-1-enadolski@suse.com>
 <20170620160653.19907-9-enadolski@suse.com>
 <be7f16ca-6a91-1e3b-cc5a-6e5454c6c3cc@suse.com>
 <e3778e1b-c1c1-03b9-5abe-e70cc2c19f6c@suse.com>
Cc: Edmund Nadolski <enadolski@suse.com>, David Sterba <dsterba@suse.com>
Message-ID: <45d5ace2-bdf6-b6a9-4c97-bfea500b938e@suse.com>
Date: Tue, 27 Jun 2017 17:11:36 -0400
MIME-Version: 1.0
In-Reply-To: <e3778e1b-c1c1-03b9-5abe-e70cc2c19f6c@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[This should probably be rolled into Patch 8].


We iterate over the indirect tree looking for refs that don't have
key associated with them, look them up, and update the ref with the
resolved key.  The problem is that when we resolve the key, we've
changed where the ref would be located in the tree, which means
searches and insertions would fail.

The good news is that it's not a visible bug since we don't actually search
for or insert new items into the tree at this point.

This patch uses a separate tree for those refs, resolves them, and inserts
them into the indirect tree.  This has the benefit of letting us skip
the refs that don't need any attention and this is used in the next patch.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/backref.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -132,6 +132,7 @@ struct preftree {
 struct preftrees {
 	struct preftree direct;    /* BTRFS_SHARED_[DATA|BLOCK]_REF_KEY */
 	struct preftree indirect;  /* BTRFS_[TREE_BLOCK|EXTENT_DATA]_REF_KEY */
+	struct preftree indirect_missing_keys;
 };
 
 /*
@@ -406,8 +407,11 @@ static int add_indirect_ref(const struct
 			    u64 wanted_disk_byte, int count,
 			    struct share_check *sc, gfp_t gfp_mask)
 {
-	return add_prelim_ref(fs_info, &preftrees->indirect, root_id, key,
-			      level, 0, wanted_disk_byte, count, sc, gfp_mask);
+	struct preftree *tree = &preftrees->indirect;
+	if (!key)
+		tree = &preftrees->indirect_missing_keys;
+	return add_prelim_ref(fs_info, tree, root_id, key, level, 0,
+			      wanted_disk_byte, count, sc, gfp_mask);
 }
 
 static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
@@ -707,22 +711,25 @@ static int add_missing_keys(struct btrfs
 {
 	struct prelim_ref *ref;
 	struct extent_buffer *eb;
-	struct rb_node *node = rb_first(&preftrees->indirect.root);
+	struct preftree *tree = &preftrees->indirect_missing_keys;
+	struct rb_node *node;
 
-	while (node) {
+	while ((node = rb_first(&tree->root))) {
 		ref = rb_entry(node, struct prelim_ref, rbnode);
-		node = rb_next(&ref->rbnode);
-		BUG_ON(ref->parent);	/* should not be a direct ref */
+		rb_erase(node, &tree->root);
 
-		if (ref->key_for_search.type)
-			continue;
+		BUG_ON(ref->parent);	/* should not be a direct ref */
+		BUG_ON(ref->key_for_search.type);
 		BUG_ON(!ref->wanted_disk_byte);
+
 		eb = read_tree_block(fs_info->tree_root, ref->wanted_disk_byte,
 				     0);
 		if (IS_ERR(eb)) {
+			release_pref(ref);
 			return PTR_ERR(eb);
 		} else if (!extent_buffer_uptodate(eb)) {
 			free_extent_buffer(eb);
+			release_pref(ref);
 			return -EIO;
 		}
 		btrfs_tree_read_lock(eb);
@@ -749,12 +756,15 @@ static int add_delayed_refs(const struct
 	struct btrfs_delayed_ref_node *node;
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
 	struct btrfs_key key;
-	struct btrfs_key op_key = {0};
+	struct btrfs_key tmp_op_key;
+	struct btrfs_key *op_key = NULL;
 	int count;
 	int ret = 0;
 
-	if (extent_op && extent_op->update_key)
-		btrfs_disk_key_to_cpu(&op_key, &extent_op->key);
+	if (extent_op && extent_op->update_key) {
+		btrfs_disk_key_to_cpu(&tmp_op_key, &extent_op->key);
+		op_key = &tmp_op_key;
+	}
 
 	spin_lock(&head->lock);
 	list_for_each_entry(node, &head->ref_list, list) {
@@ -783,7 +793,7 @@ static int add_delayed_refs(const struct
 
 			ref = btrfs_delayed_node_to_tree_ref(node);
 			ret = add_indirect_ref(fs_info, preftrees, ref->root,
-					       &op_key, ref->level + 1,
+					       op_key, ref->level + 1,
 					       node->bytenr, count, sc,
 					       GFP_ATOMIC);
 			break;
@@ -1206,6 +1216,8 @@ again:
 	if (ret)
 		goto out;
 
+	WARN_ON(!RB_EMPTY_ROOT(&preftrees.indirect_missing_keys.root));
+
 	ret = resolve_indirect_refs(fs_info, path, time_seq, &preftrees,
 				    extent_item_pos, total_refs, sc);
 	if (ret)
@@ -1289,6 +1301,7 @@ out:
 
 	prelim_release(&preftrees.direct);
 	prelim_release(&preftrees.indirect);
+	prelim_release(&preftrees.indirect_missing_keys);
 
 	if (ret < 0)
 		free_inode_elem_list(eie);

