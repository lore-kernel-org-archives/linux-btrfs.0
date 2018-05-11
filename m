Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:62725 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752507AbeEKH1m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:27:42 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id C0EFBAC00BB
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:37 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id F0E8F32881B
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:36 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 09/11] btrfs-progs: sub show: Allow non-privileged user to call "subvolume show"
Date: Fri, 11 May 2018 16:29:47 +0900
Message-ID: <20180511072949.15269-10-misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
References: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow non-privileged user to call subvolume show (-r or -u cannot be used)
if new ioctls (BTRFS_IOC_GET_SUBVOL_INFO etc.) are available.
The behavior for root user is the same as before.

There are some output differences between root and user:
  root ... subvolume path is from top-level subvolume
           list all snapshots in the fs (inc. non-accessible ones)
  user ... subvolume path is from mount point
           list snapshots under the mountpoint
	   (to which the user has appropriate privileges)

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 cmds-subvolume.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 78 insertions(+), 12 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index c3952172..d88d5d76 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1883,8 +1883,8 @@ static int cmd_subvol_find_new(int argc, char **argv)
 static const char * const cmd_subvol_show_usage[] = {
 	"btrfs subvolume show [options] <subvol-path>|<mnt>",
 	"Show more information about the subvolume",
-	"-r|--rootid   rootid of the subvolume",
-	"-u|--uuid     uuid of the subvolume",
+	"-r|--rootid   rootid of the subvolume (require root privileges)",
+	"-u|--uuid     uuid of the subvolume   (require root privileges)",
 	"",
 	"If no option is specified, <subvol-path> will be shown, otherwise",
 	"the rootid or uuid are resolved relative to the <mnt> path.",
@@ -1897,8 +1897,10 @@ static int cmd_subvol_show(int argc, char **argv)
 	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
 	char *fullpath = NULL;
 	int fd = -1;
+	int fd_mnt = -1;
 	int ret = 1;
 	DIR *dirstream1 = NULL;
+	DIR *dirstream_mnt = NULL;
 	int by_rootid = 0;
 	int by_uuid = 0;
 	u64 rootid_arg = 0;
@@ -1906,6 +1908,8 @@ static int cmd_subvol_show(int argc, char **argv)
 	struct btrfs_util_subvolume_iterator *iter;
 	struct btrfs_util_subvolume_info subvol;
 	char *subvol_path = NULL;
+	char *subvol_name = NULL;
+	char *mount_point = NULL;
 	enum btrfs_util_error err;
 
 	while (1) {
@@ -1943,6 +1947,11 @@ static int cmd_subvol_show(int argc, char **argv)
 		usage(cmd_subvol_show_usage);
 	}
 
+	if (!is_root() && (by_rootid || by_uuid)) {
+		error("Only root can use -r or -u options");
+		return -1;
+	}
+
 	fullpath = realpath(argv[optind], NULL);
 	if (!fullpath) {
 		error("cannot find real path for '%s': %m", argv[optind]);
@@ -1997,19 +2006,65 @@ static int cmd_subvol_show(int argc, char **argv)
 			goto out;
 		}
 
-		err = btrfs_util_subvolume_path_fd(fd, subvol.id, &subvol_path);
-		if (err) {
-			error_btrfs_util(err);
-			goto out;
+		if (is_root()) {
+			/* Construct path from top-level subvolume */
+			err = btrfs_util_subvolume_path_fd(fd, subvol.id,
+								&subvol_path);
+			if (err) {
+				error_btrfs_util(err);
+				goto out;
+			}
+			subvol_name = strdup(basename(subvol_path));
+		} else {
+			/* Construct path from mount point */
+			ret = find_mount_root(fullpath, &mount_point);
+			if (ret < 0) {
+				error("cannot get mount point");
+				goto out;
+			}
+
+			fd_mnt = open_file_or_dir(mount_point, &dirstream_mnt);
+			if (fd_mnt < 0) {
+				error("cannot open mount point");
+				goto out;
+			}
+
+			if (strlen(fullpath) == strlen(mount_point)) {
+				/* Get real name at mount point */
+				struct btrfs_ioctl_get_subvol_info_args arg;
+
+				ret = ioctl(fd_mnt, BTRFS_IOC_GET_SUBVOL_INFO,
+							&arg);
+				if (ret < 0) {
+					error("cannot get subvolume info");
+					goto out;
+				}
+				subvol_path = strdup("./");
+				subvol_name = strdup(arg.name);
+			} else {
+				subvol_path = malloc(strlen(fullpath) -
+						strlen(mount_point) + 1);
+				if (!subvol_path) {
+					error("not enough memory");
+					ret = 1;
+					goto out;
+				}
+				subvol_path[0] = '.';
+				memcpy(subvol_path + 1,
+					fullpath + strlen(mount_point),
+					strlen(fullpath) - strlen(mount_point));
+				subvol_name = strdup(basename(subvol_path));
+			}
 		}
 
 	}
 
 	/* print the info */
-	printf("%s\n", subvol.id == BTRFS_FS_TREE_OBJECTID ? "/" : subvol_path);
+	printf("%s\n", subvol.id == BTRFS_FS_TREE_OBJECTID ?
+			(is_root() ? "/" : "./") : subvol_path);
 	printf("\tName: \t\t\t%s\n",
-	       (subvol.id == BTRFS_FS_TREE_OBJECTID ? "<FS_TREE>" :
-		basename(subvol_path)));
+		(subvol.id == BTRFS_FS_TREE_OBJECTID ? "<FS_TREE>" :
+		 subvol_name));
 
 	if (uuid_is_null(subvol.uuid))
 		strcpy(uuidparse, "-");
@@ -2052,9 +2107,18 @@ static int cmd_subvol_show(int argc, char **argv)
 	/* print the snapshots of the given subvol if any*/
 	printf("\tSnapshot(s):\n");
 
-	err = btrfs_util_create_subvolume_iterator_fd(fd,
-						      BTRFS_FS_TREE_OBJECTID, 0,
-						      &iter);
+	/*
+	 * For root, show all snapshots in the filesystem.
+	 * For non-privileged user, show all snapshots under mount point.
+	 */
+	if (is_root())
+		err = btrfs_util_create_subvolume_iterator_fd(fd,
+					      BTRFS_FS_TREE_OBJECTID, 0,
+					      &iter);
+	else
+		err = btrfs_util_create_subvolume_iterator_fd(fd_mnt,
+					      0, 0,
+					      &iter);
 
 	for (;;) {
 		struct btrfs_util_subvolume_info subvol2;
@@ -2080,7 +2144,9 @@ static int cmd_subvol_show(int argc, char **argv)
 out:
 	free(subvol_path);
 	close_file_or_dir(fd, dirstream1);
+	close_file_or_dir(fd_mnt, dirstream_mnt);
 	free(fullpath);
+	free(mount_point);
 	return !!ret;
 }
 
-- 
2.14.3


