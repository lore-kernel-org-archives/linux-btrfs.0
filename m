Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50109 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaBJH1j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 02:27:39 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1A7RXJ9020167
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 15:27:33 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: move find_mount_root to utils.[ch]
Date: Mon, 10 Feb 2014 15:28:28 +0800
Message-Id: <1392017310-19951-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1392017310-19951-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1392017310-19951-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move find_mount_root to utils.[ch] for general use.

Signed-off-by: Qu Wenruo <quwenruo@cn.fuijitsu.com>
---
 cmds-send.c | 49 +------------------------------------------------
 commands.h  |  1 -
 utils.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h     |  1 +
 4 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index fc9a01e..9d49ce9 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -39,6 +39,7 @@
 #include "ioctl.h"
 #include "commands.h"
 #include "list.h"
+#include "utils.h"
 
 #include "send.h"
 #include "send-utils.h"
@@ -57,54 +58,6 @@ struct btrfs_send {
 	struct subvol_uuid_search sus;
 };
 
-int find_mount_root(const char *path, char **mount_root)
-{
-	FILE *mnttab;
-	int fd;
-	struct mntent *ent;
-	int len;
-	int ret;
-	int longest_matchlen = 0;
-	char *longest_match = NULL;
-
-	fd = open(path, O_RDONLY | O_NOATIME);
-	if (fd < 0)
-		return -errno;
-	close(fd);
-
-	mnttab = setmntent("/proc/self/mounts", "r");
-	if (!mnttab)
-		return -errno;
-
-	while ((ent = getmntent(mnttab))) {
-		len = strlen(ent->mnt_dir);
-		if (strncmp(ent->mnt_dir, path, len) == 0) {
-			/* match found */
-			if (longest_matchlen < len) {
-				free(longest_match);
-				longest_matchlen = len;
-				longest_match = strdup(ent->mnt_dir);
-			}
-		}
-	}
-	endmntent(mnttab);
-
-	if (!longest_match) {
-		fprintf(stderr,
-			"ERROR: Failed to find mount root for path %s.\n",
-			path);
-		return -ENOENT;
-	}
-
-	ret = 0;
-	*mount_root = realpath(longest_match, NULL);
-	if (!*mount_root)
-		ret = -errno;
-
-	free(longest_match);
-	return ret;
-}
-
 static int get_root_id(struct btrfs_send *s, const char *path, u64 *root_id)
 {
 	struct subvol_info *si;
diff --git a/commands.h b/commands.h
index 23c1201..db70043 100644
--- a/commands.h
+++ b/commands.h
@@ -126,5 +126,4 @@ int cmd_rescue(int argc, char **argv);
 int test_issubvolume(char *path);
 
 /* send.c */
-int find_mount_root(const char *path, char **mount_root);
 char *get_subvol_name(char *mnt, char *full_path);
diff --git a/utils.c b/utils.c
index 75b37f3..8f06d4e 100644
--- a/utils.c
+++ b/utils.c
@@ -2110,3 +2110,51 @@ int lookup_ino_rootid(int fd, u64 *rootid)
 
 	return 0;
 }
+
+int find_mount_root(const char *path, char **mount_root)
+{
+	FILE *mnttab;
+	int fd;
+	struct mntent *ent;
+	int len;
+	int ret;
+	int longest_matchlen = 0;
+	char *longest_match = NULL;
+
+	fd = open(path, O_RDONLY | O_NOATIME);
+	if (fd < 0)
+		return -errno;
+	close(fd);
+
+	mnttab = setmntent("/proc/self/mounts", "r");
+	if (!mnttab)
+		return -errno;
+
+	while ((ent = getmntent(mnttab))) {
+		len = strlen(ent->mnt_dir);
+		if (strncmp(ent->mnt_dir, path, len) == 0) {
+			/* match found */
+			if (longest_matchlen < len) {
+				free(longest_match);
+				longest_matchlen = len;
+				longest_match = strdup(ent->mnt_dir);
+			}
+		}
+	}
+	endmntent(mnttab);
+
+	if (!longest_match) {
+		fprintf(stderr,
+			"ERROR: Failed to find mount root for path %s.\n",
+			path);
+		return -ENOENT;
+	}
+
+	ret = 0;
+	*mount_root = realpath(longest_match, NULL);
+	if (!*mount_root)
+		ret = -errno;
+
+	free(longest_match);
+	return ret;
+}
diff --git a/utils.h b/utils.h
index 512c51b..e074732 100644
--- a/utils.h
+++ b/utils.h
@@ -96,5 +96,6 @@ int ask_user(char *question);
 int lookup_ino_rootid(int fd, u64 *rootid);
 int btrfs_scan_lblkid(int update_kernel);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
+int find_mount_root(const char *path, char **mount_root);
 
 #endif
-- 
1.8.5.4

