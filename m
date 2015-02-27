Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33515 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755066AbbB0I0l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:26:41 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8PlBp019915
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:25:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/7] btrfs-progs: Update qgroup status flags and replace qgroup level/subvid calculation with inline function.
Date: Fri, 27 Feb 2015 16:26:33 +0800
Message-ID: <1425025599-30048-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ctree.h of btrfs-progs contains wrong flags for btrfs_qgroup_status.
Update it with the one in kernel.

Also, introduce the inline function btrfs_qgroup_(level/subvid) to get
the level/subvolid of qgroup, to replace the old open-coded bit
operations.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-qgroup.c |  2 +-
 ctree.h       | 17 +++++++++++++----
 print-tree.c  |  8 ++++----
 qgroup.c      | 28 ++++++++++++++++------------
 4 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index c5082f7..2d6d84b 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -52,7 +52,7 @@ static int qgroup_assign(int assign, int argc, char **argv)
 	/*
 	 * FIXME src should accept subvol path
 	 */
-	if ((args.src >> 48) >= (args.dst >> 48)) {
+	if (btrfs_qgroup_level(args.src) >= btrfs_qgroup_level(args.dst)) {
 		fprintf(stderr, "ERROR: bad relation requested '%s'\n", path);
 		return 1;
 	}
diff --git a/ctree.h b/ctree.h
index 901c340..1914a70 100644
--- a/ctree.h
+++ b/ctree.h
@@ -868,11 +868,20 @@ struct btrfs_csum_item {
  */
 #define BTRFS_SPACE_INFO_GLOBAL_RSV    (1ULL << 49)
 
-#define BTRFS_QGROUP_STATUS_OFF			0
-#define BTRFS_QGROUP_STATUS_ON			1
-#define BTRFS_QGROUP_STATUS_SCANNING		2
+#define BTRFS_QGROUP_LEVEL_SHIFT		48
+static inline u64 btrfs_qgroup_level(u64 qgroupid)
+{
+	return qgroupid >> BTRFS_QGROUP_LEVEL_SHIFT;
+}
+
+static inline u64 btrfs_qgroup_subvid(u64 qgroupid)
+{
+	return qgroupid & ((1ULL << BTRFS_QGROUP_LEVEL_SHIFT) - 1);
+}
 
-#define BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT	(1 << 0)
+#define BTRFS_QGROUP_STATUS_FLAG_ON		(1ULL << 0)
+#define BTRFS_QGROUP_STATUS_FLAG_RESCAN		(1ULL << 1)
+#define BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT	(1ULL << 2)
 
 struct btrfs_qgroup_status_item {
 	__le64 version;
diff --git a/print-tree.c b/print-tree.c
index 931a321..30adc1a 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -645,8 +645,8 @@ static void print_objectid(u64 objectid, u8 type)
 		printf("%llu", (unsigned long long)objectid); /* device id */
 		return;
 	case BTRFS_QGROUP_RELATION_KEY:
-		printf("%llu/%llu", objectid >> 48,
-			objectid & ((1ll << 48) - 1));
+		printf("%llu/%llu", btrfs_qgroup_level(objectid),
+		       btrfs_qgroup_subvid(objectid));
 		return;
 	case BTRFS_UUID_KEY_SUBVOL:
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
@@ -743,8 +743,8 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 	case BTRFS_QGROUP_RELATION_KEY:
 	case BTRFS_QGROUP_INFO_KEY:
 	case BTRFS_QGROUP_LIMIT_KEY:
-		printf(" %llu/%llu)", (unsigned long long)(offset >> 48),
-			(unsigned long long)(offset & ((1ll << 48) - 1)));
+		printf(" %llu/%llu)", btrfs_qgroup_level(offset),
+		       btrfs_qgroup_subvid(offset));
 		break;
 	case BTRFS_UUID_KEY_SUBVOL:
 	case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
diff --git a/qgroup.c b/qgroup.c
index d59f4bb..62f8777 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -171,8 +171,9 @@ static int print_parent_column(struct btrfs_qgroup *qgroup)
 	int len = 0;
 
 	list_for_each_entry(list, &qgroup->qgroups, next_qgroup) {
-		len += printf("%llu/%llu", (list->qgroup)->qgroupid >> 48,
-			((1ll << 48) - 1) & (list->qgroup)->qgroupid);
+		len += printf("%llu/%llu",
+			      btrfs_qgroup_level(list->qgroup->qgroupid),
+			      btrfs_qgroup_subvid(list->qgroup->qgroupid));
 		if (!list_is_last(&list->next_qgroup, &qgroup->qgroups))
 			len += printf(",");
 	}
@@ -188,8 +189,9 @@ static int print_child_column(struct btrfs_qgroup *qgroup)
 	int len = 0;
 
 	list_for_each_entry(list, &qgroup->members, next_member) {
-		len += printf("%llu/%llu", (list->member)->qgroupid >> 48,
-				((1ll << 48) - 1) & (list->member)->qgroupid);
+		len += printf("%llu/%llu",
+			      btrfs_qgroup_level(list->member->qgroupid),
+			      btrfs_qgroup_subvid(list->member->qgroupid));
 		if (!list_is_last(&list->next_member, &qgroup->members))
 			len += printf(",");
 	}
@@ -218,8 +220,9 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 	switch (column) {
 
 	case BTRFS_QGROUP_QGROUPID:
-		len = printf("%llu/%llu", qgroup->qgroupid >> 48,
-				((1ll << 48) - 1) & qgroup->qgroupid);
+		len = printf("%llu/%llu",
+			     btrfs_qgroup_level(qgroup->qgroupid),
+			     btrfs_qgroup_subvid(qgroup->qgroupid));
 		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
 		break;
 	case BTRFS_QGROUP_RFER:
@@ -920,8 +923,9 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 	switch (column) {
 
 	case BTRFS_QGROUP_QGROUPID:
-		sprintf(tmp, "%llu/%llu", (bq->qgroupid >> 48),
-			bq->qgroupid & ((1ll << 48) - 1));
+		sprintf(tmp, "%llu/%llu",
+			btrfs_qgroup_level(bq->qgroupid),
+			btrfs_qgroup_subvid(bq->qgroupid));
 		len = strlen(tmp);
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
@@ -950,8 +954,8 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 		len = 0;
 		list_for_each_entry(list, &bq->qgroups, next_qgroup) {
 			len += sprintf(tmp, "%llu/%llu",
-				(list->qgroup)->qgroupid >> 48,
-				((1ll << 48) - 1) & (list->qgroup)->qgroupid);
+				btrfs_qgroup_level(list->qgroup->qgroupid),
+				btrfs_qgroup_subvid(list->qgroup->qgroupid));
 			if (!list_is_last(&list->next_qgroup, &bq->qgroups))
 				len += 1;
 		}
@@ -962,8 +966,8 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 		len = 0;
 		list_for_each_entry(list, &bq->members, next_member) {
 			len += sprintf(tmp, "%llu/%llu",
-				(list->member)->qgroupid >> 48,
-				((1ll << 48) - 1) & (list->member)->qgroupid);
+				btrfs_qgroup_level(list->member->qgroupid),
+				btrfs_qgroup_subvid(list->member->qgroupid));
 			if (!list_is_last(&list->next_member, &bq->members))
 				len += 1;
 		}
-- 
2.3.0

