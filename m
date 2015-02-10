Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51320 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755148AbbBJK1t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:49 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAR27K000966
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:27:02 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH 4/4] btrfs-progs:show qgroup type
Date: Tue, 10 Feb 2015 18:24:18 +0800
Message-ID: <1423563862-9151-8-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>

make 'btrfs qgroup show' command show qgroup type.

Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
---
 qgroup.c | 42 +++++++++++++++++++++++++++++++++++++++---
 qgroup.h |  1 +
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index a647925..d359659 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -135,6 +135,13 @@ static struct {
 		.max_len	= 5,
 	},
 	{
+		.name		= "type",
+		.column_name	= "Type",
+		.need_print	= 1,
+		.unit_mode	= 0,
+		.max_len	= 8,
+	},
+	{
 		.name		= NULL,
 		.column_name	= NULL,
 		.need_print	= 0,
@@ -201,6 +208,20 @@ static int print_child_column(struct btrfs_qgroup *qgroup)
 	return len;
 }
 
+static int print_type_column(struct btrfs_qgroup *qgroup)
+{
+	__u8 type = qgroup->type;
+	int len = 0;
+
+	if (type == BTRFS_QGROUP_TYPE_DATA)
+		len = printf("data");
+	if (type == BTRFS_QGROUP_TYPE_METADATA)
+		len = printf("metadata");
+	if (type == BTRFS_QGROUP_TYPE_MIXED)
+		len = printf("metadata,data");
+	return len;
+}
+
 static void print_qgroup_column_add_blank(enum btrfs_qgroup_column_enum column,
 					  int len)
 {
@@ -244,6 +265,10 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		len = print_child_column(qgroup);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_CHILD, len);
 		break;
+	case BTRFS_QGROUP_TYPE:
+		len = print_type_column(qgroup);
+		print_qgroup_column_add_blank(BTRFS_QGROUP_TYPE, len);
+		break;
 	default:
 		break;
 	}
@@ -258,7 +283,7 @@ static void print_single_qgroup_table(struct btrfs_qgroup *qgroup)
 			continue;
 		print_qgroup_column(qgroup, i);
 
-		if (i != BTRFS_QGROUP_CHILD)
+		if (i != BTRFS_QGROUP_ALL - 1)
 			printf(" ");
 	}
 	printf("\n");
@@ -275,7 +300,7 @@ static void print_table_head()
 		if (!btrfs_qgroup_columns[i].need_print)
 			continue;
 		if ((i == BTRFS_QGROUP_QGROUPID) | (i == BTRFS_QGROUP_PARENT) |
-			(i == BTRFS_QGROUP_CHILD))
+			(i == BTRFS_QGROUP_CHILD) | (i == BTRFS_QGROUP_TYPE))
 			printf("%-*s", max_len, btrfs_qgroup_columns[i].name);
 		else
 			printf("%*s", max_len, btrfs_qgroup_columns[i].name);
@@ -287,7 +312,7 @@ static void print_table_head()
 		if (!btrfs_qgroup_columns[i].need_print)
 			continue;
 		if ((i == BTRFS_QGROUP_QGROUPID) | (i == BTRFS_QGROUP_PARENT) |
-			(i == BTRFS_QGROUP_CHILD)) {
+			(i == BTRFS_QGROUP_CHILD) | (i == BTRFS_QGROUP_TYPE)) {
 			len = strlen(btrfs_qgroup_columns[i].name);
 			while (len--)
 				printf("-");
@@ -976,6 +1001,17 @@ static void __update_columns_max_len(struct btrfs_qgroup *bq,
 		if (btrfs_qgroup_columns[column].max_len < len)
 			btrfs_qgroup_columns[column].max_len = len;
 		break;
+	case BTRFS_QGROUP_TYPE:
+		len = 0;
+		if (bq->type == BTRFS_QGROUP_TYPE_DATA)
+			len = strlen("data");
+		if (bq->type == BTRFS_QGROUP_TYPE_METADATA)
+			len = strlen("metadata");
+		if (bq->type == BTRFS_QGROUP_TYPE_MIXED)
+			len = strlen("metadata,data");
+		if (btrfs_qgroup_columns[column].max_len < len)
+			btrfs_qgroup_columns[column].max_len = len;
+		break;
 	default:
 		break;
 	}
diff --git a/qgroup.h b/qgroup.h
index 8423fdf..cc61477 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -75,6 +75,7 @@ enum btrfs_qgroup_column_enum {
 	BTRFS_QGROUP_MAX_EXCL,
 	BTRFS_QGROUP_PARENT,
 	BTRFS_QGROUP_CHILD,
+        BTRFS_QGROUP_TYPE,
 	BTRFS_QGROUP_ALL,
 };
 
-- 
1.8.4.2

