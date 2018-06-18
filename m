Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:28214 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968188AbeFRIiS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:18 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 731A1AC0267
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:10 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id AAD1DBD65F4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:09 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 11/20] btrfs-progs: sub list: Add -f option to follow mounted subvolumes below the path
Date: Mon, 18 Jun 2018 17:40:59 +0900
Message-ID: <84d06767762b4285ddefec0392ee16e2d7e06f62.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add -f option to follow mounted subvolumes below the specified path, only
if it is the same filesystem.

[Example]
 $ mkfs.btrfs -f $DEV
 $ mkfs.btrfs -f $DEV2
 $ mount $DEV /mnt

 $ btrfs subvolume create /mnt/AAA
 $ btrfs subvolume create /mnt/BBB
 $ btrfs subvolume create /mnt/CCC
 $ mkdir /mnt/AAA/bbb
 $ mkdir /mnt/AAA/ccc
 $ mkdir /mnt/AAA/other

 $ umount /mnt
 $ mount -o subvol=AAA $DEV /mnt
 $ mount -o subvol=BBB $DEV /mnt/bbb
 $ mount -o subvol=CCC $DEV /mnt/ccc
 $ mount -o $DEV2 /mnt/other

 $ btrfs subvolume list /mnt
 ID 256 gen 9 top level 5 path .

 $ btrfs subvolume list -f /mnt
 ID 256 gen 9 top level 5 path .
 ID 258 gen 7 top level 5 path bbb
 ID 259 gen 8 top level 5 path ccc

Note that this option lists top-level subvolume if it is mounted in the
way.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 Documentation/btrfs-subvolume.asciidoc |   4 ++
 cmds-subvolume.c                       | 116 +++++++++++++++++++++++++++++++--
 2 files changed, 113 insertions(+), 7 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index fec4b769..b2461398 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -120,6 +120,10 @@ print only subvolumes below specified <path>.
 -a::::
 print all the subvolumes in the filesystem and distinguish between
 absolute and relative path with respect to the given <path>.
+-f::::
+follow mounted subvolumes below <path> recursively and list them too
+(only if it is the same filesystem). If top-level subvolume is mounted
+in the way, it is also listed.
 
 Field selection;;
 -p::::
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ea341d50..4ebe0377 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -28,6 +28,7 @@
 #include <getopt.h>
 #include <uuid/uuid.h>
 #include <linux/magic.h>
+#include <mntent.h>
 
 #include <btrfsutil.h>
 
@@ -1157,7 +1158,8 @@ static void get_subvols_info(struct subvol_list **subvols,
 			     int fd,
 			     int tree_id,
 			     size_t *capacity,
-			     const char *prefix)
+			     const char *prefix,
+			     int show_top)
 {
 	struct btrfs_util_subvolume_iterator *iter;
 	enum btrfs_util_error err;
@@ -1195,7 +1197,7 @@ static void get_subvols_info(struct subvol_list **subvols,
 			ret = -1;
 			goto out;
 		}
-		if (id == BTRFS_FS_TREE_OBJECTID) {
+		if (!show_top && id == BTRFS_FS_TREE_OBJECTID) {
 			/* Skip top level subvolume */
 			ret = 0;
 			goto skip;
@@ -1280,6 +1282,7 @@ out:
 static struct subvol_list *btrfs_list_subvols(int fd,
 					      int is_list_all,
 					      int absolute_path,
+					      int follow_mount,
 					      const char *path,
 					      struct btrfs_list_filter_set_v2 *filter_set)
 {
@@ -1295,7 +1298,8 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 
 	if (is_list_all) {
 		get_subvols_info(&subvols, filter_set, fd,
-				BTRFS_FS_TREE_OBJECTID, &capacity, NULL);
+				BTRFS_FS_TREE_OBJECTID, &capacity, NULL,
+				false);
 	} else {
 		char *fullpath;
 
@@ -1307,8 +1311,92 @@ static struct subvol_list *btrfs_list_subvols(int fd,
 		}
 
 		get_subvols_info(&subvols, filter_set, fd, 0, &capacity,
-				(absolute_path ? fullpath : NULL));
+				(absolute_path ? fullpath : NULL), false);
 
+		if (subvols == NULL) {
+			free(fullpath);
+			return NULL;
+		}
+
+		/* Follow mounted subvolumes below @path */
+		if (follow_mount) {
+			struct mntent *mnt;
+			FILE *f;
+			DIR *dirstream;
+			u8 fsid[BTRFS_FSID_SIZE];
+			u8 fsid2[BTRFS_FSID_SIZE];
+			char *c;
+			int fd2;
+			int ret;
+
+			ret = get_fsid(path, fsid, 0);
+			if (ret < 0) {
+				error("failed to get fsid: %m");
+				free(fullpath);
+				free_subvol_list(subvols);
+				return NULL;
+			}
+
+			f = setmntent("/proc/self/mounts", "r");
+			if (f == NULL) {
+				error("failed to read mount entry: %m");
+				free(fullpath);
+				free_subvol_list(subvols);
+				return NULL;
+			}
+
+			/* Iterate for each mount entry */
+			while ((mnt = getmntent(f)) != NULL) {
+				if (strcmp(mnt->mnt_type, "btrfs"))
+					continue;
+
+				if (!strcmp(mnt->mnt_dir, fullpath))
+					continue;
+
+				c = strstr(mnt->mnt_dir, fullpath);
+				if (c != mnt->mnt_dir)
+					continue;
+
+				/* If fsid is different, skip it */
+				ret = get_fsid(mnt->mnt_dir, fsid2, 1);
+				if (ret < 0) {
+					/*
+					 * ENOENT may happen when mount is
+					 * stacked
+					 */
+					if (errno == EACCES || errno == ENOENT)
+						continue;
+					error("failed to get fsid: %m");
+					free(fullpath);
+					free_subvol_list(subvols);
+					return NULL;
+				}
+				if (uuid_compare(fsid, fsid2))
+					continue;
+
+				fd2 = btrfs_open_dir(mnt->mnt_dir,
+						     &dirstream, 1);
+				if (fd2 < 0) {
+					error("cannot open '%s': %m",
+							mnt->mnt_dir);
+					free(fullpath);
+					free_subvol_list(subvols);
+					return NULL;
+				}
+				get_subvols_info(&subvols, filter_set,
+						fd2, 0, &capacity,
+						(absolute_path ? mnt->mnt_dir :
+							(strlen(fullpath) == 1 ?
+							 mnt->mnt_dir + 1 :
+							 mnt->mnt_dir + strlen(fullpath) + 1)),
+						true);
+				close_file_or_dir(fd2, dirstream);
+				if (subvols == NULL) {
+					free(fullpath);
+					return NULL;
+				}
+			}
+		}
 		free(fullpath);
 	}
 
@@ -1321,6 +1409,7 @@ static int btrfs_list_subvols_print_v2(int fd,
 				    enum btrfs_list_layout layout,
 				    int is_list_all,
 				    int absolute_path,
+				    int follow_mount,
 				    const char *path,
 				    const char *raw_prefix)
 {
@@ -1330,7 +1419,7 @@ static int btrfs_list_subvols_print_v2(int fd,
 		subvols = btrfs_list_deleted_subvols(fd, filter_set);
 	else
 		subvols = btrfs_list_subvols(fd, is_list_all, absolute_path,
-					     path, filter_set);
+					     follow_mount, path, filter_set);
 	if (!subvols)
 		return -1;
 
@@ -1454,6 +1543,8 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-a           print all the subvolumes in the filesystem and",
 	"             distinguish absolute and relative path with respect",
 	"             to the given <path> (require root privileges)",
+	"-f           follow mounted subvolumes below the specified path",
+	"             and list them too (only if it is the same filesystem)",
 	"",
 	"Field selection:",
 	"-p           print parent ID",
@@ -1497,6 +1588,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	int ret = -1, uerr = 0;
 	char *subvol;
 	int is_list_all = 0;
+	int follow_mount = 0;
 	int is_only_in_path = 0;
 	int absolute_path = 0;
 	DIR *dirstream = NULL;
@@ -1513,7 +1605,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		};
 
 		c = getopt_long(argc, argv,
-				    "acdgopqsurARG:C:t", long_options, NULL);
+				    "acdfgopqsurARG:C:t", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -1527,6 +1619,9 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'a':
 			is_list_all = 1;
 			break;
+		case 'f':
+			follow_mount = 1;
+			break;
 		case 'c':
 			btrfs_list_setup_print_column_v2(BTRFS_LIST_OGENERATION);
 			break;
@@ -1616,6 +1711,12 @@ static int cmd_subvol_list(int argc, char **argv)
 		goto out;
 	}
 
+	if (follow_mount && (is_list_all || is_only_in_path)) {
+		ret = -1;
+		error("cannot use -f with -a or -o option");
+		goto out;
+	}
+
 	subvol = argv[optind];
 	fd = btrfs_open_dir(subvol, &dirstream, 1);
 	if (fd < 0) {
@@ -1648,7 +1749,8 @@ static int cmd_subvol_list(int argc, char **argv)
 	btrfs_list_setup_print_column_v2(BTRFS_LIST_PATH);
 
 	ret = btrfs_list_subvols_print_v2(fd, filter_set, comparer_set,
-			layout, is_list_all, absolute_path, subvol, NULL);
+			layout, is_list_all, absolute_path, follow_mount,
+			subvol, NULL);
 
 out:
 	close_file_or_dir(fd, dirstream);
-- 
2.14.4


