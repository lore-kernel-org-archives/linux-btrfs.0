Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38722 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964796AbaLLVAr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 16:00:47 -0500
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id sBCKtbxa012062
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 13:00:46 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1r85wggh1r-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 13:00:46 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't delete csum for free space cache
Date: Fri, 12 Dec 2014 16:00:42 -0500
Message-ID: <1418418042-1105-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We unconditionally delete csums for data extents, but we don't have csums for
free space cache, so all this does is force us to recow the csum root, which
will cause us to re-write the block group cache.  This patch fixes this by
noticing if we're a free space cache extent and simply skipping the delete csum
step.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-ref.c | 8 ++++++++
 fs/btrfs/delayed-ref.h | 1 +
 fs/btrfs/extent-tree.c | 8 ++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 6d16bea..7c729c3 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -605,6 +605,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	head_ref->is_data = is_data;
 	head_ref->ref_root = RB_ROOT;
 	head_ref->processing = 0;
+	head_ref->no_csums = 0;
 
 	spin_lock_init(&head_ref->lock);
 	mutex_init(&head_ref->mutex);
@@ -848,6 +849,13 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node,
 					bytenr, num_bytes, action, 1);
 
+	/*
+	 * If ref_root is the tree root then this is a block group space cache
+	 * extent and doesn't have csums, so we can set no_csums.
+	 */
+	if (ref_root == BTRFS_ROOT_TREE_OBJECTID)
+		head_ref->no_csums = 1;
+
 	add_delayed_data_ref(fs_info, trans, head_ref, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, owner, offset,
 				   action, no_quota);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index a764e23..c464dd3 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -101,6 +101,7 @@ struct btrfs_delayed_ref_head {
 	 * the free has happened.
 	 */
 	unsigned int must_insert_reserved:1;
+	unsigned int no_csums:1;
 	unsigned int is_data:1;
 	unsigned int processing:1;
 };
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 74eb29d..23b704e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2312,7 +2312,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 		if (insert_reserved) {
 			btrfs_pin_extent(root, node->bytenr,
 					 node->num_bytes, 1);
-			if (head->is_data) {
+			if (head->is_data && !head->no_csums) {
 				ret = btrfs_del_csums(trans, root,
 						      node->bytenr,
 						      node->num_bytes);
@@ -6094,7 +6094,11 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		}
 		btrfs_release_path(path);
 
-		if (is_data) {
+		/*
+		 * If the ref root is the tree root then this is a nodatasum
+		 * extent and we can skip the btrfs_del_csums step.
+		 */
+		if (is_data && (root_objectid != BTRFS_ROOT_TREE_OBJECTID)) {
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
 			if (ret) {
 				btrfs_abort_transaction(trans, extent_root, ret);
-- 
1.8.3.1

