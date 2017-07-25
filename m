Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44917 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752857AbdGYUvD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 16:51:03 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42A85AEC5
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 20:51:01 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 7/7] btrfs-progs: backref: use separate list for indirect refs
Date: Tue, 25 Jul 2017 16:51:38 -0400
Message-Id: <20170725205138.28376-7-jeffm@suse.com>
In-Reply-To: <20170725205138.28376-1-jeffm@suse.com>
References: <20170725205138.28376-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Rather than iterate over all outstanding backrefs to resolve indirect refs,
use a separate list that only contains indirect refs.

When we process missing keys, the ref moves to the indirect ref list.
Once the indirect ref is resolved, move the ref to the pending list.

Eventually these lists will be replaced by rbtrees.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 backref.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/backref.c b/backref.c
index 1d670ee..2f262cf 100644
--- a/backref.c
+++ b/backref.c
@@ -138,12 +138,14 @@ static struct __prelim_ref *list_first_pref(struct list_head *head)
 struct pref_state {
 	struct list_head pending;
 	struct list_head pending_missing_keys;
+	struct list_head pending_indirect_refs;
 };
 
 static void init_pref_state(struct pref_state *prefstate)
 {
 	INIT_LIST_HEAD(&prefstate->pending);
 	INIT_LIST_HEAD(&prefstate->pending_missing_keys);
+	INIT_LIST_HEAD(&prefstate->pending_indirect_refs);
 }
 
 /*
@@ -370,11 +372,10 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 				   struct btrfs_path *path, u64 time_seq,
 				   const u64 *extent_item_pos, u64 total_refs)
 {
-	struct list_head *head = &prefstate->pending;
+	struct list_head *head = &prefstate->pending_indirect_refs;
 	int err;
 	int ret = 0;
 	struct __prelim_ref *ref;
-	struct __prelim_ref *ref_safe;
 	struct __prelim_ref *new_ref;
 	struct ulist *parents;
 	struct ulist_node *node;
@@ -384,16 +385,11 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 	if (!parents)
 		return -ENOMEM;
 
-	/*
-	 * _safe allows us to insert directly after the current item without
-	 * iterating over the newly inserted items.
-	 * we're also allowed to re-assign ref during iteration.
-	 */
-	list_for_each_entry_safe(ref, ref_safe, head, list) {
-		if (ref->parent)	/* already direct */
-			continue;
-		if (ref->count == 0)
-			continue;
+	while (!list_empty(head)) {
+		ref = list_first_pref(head);
+		list_move(&ref->list, &prefstate->pending);
+		ASSERT(!ref->parent);	/* already direct */
+		ASSERT(ref->count);
 		err = __resolve_indirect_ref(fs_info, path, time_seq, ref,
 					     parents, extent_item_pos,
 					     total_refs);
@@ -426,7 +422,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			new_ref->parent = node->val;
 			new_ref->inode_list = (struct extent_inode_elem *)
 							(uintptr_t)node->aux;
-			list_add(&new_ref->list, &ref->list);
+			list_add_tail(&new_ref->list, &prefstate->pending);
 		}
 		ulist_reinit(parents);
 	}
@@ -813,6 +809,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	__merge_refs(&prefstate, 2);
 
 	BUG_ON(!list_empty(&prefstate.pending_missing_keys));
+	BUG_ON(!list_empty(&prefstate.pending_indirect_refs));
 
 	while (!list_empty(&prefstate.pending)) {
 		ref = list_first_pref(&prefstate.pending);
-- 
2.11.0

