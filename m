Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60586 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934923AbeCHClE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:04 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0A012AB3D
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:03 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 06/20] btrfs-progs: qgroups: add pathname to show output
Date: Wed,  7 Mar 2018 21:40:33 -0500
Message-Id: <20180308024047.10104-7-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The btrfs qgroup show command currently only exports qgroup IDs,
forcing the user to resolve which subvolume each corresponds to.

This patch adds pathname resolution to qgroup show so that when
the -P option is used, the last column contains the pathname of
the root of the subvolume it describes.  In the case of nested
qgroups, it will show the number of member qgroups or the paths
of the members if the -v option is used.

Pathname can also be used as a sort parameter.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Documentation/btrfs-qgroup.asciidoc |   4 +
 cmds-qgroup.c                       |  18 ++++-
 kerncompat.h                        |   1 +
 qgroup.c                            | 152 ++++++++++++++++++++++++++++++++----
 qgroup.h                            |   4 +-
 utils.c                             |  23 ++++--
 utils.h                             |   2 +
 7 files changed, 178 insertions(+), 26 deletions(-)

diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index 3108457c..360b3269 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -97,10 +97,14 @@ print child qgroup id.
 print limit of referenced size of qgroup.
 -e::::
 print limit of exclusive size of qgroup.
+-P::::
+print pathname to the root of the subvolume managed by qgroup.  For nested qgroups, the number of members will be printed unless -v is specified.
 -F::::
 list all qgroups which impact the given path(include ancestral qgroups)
 -f::::
 list all qgroups which impact the given path(exclude ancestral qgroups)
+-v::::
+Be more verbose.  Print pathnames of member qgroups when nested.
 --raw::::
 raw numbers in bytes, without the 'B' suffix.
 --human-readable::::
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 48686436..d704aeaf 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -280,8 +280,11 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"               (including ancestral qgroups)",
 	"-f             list all qgroups which impact the given path",
 	"               (excluding ancestral qgroups)",
+	"-P             print first-level qgroups using pathname",
+	"               - nested qgroups will be reported as a count",
+	"-v             verbose, prints pathnames for all nested qgroups",
 	HELPINFO_UNITS_LONG,
-	"--sort=qgroupid,rfer,excl,max_rfer,max_excl",
+	"--sort=qgroupid,rfer,excl,max_rfer,max_excl,pathname",
 	"               list qgroups sorted by specified items",
 	"               you can use '+' or '-' in front of each item.",
 	"               (+:ascending, -:descending, ascending default)",
@@ -299,6 +302,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 	int filter_flag = 0;
 	unsigned unit_mode;
 	int sync = 0;
+	bool verbose = false;
 
 	struct btrfs_qgroup_comparer_set *comparer_set;
 	struct btrfs_qgroup_filter_set *filter_set;
@@ -316,10 +320,11 @@ static int cmd_qgroup_show(int argc, char **argv)
 		static const struct option long_options[] = {
 			{"sort", required_argument, NULL, GETOPT_VAL_SORT},
 			{"sync", no_argument, NULL, GETOPT_VAL_SYNC},
+			{"verbose", no_argument, NULL, 'v'},
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(argc, argv, "pcreFf", long_options, NULL);
+		c = getopt_long(argc, argv, "pPcreFfv", long_options, NULL);
 		if (c < 0)
 			break;
 		switch (c) {
@@ -327,6 +332,10 @@ static int cmd_qgroup_show(int argc, char **argv)
 			btrfs_qgroup_setup_print_column(
 				BTRFS_QGROUP_PARENT);
 			break;
+		case 'P':
+			btrfs_qgroup_setup_print_column(
+				BTRFS_QGROUP_PATHNAME);
+			break;
 		case 'c':
 			btrfs_qgroup_setup_print_column(
 				BTRFS_QGROUP_CHILD);
@@ -354,6 +363,9 @@ static int cmd_qgroup_show(int argc, char **argv)
 		case GETOPT_VAL_SYNC:
 			sync = 1;
 			break;
+		case 'v':
+			verbose = true;
+			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
@@ -394,7 +406,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 					BTRFS_QGROUP_FILTER_PARENT,
 					qgroupid);
 	}
-	ret = btrfs_show_qgroups(fd, filter_set, comparer_set);
+	ret = btrfs_show_qgroups(fd, filter_set, comparer_set, verbose);
 	close_file_or_dir(fd, dirstream);
 	free(filter_set);
 	free(comparer_set);
diff --git a/kerncompat.h b/kerncompat.h
index fa96715f..f97495ee 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -29,6 +29,7 @@
 #include <stddef.h>
 #include <linux/types.h>
 #include <stdint.h>
+#include <stdbool.h>
 
 #include <features.h>
 
diff --git a/qgroup.c b/qgroup.c
index 67bc0738..5600da99 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -40,6 +40,9 @@ struct btrfs_qgroup {
 	struct rb_node all_parent_node;
 	u64 qgroupid;
 
+	/* NULL for qgroups with level > 0 */
+	const char *pathname;
+
 	/*
 	 * info_item
 	 */
@@ -134,6 +137,13 @@ static struct {
 		.max_len	= 5,
 	},
 	{
+		.name		= "pathname",
+		.column_name	= "pathname",
+		.need_print	= 0,
+		.unit_mode	= 0,
+		.max_len	= 10,
+	},
+	{
 		.name		= NULL,
 		.column_name	= NULL,
 		.need_print	= 0,
@@ -210,8 +220,49 @@ static void print_qgroup_column_add_blank(enum btrfs_qgroup_column_enum column,
 		printf(" ");
 }
 
+void print_pathname_column(struct btrfs_qgroup *qgroup, bool verbose)
+{
+	struct btrfs_qgroup_list *list = NULL;
+
+	fputs("  ", stdout);
+	if (btrfs_qgroup_level(qgroup->qgroupid) > 0) {
+		int count = 0;
+
+		list_for_each_entry(list, &qgroup->qgroups,
+				    next_qgroup) {
+			if (verbose) {
+				struct btrfs_qgroup *member = list->qgroup;
+				u64 qgroupid = member->qgroupid;
+				u64 level = btrfs_qgroup_level(qgroupid);
+				u64 sid = btrfs_qgroup_subvid(qgroupid);
+
+				if (count)
+					fputs(" ", stdout);
+				if (level == 0) {
+					const char *path = member->pathname;
+
+					if (!path)
+						path = "<missing>";
+					fputs(path, stdout);
+				} else
+					printf("%llu/%llu", level, sid);
+			}
+			count++;
+		}
+		if (!count)
+			fputs("<empty>", stdout);
+		else if (!verbose)
+			printf("<%u member qgroup%c>", count,
+			       count != 1 ? 's' : '\0');
+	} else if (qgroup->pathname)
+		fputs(qgroup->pathname, stdout);
+	else
+		fputs("<missing>", stdout);
+}
+
 static void print_qgroup_column(struct btrfs_qgroup *qgroup,
-				enum btrfs_qgroup_column_enum column)
+				enum btrfs_qgroup_column_enum column,
+				bool verbose)
 {
 	int len;
 	int unit_mode = btrfs_qgroup_columns[column].unit_mode;
@@ -253,19 +304,22 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		len = print_child_column(qgroup);
 		print_qgroup_column_add_blank(BTRFS_QGROUP_CHILD, len);
 		break;
+	case BTRFS_QGROUP_PATHNAME:
+		print_pathname_column(qgroup, verbose);
+		break;
 	default:
 		break;
 	}
 }
 
-static void print_single_qgroup_table(struct btrfs_qgroup *qgroup)
+static void print_single_qgroup_table(struct btrfs_qgroup *qgroup, bool verbose)
 {
 	int i;
 
 	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
 		if (!btrfs_qgroup_columns[i].need_print)
 			continue;
-		print_qgroup_column(qgroup, i);
+		print_qgroup_column(qgroup, i, verbose);
 
 		if (i != BTRFS_QGROUP_ALL - 1)
 			printf(" ");
@@ -338,6 +392,47 @@ static int comp_entry_with_qgroupid(struct btrfs_qgroup *entry1,
 	return is_descending ? -ret : ret;
 }
 
+/* Sorts first-level qgroups by pathname and nested qgroups by qgroupid */
+static int comp_entry_with_pathname(struct btrfs_qgroup *entry1,
+				    struct btrfs_qgroup *entry2,
+				    int is_descending)
+{
+	int ret = 0;
+	const char *p1 = entry1->pathname;
+	const char *p2 = entry2->pathname;
+
+	u64 level1 = btrfs_qgroup_level(entry1->qgroupid);
+	u64 level2 = btrfs_qgroup_level(entry2->qgroupid);
+
+	if (level1 != level2) {
+		if (entry1->qgroupid > entry2->qgroupid)
+			ret = 1;
+		else if (entry1->qgroupid < entry2->qgroupid)
+			ret = -1;
+	}
+
+	if (ret)
+		goto out;
+
+	while (*p1 && *p2) {
+		if (*p1 != *p2)
+			break;
+		p1++;
+		p2++;
+	}
+
+	if (*p1 == '/')
+		ret = 1;
+	else if (*p2 == '/')
+		ret = -1;
+	else if (*p1 > *p2)
+		ret = 1;
+	else if (*p1 < *p2)
+		ret = -1;
+out:
+	return is_descending ? -ret : ret;
+}
+
 static int comp_entry_with_rfer(struct btrfs_qgroup *entry1,
 				struct btrfs_qgroup *entry2,
 				int is_descending)
@@ -404,6 +499,7 @@ static int comp_entry_with_max_excl(struct btrfs_qgroup *entry1,
 
 static btrfs_qgroup_comp_func all_comp_funcs[] = {
 	[BTRFS_QGROUP_COMP_QGROUPID]	= comp_entry_with_qgroupid,
+	[BTRFS_QGROUP_COMP_PATHNAME]	= comp_entry_with_pathname,
 	[BTRFS_QGROUP_COMP_RFER]	= comp_entry_with_rfer,
 	[BTRFS_QGROUP_COMP_EXCL]	= comp_entry_with_excl,
 	[BTRFS_QGROUP_COMP_MAX_RFER]	= comp_entry_with_max_rfer,
@@ -412,6 +508,7 @@ static btrfs_qgroup_comp_func all_comp_funcs[] = {
 
 static char *all_sort_items[] = {
 	[BTRFS_QGROUP_COMP_QGROUPID]	= "qgroupid",
+	[BTRFS_QGROUP_COMP_PATHNAME]	= "pathname",
 	[BTRFS_QGROUP_COMP_RFER]	= "rfer",
 	[BTRFS_QGROUP_COMP_EXCL]	= "excl",
 	[BTRFS_QGROUP_COMP_MAX_RFER]	= "max_rfer",
@@ -578,6 +675,26 @@ static struct btrfs_qgroup *qgroup_tree_search(struct qgroup_lookup *root_tree,
 	return NULL;
 }
 
+static const char *qgroup_pathname(int fd, u64 qgroupid)
+{
+	struct root_info root_info;
+	int ret;
+	char *pathname;
+
+	ret = get_subvol_info_by_rootid_fd(fd, &root_info, qgroupid);
+	if (ret)
+		return NULL;
+
+	ret = asprintf(&pathname, "%s%s",
+		       root_info.full_path[0] == '/' ? "" : "/",
+		       root_info.full_path);
+	btrfs_cleanup_root_info(&root_info);
+	if (ret < 0)
+		return NULL;
+
+	return pathname;
+}
+
 /*
  * Lookup or insert btrfs_qgroup into qgroup_lookup.
  *
@@ -588,7 +705,7 @@ static struct btrfs_qgroup *qgroup_tree_search(struct qgroup_lookup *root_tree,
  * Return the pointer to the btrfs_qgroup if found or if inserted successfully.
  * Return ERR_PTR if any error occurred.
  */
-static struct btrfs_qgroup *get_or_add_qgroup(
+static struct btrfs_qgroup *get_or_add_qgroup(int fd,
 		struct qgroup_lookup *qgroup_lookup, u64 qgroupid)
 {
 	struct btrfs_qgroup *bq;
@@ -608,6 +725,8 @@ static struct btrfs_qgroup *get_or_add_qgroup(
 	INIT_LIST_HEAD(&bq->qgroups);
 	INIT_LIST_HEAD(&bq->members);
 
+	bq->pathname = qgroup_pathname(fd, qgroupid);
+
 	ret = qgroup_tree_insert(qgroup_lookup, bq);
 	if (ret) {
 		error("failed to insert %llu into tree: %s",
@@ -619,12 +738,12 @@ static struct btrfs_qgroup *get_or_add_qgroup(
 	return bq;
 }
 
-static int update_qgroup_info(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
-			      struct btrfs_qgroup_info_item *info)
+static int update_qgroup_info(int fd, struct qgroup_lookup *qgroup_lookup,
+			      u64 qgroupid, struct btrfs_qgroup_info_item *info)
 {
 	struct btrfs_qgroup *bq;
 
-	bq = get_or_add_qgroup(qgroup_lookup, qgroupid);
+	bq = get_or_add_qgroup(fd, qgroup_lookup, qgroupid);
 	if (IS_ERR_OR_NULL(bq))
 		return PTR_ERR(bq);
 
@@ -637,13 +756,13 @@ static int update_qgroup_info(struct qgroup_lookup *qgroup_lookup, u64 qgroupid,
 	return 0;
 }
 
-static int update_qgroup_limit(struct qgroup_lookup *qgroup_lookup,
+static int update_qgroup_limit(int fd, struct qgroup_lookup *qgroup_lookup,
 			       u64 qgroupid,
 			       struct btrfs_qgroup_limit_item *limit)
 {
 	struct btrfs_qgroup *bq;
 
-	bq = get_or_add_qgroup(qgroup_lookup, qgroupid);
+	bq = get_or_add_qgroup(fd, qgroup_lookup, qgroupid);
 	if (IS_ERR_OR_NULL(bq))
 		return PTR_ERR(bq);
 
@@ -712,6 +831,8 @@ static void __free_btrfs_qgroup(struct btrfs_qgroup *bq)
 		list_del(&list->next_member);
 		free(list);
 	}
+	if (bq->pathname)
+		free((void *)bq->pathname);
 	free(bq);
 }
 
@@ -1107,7 +1228,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				info = (struct btrfs_qgroup_info_item *)
 				       (args.buf + off);
 
-				ret = update_qgroup_info(qgroup_lookup,
+				ret = update_qgroup_info(fd, qgroup_lookup,
 							 qgroupid, info);
 				break;
 			case BTRFS_QGROUP_LIMIT_KEY:
@@ -1115,7 +1236,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				limit = (struct btrfs_qgroup_limit_item *)
 					(args.buf + off);
 
-				ret = update_qgroup_limit(qgroup_lookup,
+				ret = update_qgroup_limit(fd, qgroup_lookup,
 							  qgroupid, limit);
 				break;
 			case BTRFS_QGROUP_RELATION_KEY:
@@ -1159,7 +1280,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 	return ret;
 }
 
-static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup)
+static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup, bool verbose)
 {
 
 	struct rb_node *n;
@@ -1170,14 +1291,15 @@ static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup)
 	n = rb_first(&qgroup_lookup->root);
 	while (n) {
 		entry = rb_entry(n, struct btrfs_qgroup, sort_node);
-		print_single_qgroup_table(entry);
+		print_single_qgroup_table(entry, verbose);
 		n = rb_next(n);
 	}
 }
 
 int btrfs_show_qgroups(int fd,
 		       struct btrfs_qgroup_filter_set *filter_set,
-		       struct btrfs_qgroup_comparer_set *comp_set)
+		       struct btrfs_qgroup_comparer_set *comp_set,
+		       bool verbose)
 {
 
 	struct qgroup_lookup qgroup_lookup;
@@ -1189,7 +1311,7 @@ int btrfs_show_qgroups(int fd,
 		return ret;
 	__filter_and_sort_qgroups(&qgroup_lookup, &sort_tree,
 				  filter_set, comp_set);
-	print_all_qgroups(&sort_tree);
+	print_all_qgroups(&sort_tree, verbose);
 
 	__free_all_qgroups(&qgroup_lookup);
 	return ret;
diff --git a/qgroup.h b/qgroup.h
index 875fbdf3..f7ab7de5 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -59,11 +59,13 @@ enum btrfs_qgroup_column_enum {
 	BTRFS_QGROUP_MAX_EXCL,
 	BTRFS_QGROUP_PARENT,
 	BTRFS_QGROUP_CHILD,
+	BTRFS_QGROUP_PATHNAME,
 	BTRFS_QGROUP_ALL,
 };
 
 enum btrfs_qgroup_comp_enum {
 	BTRFS_QGROUP_COMP_QGROUPID,
+	BTRFS_QGROUP_COMP_PATHNAME,
 	BTRFS_QGROUP_COMP_RFER,
 	BTRFS_QGROUP_COMP_EXCL,
 	BTRFS_QGROUP_COMP_MAX_RFER,
@@ -80,7 +82,7 @@ enum btrfs_qgroup_filter_enum {
 int btrfs_qgroup_parse_sort_string(const char *opt_arg,
 				struct btrfs_qgroup_comparer_set **comps);
 int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
-		       struct btrfs_qgroup_comparer_set *);
+		       struct btrfs_qgroup_comparer_set *, bool verbose);
 void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column);
 void btrfs_qgroup_setup_units(unsigned unit_mode);
 struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void);
diff --git a/utils.c b/utils.c
index e9cb3a82..7b7f87f1 100644
--- a/utils.c
+++ b/utils.c
@@ -2556,15 +2556,9 @@ out:
 	return ret;
 }
 
-int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_ri, u64 r_id)
+int get_subvol_info_by_rootid_fd(int fd, struct root_info *get_ri, u64 r_id)
 {
-	int fd;
 	int ret;
-	DIR *dirstream = NULL;
-
-	fd = btrfs_open_dir(mnt, &dirstream, 1);
-	if (fd < 0)
-		return -EINVAL;
 
 	memset(get_ri, 0, sizeof(*get_ri));
 	get_ri->root_id = r_id;
@@ -2574,6 +2568,21 @@ int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_ri, u64 r_i
 	else
 		ret = btrfs_get_subvol(fd, get_ri);
 
+	return ret;
+}
+
+int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_ri,
+			      u64 r_id)
+{
+	int fd;
+	int ret;
+	DIR *dirstream = NULL;
+
+	fd = btrfs_open_dir(mnt, &dirstream, 1);
+	if (fd < 0)
+		return -EINVAL;
+
+	ret = get_subvol_info_by_rootid_fd(fd, get_ri, r_id);
 	if (ret)
 		error("can't find rootid '%llu' on '%s': %d", r_id, mnt, ret);
 
diff --git a/utils.h b/utils.h
index b871c9ff..722d3c48 100644
--- a/utils.h
+++ b/utils.h
@@ -154,6 +154,8 @@ int test_isdir(const char *path);
 
 const char *subvol_strip_mountpoint(const char *mnt, const char *full_path);
 int get_subvol_info(const char *fullpath, struct root_info *get_ri);
+int get_subvol_info_by_rootid_fd(int fd, struct root_info *get_ri,
+				 u64 rootid_arg);
 int get_subvol_info_by_rootid(const char *mnt, struct root_info *get_ri,
 							u64 rootid_arg);
 int get_subvol_info_by_uuid(const char *mnt, struct root_info *get_ri,
-- 
2.12.3

