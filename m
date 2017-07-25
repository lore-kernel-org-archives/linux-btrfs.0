Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44918 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752859AbdGYUvD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 16:51:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3F59DAEC4
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 20:51:01 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 6/7] btrfs-progs: backref: use separate list for missing keys
Date: Tue, 25 Jul 2017 16:51:37 -0400
Message-Id: <20170725205138.28376-6-jeffm@suse.com>
In-Reply-To: <20170725205138.28376-1-jeffm@suse.com>
References: <20170725205138.28376-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Rather than iterate over all outstanding backrefs to resolve missing keys,
use a separate list that only contains refs that need missing keys resolved.

Once the missing key is resolved, move the ref to the pending list.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 backref.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/backref.c b/backref.c
index be3376a..1d670ee 100644
--- a/backref.c
+++ b/backref.c
@@ -137,11 +137,13 @@ static struct __prelim_ref *list_first_pref(struct list_head *head)
 
 struct pref_state {
 	struct list_head pending;
+	struct list_head pending_missing_keys;
 };
 
 static void init_pref_state(struct pref_state *prefstate)
 {
 	INIT_LIST_HEAD(&prefstate->pending);
+	INIT_LIST_HEAD(&prefstate->pending_missing_keys);
 }
 
 /*
@@ -188,7 +190,7 @@ static int __add_prelim_ref(struct pref_state *prefstate, u64 root_id,
 			    u64 parent, u64 wanted_disk_byte, int count,
 			    gfp_t gfp_mask)
 {
-	struct list_head *head = &prefstate->pending;
+	struct list_head *head;
 	struct __prelim_ref *ref;
 
 	if (root_id == BTRFS_DATA_RELOC_TREE_OBJECTID)
@@ -199,16 +201,20 @@ static int __add_prelim_ref(struct pref_state *prefstate, u64 root_id,
 		return -ENOMEM;
 
 	ref->root_id = root_id;
-	if (key)
+	if (key) {
 		ref->key_for_search = *key;
-	else
+		head = &prefstate->pending;
+	} else {
 		memset(&ref->key_for_search, 0, sizeof(ref->key_for_search));
+		head = &prefstate->pending_missing_keys;
+	}
 
 	ref->inode_list = NULL;
 	ref->level = level;
 	ref->count = count;
 	ref->parent = parent;
 	ref->wanted_disk_byte = wanted_disk_byte;
+
 	list_add_tail(&ref->list, head);
 
 	return 0;
@@ -454,18 +460,15 @@ static inline int ref_for_same_block(struct __prelim_ref *ref1,
 static int __add_missing_keys(struct btrfs_fs_info *fs_info,
 			      struct pref_state *prefstate)
 {
-	struct list_head *head = &prefstate->pending;
-	struct list_head *pos;
 	struct extent_buffer *eb;
 
-	list_for_each(pos, head) {
+	while(!list_empty(&prefstate->pending_missing_keys)) {
 		struct __prelim_ref *ref;
-		ref = list_entry(pos, struct __prelim_ref, list);
+		ref = list_first_pref(&prefstate->pending_missing_keys);
 
-		if (ref->parent)
-			continue;
-		if (ref->key_for_search.type)
-			continue;
+		ASSERT(ref->root_id);
+		ASSERT(!ref->parent);
+		ASSERT(ref->key_for_search.type);
 		BUG_ON(!ref->wanted_disk_byte);
 		eb = read_tree_block(fs_info->tree_root, ref->wanted_disk_byte,
 				     fs_info->tree_root->nodesize, 0);
@@ -478,6 +481,7 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
 		else
 			btrfs_node_key_to_cpu(eb, &ref->key_for_search, 0);
 		free_extent_buffer(eb);
+		list_move(&ref->list, &prefstate->pending);
 	}
 	return 0;
 }
@@ -808,6 +812,8 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 
 	__merge_refs(&prefstate, 2);
 
+	BUG_ON(!list_empty(&prefstate.pending_missing_keys));
+
 	while (!list_empty(&prefstate.pending)) {
 		ref = list_first_pref(&prefstate.pending);
 		WARN_ON(ref->count < 0);
-- 
2.11.0

