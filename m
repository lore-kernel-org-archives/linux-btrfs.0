Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14022 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752125AbbCWIKq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 04:10:46 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2N89fCl012356
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 16:09:41 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 08/11] btrfs: qgroup: Record current referenced roots at qgroup_record_ref().
Date: Mon, 23 Mar 2015 16:08:34 +0800
Message-ID: <1427098117-25152-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of problems in old qgroup is, we can only get a view on the final
results when we are going to adjust qgroup accounting.

This makes the following operataion get wrong result:
1. Subvol 257 add an exclusive extent A.
2. Subvol 258 add a shared reference to extent A.
3. Subvol 259 add a shared reference to extent A.
4. Sync

Subvol 258 and 259's qgroup data is consistent, but subvol 257 still
have exclusive reference on extent A.

The problem happens on step 2, where we should decrease exclusive
reference number, but old implement just record the operation type,
and let qgroup get roots reference number at step 4, where extent A is
finally referred by 3 roots.

At the time quota running, it can only see the final result, extent A is
referred by 3 roots (new_refcnt = 3) and before that, referred by 2
roots(old_refcnt = 2).
Quota will only decrease exclusive refer when old_refcnt == old_roots.
However in that case, old_refcnt is the final one, not the one in before
step 2, causing the exclusive counts of 257 untouched.

This patch will records root reference counts at qgroup_record_ref()
timing, which will give correct result.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b82c43c..4ad4106 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1379,6 +1379,14 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 
 	trace_btrfs_qgroup_record_ref(oper);
 
+	if (type == BTRFS_QGROUP_OPER_ADD_SHARED ||
+	    type == BTRFS_QGROUP_OPER_SUB_SHARED) {
+		ret = btrfs_find_all_roots(trans, fs_info, NULL, bytenr, node_seq,
+					   &oper->new_roots, 1);
+		if (ret < 0)
+			goto out;
+	}
+
 	if (type == BTRFS_QGROUP_OPER_SUB_SUBTREE) {
 		/*
 		 * If any operation for this bytenr/ref_root combo
@@ -1390,8 +1398,8 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 		 * drop snapshot.
 		 */
 		if (qgroup_oper_exists(fs_info, oper)) {
-			kfree(oper);
-			return 0;
+			ret = 0;
+			goto out;
 		}
 	}
 
@@ -1399,8 +1407,7 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 	if (ret) {
 		/* Shouldn't happen so have an assert for developers */
 		ASSERT(0);
-		kfree(oper);
-		return ret;
+		goto out;
 	}
 	list_add_tail(&oper->list, &trans->qgroup_ref_list);
 
@@ -1408,6 +1415,11 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 		btrfs_get_tree_mod_seq(fs_info, &oper->elem);
 
 	return 0;
+out:
+	if (ret < 0)
+		ulist_free(oper->new_roots);
+	kfree(oper);
+	return ret;
 }
 
 /*
-- 
2.3.3

