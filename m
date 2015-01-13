Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24013 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751041AbbAMFzJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 00:55:09 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0D5s4fZ009027
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Jan 2015 13:54:04 +0800
From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH v2 RESEND] btrfs-progs: make btrfs qgroups show human readable sizes
Date: Tue, 13 Jan 2015 13:53:39 +0800
Message-ID: <1421128419-17169-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

make btrfs qgroups show human readable sizes
using --human-readable option, example:

qgroupid rfer         excl         max_rfer     max_excl     parent  child
-------- ----         ----         --------     --------     ------  -----
0/5      299.58MiB    299.58MiB    400.00MiB    0.00B        1/1     ---
0/265    299.58MiB    16.00KiB     0.00B        320.00MiB    1/1     ---
0/266    299.58MiB    16.00KiB     350.00MiB    0.00B        ---     ---
1/1      599.16MiB    299.59MiB    800.00MiB    0.00B        ---     0/5,0/265

Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
---
v2:
- change -h option to --human-readable
- merge need_print and human_readable into format
- add print_group_size function

 Documentation/btrfs-qgroup.txt |  2 ++
 cmds-qgroup.c                  | 10 +++++-
 qgroup.c                       | 69 ++++++++++++++++++++++++++++--------------
 qgroup.h                       |  1 +
 4 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/Documentation/btrfs-qgroup.txt b/Documentation/btrfs-qgroup.txt
index 3e13373..d8ed028 100644
--- a/Documentation/btrfs-qgroup.txt
+++ b/Documentation/btrfs-qgroup.txt
@@ -73,6 +73,8 @@ print max exclusive size of qgroup.
 list all qgroups which impact the given path(include ancestral qgroups)
 -f::::
 list all qgroups which impact the given path(exclude ancestral qgroups)
+--human-readable::::
+print sizes in human readable format (e.g., 1KiB 234MiB 2GiB).
 --sort=[\+/-]<attr>[,[+/-]<attr>]...::::
 list qgroups in order of <attr>.
 +
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 957fbc9..ba6f19b 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -216,6 +216,8 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"(include ancestral qgroups)",
 	"-f		list all qgroups which impact the given path"
 	"(exclude ancestral qgroups)",
+	"--human-readable",
+	"		print sizes in human readable format (e.g., 1KiB 234MiB 2GiB)",
 	"--sort=qgroupid,rfer,excl,max_rfer,max_excl",
 	"		list qgroups in order of qgroupid,"
 	"rfer,max_rfer or max_excl",
@@ -234,6 +236,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 	int c;
 	u64 qgroupid;
 	int filter_flag = 0;
+	int option_index = 0;
 
 	struct btrfs_qgroup_comparer_set *comparer_set;
 	struct btrfs_qgroup_filter_set *filter_set;
@@ -241,16 +244,21 @@ static int cmd_qgroup_show(int argc, char **argv)
 	comparer_set = btrfs_qgroup_alloc_comparer_set();
 	struct option long_options[] = {
 		{"sort", 1, NULL, 'S'},
+		{"human-readable", 0, NULL, 0},
 		{0, 0, 0, 0}
 	};
 
 	optind = 1;
 	while (1) {
 		c = getopt_long(argc, argv, "pcreFf",
-				long_options, NULL);
+				long_options, &option_index);
 		if (c < 0)
 			break;
 		switch (c) {
+		case 0:
+			if (option_index == 1)
+				btrfs_qgroup_setup_human_readable();
+			break;
 		case 'p':
 			btrfs_qgroup_setup_print_column(
 				BTRFS_QGROUP_PARENT);
diff --git a/qgroup.c b/qgroup.c
index 1a4866c..ce87fe4 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -20,10 +20,14 @@
 #include <sys/ioctl.h>
 #include "ctree.h"
 #include "ioctl.h"
+#include "utils.h"
 
 #define BTRFS_QGROUP_NFILTERS_INCREASE (2 * BTRFS_QGROUP_FILTER_MAX)
 #define BTRFS_QGROUP_NCOMPS_INCREASE (2 * BTRFS_QGROUP_COMP_MAX)
 
+#define BTRFS_QGROUP_FORMAT_PRINT 1
+#define BTRFS_QGROUP_FORMAT_HUMAN (1U << 1)
+
 struct qgroup_lookup {
 	struct rb_root root;
 };
@@ -79,54 +83,54 @@ struct btrfs_qgroup_list {
 static struct {
 	char *name;
 	char *column_name;
-	int need_print;
+	unsigned int format;
 	int max_len;
 } btrfs_qgroup_columns[] = {
 	{
 		.name		= "qgroupid",
 		.column_name	= "Qgroupid",
-		.need_print	= 1,
+		.format		= BTRFS_QGROUP_FORMAT_PRINT,
 		.max_len	= 8,
 	},
 	{
 		.name		= "rfer",
 		.column_name	= "Rfer",
-		.need_print	= 1,
-		.max_len	= 4,
+		.format		= BTRFS_QGROUP_FORMAT_PRINT,
+		.max_len	= 12,
 	},
 	{
 		.name		= "excl",
 		.column_name	= "Excl",
-		.need_print	= 1,
-		.max_len	= 4,
+		.format		= BTRFS_QGROUP_FORMAT_PRINT,
+		.max_len	= 12,
 	},
 	{	.name		= "max_rfer",
 		.column_name	= "Max_rfer",
-		.need_print	= 0,
-		.max_len	= 8,
+		.format		= 0,
+		.max_len	= 12,
 	},
 	{
 		.name		= "max_excl",
 		.column_name	= "Max_excl",
-		.need_print	= 0,
-		.max_len	= 8,
+		.format		= 0,
+		.max_len	= 12,
 	},
 	{
 		.name		= "parent",
 		.column_name	= "Parent",
-		.need_print	= 0,
+		.format		= 0,
 		.max_len	= 7,
 	},
 	{
 		.name		= "child",
 		.column_name	= "Child",
-		.need_print	= 0,
+		.format		= 0,
 		.max_len	= 5,
 	},
 	{
 		.name		= NULL,
 		.column_name	= NULL,
-		.need_print	= 0,
+		.format		= 0,
 	},
 };
 
@@ -140,11 +144,19 @@ void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column)
 	BUG_ON(column < 0 || column > BTRFS_QGROUP_ALL);
 
 	if (column < BTRFS_QGROUP_ALL) {
-		btrfs_qgroup_columns[column].need_print = 1;
+		btrfs_qgroup_columns[column].format |= BTRFS_QGROUP_FORMAT_PRINT;
 		return;
 	}
 	for (i = 0; i < BTRFS_QGROUP_ALL; i++)
-		btrfs_qgroup_columns[i].need_print = 1;
+		btrfs_qgroup_columns[i].format |= BTRFS_QGROUP_FORMAT_PRINT;
+}
+
+void btrfs_qgroup_setup_human_readable(void)
+{
+	btrfs_qgroup_columns[BTRFS_QGROUP_RFER].format |= BTRFS_QGROUP_FORMAT_HUMAN;
+	btrfs_qgroup_columns[BTRFS_QGROUP_EXCL].format |= BTRFS_QGROUP_FORMAT_HUMAN;
+	btrfs_qgroup_columns[BTRFS_QGROUP_MAX_RFER].format |= BTRFS_QGROUP_FORMAT_HUMAN;
+	btrfs_qgroup_columns[BTRFS_QGROUP_MAX_EXCL].format |= BTRFS_QGROUP_FORMAT_HUMAN;
 }
 
 static int print_parent_column(struct btrfs_qgroup *qgroup)
@@ -189,6 +201,17 @@ static void print_qgroup_column_add_blank(enum btrfs_qgroup_column_enum column,
 		printf(" ");
 }
 
+static int print_qgroup_size(u64 size, unsigned int format)
+{
+	int len;
+	if (format & BTRFS_QGROUP_FORMAT_HUMAN)
+		len = printf("%s", pretty_size(size));
+	else
+		len = printf("%llu", size);
+
+	return len;
+}
+
 static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 				enum btrfs_qgroup_column_enum column)
 {
@@ -203,11 +226,11 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
 		break;
 	case BTRFS_QGROUP_RFER:
-		len = printf("%llu", qgroup->rfer);
+		len = print_qgroup_size(qgroup->rfer, btrfs_qgroup_columns[column].format);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_RFER, len);
 		break;
 	case BTRFS_QGROUP_EXCL:
-		len = printf("%llu", qgroup->excl);
+		len = print_qgroup_size(qgroup->excl, btrfs_qgroup_columns[column].format);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_EXCL, len);
 		break;
 	case BTRFS_QGROUP_PARENT:
@@ -215,11 +238,11 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		print_qgroup_column_add_blank(BTRFS_QGROUP_PARENT, len);
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		len = printf("%llu", qgroup->max_rfer);
+		len = print_qgroup_size(qgroup->max_rfer, btrfs_qgroup_columns[column].format);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_RFER, len);
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		len = printf("%llu", qgroup->max_excl);
+		len = print_qgroup_size(qgroup->max_excl, btrfs_qgroup_columns[column].format);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_EXCL, len);
 		break;
 	case BTRFS_QGROUP_CHILD:
@@ -236,7 +259,7 @@ static void print_single_qgroup_table(struct btrfs_qgroup *qgroup)
 	int i;
 
 	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
-		if (!btrfs_qgroup_columns[i].need_print)
+		if (!(btrfs_qgroup_columns[i].format & BTRFS_QGROUP_FORMAT_PRINT))
 			continue;
 		print_qgroup_column(qgroup, i);
 
@@ -252,7 +275,7 @@ static void print_table_head()
 	int len;
 
 	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
-		if (!btrfs_qgroup_columns[i].need_print)
+		if (!(btrfs_qgroup_columns[i].format & BTRFS_QGROUP_FORMAT_PRINT))
 			continue;
 		printf("%s", btrfs_qgroup_columns[i].name);
 		len = btrfs_qgroup_columns[i].max_len -
@@ -263,7 +286,7 @@ static void print_table_head()
 	}
 	printf("\n");
 	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
-		if (!btrfs_qgroup_columns[i].need_print)
+		if (!(btrfs_qgroup_columns[i].format & BTRFS_QGROUP_FORMAT_PRINT))
 			continue;
 
 		len = strlen(btrfs_qgroup_columns[i].name);
@@ -957,7 +980,7 @@ static void update_columns_max_len(struct btrfs_qgroup *bq)
 	int i;
 
 	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
-		if (!btrfs_qgroup_columns[i].need_print)
+		if (!(btrfs_qgroup_columns[i].format & BTRFS_QGROUP_FORMAT_PRINT))
 			continue;
 		__update_columns_max_len(bq, i);
 	}
diff --git a/qgroup.h b/qgroup.h
index 653cf1c..cc8ae29 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -83,6 +83,7 @@ u64 btrfs_get_path_rootid(int fd);
 int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
 		       struct btrfs_qgroup_comparer_set *);
 void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column);
+void btrfs_qgroup_setup_human_readable(void);
 struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void);
 void btrfs_qgroup_free_filter_set(struct btrfs_qgroup_filter_set *filter_set);
 int btrfs_qgroup_setup_filter(struct btrfs_qgroup_filter_set **filter_set,
-- 
1.9.1

