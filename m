Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55030 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031478AbbD2CbZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 22:31:25 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3T2U9sP018330
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 10:30:09 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 09/18] btrfs: qgroup: Add new function to record old_roots.
Date: Wed, 29 Apr 2015 10:29:02 +0800
Message-ID: <1430274551-9277-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add function btrfs_qgroup_prepare_account_extents() to get old_roots
which are needed for qgroup.

We do it in commit_transaction() and before switch_roots(), and only
search commit_root, so it gives a quite accurate view for previous
transaction.

With old_roots from previous transaction, we can use it to do accurate
account with current transaction.
---
v2:
  None

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 27 +++++++++++++++++++++++++++
 fs/btrfs/qgroup.h |  2 ++
 2 files changed, 29 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 505f6f3..3040296 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1403,6 +1403,33 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
+					 struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_qgroup_extent_record *record;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct rb_node *node;
+	int ret = 0;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	/*
+	 * No need to do lock, since this function will only be called in
+	 * btrfs_commmit_transaction().
+	 */
+	node = rb_first(&delayed_refs->dirty_extent_root);
+	while (node) {
+		record = rb_entry(node, struct btrfs_qgroup_extent_record,
+				  node);
+		ret = btrfs_find_all_roots(NULL, fs_info, record->bytenr, 0,
+					   &record->old_roots);
+		if (ret < 0)
+			break;
+		node = rb_next(node);
+	}
+	return ret;
+}
+
 struct btrfs_qgroup_extent_record
 *btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
 				  struct btrfs_qgroup_extent_record *record)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 7754d08..3b549cb 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -99,6 +99,8 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 			    u64 bytenr, u64 num_bytes,
 			    enum btrfs_qgroup_operation_type type,
 			    int mod_seq);
+int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
+					 struct btrfs_fs_info *fs_info);
 struct btrfs_qgroup_extent_record
 *btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
 				  struct btrfs_qgroup_extent_record *record);
-- 
2.3.6

