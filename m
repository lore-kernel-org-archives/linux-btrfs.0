Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62294 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799AbbCSGE5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 02:04:57 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jbacik@fb.com>,
        <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 4/4] Btrfs-progs: qgroup: show specified quota data.
Date: Thu, 19 Mar 2015 14:01:00 +0800
Message-ID: <1426744864-7031-8-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch allow user to choose the information type
in command of qgroup show.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 cmds-qgroup.c | 24 +++++++++++++++++++++++-
 qgroup.c      | 44 +++++++++++++++++++++++++++++++++++---------
 qgroup.h      |  7 ++++++-
 3 files changed, 64 insertions(+), 11 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 1c42fc8..86b6d2d 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -204,6 +204,21 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 	return ret;
 }
 
+static int parse_show_type(u8 *qgroup_type, char *arg)
+{
+	if (strcmp(arg, "data") == 0)
+		*qgroup_type = BTRFS_QGROUP_SHOW_TYPE_DATA;
+	else if (strcmp(arg, "metadata") == 0)
+		*qgroup_type = BTRFS_QGROUP_SHOW_TYPE_METADATA;
+	else if (strcmp(arg, "mixed") == 0) {
+		*qgroup_type = BTRFS_QGROUP_SHOW_TYPE_MIXED;
+	} else {
+		fprintf(stderr, "ERROR: Invalid qgroup type arguments given\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static const char * const cmd_qgroup_show_usage[] = {
 	"btrfs qgroup show -pcreFf "
 	"[--sort=qgroupid,rfer,excl,max_rfer,max_excl] <path>",
@@ -238,6 +253,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 	int ret = 0;
 	int fd;
 	int e;
+	u8 type = BTRFS_QGROUP_SHOW_TYPE_MIXED;
 	DIR *dirstream = NULL;
 	u64 qgroupid;
 	int filter_flag = 0;
@@ -253,6 +269,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 		int c;
 		int option_index = 0;
 		static const struct option long_options[] = {
+			{"type", required_argument, NULL, 't'},
 			{"sort", 1, NULL, 'S'},
 			{"raw", no_argument, NULL, GETOPT_VAL_RAW},
 			{"kbytes", no_argument, NULL, GETOPT_VAL_KBYTES},
@@ -299,6 +316,11 @@ static int cmd_qgroup_show(int argc, char **argv)
 			if (ret)
 				usage(cmd_qgroup_show_usage);
 			break;
+		case 't':
+			ret = parse_show_type(&type, optarg);
+			if (ret)
+				usage(cmd_qgroup_show_usage);
+			break;
 		case GETOPT_VAL_RAW:
 			unit_mode = UNITS_RAW;
 			break;
@@ -350,7 +372,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 					BTRFS_QGROUP_FILTER_PARENT,
 					qgroupid);
 	}
-	ret = btrfs_show_qgroups(fd, filter_set, comparer_set);
+	ret = btrfs_show_qgroups(fd, filter_set, comparer_set, type);
 	e = errno;
 	close_file_or_dir(fd, dirstream);
 	if (ret < 0)
diff --git a/qgroup.c b/qgroup.c
index 91e25ea..0e32284 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -226,14 +226,36 @@ static void print_qgroup_column_add_blank(enum btrfs_qgroup_column_enum column,
 }
 
 static void print_qgroup_column(struct btrfs_qgroup *qgroup,
-				enum btrfs_qgroup_column_enum column)
+				enum btrfs_qgroup_column_enum column,
+				u8 type)
 {
 	BUG_ON(column >= BTRFS_QGROUP_ALL || column < 0);
 	int len;
 	int unit_mode = btrfs_qgroup_columns[column].unit_mode;
 	int max_len = btrfs_qgroup_columns[column].max_len;
-	struct btrfs_qgroup_info *info = &qgroup->data_info;
-	struct btrfs_qgroup_limits *limits = &qgroup->mixed_limits;
+	struct btrfs_qgroup_limits *limits = NULL;
+	struct btrfs_qgroup_info *info = NULL;
+	int need_free = 0;
+
+
+	if (type == BTRFS_QGROUP_SHOW_TYPE_DATA) {
+		info = &qgroup->data_info;
+		limits = &qgroup->data_limits;
+	} else if (type == BTRFS_QGROUP_SHOW_TYPE_METADATA) {
+		info = &qgroup->metadata_info;
+		limits = &qgroup->metadata_limits;
+	} else {
+		/*
+		 * For mixed type show.
+		 */ 
+		info = malloc(sizeof(*info));
+		info->rfer = qgroup->data_info.rfer +
+				qgroup->metadata_info.rfer;
+		info->excl = qgroup->data_info.excl +
+				qgroup->metadata_info.excl;
+		limits = &qgroup->mixed_limits;
+		need_free = 1;
+	}
 
 	switch (column) {
 
@@ -265,16 +287,19 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 	default:
 		break;
 	}
+
+	if (need_free)
+		free(info);
 }
 
-static void print_single_qgroup_table(struct btrfs_qgroup *qgroup)
+static void print_single_qgroup_table(struct btrfs_qgroup *qgroup, u8 type)
 {
 	int i;
 
 	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
 		if (!btrfs_qgroup_columns[i].need_print)
 			continue;
-		print_qgroup_column(qgroup, i);
+		print_qgroup_column(qgroup, i, type);
 
 		if (i != BTRFS_QGROUP_CHILD)
 			printf(" ");
@@ -1205,7 +1230,7 @@ done:
 	return ret;
 }
 
-static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup)
+static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup, u8 type)
 {
 
 	struct rb_node *n;
@@ -1216,14 +1241,15 @@ static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup)
 	n = rb_first(&qgroup_lookup->root);
 	while (n) {
 		entry = rb_entry(n, struct btrfs_qgroup, sort_node);
-		print_single_qgroup_table(entry);
+		print_single_qgroup_table(entry, type);
 		n = rb_next(n);
 	}
 }
 
 int btrfs_show_qgroups(int fd,
 		       struct btrfs_qgroup_filter_set *filter_set,
-		       struct btrfs_qgroup_comparer_set *comp_set)
+		       struct btrfs_qgroup_comparer_set *comp_set,
+		       u8 type)
 {
 
 	struct qgroup_lookup qgroup_lookup;
@@ -1235,7 +1261,7 @@ int btrfs_show_qgroups(int fd,
 		return ret;
 	__filter_and_sort_qgroups(&qgroup_lookup, &sort_tree,
 				  filter_set, comp_set);
-	print_all_qgroups(&sort_tree);
+	print_all_qgroups(&sort_tree, type);
 
 	__free_all_qgroups(&qgroup_lookup);
 	btrfs_qgroup_free_filter_set(filter_set);
diff --git a/qgroup.h b/qgroup.h
index 6e65ef7..474db75 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -22,6 +22,10 @@
 #include "ioctl.h"
 #include "kerncompat.h"
 
+#define BTRFS_QGROUP_SHOW_TYPE_DATA		(1 << 0)
+#define BTRFS_QGROUP_SHOW_TYPE_METADATA		(1 << 1)
+#define BTRFS_QGROUP_SHOW_TYPE_MIXED		(1 << 2)
+
 struct btrfs_qgroup;
 
 typedef int (*btrfs_qgroup_filter_func)(struct btrfs_qgroup *, u64);
@@ -81,7 +85,8 @@ int btrfs_qgroup_parse_sort_string(char *opt_arg,
 				struct btrfs_qgroup_comparer_set **comps);
 u64 btrfs_get_path_rootid(int fd);
 int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
-		       struct btrfs_qgroup_comparer_set *);
+		       struct btrfs_qgroup_comparer_set *,
+		       u8 type);
 void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column);
 void btrfs_qgroup_setup_units(unsigned unit_mode);
 struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void);
-- 
1.8.4.2

