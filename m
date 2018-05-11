Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:29758 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbeEKH1j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:27:39 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 5D1E0AC00FC
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:36 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 8A3D232881C
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:35 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 07/11] btrfs-progs: sub list: Change the default behavior of "subvolume list" and allow non-privileged user to call it
Date: Fri, 11 May 2018 16:29:45 +0900
Message-ID: <20180511072949.15269-8-misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
References: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change the default behavior of "subvolume list" and allow non-privileged
user to call it as well.

>From this commit, by default it only lists subvolumes under the specified
path (incl. the path itself except top-level subvolume). Also, if kernel
supports new ioctls (BTRFS_IOC_GET_SUBVOL_INFO/BTRFS_IOC_GET_ROOTREF/
BTRFS_IOC_INO_LOOKUP_USER),
  - the specified path can be non-subvolume directory.
  - non-privileged user can also call it.

Note that root user can list all the subvolume in the fs with -a option
(the same behavior as before).

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 Documentation/btrfs-subvolume.asciidoc |  2 +
 cmds-subvolume.c                       | 90 +++++++++++++++++++++++++++++-----
 2 files changed, 81 insertions(+), 11 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index a8c4af4b..e03d4a6e 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -92,6 +92,7 @@ The output format is similar to *subvolume list* command.
 
 *list* [options] [-G [\+|-]<value>] [-C [+|-]<value>] [--sort=rootid,gen,ogen,path] <path>::
 List the subvolumes present in the filesystem <path>.
+By default, this lists the subvolume under the specified path.
 +
 For every subvolume the following information is shown by default. +
 ID <ID> top level <ID> path <path> +
@@ -109,6 +110,7 @@ print parent ID.
 -a::::
 print all the subvolumes in the filesystem and distinguish between
 absolute and relative path with respect to the given <path>.
+This requires root privileges.
 -c::::
 print the ogeneration of the subvolume, aliases: ogen or origin generation.
 -g::::
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 06686943..c3952172 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1126,6 +1126,7 @@ out:
 }
 
 static struct subvol_list *btrfs_list_subvols(int fd,
+					      int is_list_all,
 					      struct btrfs_list_filter_set_v2 *filter_set)
 {
 	struct subvol_list *subvols;
@@ -1133,6 +1134,7 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 	struct btrfs_util_subvolume_iterator *iter;
 	enum btrfs_util_error err;
 	int ret = -1;
+	int tree_id = 0;
 
 	subvols = malloc(sizeof(*subvols));
 	if (!subvols) {
@@ -1141,8 +1143,11 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 	}
 	subvols->num = 0;
 
+	if (is_list_all)
+		tree_id = BTRFS_FS_TREE_OBJECTID;
+
 	err = btrfs_util_create_subvolume_iterator_fd(fd,
-						      BTRFS_FS_TREE_OBJECTID, 0,
+						      tree_id, 0,
 						      &iter);
 	if (err) {
 		iter = NULL;
@@ -1189,6 +1194,60 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 		subvols->num++;
 	}
 
+	/*
+	 * Subvolume iterator does not include the information of the
+	 * specified path/fd. So, add it here.
+	 */
+	if (!is_list_all) {
+		uint64_t id;
+		struct listed_subvol subvol;
+
+		err = btrfs_util_is_subvolume_fd(fd);
+		if (err != BTRFS_UTIL_OK) {
+			if (err == BTRFS_UTIL_ERROR_NOT_SUBVOLUME)
+				ret = 0;
+			goto out;
+		}
+		err = btrfs_util_subvolume_id_fd(fd, &id);
+		if (err)
+			goto out;
+		if (id == BTRFS_FS_TREE_OBJECTID) {
+			/* Skip top level subvolume */
+			ret = 0;
+			goto out;
+		}
+
+		err = btrfs_util_subvolume_info_fd(fd, 0, &subvol.info);
+		if (err)
+			goto out;
+
+		subvol.path = strdup(".");
+		if (!filters_match(&subvol, filter_set)) {
+			free(subvol.path);
+		} else {
+			if (subvols->num >= capacity) {
+				struct subvol_list *new_subvols;
+				size_t new_capacity =
+					max_t(size_t, 1, capacity * 2);
+
+				new_subvols = realloc(subvols,
+					sizeof(*new_subvols) +
+					new_capacity *
+					sizeof(new_subvols->subvols[0]));
+				if (!new_subvols) {
+					error("out of memory");
+					goto out;
+				}
+
+				subvols = new_subvols;
+				capacity = new_capacity;
+			}
+
+			subvols->subvols[subvols->num] = subvol;
+			subvols->num++;
+		}
+	}
+
 	ret = 0;
 out:
 	if (iter)
@@ -1202,20 +1261,14 @@ static int btrfs_list_subvols_print_v2(int fd,
 				    struct btrfs_list_filter_set_v2 *filter_set,
 				    struct btrfs_list_comparer_set_v2 *comp_set,
 				    enum btrfs_list_layout layout,
-				    int full_path, const char *raw_prefix)
+				    int is_list_all, const char *raw_prefix)
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
+		subvols = btrfs_list_subvols(fd, is_list_all, filter_set);
 	if (!subvols)
 		return -1;
 
@@ -1311,6 +1364,14 @@ static int btrfs_list_parse_filter_string_v2(char *opt_arg,
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
@@ -1319,12 +1380,13 @@ static int btrfs_list_parse_filter_string_v2(char *opt_arg,
 static const char * const cmd_subvol_list_usage[] = {
 	"btrfs subvolume list [options] <path>",
 	"List subvolumes and snapshots in the filesystem.",
+	"By default, this only lists the subvolume under the specified path.",
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
@@ -1485,6 +1547,12 @@ static int cmd_subvol_list(int argc, char **argv)
 	if (ret)
 		goto out;
 
+	if (is_list_all && !is_root()) {
+		ret = -1;
+		error("Only root can use -a option");
+		goto out;
+	}
+
 	if (is_list_all)
 		btrfs_list_setup_filter_v2(&filter_set,
 					BTRFS_LIST_FILTER_FULL_PATH,
@@ -1501,7 +1569,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	btrfs_list_setup_print_column_v2(BTRFS_LIST_PATH);
 
 	ret = btrfs_list_subvols_print_v2(fd, filter_set, comparer_set,
-			layout, !is_list_all && !is_only_in_path, NULL);
+			layout, is_list_all, NULL);
 
 out:
 	close_file_or_dir(fd, dirstream);
-- 
2.14.3


