Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33815 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753173AbdCMUba (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 16:31:30 -0400
Received: by mail-wm0-f65.google.com with SMTP id u132so11768463wmg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 13:31:28 -0700 (PDT)
From: ednadolski@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: Edmund Nadolski <enadolski@suse.com>
Subject: [PATCH 2/2] btrfs: replace hardcoded value with SEQ_NONE macro
Date: Mon, 13 Mar 2017 14:32:04 -0600
Message-Id: <20170313203204.11857-3-enadolski@suse.com>
In-Reply-To: <20170313203204.11857-1-enadolski@suse.com>
References: <20170313203204.11857-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Edmund Nadolski <enadolski@suse.com>

Define the SEQ_NONE macro to replace (u64)-1 in places where said
value triggers a special-case ref search behavior.

Signed-off-by: Edmund Nadolski <enadolski@suse.com>
Reviewed-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/backref.c | 16 ++++++++--------
 fs/btrfs/backref.h |  2 ++
 fs/btrfs/qgroup.c  |  4 ++--
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index e794b6e..297de5b 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -538,7 +538,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 	 * slot==nritems. In that case, go to the next leaf before we continue.
 	 */
 	if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
-		if (time_seq == (u64)-1)
+		if (time_seq == SEQ_NONE)
 			ret = btrfs_next_leaf(root, path);
 		else
 			ret = btrfs_next_old_leaf(root, path, time_seq);
@@ -582,7 +582,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			eie = NULL;
 		}
 next:
-		if (time_seq == (u64)-1)
+		if (time_seq == SEQ_NONE)
 			ret = btrfs_next_item(root, path);
 		else
 			ret = btrfs_next_old_item(root, path, time_seq);
@@ -634,7 +634,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 
 	if (path->search_commit_root)
 		root_level = btrfs_header_level(root->commit_root);
-	else if (time_seq == (u64)-1)
+	else if (time_seq == SEQ_NONE)
 		root_level = btrfs_header_level(root->node);
 	else
 		root_level = btrfs_old_root_level(root, time_seq);
@@ -645,7 +645,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	}
 
 	path->lowest_level = level;
-	if (time_seq == (u64)-1)
+	if (time_seq == SEQ_NONE)
 		ret = btrfs_search_slot(NULL, root, &ref->key_for_search, path,
 					0, 0);
 	else
@@ -1199,7 +1199,7 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
  *
  * NOTE: This can return values > 0
  *
- * If time_seq is set to (u64)-1, it will not search delayed_refs, and behave
+ * If time_seq is set to SEQ_NONE, it will not search delayed_refs, and behave
  * much like trans == NULL case, the difference only lies in it will not
  * commit root.
  * The special case is for qgroup to search roots in commit_transaction().
@@ -1246,7 +1246,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 		path->skip_locking = 1;
 	}
 
-	if (time_seq == (u64)-1)
+	if (time_seq == SEQ_NONE)
 		path->skip_locking = 1;
 
 	/*
@@ -1276,9 +1276,9 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	if (trans && likely(trans->type != __TRANS_DUMMY) &&
-	    time_seq != (u64)-1) {
+	    time_seq != SEQ_NONE) {
 #else
-	if (trans && time_seq != (u64)-1) {
+	if (trans && time_seq != SEQ_NONE) {
 #endif
 		/*
 		 * look if there are updates for this ref queued and lock the
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 9c41fba..20915a6 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -23,6 +23,8 @@
 #include "ulist.h"
 #include "extent_io.h"
 
+#define SEQ_NONE	((u64)-1)
+
 struct inode_fs_paths {
 	struct btrfs_path		*btrfs_path;
 	struct btrfs_root		*fs_root;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index bb7e42f..76d84af 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2077,12 +2077,12 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
 					goto cleanup;
 			}
 			/*
-			 * Use (u64)-1 as time_seq to do special search, which
+			 * Use SEQ_NONE as time_seq to do special search, which
 			 * doesn't lock tree or delayed_refs and search current
 			 * root. It's safe inside commit_transaction().
 			 */
 			ret = btrfs_find_all_roots(trans, fs_info,
-					record->bytenr, (u64)-1, &new_roots);
+					record->bytenr, SEQ_NONE, &new_roots);
 			if (ret < 0)
 				goto cleanup;
 			if (qgroup_to_skip) {
-- 
2.10.2

