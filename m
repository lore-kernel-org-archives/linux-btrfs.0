Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48649 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753296AbbAIGsT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 01:48:19 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t096lWkk023545
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Jan 2015 14:47:32 +0800
From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: make btrfs qgroups show human readable sizes
Date: Fri, 9 Jan 2015 14:47:05 +0800
Message-ID: <1420786025-7361-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

make btrfs qgroups show human readable sizes, using -h option, example:

qgroupid rfer         excl         max_rfer     max_excl     parent  child
-------- ----         ----         --------     --------     ------  -----
0/5      299.58MiB    299.58MiB    400.00MiB    0.00B        1/1     ---
0/265    299.58MiB    16.00KiB     0.00B        320.00MiB    1/1     ---
0/266    299.58MiB    16.00KiB     350.00MiB    0.00B        ---     ---
1/1      599.16MiB    299.59MiB    800.00MiB    0.00B        ---     0/5,0/265

Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-qgroup.txt |  2 ++
 cmds-qgroup.c                  |  6 +++++-
 qgroup.c                       | 46 ++++++++++++++++++++++++++++++++++--------
 qgroup.h                       |  1 +
 4 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/Documentation/btrfs-qgroup.txt b/Documentation/btrfs-qgroup.txt
index 3e13373..6a3d649 100644
--- a/Documentation/btrfs-qgroup.txt
+++ b/Documentation/btrfs-qgroup.txt
@@ -69,6 +69,8 @@ print child qgroup id.
 print max referenced size of qgroup.
 -e::::
 print max exclusive size of qgroup.
+-h::::
+print sizes in human readable format (e.g., 1KiB 234MiB 2GiB).
 -F::::
 list all qgroups which impact the given path(include ancestral qgroups)
 -f::::
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 957fbc9..c2bd0a3 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -212,6 +212,7 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"-c		print child qgroup id",
 	"-r		print max referenced size of qgroup",
 	"-e		print max exclusive size of qgroup",
+	"-h		print sizes in human readable format (e.g., 1KiB 234MiB 2GiB)",
 	"-F		list all qgroups which impact the given path"
 	"(include ancestral qgroups)",
 	"-f		list all qgroups which impact the given path"
@@ -246,7 +247,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		c = getopt_long(argc, argv, "pcreFf",
+		c = getopt_long(argc, argv, "pcrehFf",
 				long_options, NULL);
 		if (c < 0)
 			break;
@@ -267,6 +268,9 @@ static int cmd_qgroup_show(int argc, char **argv)
 			btrfs_qgroup_setup_print_column(
 				BTRFS_QGROUP_MAX_EXCL);
 			break;
+		case 'h':
+			btrfs_qgroup_setup_human_readable();
+			break;
 		case 'F':
 			filter_flag |= 0x1;
 			break;
diff --git a/qgroup.c b/qgroup.c
index 1a4866c..5cb239e 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -20,6 +20,7 @@
 #include <sys/ioctl.h>
 #include "ctree.h"
 #include "ioctl.h"
+#include "utils.h"
 
 #define BTRFS_QGROUP_NFILTERS_INCREASE (2 * BTRFS_QGROUP_FILTER_MAX)
 #define BTRFS_QGROUP_NCOMPS_INCREASE (2 * BTRFS_QGROUP_COMP_MAX)
@@ -80,53 +81,62 @@ static struct {
 	char *name;
 	char *column_name;
 	int need_print;
+	int human_readable;
 	int max_len;
 } btrfs_qgroup_columns[] = {
 	{
 		.name		= "qgroupid",
 		.column_name	= "Qgroupid",
 		.need_print	= 1,
+		.human_readable = 0,
 		.max_len	= 8,
 	},
 	{
 		.name		= "rfer",
 		.column_name	= "Rfer",
 		.need_print	= 1,
-		.max_len	= 4,
+		.human_readable = 0,
+		.max_len	= 12,
 	},
 	{
 		.name		= "excl",
 		.column_name	= "Excl",
 		.need_print	= 1,
-		.max_len	= 4,
+		.human_readable = 0,
+		.max_len	= 12,
 	},
 	{	.name		= "max_rfer",
 		.column_name	= "Max_rfer",
 		.need_print	= 0,
-		.max_len	= 8,
+		.human_readable = 0,
+		.max_len	= 12,
 	},
 	{
 		.name		= "max_excl",
 		.column_name	= "Max_excl",
 		.need_print	= 0,
-		.max_len	= 8,
+		.human_readable = 0,
+		.max_len	= 12,
 	},
 	{
 		.name		= "parent",
 		.column_name	= "Parent",
 		.need_print	= 0,
+		.human_readable = 0,
 		.max_len	= 7,
 	},
 	{
 		.name		= "child",
 		.column_name	= "Child",
 		.need_print	= 0,
+		.human_readable = 0,
 		.max_len	= 5,
 	},
 	{
 		.name		= NULL,
 		.column_name	= NULL,
 		.need_print	= 0,
+		.human_readable = 0,
 	},
 };
 
@@ -147,6 +157,14 @@ void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column)
 		btrfs_qgroup_columns[i].need_print = 1;
 }
 
+void btrfs_qgroup_setup_human_readable(void)
+{
+	btrfs_qgroup_columns[BTRFS_QGROUP_RFER].human_readable = 1;
+	btrfs_qgroup_columns[BTRFS_QGROUP_EXCL].human_readable = 1;
+	btrfs_qgroup_columns[BTRFS_QGROUP_MAX_RFER].human_readable = 1;
+	btrfs_qgroup_columns[BTRFS_QGROUP_MAX_EXCL].human_readable = 1;
+}
+
 static int print_parent_column(struct btrfs_qgroup *qgroup)
 {
 	struct btrfs_qgroup_list *list = NULL;
@@ -203,11 +221,17 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
 		break;
 	case BTRFS_QGROUP_RFER:
-		len = printf("%llu", qgroup->rfer);
+		if (btrfs_qgroup_columns[column].human_readable)
+			len = printf("%s", pretty_size(qgroup->rfer));
+		else
+			len = printf("%llu", qgroup->rfer);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_RFER, len);
 		break;
 	case BTRFS_QGROUP_EXCL:
-		len = printf("%llu", qgroup->excl);
+		if (btrfs_qgroup_columns[column].human_readable)
+			len = printf("%s", pretty_size(qgroup->excl));
+		else
+			len = printf("%llu", qgroup->excl);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_EXCL, len);
 		break;
 	case BTRFS_QGROUP_PARENT:
@@ -215,11 +239,17 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		print_qgroup_column_add_blank(BTRFS_QGROUP_PARENT, len);
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		len = printf("%llu", qgroup->max_rfer);
+		if (btrfs_qgroup_columns[column].human_readable)
+			len = printf("%s", pretty_size(qgroup->max_rfer));
+		else
+			len = printf("%llu", qgroup->max_rfer);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_RFER, len);
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		len = printf("%llu", qgroup->max_excl);
+		if (btrfs_qgroup_columns[column].human_readable)
+			len = printf("%s", pretty_size(qgroup->max_excl));
+		else
+			len = printf("%llu", qgroup->max_excl);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_EXCL, len);
 		break;
 	case BTRFS_QGROUP_CHILD:
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

