Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27943 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754918AbbBJK1n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:43 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQtw7000945
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:55 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/4] btrfs-progs: Add type to qgroup.
Date: Tue, 10 Feb 2015 18:24:12 +0800
Message-ID: <1423563862-9151-2-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 ctree.h      | 12 +++++++++++-
 ioctl.h      |  1 +
 mkfs.c       |  2 ++
 print-tree.c |  9 +++++++++
 qgroup.c     | 25 +++++++++++++++++++------
 qgroup.h     | 16 ++++++++++++++++
 6 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/ctree.h b/ctree.h
index c069a95..6b8e144 100644
--- a/ctree.h
+++ b/ctree.h
@@ -474,6 +474,10 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
 
+/*
+ *  * Add a type in btrfs_qgroup_info_item;
+ *   */
+#define BTRFS_FEATURE_INCOMPAT_QGROUP_TYPE      (1ULL << 10)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
@@ -486,7 +490,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_QGROUP_TYPE)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -892,6 +897,7 @@ struct btrfs_qgroup_info_item {
 	__le64 referenced_compressed;
 	__le64 exclusive;
 	__le64 exclusive_compressed;
+	__u8   type;
 } __attribute__ ((__packed__));
 
 /* flags definition for qgroup limits */
@@ -2059,6 +2065,8 @@ BTRFS_SETGET_FUNCS(qgroup_status_scan, struct btrfs_qgroup_status_item,
 /* btrfs_qgroup_info_item */
 BTRFS_SETGET_FUNCS(qgroup_info_generation, struct btrfs_qgroup_info_item,
 		   generation, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_type, struct btrfs_qgroup_info_item,
+		   type, 8);
 BTRFS_SETGET_FUNCS(qgroup_info_referenced, struct btrfs_qgroup_info_item,
 		   referenced, 64);
 BTRFS_SETGET_FUNCS(qgroup_info_referenced_compressed,
@@ -2070,6 +2078,8 @@ BTRFS_SETGET_FUNCS(qgroup_info_exclusive_compressed,
 
 BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_generation,
 			 struct btrfs_qgroup_info_item, generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_type,
+			 struct btrfs_qgroup_info_item, type, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_referenced,
 			 struct btrfs_qgroup_info_item, referenced, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_referenced_compressed,
diff --git a/ioctl.h b/ioctl.h
index a47eab8..892f8de 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -77,6 +77,7 @@ struct btrfs_ioctl_vol_args_v2 {
 		struct {
 			__u64 size;
 			struct btrfs_qgroup_inherit *qgroup_inherit;
+			__u8 qgroup_type;
 		};
 		__u64 unused[4];
 	};
diff --git a/mkfs.c b/mkfs.c
index 18c4cb0..379068d 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1144,6 +1144,8 @@ static const struct btrfs_fs_feature {
 		"reduced-size metadata extent refs" },
 	{ "no-holes", BTRFS_FEATURE_INCOMPAT_NO_HOLES,
 		"no explicit hole extents for files" },
+	{ "qgroup-type", BTRFS_FEATURE_INCOMPAT_QGROUP_TYPE,
+		"create qgroup in different type" },
 	/* Keep this one last */
 	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
 };
diff --git a/print-tree.c b/print-tree.c
index 70a7acc..6bfcc32 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -25,6 +25,7 @@
 #include "disk-io.h"
 #include "print-tree.h"
 #include "utils.h"
+#include "qgroup.h"
 
 
 static void print_dir_item_type(struct extent_buffer *eb,
@@ -797,6 +798,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	u32 nr = btrfs_header_nritems(l);
 	u64 objectid;
 	u32 type;
+	u8 qgroup_type = BTRFS_QGROUP_TYPE_DEFAULT;
 	char bg_flags_str[32];
 
 	printf("leaf %llu items %d free space %d generation %llu owner %llu\n",
@@ -980,6 +982,13 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			       (unsigned long long)
 			       btrfs_qgroup_info_exclusive_compressed(l,
 								      qg_info));
+			
+			if (btrfs_fs_incompat(root->fs_info,
+					BTRFS_FEATURE_INCOMPAT_QGROUP_TYPE))
+				qgroup_type = btrfs_qgroup_info_type(l, qg_info);
+
+			printf("\t\tqgroup type %u\n",
+			       (unsigned int)qgroup_type);
 			break;
 		case BTRFS_QGROUP_LIMIT_KEY:
 			qg_limit = btrfs_item_ptr(l, i,
diff --git a/qgroup.c b/qgroup.c
index 620ec7e..8a7c20f 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -48,6 +48,7 @@ struct btrfs_qgroup {
 	u64 rfer_cmpr;	/*referenced compressed*/
 	u64 excl;	/*exclusive*/
 	u64 excl_cmpr;	/*exclusive compressed*/
+	u8 type;
 
 	/*
 	 *limit_item
@@ -572,7 +573,7 @@ static struct btrfs_qgroup *qgroup_tree_search(struct qgroup_lookup *root_tree,
 
 static int update_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 			 u64 generation, u64 rfer, u64 rfer_cmpr, u64 excl,
-			 u64 excl_cmpr, u64 flags, u64 max_rfer, u64 max_excl,
+			 u64 excl_cmpr, u8 type, u64 flags, u64 max_rfer, u64 max_excl,
 			 u64 rsv_rfer, u64 rsv_excl, struct btrfs_qgroup *pa,
 			 struct btrfs_qgroup *child)
 {
@@ -593,6 +594,8 @@ static int update_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 		bq->excl = excl;
 	if (excl_cmpr)
 		bq->excl_cmpr = excl_cmpr;
+	if (type)
+		bq->type = type;
 	if (flags)
 		bq->flags = flags;
 	if (max_rfer)
@@ -617,7 +620,7 @@ static int update_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 
 static int add_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 		      u64 generation, u64 rfer, u64 rfer_cmpr, u64 excl,
-		      u64 excl_cmpr, u64 flags, u64 max_rfer, u64 max_excl,
+		      u64 excl_cmpr, u8 type, u64 flags, u64 max_rfer, u64 max_excl,
 		      u64 rsv_rfer, u64 rsv_excl, struct btrfs_qgroup *parent,
 		      struct btrfs_qgroup *child)
 {
@@ -626,7 +629,7 @@ static int add_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 	int ret;
 
 	ret = update_qgroup(qgroup_lookup, qgroupid, generation, rfer,
-			    rfer_cmpr, excl, excl_cmpr, flags, max_rfer,
+			    rfer_cmpr, excl, excl_cmpr, type, flags, max_rfer,
 			    max_excl, rsv_rfer, rsv_excl, parent, child);
 	if (!ret)
 		return 0;
@@ -652,6 +655,8 @@ static int add_qgroup(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 		bq->excl = excl;
 	if (excl_cmpr)
 		bq->excl_cmpr = excl_cmpr;
+	if (type)
+		bq->type = type;
 	if (flags)
 		bq->flags = flags;
 	if (max_rfer)
@@ -1031,6 +1036,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 	u64 a3;
 	u64 a4;
 	u64 a5;
+	u8 type;
 
 	memset(&args, 0, sizeof(args));
 
@@ -1044,6 +1050,8 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 
 	qgroup_lookup_init(qgroup_lookup);
 
+	type = BTRFS_QGROUP_TYPE_DEFAULT;
+
 	while (1) {
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		e = errno;
@@ -1079,8 +1087,13 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				a5 =
 				  btrfs_stack_qgroup_info_exclusive_compressed
 				  (info);
+				/*
+				 * Check incompatability of qgroup->type.
+				 */
+				if (sh->len == sizeof(*info))
+					type = btrfs_stack_qgroup_info_type(info);
 				add_qgroup(qgroup_lookup, sh->offset, a1, a2,
-					   a3, a4, a5, 0, 0, 0, 0, 0, 0, 0);
+					   a3, a4, a5, type, 0, 0, 0, 0, 0, 0, 0);
 			} else if (sh->type == BTRFS_QGROUP_LIMIT_KEY) {
 				limit = (struct btrfs_qgroup_limit_item *)
 				    (args.buf + off);
@@ -1095,7 +1108,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				a5 = btrfs_stack_qgroup_limit_rsv_exclusive
 				     (limit);
 				add_qgroup(qgroup_lookup, sh->offset, 0, 0,
-					   0, 0, 0, a1, a2, a3, a4, a5, 0, 0);
+					   0, 0, 0, 0, a1, a2, a3, a4, a5, 0, 0);
 			} else if (sh->type == BTRFS_QGROUP_RELATION_KEY) {
 				if (sh->offset < sh->objectid)
 					goto skip;
@@ -1108,7 +1121,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				if (!bq1)
 					goto skip;
 				add_qgroup(qgroup_lookup, sh->offset, 0, 0,
-					   0, 0, 0, 0, 0, 0, 0, 0, bq, bq1);
+					   0, 0, 0, 0, 0, 0, 0, 0, 0, bq, bq1);
 			} else
 				goto done;
 skip:
diff --git a/qgroup.h b/qgroup.h
index e5d03ca..421eb42 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -22,6 +22,22 @@
 #include "ioctl.h"
 #include "kerncompat.h"
 
+/*
+ *  * Type for qgroup.
+ *   */
+#define BTRFS_QGROUP_TYPE_DATA          (1 << 0)
+#define BTRFS_QGROUP_TYPE_METADATA      (1 << 1)
+#define BTRFS_QGROUP_TYPE_MIXED         (BTRFS_QGROUP_TYPE_DATA | \
+                                         BTRFS_QGROUP_TYPE_METADATA)
+
+#define BTRFS_QGROUP_TYPE_DEFAULT       BTRFS_QGROUP_TYPE_MIXED
+
+/*
+ *  * We are using the first byte in ->create of btrfs_ioctl_qgroup_create_args
+ *   * to specify the type of the qgroup to be created.
+ *    */
+#define BTRFS_QGROUP_TYPE_SHIFT         56
+
 struct btrfs_qgroup;
 
 typedef int (*btrfs_qgroup_filter_func)(struct btrfs_qgroup *, u64);
-- 
1.8.4.2

