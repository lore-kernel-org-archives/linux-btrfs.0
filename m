Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:18083 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965051AbdIZFpM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 01:45:12 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id A86B0AC0107
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 14:45:04 +0900 (JST)
Received: from G01JPEXCHYT15.g01.fujitsu.local (G01JPEXCHYT15.g01.fujitsu.local [10.128.194.54])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id C75DD584302
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 14:45:03 +0900 (JST)
Subject: [PATCH 1/4] btrfs-progs: move get_fsid() to util.c
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <8c494134-ce71-4ca7-dc91-06d36774cc84@jp.fujitsu.com>
Message-ID: <7aa5d067-bd06-ee73-ee61-33ca1ea2223e@jp.fujitsu.com>
Date: Tue, 26 Sep 2017 14:45:00 +0900
MIME-Version: 1.0
In-Reply-To: <8c494134-ce71-4ca7-dc91-06d36774cc84@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make get_fsid() to a common function.
This will be used for 'subvol delete --commit-after'.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 cmds-property.c | 30 ------------------------------
 utils.c         | 31 +++++++++++++++++++++++++++++++
 utils.h         |  1 +
 3 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index 9ae1246..03bafa0 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -48,36 +48,6 @@ static int parse_prop(const char *arg, const struct prop_handler *props,
 	return -1;
 }
 
-static int get_fsid(const char *path, u8 *fsid, int silent)
-{
-	int ret;
-	int fd;
-	struct btrfs_ioctl_fs_info_args args;
-
-	fd = open(path, O_RDONLY);
-	if (fd < 0) {
-		ret = -errno;
-		if (!silent)
-			error("failed to open %s: %s", path,
-				strerror(-ret));
-		goto out;
-	}
-
-	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &args);
-	if (ret < 0) {
-		ret = -errno;
-		goto out;
-	}
-
-	memcpy(fsid, args.fsid, BTRFS_FSID_SIZE);
-	ret = 0;
-
-out:
-	if (fd != -1)
-		close(fd);
-	return ret;
-}
-
 static int check_btrfs_object(const char *object)
 {
 	int ret;
diff --git a/utils.c b/utils.c
index 7a2710f..4a5dc60 100644
--- a/utils.c
+++ b/utils.c
@@ -1758,6 +1758,37 @@ out:
 	return ret;
 }
 
+int get_fsid(const char *path, u8 *fsid, int silent)
+{
+	int ret;
+	int fd;
+	struct btrfs_ioctl_fs_info_args args;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		ret = -errno;
+		if (!silent)
+			error("failed to open %s: %s", path,
+				strerror(-ret));
+		goto out;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &args);
+	if (ret < 0) {
+		ret = -errno;
+		goto out;
+	}
+
+	memcpy(fsid, args.fsid, BTRFS_FSID_SIZE);
+	ret = 0;
+
+out:
+	if (fd != -1)
+		close(fd);
+	return ret;
+}
+
+
 static int group_profile_devs_min(u64 flag)
 {
 	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
diff --git a/utils.h b/utils.h
index d28a05a..b3aabe1 100644
--- a/utils.h
+++ b/utils.h
@@ -100,6 +100,7 @@ int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags);
 void close_file_or_dir(int fd, DIR *dirstream);
 int get_fs_info(const char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		struct btrfs_ioctl_dev_info_args **di_ret);
+int get_fsid(const char *path, u8 *fsid, int silent);
 int get_label(const char *btrfs_dev, char *label);
 int set_label(const char *btrfs_dev, const char *label);
 
-- 
2.9.5

