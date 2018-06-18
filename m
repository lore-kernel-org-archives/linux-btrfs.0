Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:18222 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968173AbeFRIiN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:13 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 5D190AC0272
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:10 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 77E9B3286FA
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:09 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 10/20] btrfs-progs: sub list: Add -A option to output path in absolute path
Date: Mon, 18 Jun 2018 17:40:58 +0900
Message-ID: <5bd335d05f69173a7cf126cd5dcd836092280855.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By default, the printed path is relative to the specified path.
Let's add option to print absolute path with -A option.

[Example]
 $ mkfs.btrfs -f $DEV
 $ mount $DEV /mnt

 $ btrfs subvolume create /mnt/AAA

 $ btrfs subvolume list /mnt
 ID 256 gen 6 top level 5 path AAA

 $ btrfs subvolume list -A /mnt
 ID 256 gen 6 top level 5 path /mnt/AAA

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 Documentation/btrfs-subvolume.asciidoc |  2 +
 cmds-subvolume.c                       | 73 +++++++++++++++++++++++++++++-----
 2 files changed, 66 insertions(+), 9 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index 99fff977..fec4b769 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -148,6 +148,8 @@ list deleted subvolumes that are not yet cleaned.
 Other;;
 -t::::
 print the result as a table.
+-A::::
+print path in absolute path.
 
 Sorting;;
 -G [+|-]<value>::::
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 23596c17..ea341d50 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1156,7 +1156,8 @@ static void get_subvols_info(struct subvol_list **subvols,
 			     struct btrfs_list_filter_set_v2 *filter_set,
 			     int fd,
 			     int tree_id,
-			     size_t *capacity)
+			     size_t *capacity,
+			     const char *prefix)
 {
 	struct btrfs_util_subvolume_iterator *iter;
 	enum btrfs_util_error err;
@@ -1206,7 +1207,10 @@ static void get_subvols_info(struct subvol_list **subvols,
 			goto out;
 		}
 
-		subvol.path = strdup(".");
+		if (prefix)
+			subvol.path = strdup(prefix);
+		else
+			subvol.path = strdup(".");
 		if (!filters_match(&subvol, filter_set)) {
 			free(subvol.path);
 		} else {
@@ -1231,6 +1235,29 @@ skip:
 			goto out;
 		}
 
+		if (prefix) {
+			char *temp = subvol.path;
+
+			subvol.path = malloc(strlen(prefix) +
+					     strlen(subvol.path) + 2);
+			if (!subvol.path) {
+				error("out of memory");
+				subvol.path = temp;
+				ret = -1;
+				goto out;
+			}
+
+			strcpy(subvol.path, prefix);
+			if (strlen(prefix) == 1) {
+				strcpy(subvol.path + 1, temp);
+			} else {
+				subvol.path[strlen(prefix)] = '/';
+				strcpy(subvol.path + strlen(prefix) + 1, temp);
+			}
+
+			free(temp);
+		}
+
 		if (!filters_match(&subvol, filter_set)) {
 			free(subvol.path);
 		} else {
@@ -1252,6 +1279,7 @@ out:
 
 static struct subvol_list *btrfs_list_subvols(int fd,
 					      int is_list_all,
+					      int absolute_path,
 					      const char *path,
 					      struct btrfs_list_filter_set_v2 *filter_set)
 {
@@ -1265,11 +1293,24 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 	}
 	subvols->num = 0;
 
-	if (is_list_all)
+	if (is_list_all) {
 		get_subvols_info(&subvols, filter_set, fd,
-				BTRFS_FS_TREE_OBJECTID, &capacity);
-	else
-		get_subvols_info(&subvols, filter_set, fd, 0, &capacity);
+				BTRFS_FS_TREE_OBJECTID, &capacity, NULL);
+	} else {
+		char *fullpath;
+
+		fullpath = realpath(path, NULL);
+		if (!fullpath) {
+			error("cannot find real path for '%s': %m", path);
+			free_subvol_list(subvols);
+			return NULL;
+		}
+
+		get_subvols_info(&subvols, filter_set, fd, 0, &capacity,
+				(absolute_path ? fullpath : NULL));
+
+		free(fullpath);
+	}
 
 	return subvols;
 }
@@ -1279,6 +1320,7 @@ static int btrfs_list_subvols_print_v2(int fd,
 				    struct btrfs_list_comparer_set_v2 *comp_set,
 				    enum btrfs_list_layout layout,
 				    int is_list_all,
+				    int absolute_path,
 				    const char *path,
 				    const char *raw_prefix)
 {
@@ -1287,7 +1329,8 @@ static int btrfs_list_subvols_print_v2(int fd,
 	if (filter_set->only_deleted)
 		subvols = btrfs_list_deleted_subvols(fd, filter_set);
 	else
-		subvols = btrfs_list_subvols(fd, is_list_all, path, filter_set);
+		subvols = btrfs_list_subvols(fd, is_list_all, absolute_path,
+					     path, filter_set);
 	if (!subvols)
 		return -1;
 
@@ -1427,6 +1470,8 @@ static const char * const cmd_subvol_list_usage[] = {
 	"",
 	"Other:",
 	"-t           print the result as a table",
+	"-A           print path in absolute path",
+	"             (default is a relative to the specified path)",
 	"",
 	"Sorting:",
 	"-G [+|-]value",
@@ -1453,6 +1498,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	char *subvol;
 	int is_list_all = 0;
 	int is_only_in_path = 0;
+	int absolute_path = 0;
 	DIR *dirstream = NULL;
 	enum btrfs_list_layout layout = BTRFS_LIST_LAYOUT_DEFAULT;
 
@@ -1467,11 +1513,14 @@ static int cmd_subvol_list(int argc, char **argv)
 		};
 
 		c = getopt_long(argc, argv,
-				    "acdgopqsurRG:C:t", long_options, NULL);
+				    "acdgopqsurARG:C:t", long_options, NULL);
 		if (c < 0)
 			break;
 
 		switch(c) {
+		case 'A':
+			absolute_path = 1;
+			break;
 		case 'p':
 			btrfs_list_setup_print_column_v2(BTRFS_LIST_PARENT);
 			break;
@@ -1561,6 +1610,12 @@ static int cmd_subvol_list(int argc, char **argv)
 		goto out;
 	}
 
+	if (is_list_all && absolute_path) {
+		ret = -1;
+		error("cannot use -a with -A option");
+		goto out;
+	}
+
 	subvol = argv[optind];
 	fd = btrfs_open_dir(subvol, &dirstream, 1);
 	if (fd < 0) {
@@ -1593,7 +1648,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	btrfs_list_setup_print_column_v2(BTRFS_LIST_PATH);
 
 	ret = btrfs_list_subvols_print_v2(fd, filter_set, comparer_set,
-			layout, is_list_all, subvol, NULL);
+			layout, is_list_all, absolute_path, subvol, NULL);
 
 out:
 	close_file_or_dir(fd, dirstream);
-- 
2.14.4


