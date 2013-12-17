Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:40273 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab3LQJPR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 04:15:17 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: miaox@cn.fujitsu.com, mwd@md5i.com,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: receive: fix the case that we can not find subvolume
Date: Tue, 17 Dec 2013 17:13:49 +0800
Message-Id: <1387271629-11315-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we change our default subvolume, btrfs receive will fail to find
subvolume. To fix this problem, i have two ideas.

1.make btrfs snapshot ioctl support passing source subvolume's objectid
2.when we want to using interval subvolume path, we mount it other place
that use subvolume 5 as its default subvolume.

We'd better use the second approach because it won't bother kernel change.

Reported-by: Michael Welsh Duggan <mwd@md5i.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-receive.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
 utils.c        | 28 ++++++++++++++++++++++++++++
 utils.h        |  1 +
 3 files changed, 76 insertions(+), 4 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index ed44107..c2cf8a3 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -40,6 +40,7 @@
 #include <sys/types.h>
 #include <sys/xattr.h>
 #include <uuid/uuid.h>
+#include <sys/mount.h>
 
 #include "ctree.h"
 #include "ioctl.h"
@@ -199,6 +200,10 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
 	struct btrfs_ioctl_vol_args_v2 args_v2;
 	struct subvol_info *parent_subvol = NULL;
+	char *dev = NULL;
+	char tmp_name[15] = "btrfs-XXXXXX";
+	char tmp_dir[30] = "/tmp";
+	char *full_path = NULL;
 
 	ret = finish_subvol(r);
 	if (ret < 0)
@@ -253,13 +258,47 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		}
 	}*/
 
-	args_v2.fd = openat(r->mnt_fd, parent_subvol->path,
-			O_RDONLY | O_NOATIME);
+	ret = mnt_to_dev(r->root_path, &dev);
+	if (ret)
+		goto out;
+	if (!mktemp(tmp_name)) {
+		fprintf(stderr, "ERROR: fail to generate a tmp file\n");
+		goto out;
+	}
+	strncat(tmp_dir, "/", 1);
+	strncat(tmp_dir, tmp_name, strlen(tmp_name));
+
+	ret = mkdir(tmp_dir, 0777);
+	if (ret) {
+		fprintf(stderr, "ERROR: fail to make dir: %s\n", tmp_dir);
+		goto out;
+	}
+	/* if we change default subvolume, using btrfs interval
+	 * subvolume path to lookup may return us ENOENT.To handle
+	 * such case, we mount this btrfs filesystem other place
+	 * where we use fs tree as our default subvolume.
+	 */
+	ret = mount(dev, tmp_dir, "btrfs", 0, "-o subvolid=5");
+	if (ret) {
+		fprintf(stderr, "ERROR: fail to mount dev: %s", dev);
+		goto out;
+	}
+
+	full_path = calloc(1, strlen(parent_subvol->path) + strlen(tmp_dir));
+	if (!full_path) {
+		ret = -ENOMEM;
+		goto out_umount;
+	}
+	strncat(full_path, tmp_dir, strlen(tmp_dir));
+	strncat(full_path, "/", 1);
+	strncat(full_path, parent_subvol->path, strlen(parent_subvol->path));
+
+	args_v2.fd = open(full_path, O_RDONLY | O_NOATIME);
 	if (args_v2.fd < 0) {
 		ret = -errno;
 		fprintf(stderr, "ERROR: open %s failed. %s\n",
 				parent_subvol->path, strerror(-ret));
-		goto out;
+		goto out_umount;
 	}
 
 	ret = ioctl(r->dest_dir_fd, BTRFS_IOC_SNAP_CREATE_V2, &args_v2);
@@ -269,10 +308,14 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 		fprintf(stderr, "ERROR: creating snapshot %s -> %s "
 				"failed. %s\n", parent_subvol->path,
 				path, strerror(-ret));
-		goto out;
 	}
 
+out_umount:
+	umount(tmp_dir);
+	rmdir(tmp_dir);
 out:
+	free(full_path);
+	free(dev);
 	if (parent_subvol) {
 		free(parent_subvol->path);
 		free(parent_subvol);
diff --git a/utils.c b/utils.c
index a92696e..da5291b 100644
--- a/utils.c
+++ b/utils.c
@@ -2194,6 +2194,34 @@ out:
 	return ret;
 }
 
+/*
+ * Given mount point, this function will return
+ * its corresponding device
+ */
+int mnt_to_dev(const char *mnt_dir, char **dev)
+{
+	struct mntent *mnt;
+	FILE *f;
+	int ret = -1;
+
+	f = setmntent("/proc/self/mounts", "r");
+	if (f == NULL)
+		return ret;
+	while ((mnt = getmntent(f)) != NULL) {
+		if (strcmp(mnt->mnt_type, "btrfs"))
+			continue;
+		if (strcmp(mnt->mnt_dir, mnt_dir))
+			continue;
+		*dev = strdup(mnt->mnt_fsname);
+		if (*dev)
+			ret = 0;
+		break;
+	}
+	endmntent(f);
+
+	return ret;
+}
+
 /* This finds the mount point for a given fsid,
  *  subvols of the same fs/fsid can be mounted
  *  so here this picks and lowest subvol id
diff --git a/utils.h b/utils.h
index 00f1c18..9b2f79c 100644
--- a/utils.h
+++ b/utils.h
@@ -98,5 +98,6 @@ int btrfs_scan_lblkid(int update_kernel);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 int get_fslist(struct btrfs_ioctl_fslist **out_fslist, u64 *out_count);
 int fsid_to_mntpt(__u8 *fsid, char *mntpt, int *mnt_cnt);
+int mnt_to_dev(const char *mnt, char **dev);
 
 #endif
-- 
1.8.3.1

