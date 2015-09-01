Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18969 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbbIBHvX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Sep 2015 03:51:23 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t810XlIe023763
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 08:33:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 01/14] btrfs: qgroup: New function declaration for new reserve implement
Date: Tue,  1 Sep 2015 08:31:41 +0800
Message-Id: <1441067515-21105-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441067515-21105-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441067515-21105-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new structures and functions for new qgroup reserve implement dirty
phase.
Which will focus on avoiding over-reserve as in that case, which means
for already reserved dirty space range, we won't reserve space again.

This patch adds the needed structure declaration and comments.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |  4 ++++
 fs/btrfs/qgroup.c      | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h      |  3 +++
 3 files changed, 65 insertions(+)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 0ef5cc1..6d799b8 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -24,6 +24,7 @@
 #include "extent_io.h"
 #include "ordered-data.h"
 #include "delayed-inode.h"
+#include "qgroup.h"
 
 /*
  * ordered_data_close is set by truncate when a file that used
@@ -193,6 +194,9 @@ struct btrfs_inode {
 	struct timespec i_otime;
 
 	struct inode vfs_inode;
+
+	/* qgroup dirty map for data space reserve */
+	struct btrfs_qgroup_data_rsv_map *qgroup_rsv_map;
 };
 
 extern unsigned char btrfs_filetype_table[];
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1667567..640106a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -91,6 +91,64 @@ struct btrfs_qgroup {
 	u64 new_refcnt;
 };
 
+/*
+ * Record one range of reserved space.
+ */
+struct data_rsv_range {
+	struct rb_node node;
+	u64 start;
+	u64 len;
+};
+
+/*
+ * Record per inode reserved range.
+ * This is mainly used to resolve reserved space leaking problem.
+ * One of the cause is the mismatch with reserve and free.
+ *
+ * New qgroup will handle reserve in two phase.
+ * 1) Dirty phase.
+ *    Pages are just marked dirty, but not written to disk.
+ * 2) Flushed phase
+ *    Pages are written to disk, but transaction is not committed yet.
+ *
+ * At Diryt phase, we only need to focus on avoiding over-reserve.
+ *
+ * The idea is like below.
+ * 1) Write [0,8K)
+ * 0	4K	8K	12K	16K
+ * |////////////|
+ * Reserve +8K, total reserved: 8K
+ *
+ * 2) Write [0,4K)
+ * 0	4K	8K	12K	16K
+ * |////////////|
+ * Reserve 0, total reserved 8K
+ *
+ * 3) Write [12K,16K)
+ * 0	4K	8K	12K	16K
+ * |////////////|	|///////|
+ * Reserve +4K, tocal reserved 12K
+ *
+ * 4) Flush [0,8K)
+ * Can happen without commit transaction, like fallocate will trigger the
+ * write.
+ * 0	4K	8K	12K	16K
+ * 			|///////|
+ * Reserve 0, tocal reserved 12K
+ * As the extent is written to disk, not dirty any longer, the range get
+ * removed.
+ * But as its delayed_refs is not run, its reserved space will not be freed.
+ * And things continue to Flushed phase.
+ *
+ * By this method, we can avoid over-reserve, which will lead to reserved
+ * space leak.
+ */
+struct btrfs_qgroup_data_rsv_map {
+	struct rb_root root;
+	u64 reserved;
+	spinlock_t lock;
+};
+
 static void btrfs_qgroup_update_old_refcnt(struct btrfs_qgroup *qg, u64 seq,
 					   int mod)
 {
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 6387dcf..2f863a4 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -33,6 +33,9 @@ struct btrfs_qgroup_extent_record {
 	struct ulist *old_roots;
 };
 
+/* For per-inode dirty range reserve */
+struct btrfs_qgroup_data_rsv_map;
+
 int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info);
 int btrfs_quota_disable(struct btrfs_trans_handle *trans,
-- 
2.5.0

