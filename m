Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:59119 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968211AbeFRIiS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:18 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id E81E6AC00C4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:09 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 1F321BD670B
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:09 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 09/20] btrfs-progs: sub list: Change the default behavior of "subvolume list" and allow non-privileged user to call it
Date: Mon, 18 Jun 2018 17:40:57 +0900
Message-ID: <6af6dac8829d3ba405e3c53baffd828c9c428ef6.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change the default behavior of "subvolume list" and allow non-privileged
user to call it as well.

>From this commit, by default it only lists subvolumes under the specified
path (incl. the path itself except top-level subvolume). Also, if kernel
supports new ioctls (BTRFS_IOC_GET_SUBVOL_INFO/BTRFS_IOC_GET_SUBVOL_ROOTREF
and BTRFS_IOC_INO_LOOKUP_USER, which are avilable from 4.18),
  - the specified path can be non-subvolume directory.
  - non-privileged user can also call it (subvolumes which the user
    does not have access right will be skiped).

Note that root user can list all the subvolume in the fs with -a option.

[Example]
 $ mkfs.btrfs -f $DEV
 $ mount $DEV /mnt

 $ btrfs subvolume create /mnt/AAA
 $ btrfs subvolume create /mnt/AAA/BBB
 $ mkdir /mnt/AAA/BBB/dir
 $ btrfs subvolume create /mnt/AAA/BBB/dir/CCC
 $ btrfs subvolume create /mnt/ZZZ

 $ umount /mnt
 $ mount -o subvol=AAA $DEV /mnt

 $ btrfs subvolume list /mnt
 ID 256 gen 11 top level 5 path .
 ID 257 gen 8 top level 256 path BBB
 ID 258 gen 8 top level 257 path BBB/dir/CCC

 $ btrfs subvolume list /mnt/BBB
 ID 257 gen 8 top level 256 path .
 ID 258 gen 8 top level 257 path dir/CCC

 $ btrfs subvolume list /mnt/BBB/dir
 ID 258 gen 8 top level 257 path CCC

 ** output of progs <= 4.17
 $ mount -o subvol=AAA $DEV /mnt
 $ btrfs subvolume list /mnt
 ID 256 gen 11 top level 5 path AAA
 ID 257 gen 8 top level 256 path BBB
 ID 258 gen 8 top level 257 path BBB/dir/CCC
 ID 259 gen 11 top level 256 path ZZZ

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 Documentation/btrfs-subvolume.asciidoc |   8 +-
 cmds-subvolume.c                       | 144 +++++++++++++++++++++++++--------
 2 files changed, 119 insertions(+), 33 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index f3eb4e26..99fff977 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -95,6 +95,12 @@ The output format is similar to *subvolume list* command.
 
 *list* [options] [-G [\+|-]<value>] [-C [+|-]<value>] [--sort=rootid,gen,ogen,path] <path>::
 List the subvolumes present in the filesystem <path>.
+By default, this only lists the subvolumes under <path>,
+including <path> itself (except top-level subvolume).
++
+This command had required root privileges. From kernel 4.18,
+non privileged user can call this too. Also from kernel 4.18,
+It is possible to specify non-subvolume directory as <path>.
 +
 For every subvolume the following information is shown by default:
 +
@@ -102,7 +108,7 @@ ID <ID> gen <generation> top level <ID> path <path>
 +
 where ID is subvolume's id, gen is an internal counter which is updated
 every transaction, top level is the same as parent subvolume's id, and
-path is the relative path of the subvolume to the top level subvolume.
+path is the relative path of the subvolume to the specified path.
 The subvolume's ID may be used by the subvolume set-default command,
 or at mount time via the subvolid= option.
 +
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 279a6e51..23596c17 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1125,9 +1125,37 @@ out:
 	return subvols;
 }
 
+static int add_subvol(struct subvol_list **subvols,
+		      struct listed_subvol *subvol,
+		      size_t *capacity)
+{
+	if ((*subvols)->num >= *capacity) {
+		struct subvol_list *new_subvols;
+		size_t new_capacity = max_t(size_t, 1, *capacity * 2);
+
+		new_subvols = realloc(*subvols,
+				      sizeof(*new_subvols) +
+				      new_capacity *
+				      sizeof(new_subvols->subvols[0]));
+		if (!new_subvols) {
+			error("out of memory");
+			return -1;
+		}
+
+		*subvols = new_subvols;
+		*capacity = new_capacity;
+	}
+
+	(*subvols)->subvols[(*subvols)->num] = *subvol;
+	(*subvols)->num++;
+
+	return 0;
+}
+
 static void get_subvols_info(struct subvol_list **subvols,
 			     struct btrfs_list_filter_set_v2 *filter_set,
 			     int fd,
+			     int tree_id,
 			     size_t *capacity)
 {
 	struct btrfs_util_subvolume_iterator *iter;
@@ -1135,7 +1163,7 @@ static void get_subvols_info(struct subvol_list **subvols,
 	int ret = -1;
 
 	err = btrfs_util_create_subvolume_iterator_fd(fd,
-						      BTRFS_FS_TREE_OBJECTID, 0,
+						      tree_id, 0,
 						      &iter);
 	if (err) {
 		iter = NULL;
@@ -1143,6 +1171,52 @@ static void get_subvols_info(struct subvol_list **subvols,
 		goto out;
 	}
 
+	/*
+	 * Subvolume iterator does not include the information of the
+	 * specified path/fd. So, add it first.
+	 */
+	if (!tree_id) {
+		uint64_t id;
+		struct listed_subvol subvol;
+
+		err = btrfs_util_is_subvolume_fd(fd);
+		if (err != BTRFS_UTIL_OK) {
+			if (err == BTRFS_UTIL_ERROR_NOT_SUBVOLUME) {
+				ret = 0;
+				goto skip;
+			} else {
+				ret = -1;
+				goto out;
+			}
+		}
+		err = btrfs_util_subvolume_id_fd(fd, &id);
+		if (err) {
+			ret = -1;
+			goto out;
+		}
+		if (id == BTRFS_FS_TREE_OBJECTID) {
+			/* Skip top level subvolume */
+			ret = 0;
+			goto skip;
+		}
+
+		err = btrfs_util_subvolume_info_fd(fd, 0, &subvol.info);
+		if (err) {
+			ret = -1;
+			goto out;
+		}
+
+		subvol.path = strdup(".");
+		if (!filters_match(&subvol, filter_set)) {
+			free(subvol.path);
+		} else {
+			ret = add_subvol(subvols, &subvol, capacity);
+			if (ret)
+				goto out;
+		}
+	}
+
+skip:
 	for (;;) {
 		struct listed_subvol subvol;
 
@@ -1153,33 +1227,17 @@ static void get_subvols_info(struct subvol_list **subvols,
 			break;
 		} else if (err) {
 			error_btrfs_util(err);
+			ret = -1;
 			goto out;
 		}
 
 		if (!filters_match(&subvol, filter_set)) {
 			free(subvol.path);
-			continue;
-		}
-
-		if ((*subvols)->num >= *capacity) {
-			struct subvol_list *new_subvols;
-			size_t new_capacity = max_t(size_t, 1, *capacity * 2);
-
-			new_subvols = realloc(*subvols,
-					      sizeof(*new_subvols) +
-					      new_capacity *
-					      sizeof(new_subvols->subvols[0]));
-			if (!new_subvols) {
-				error("out of memory");
+		} else {
+			ret = add_subvol(subvols, &subvol, capacity);
+			if (ret)
 				goto out;
-			}
-
-			*subvols = new_subvols;
-			*capacity = new_capacity;
 		}
-
-		(*subvols)->subvols[(*subvols)->num] = subvol;
-		(*subvols)->num++;
 	}
 
 	ret = 0;
@@ -1193,6 +1251,8 @@ out:
 }
 
 static struct subvol_list *btrfs_list_subvols(int fd,
+					      int is_list_all,
+					      const char *path,
 					      struct btrfs_list_filter_set_v2 *filter_set)
 {
 	struct subvol_list *subvols;
@@ -1205,7 +1265,11 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 	}
 	subvols->num = 0;
 
-	get_subvols_info(&subvols, filter_set, fd, &capacity);
+	if (is_list_all)
+		get_subvols_info(&subvols, filter_set, fd,
+				BTRFS_FS_TREE_OBJECTID, &capacity);
+	else
+		get_subvols_info(&subvols, filter_set, fd, 0, &capacity);
 
 	return subvols;
 }
@@ -1214,20 +1278,16 @@ static int btrfs_list_subvols_print_v2(int fd,
 				    struct btrfs_list_filter_set_v2 *filter_set,
 				    struct btrfs_list_comparer_set_v2 *comp_set,
 				    enum btrfs_list_layout layout,
-				    int full_path, const char *raw_prefix)
+				    int is_list_all,
+				    const char *path,
+				    const char *raw_prefix)
 {
 	struct subvol_list *subvols;
 
-	/*
-	 * full_path hasn't done anything since 4f5ebb3ef553 ("Btrfs-progs: fix
-	 * to make list specified directory's subvolumes work"). See
-	 * https://www.spinics.net/lists/linux-btrfs/msg69820.html
-	 */
-
 	if (filter_set->only_deleted)
 		subvols = btrfs_list_deleted_subvols(fd, filter_set);
 	else
-		subvols = btrfs_list_subvols(fd, filter_set);
+		subvols = btrfs_list_subvols(fd, is_list_all, path, filter_set);
 	if (!subvols)
 		return -1;
 
@@ -1323,6 +1383,14 @@ static int btrfs_list_parse_filter_string_v2(char *opt_arg,
 	return 0;
 }
 
+static bool is_root(void)
+{
+	uid_t uid;
+
+	uid = geteuid();
+	return (uid == 0);
+}
+
 /*
  * Naming of options:
  * - uppercase for filters and sort options
@@ -1331,12 +1399,18 @@ static int btrfs_list_parse_filter_string_v2(char *opt_arg,
 static const char * const cmd_subvol_list_usage[] = {
 	"btrfs subvolume list [options] <path>",
 	"List subvolumes and snapshots in the filesystem.",
+	"By default, this only lists the subvolumes under <path>,",
+	"including <path> itself (except top-level subvolume).",
+	"",
+	"This command had required root privileges. From kernel 4.18,",
+	"non privileged user can call this too. Also from kernel 4.18,",
+	"It is possible to specify non-subvolume directory as <path>.",
 	"",
 	"Path filtering:",
 	"-o           print only subvolumes below specified path",
 	"-a           print all the subvolumes in the filesystem and",
 	"             distinguish absolute and relative path with respect",
-	"             to the given <path>",
+	"             to the given <path> (require root privileges)",
 	"",
 	"Field selection:",
 	"-p           print parent ID",
@@ -1481,6 +1555,12 @@ static int cmd_subvol_list(int argc, char **argv)
 		goto out;
 	}
 
+	if (is_list_all && !is_root()) {
+		ret = -1;
+		error("only root can use -a option");
+		goto out;
+	}
+
 	subvol = argv[optind];
 	fd = btrfs_open_dir(subvol, &dirstream, 1);
 	if (fd < 0) {
@@ -1513,7 +1593,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	btrfs_list_setup_print_column_v2(BTRFS_LIST_PATH);
 
 	ret = btrfs_list_subvols_print_v2(fd, filter_set, comparer_set,
-			layout, !is_list_all && !is_only_in_path, NULL);
+			layout, is_list_all, subvol, NULL);
 
 out:
 	close_file_or_dir(fd, dirstream);
-- 
2.14.4


