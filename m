Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:33188 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968199AbeFRIiQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:16 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id AAE03AC00D1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:10 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id DCE063286F5
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:09 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 12/20] btrfs-progs: sub list: Add --nosort option to output incrementally without sort
Date: Mon, 18 Jun 2018 17:41:00 +0900
Message-ID: <10489eb84799fe52014a0119dfd51e55b33708bc.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, "subvolume list" loads all the subvolume information into
memory first in order to sort them. This may cause a performance problem
if there are a lot of subvolumes.

This commit adds --nosort option to output subvolume information
incrementally without sort to avoid consuming memory.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 Documentation/btrfs-subvolume.asciidoc |   5 ++
 cmds-subvolume.c                       | 140 ++++++++++++++++++++++-----------
 2 files changed, 100 insertions(+), 45 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index b2461398..cd91385a 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -170,6 +170,11 @@ you can add \'\+' or \'-' in front of each items, \'+' means ascending,
 +
 for --sort you can combine some items together by \',', just like
 --sort=+ogen,-gen,path,rootid.
++
+--nosort::::
+Output the results incrementally without sort. This avoids loading all
+subvolume information to memory and can be useful when there is a lot
+of subvolumes.
 
 *set-default* [<subvolume>|<id> <path>]::
 Set the default subvolume for the (mounted) filesystem.
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 4ebe0377..802f5c5e 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1036,6 +1036,23 @@ static void print_all_subvol_info_tab_head(void)
 	}
 }
 
+static void print_one_subvol_info(struct listed_subvol *subvol,
+				  enum btrfs_list_layout layout,
+				  const char *raw_prefix)
+{
+	switch (layout) {
+	case BTRFS_LIST_LAYOUT_DEFAULT:
+		print_one_subvol_info_default(subvol);
+		break;
+	case BTRFS_LIST_LAYOUT_TABLE:
+		print_one_subvol_info_table(subvol);
+		break;
+	case BTRFS_LIST_LAYOUT_RAW:
+		print_one_subvol_info_raw(subvol, raw_prefix);
+		break;
+	}
+}
+
 static void print_all_subvol_info(struct subvol_list *subvols,
 				  enum btrfs_list_layout layout,
 				  const char *raw_prefix)
@@ -1048,17 +1065,7 @@ static void print_all_subvol_info(struct subvol_list *subvols,
 	for (i = 0; i < subvols->num; i++) {
 		struct listed_subvol *subvol = &subvols->subvols[i];
 
-		switch (layout) {
-		case BTRFS_LIST_LAYOUT_DEFAULT:
-			print_one_subvol_info_default(subvol);
-			break;
-		case BTRFS_LIST_LAYOUT_TABLE:
-			print_one_subvol_info_table(subvol);
-			break;
-		case BTRFS_LIST_LAYOUT_RAW:
-			print_one_subvol_info_raw(subvol, raw_prefix);
-			break;
-		}
+		print_one_subvol_info(subvol, layout, raw_prefix);
 	}
 }
 
@@ -1159,7 +1166,9 @@ static void get_subvols_info(struct subvol_list **subvols,
 			     int tree_id,
 			     size_t *capacity,
 			     const char *prefix,
-			     int show_top)
+			     int show_top,
+			     enum btrfs_list_layout layout,
+			     const char *raw_prefix)
 {
 	struct btrfs_util_subvolume_iterator *iter;
 	enum btrfs_util_error err;
@@ -1216,9 +1225,14 @@ static void get_subvols_info(struct subvol_list **subvols,
 		if (!filters_match(&subvol, filter_set)) {
 			free(subvol.path);
 		} else {
-			ret = add_subvol(subvols, &subvol, capacity);
-			if (ret)
-				goto out;
+			if (*subvols == NULL) {
+				print_one_subvol_info(&subvol,
+						      layout, raw_prefix);
+			} else {
+				ret = add_subvol(subvols, &subvol, capacity);
+				if (ret)
+					goto out;
+			}
 		}
 	}
 
@@ -1263,9 +1277,14 @@ skip:
 		if (!filters_match(&subvol, filter_set)) {
 			free(subvol.path);
 		} else {
-			ret = add_subvol(subvols, &subvol, capacity);
-			if (ret)
-				goto out;
+			if (*subvols == NULL) {
+				print_one_subvol_info(&subvol,
+						      layout, raw_prefix);
+			} else {
+				ret = add_subvol(subvols, &subvol, capacity);
+				if (ret)
+					goto out;
+			}
 		}
 	}
 
@@ -1275,7 +1294,7 @@ out:
 		btrfs_util_destroy_subvolume_iterator(iter);
 	if (ret) {
 		free_subvol_list(*subvols);
-		*subvols = NULL;
+		*subvols = ERR_PTR(ret);
 	}
 }
 
@@ -1283,23 +1302,31 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 					      int is_list_all,
 					      int absolute_path,
 					      int follow_mount,
+					      int no_sort,
+					      enum btrfs_list_layout layout,
+					      const char *raw_prefix,
 					      const char *path,
 					      struct btrfs_list_filter_set_v2 *filter_set)
 {
-	struct subvol_list *subvols;
+	struct subvol_list *subvols = NULL;
 	size_t capacity = 0;
 
-	subvols = malloc(sizeof(*subvols));
-	if (!subvols) {
-		error("out of memory");
-		return NULL;
+	if (!no_sort) {
+		subvols = malloc(sizeof(*subvols));
+		if (!subvols) {
+			error("out of memory");
+			return ERR_PTR(-1);
+		}
+		subvols->num = 0;
 	}
-	subvols->num = 0;
+
+	if (no_sort && layout == BTRFS_LIST_LAYOUT_TABLE)
+		print_all_subvol_info_tab_head();
 
 	if (is_list_all) {
 		get_subvols_info(&subvols, filter_set, fd,
 				BTRFS_FS_TREE_OBJECTID, &capacity, NULL,
-				false);
+				false, layout, raw_prefix);
 	} else {
 		char *fullpath;
 
@@ -1307,16 +1334,17 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 		if (!fullpath) {
 			error("cannot find real path for '%s': %m", path);
 			free_subvol_list(subvols);
-			return NULL;
+			return ERR_PTR(-1);
 		}
 
 		get_subvols_info(&subvols, filter_set, fd, 0, &capacity,
-				(absolute_path ? fullpath : NULL), false);
+				(absolute_path ? fullpath : NULL), false,
+				layout, raw_prefix);
 
-		if (subvols == NULL) {
-			free(fullpath);
-			return NULL;
-		}
+			if (IS_ERR(subvols)) {
+				free(fullpath);
+				return ERR_PTR(-1);
+			}
 
 		/* Follow mounted subvolumes below @path */
 		if (follow_mount) {
@@ -1334,7 +1362,7 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 				error("failed to get fsid: %m");
 				free(fullpath);
 				free_subvol_list(subvols);
-				return NULL;
+				return ERR_PTR(-1);
 			}
 
 			f = setmntent("/proc/self/mounts", "r");
@@ -1342,7 +1370,7 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 				error("failed to read mount entry: %m");
 				free(fullpath);
 				free_subvol_list(subvols);
-				return NULL;
+				return ERR_PTR(-1);
 			}
 
 			/* Iterate for each mount entry */
@@ -1369,7 +1397,7 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 					error("failed to get fsid: %m");
 					free(fullpath);
 					free_subvol_list(subvols);
-					return NULL;
+					return ERR_PTR(-1);
 				}
 				if (uuid_compare(fsid, fsid2))
 					continue;
@@ -1381,7 +1409,7 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 							mnt->mnt_dir);
 					free(fullpath);
 					free_subvol_list(subvols);
-					return NULL;
+					return ERR_PTR(-1);
 				}
 				get_subvols_info(&subvols, filter_set,
 						fd2, 0, &capacity,
@@ -1389,11 +1417,11 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 							(strlen(fullpath) == 1 ?
 							 mnt->mnt_dir + 1 :
 							 mnt->mnt_dir + strlen(fullpath) + 1)),
-						true);
+						true, layout, raw_prefix);
 				close_file_or_dir(fd2, dirstream);
-				if (subvols == NULL) {
+				if (IS_ERR(subvols)) {
 					free(fullpath);
-					return NULL;
+					return ERR_PTR(-1);
 				}
 			}
 		}
@@ -1410,6 +1438,7 @@ static int btrfs_list_subvols_print_v2(int fd,
 				    int is_list_all,
 				    int absolute_path,
 				    int follow_mount,
+				    int no_sort,
 				    const char *path,
 				    const char *raw_prefix)
 {
@@ -1419,15 +1448,20 @@ static int btrfs_list_subvols_print_v2(int fd,
 		subvols = btrfs_list_deleted_subvols(fd, filter_set);
 	else
 		subvols = btrfs_list_subvols(fd, is_list_all, absolute_path,
-					     follow_mount, path, filter_set);
-	if (!subvols)
+					     follow_mount, no_sort,
+					     layout, raw_prefix,
+					     path, filter_set);
+
+	if (IS_ERR(subvols))
 		return -1;
 
-	sort_subvols(comp_set, subvols);
+	if (!no_sort) {
+		sort_subvols(comp_set, subvols);
 
-	print_all_subvol_info(subvols, layout, raw_prefix);
+		print_all_subvol_info(subvols, layout, raw_prefix);
 
-	free_subvol_list(subvols);
+		free_subvol_list(subvols);
+	}
 
 	return 0;
 }
@@ -1575,6 +1609,9 @@ static const char * const cmd_subvol_list_usage[] = {
 	"             list the subvolume in order of gen, ogen, rootid or path",
 	"             you also can add '+' or '-' in front of each items.",
 	"             (+:ascending, -:descending, ascending default)",
+	"--nosort     Output the results incrementally without sort.",
+	"             This avoids loading all subvolume information to memory",
+	"             and can be useful when there is a lot of subvolumes",
 	NULL,
 };
 
@@ -1589,6 +1626,8 @@ static int cmd_subvol_list(int argc, char **argv)
 	char *subvol;
 	int is_list_all = 0;
 	int follow_mount = 0;
+	int sort = 0;
+	int no_sort = 0;
 	int is_only_in_path = 0;
 	int absolute_path = 0;
 	DIR *dirstream = NULL;
@@ -1601,6 +1640,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		int c;
 		static const struct option long_options[] = {
 			{"sort", required_argument, NULL, 'S'},
+			{"nosort", no_argument, NULL, 'N'},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -1680,6 +1720,7 @@ static int cmd_subvol_list(int argc, char **argv)
 			}
 			break;
 		case 'S':
+			sort = 1;
 			ret = btrfs_list_parse_sort_string_v2(optarg,
 							   &comparer_set);
 			if (ret) {
@@ -1687,6 +1728,9 @@ static int cmd_subvol_list(int argc, char **argv)
 				goto out;
 			}
 			break;
+		case 'N':
+			no_sort = 1;
+			break;
 
 		default:
 			uerr = 1;
@@ -1717,6 +1761,12 @@ static int cmd_subvol_list(int argc, char **argv)
 		goto out;
 	}
 
+	if (sort && no_sort) {
+		ret = -1;
+		error("cannot use --sort with --nosort option");
+		goto out;
+	}
+
 	subvol = argv[optind];
 	fd = btrfs_open_dir(subvol, &dirstream, 1);
 	if (fd < 0) {
@@ -1750,7 +1800,7 @@ static int cmd_subvol_list(int argc, char **argv)
 
 	ret = btrfs_list_subvols_print_v2(fd, filter_set, comparer_set,
 			layout, is_list_all, absolute_path, follow_mount,
-			subvol, NULL);
+			no_sort, subvol, NULL);
 
 out:
 	close_file_or_dir(fd, dirstream);
-- 
2.14.4


