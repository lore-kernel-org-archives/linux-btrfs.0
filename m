Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:33235 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933416Ab2GLJnt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 05:43:49 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH v1 03/15] Btrfs: qgroup on-disk format
Date: Thu, 12 Jul 2012 11:43:35 +0200
Message-Id: <630dc772ea51bca3ec6fac609f450cbe0cafd1d6.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Not all features are in use by the current version
and thus may change in the future.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.h |  136 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 136 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8f8dc46..33088b0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -91,6 +91,9 @@ struct btrfs_ordered_sum;
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
 
+/* holds quota configuration and tracking */
+#define BTRFS_QUOTA_TREE_OBJECTID 8ULL
+
 /* orhpan objectid for tracking unlinked/truncated files */
 #define BTRFS_ORPHAN_OBJECTID -5ULL
 
@@ -883,6 +886,72 @@ struct btrfs_block_group_item {
 	__le64 flags;
 } __attribute__ ((__packed__));
 
+/*
+ * is subvolume quota turned on?
+ */
+#define BTRFS_QGROUP_STATUS_FLAG_ON		(1ULL << 0)
+/*
+ * SCANNING is set during the initialization phase
+ */
+#define BTRFS_QGROUP_STATUS_FLAG_SCANNING	(1ULL << 1)
+/*
+ * Some qgroup entries are known to be out of date,
+ * either because the configuration has changed in a way that
+ * makes a rescan necessary, or because the fs has been mounted
+ * with a non-qgroup-aware version.
+ * Turning qouta off and on again makes it inconsistent, too.
+ */
+#define BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT	(1ULL << 2)
+
+#define BTRFS_QGROUP_STATUS_VERSION        1
+
+struct btrfs_qgroup_status_item {
+	__le64 version;
+	/*
+	 * the generation is updated during every commit. As older
+	 * versions of btrfs are not aware of qgroups, it will be
+	 * possible to detect inconsistencies by checking the
+	 * generation on mount time
+	 */
+	__le64 generation;
+
+	/* flag definitions see above */
+	__le64 flags;
+
+	/*
+	 * only used during scanning to record the progress
+	 * of the scan. It contains a logical address
+	 */
+	__le64 scan;
+} __attribute__ ((__packed__));
+
+struct btrfs_qgroup_info_item {
+	__le64 generation;
+	__le64 rfer;
+	__le64 rfer_cmpr;
+	__le64 excl;
+	__le64 excl_cmpr;
+} __attribute__ ((__packed__));
+
+/* flags definition for qgroup limits */
+#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0)
+#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1)
+#define BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2)
+#define BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3)
+#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4)
+#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5)
+
+struct btrfs_qgroup_limit_item {
+	/*
+	 * only updated when any of the other values change
+	 */
+	__le64 flags;
+	__le64 max_rfer;
+	__le64 max_excl;
+	__le64 rsv_rfer;
+	__le64 rsv_excl;
+} __attribute__ ((__packed__));
+
 struct btrfs_space_info {
 	u64 flags;
 
@@ -1534,6 +1603,30 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_DEV_ITEM_KEY	216
 #define BTRFS_CHUNK_ITEM_KEY	228
 
+/*
+ * Records the overall state of the qgroups.
+ * There's only one instance of this key present,
+ * (0, BTRFS_QGROUP_STATUS_KEY, 0)
+ */
+#define BTRFS_QGROUP_STATUS_KEY         240
+/*
+ * Records the currently used space of the qgroup.
+ * One key per qgroup, (0, BTRFS_QGROUP_INFO_KEY, qgroupid).
+ */
+#define BTRFS_QGROUP_INFO_KEY           242
+/*
+ * Contains the user configured limits for the qgroup.
+ * One key per qgroup, (0, BTRFS_QGROUP_LIMIT_KEY, qgroupid).
+ */
+#define BTRFS_QGROUP_LIMIT_KEY          244
+/*
+ * Records the child-parent relationship of qgroups. For
+ * each relation, 2 keys are present:
+ * (childid, BTRFS_QGROUP_RELATION_KEY, parentid)
+ * (parentid, BTRFS_QGROUP_RELATION_KEY, childid)
+ */
+#define BTRFS_QGROUP_RELATION_KEY       246
+
 #define BTRFS_BALANCE_ITEM_KEY	248
 
 /*
@@ -2474,6 +2567,49 @@ static inline void btrfs_set_dev_stats_value(struct extent_buffer *eb,
 			    sizeof(val));
 }
 
+/* btrfs_qgroup_status_item */
+BTRFS_SETGET_FUNCS(qgroup_status_generation, struct btrfs_qgroup_status_item,
+		   generation, 64);
+BTRFS_SETGET_FUNCS(qgroup_status_version, struct btrfs_qgroup_status_item,
+		   version, 64);
+BTRFS_SETGET_FUNCS(qgroup_status_flags, struct btrfs_qgroup_status_item,
+		   flags, 64);
+BTRFS_SETGET_FUNCS(qgroup_status_scan, struct btrfs_qgroup_status_item,
+		   scan, 64);
+
+/* btrfs_qgroup_info_item */
+BTRFS_SETGET_FUNCS(qgroup_info_generation, struct btrfs_qgroup_info_item,
+		   generation, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_rfer, struct btrfs_qgroup_info_item, rfer, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_rfer_cmpr, struct btrfs_qgroup_info_item,
+		   rfer_cmpr, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_excl, struct btrfs_qgroup_info_item, excl, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_excl_cmpr, struct btrfs_qgroup_info_item,
+		   excl_cmpr, 64);
+
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_generation,
+			 struct btrfs_qgroup_info_item, generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_rfer, struct btrfs_qgroup_info_item,
+			 rfer, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_rfer_cmpr,
+			 struct btrfs_qgroup_info_item, rfer_cmpr, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_excl, struct btrfs_qgroup_info_item,
+			 excl, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_excl_cmpr,
+			 struct btrfs_qgroup_info_item, excl_cmpr, 64);
+
+/* btrfs_qgroup_limit_item */
+BTRFS_SETGET_FUNCS(qgroup_limit_flags, struct btrfs_qgroup_limit_item,
+		   flags, 64);
+BTRFS_SETGET_FUNCS(qgroup_limit_max_rfer, struct btrfs_qgroup_limit_item,
+		   max_rfer, 64);
+BTRFS_SETGET_FUNCS(qgroup_limit_max_excl, struct btrfs_qgroup_limit_item,
+		   max_excl, 64);
+BTRFS_SETGET_FUNCS(qgroup_limit_rsv_rfer, struct btrfs_qgroup_limit_item,
+		   rsv_rfer, 64);
+BTRFS_SETGET_FUNCS(qgroup_limit_rsv_excl, struct btrfs_qgroup_limit_item,
+		   rsv_excl, 64);
+
 static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
 {
 	return sb->s_fs_info;
-- 
1.7.3.4

