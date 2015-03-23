Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21147 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752135AbbCWIKn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 04:10:43 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2N89cT7012339
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 16:09:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 04/11] btrfs: backref: Allow find_parent_nodes() to skip given ref_node.
Date: Mon, 23 Mar 2015 16:08:30 +0800
Message-ID: <1427098117-25152-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This provides the basis for later implement to determine whether given
root has reference on a given extent before delayed_ref operation.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 6ef355e..7db848c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -568,8 +568,9 @@ static void __merge_refs(struct list_head *head, int mode)
  * add all currently queued delayed refs from this head whose seq nr is
  * smaller or equal that seq to the list
  */
-static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
-			      struct list_head *prefs, u64 *total_refs,
+static int __add_delayed_refs(struct btrfs_delayed_ref_head *head,
+			      struct btrfs_delayed_ref_node *node_to_skip,
+			      u64 seq, struct list_head *prefs, u64 *total_refs,
 			      u64 inum)
 {
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
@@ -589,6 +590,8 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 		node = rb_entry(n, struct btrfs_delayed_ref_node,
 				rb_node);
 		n = rb_next(n);
+		if (node_to_skip && node == node_to_skip)
+			continue;
 		if (node->seq > seq)
 			continue;
 
@@ -886,8 +889,9 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
  * FIXME some caching might speed things up
  */
 static int find_parent_nodes(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info, u64 bytenr,
-			     u64 time_seq, struct ulist *refs,
+			     struct btrfs_fs_info *fs_info,
+			     struct btrfs_delayed_ref_node *node_to_skip,
+			     u64 bytenr, u64 time_seq, struct ulist *refs,
 			     struct ulist *roots, const u64 *extent_item_pos,
 			     u64 root_objectid, u64 inum, int nolock)
 {
@@ -963,7 +967,7 @@ again:
 				goto again;
 			}
 			spin_unlock(&delayed_refs->lock);
-			ret = __add_delayed_refs(head, time_seq,
+			ret = __add_delayed_refs(head, node_to_skip, time_seq,
 						 &prefs_delayed, &total_refs,
 						 inum);
 			if (!nolock)
@@ -1127,7 +1131,7 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 	if (!*leafs)
 		return -ENOMEM;
 
-	ret = find_parent_nodes(trans, fs_info, bytenr,
+	ret = find_parent_nodes(trans, fs_info, NULL, bytenr,
 				time_seq, *leafs, NULL, extent_item_pos,
 				0, 0, 0);
 	if (ret < 0 && ret != -ENOENT) {
@@ -1172,7 +1176,7 @@ static int __btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
-		ret = find_parent_nodes(trans, fs_info, bytenr,
+		ret = find_parent_nodes(trans, fs_info, NULL, bytenr,
 					time_seq, tmp, *roots, NULL, 0, 0,
 					nolock);
 		if (ret < 0 && ret != -ENOENT) {
@@ -1231,8 +1235,9 @@ int btrfs_check_shared(struct btrfs_trans_handle *trans,
 		down_read(&fs_info->commit_root_sem);
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
-		ret = find_parent_nodes(trans, fs_info, bytenr, elem.seq, tmp,
-					roots, NULL, root_objectid, inum, 0);
+		ret = find_parent_nodes(trans, fs_info, NULL, bytenr, elem.seq,
+					tmp, roots, NULL, root_objectid, inum,
+					0);
 		if (ret == BACKREF_FOUND_SHARED) {
 			ret = 1;
 			break;
-- 
2.3.3

