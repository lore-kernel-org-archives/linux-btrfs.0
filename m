Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50109 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaBJH1k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 02:27:40 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1A7RXEe020166
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 15:27:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: Add path_is_mp option for find_mount_root.
Date: Mon, 10 Feb 2014 15:28:29 +0800
Message-Id: <1392017310-19951-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1392017310-19951-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1392017310-19951-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add path_is_mp option for find_mount_root, allowing to treat path as a
mount point, if not found a restricted(*) match, will return -ENOENT.

*: stricted match allow only the last '/' differs since path completion
often addes a '/' in the end but mount points in /proc/self/mounts.
e.g /mnt/data and /mnt/data/ is a restricted match but
/mnt/data and /mnt/data/something is not a restricted match.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-receive.c   |  2 +-
 cmds-send.c      |  4 ++--
 cmds-subvolume.c |  2 +-
 utils.c          | 32 ++++++++++++++++++++++++--------
 utils.h          |  2 +-
 5 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index cce37a7..810fd59 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -843,7 +843,7 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
 		goto out;
 	}
 
-	ret = find_mount_root(dest_dir_full_path, &r->root_path);
+	ret = find_mount_root(dest_dir_full_path, &r->root_path, 0);
 	if (ret < 0) {
 		ret = -EINVAL;
 		fprintf(stderr, "ERROR: failed to determine mount point "
diff --git a/cmds-send.c b/cmds-send.c
index 9d49ce9..967f45a 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -349,7 +349,7 @@ static int init_root_path(struct btrfs_send *s, const char *subvol)
 	if (s->root_path)
 		goto out;
 
-	ret = find_mount_root(subvol, &s->root_path);
+	ret = find_mount_root(subvol, &s->root_path, 0);
 	if (ret < 0) {
 		ret = -EINVAL;
 		fprintf(stderr, "ERROR: failed to determine mount point "
@@ -584,7 +584,7 @@ int cmd_send(int argc, char **argv)
 			goto out;
 		}
 
-		ret = find_mount_root(subvol, &mount_root);
+		ret = find_mount_root(subvol, &mount_root, 0);
 		if (ret < 0) {
 			fprintf(stderr, "ERROR: find_mount_root failed on %s: "
 					"%s\n", subvol,
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 0bd76f2..a78a535 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -931,7 +931,7 @@ static int cmd_subvol_show(int argc, char **argv)
 		goto out;
 	}
 
-	ret = find_mount_root(fullpath, &mnt);
+	ret = find_mount_root(fullpath, &mnt, 0);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
 				"%s\n", fullpath, strerror(-ret));
diff --git a/utils.c b/utils.c
index 8f06d4e..e39ad79 100644
--- a/utils.c
+++ b/utils.c
@@ -2111,7 +2111,13 @@ int lookup_ino_rootid(int fd, u64 *rootid)
 	return 0;
 }
 
-int find_mount_root(const char *path, char **mount_root)
+/*
+ * Find the mount root of a given path.
+ * Return 0 when found and restore the mount root into mount_root.
+ * If path_is_mp is set, path will be treated as mount point and compare
+ * in a restricted way.
+ */
+int find_mount_root(const char *path, char **mount_root, int path_is_mp)
 {
 	FILE *mnttab;
 	int fd;
@@ -2144,17 +2150,27 @@ int find_mount_root(const char *path, char **mount_root)
 	endmntent(mnttab);
 
 	if (!longest_match) {
-		fprintf(stderr,
-			"ERROR: Failed to find mount root for path %s.\n",
-			path);
-		return -ENOENT;
+		ret = -ENOENT;
+		goto out;
+	}
+
+	/* Only the last '/' in path may differs if path_is_mp */
+	if (path_is_mp && strlen(path) != strlen(longest_match)) {
+		if (strlen(path) != strlen(longest_match) + 1 ||
+		    path[strlen(path) - 1] != '/') {
+			ret = -ENOENT;
+			goto out;
+		}
 	}
 
 	ret = 0;
-	*mount_root = realpath(longest_match, NULL);
-	if (!*mount_root)
-		ret = -errno;
+	if (mount_root) {
+		*mount_root = realpath(longest_match, *mount_root);
+		if (!*mount_root)
+			ret = -errno;
+	}
 
+out:
 	free(longest_match);
 	return ret;
 }
diff --git a/utils.h b/utils.h
index e074732..b69712e 100644
--- a/utils.h
+++ b/utils.h
@@ -96,6 +96,6 @@ int ask_user(char *question);
 int lookup_ino_rootid(int fd, u64 *rootid);
 int btrfs_scan_lblkid(int update_kernel);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
-int find_mount_root(const char *path, char **mount_root);
+int find_mount_root(const char *path, char **mount_root, int path_is_mp);
 
 #endif
-- 
1.8.5.4

