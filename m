Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21147 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752141AbbCWIKp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 04:10:45 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2N89eYQ012353
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 16:09:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 07/11] btrfs: qgroup: save and pass old_roots ulist to btrfs_qgroup_record_ref().
Date: Mon, 23 Mar 2015 16:08:33 +0800
Message-ID: <1427098117-25152-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For possible shared extent accounting case, call btrfs_find_all_roots()
before we write backref data into extent tree to find exactly how many
roots is referring the extent as old_roots.

And pass it to btrfs_qgroup_record_ref() for later operations.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e73c1fa..e3e7509 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -36,6 +36,8 @@
 #include "math.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "ulist.h"
+#include "backref.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
@@ -1976,11 +1978,13 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *item;
 	struct btrfs_key key;
+	struct ulist *old_roots = NULL;
 	u64 bytenr = node->bytenr;
 	u64 num_bytes = node->num_bytes;
 	u64 refs;
 	int ret;
 	int no_quota = node->no_quota;
+	int need_to_free_old_roots = 0;
 	enum btrfs_qgroup_operation_type type = BTRFS_QGROUP_OPER_ADD_EXCL;
 
 	path = btrfs_alloc_path();
@@ -1990,6 +1994,14 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	if (!is_fstree(root_objectid) || !root->fs_info->quota_enabled)
 		no_quota = 1;
 
+	if (!no_quota) {
+		need_to_free_old_roots = 1;
+		ret = btrfs_find_all_roots(trans, fs_info, node, bytenr,
+					   node->seq, &old_roots, 1);
+		if (ret < 0)
+			goto out;
+	}
+
 	path->reada = 1;
 	path->leave_spinning = 1;
 	/* this will setup the path even if it fails to insert the back ref */
@@ -2013,9 +2025,11 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			type = BTRFS_QGROUP_OPER_ADD_SHARED;
 		btrfs_release_path(path);
 
-		ret = btrfs_qgroup_record_ref(trans, fs_info, NULL,
+		ret = btrfs_qgroup_record_ref(trans, fs_info, old_roots,
 					      root_objectid, bytenr, num_bytes,
 					      node->seq, type, 0);
+		if (!ret)
+			need_to_free_old_roots = 0;
 		goto out;
 	}
 
@@ -2038,11 +2052,13 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 
 	if (!no_quota) {
-		ret = btrfs_qgroup_record_ref(trans, fs_info, NULL,
+		ret = btrfs_qgroup_record_ref(trans, fs_info, old_roots,
 					      root_objectid, bytenr, num_bytes,
 					      node->seq, type, 0);
 		if (ret)
 			goto out;
+		else
+			need_to_free_old_roots = 0;
 	}
 
 	path->reada = 1;
@@ -2054,6 +2070,8 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	if (ret)
 		btrfs_abort_transaction(trans, root, ret);
 out:
+	if (need_to_free_old_roots)
+		ulist_free(old_roots);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -5797,12 +5815,14 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
 	struct btrfs_extent_inline_ref *iref;
+	struct ulist *old_roots = NULL;
 	int ret;
 	int is_data;
 	int extent_slot = 0;
 	int found_extent = 0;
 	int num_to_del = 1;
 	int no_quota = node->no_quota;
+	int need_to_free_old_roots = 0;
 	u32 item_size;
 	u64 refs;
 	u64 bytenr = node->bytenr;
@@ -5819,6 +5839,14 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
+	if (!no_quota) {
+		need_to_free_old_roots = 1;
+		ret = btrfs_find_all_roots(trans, root->fs_info, node, bytenr,
+					   node->seq, &old_roots, 1);
+		if (ret < 0)
+			goto out;
+	}
+
 	path->reada = 1;
 	path->leave_spinning = 1;
 
@@ -6059,11 +6087,15 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		    type == BTRFS_QGROUP_OPER_SUB_SHARED)
 			mod_seq = 1;
 
-		ret = btrfs_qgroup_record_ref(trans, info, NULL, root_objectid,
-					      bytenr, num_bytes, node->seq,
-					      type, mod_seq);
+		ret = btrfs_qgroup_record_ref(trans, info, old_roots,
+					      root_objectid, bytenr, num_bytes,
+					      node->seq, type, mod_seq);
+		if (!ret)
+			need_to_free_old_roots = 0;
 	}
 out:
+	if (need_to_free_old_roots)
+		ulist_free(old_roots);
 	btrfs_free_path(path);
 	return ret;
 }
-- 
2.3.3

