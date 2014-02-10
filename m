Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29722 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbaBJH1l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 02:27:41 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1A7RXJA020167
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 15:27:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: reuse find_mount_root to determine arg type and so on.
Date: Mon, 10 Feb 2014 15:28:30 +0800
Message-Id: <1392017310-19951-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1392017310-19951-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1392017310-19951-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since find_mount_root now can check mount point quiet good, reuse it to
determing arg type and get real mount point

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-filesystem.c |  7 +++++++
 utils.c           | 24 +++++++++---------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 43e1cf3..bc62d51 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -532,6 +532,7 @@ static int cmd_show(int argc, char **argv)
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head *cur_uuid;
 	char *search = NULL;
+	char *real_mp = NULL;
 	int ret;
 	int where = BTRFS_SCAN_LBLKID;
 	int type = 0;
@@ -607,6 +608,11 @@ static int cmd_show(int argc, char **argv)
 				}
 			}
 		}
+
+		if (type == BTRFS_ARG_MNTPOINT) {
+			find_mount_root(search, &real_mp, 1);
+			search = real_mp;
+		}
 	}
 
 	if (where == BTRFS_SCAN_DEV)
@@ -646,6 +652,7 @@ devs_only:
 
 out:
 	printf("%s\n", BTRFS_BUILD_VERSION);
+	free(real_mp);
 	free_seen_fsid();
 	return ret;
 }
diff --git a/utils.c b/utils.c
index e39ad79..297f18d 100644
--- a/utils.c
+++ b/utils.c
@@ -700,26 +700,20 @@ int is_block_device(const char *path)
 
 /*
  * check if given path is a mount point
- * return 1 if yes. 0 if no. -1 for error
+ * return 1 if yes. 0 if no. <0 for error
  */
 int is_mount_point(const char *path)
 {
-	FILE *f;
-	struct mntent *mnt;
-	int ret = 0;
-
-	f = setmntent("/proc/self/mounts", "r");
-	if (f == NULL)
-		return -1;
+	int ret;
 
-	while ((mnt = getmntent(f)) != NULL) {
-		if (strcmp(mnt->mnt_dir, path))
-			continue;
-		ret = 1;
-		break;
+	ret = find_mount_root(path, NULL, 1);
+	if (ret < 0) {
+		if (ret != -ENOENT)
+			return 0;
+		else
+			return ret;
 	}
-	endmntent(f);
-	return ret;
+	return 1;
 }
 
 /*
-- 
1.8.5.4

