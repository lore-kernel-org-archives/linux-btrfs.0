Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:31627 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754461AbdI0CCb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 22:02:31 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 0EDCFAC014C
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 11:02:23 +0900 (JST)
Received: from g01jpexchyt35.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 2E3B16D67D2
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 11:02:22 +0900 (JST)
Subject: [PATCH v2 3/5] btrfs-progs: move seen_fsid to util.c
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <7610069d-bd81-2239-0be8-6635478c2dda@jp.fujitsu.com>
Message-ID: <5918ee68-eb55-cbfb-8dd6-7686c81db857@jp.fujitsu.com>
Date: Wed, 27 Sep 2017 11:02:19 +0900
MIME-Version: 1.0
In-Reply-To: <7610069d-bd81-2239-0be8-6635478c2dda@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make is_seen_fsid()/add_seen_fsid()/free_seen_fsid() to common functions.
This will be used for 'subvol delete --commit-after'.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 cmds-filesystem.c | 88 ++++---------------------------------------------------
 utils.c           | 70 +++++++++++++++++++++++++++++++++++++++++++
 utils.h           | 11 +++++++
 3 files changed, 86 insertions(+), 83 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 018857c..c7dae40 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -30,7 +30,6 @@
 
 #include "kerncompat.h"
 #include "ctree.h"
-#include "ioctl.h"
 #include "utils.h"
 #include "volumes.h"
 #include "commands.h"
@@ -43,85 +42,8 @@
  * for btrfs fi show, we maintain a hash of fsids we've already printed.
  * This way we don't print dups if a given FS is mounted more than once.
  */
-#define SEEN_FSID_HASH_SIZE 256
-
-struct seen_fsid {
-	u8 fsid[BTRFS_FSID_SIZE];
-	struct seen_fsid *next;
-};
-
 static struct seen_fsid *seen_fsid_hash[SEEN_FSID_HASH_SIZE] = {NULL,};
 
-static int is_seen_fsid(u8 *fsid)
-{
-	u8 hash = fsid[0];
-	int slot = hash % SEEN_FSID_HASH_SIZE;
-	struct seen_fsid *seen = seen_fsid_hash[slot];
-
-	while (seen) {
-		if (memcmp(seen->fsid, fsid, BTRFS_FSID_SIZE) == 0)
-			return 1;
-
-		seen = seen->next;
-	}
-
-	return 0;
-}
-
-static int add_seen_fsid(u8 *fsid)
-{
-	u8 hash = fsid[0];
-	int slot = hash % SEEN_FSID_HASH_SIZE;
-	struct seen_fsid *seen = seen_fsid_hash[slot];
-	struct seen_fsid *alloc;
-
-	if (!seen)
-		goto insert;
-
-	while (1) {
-		if (memcmp(seen->fsid, fsid, BTRFS_FSID_SIZE) == 0)
-			return -EEXIST;
-
-		if (!seen->next)
-			break;
-
-		seen = seen->next;
-	}
-
-insert:
-
-	alloc = malloc(sizeof(*alloc));
-	if (!alloc)
-		return -ENOMEM;
-
-	alloc->next = NULL;
-	memcpy(alloc->fsid, fsid, BTRFS_FSID_SIZE);
-
-	if (seen)
-		seen->next = alloc;
-	else
-		seen_fsid_hash[slot] = alloc;
-
-	return 0;
-}
-
-static void free_seen_fsid(void)
-{
-	int slot;
-	struct seen_fsid *seen;
-	struct seen_fsid *next;
-
-	for (slot = 0; slot < SEEN_FSID_HASH_SIZE; slot++) {
-		seen = seen_fsid_hash[slot];
-		while (seen) {
-			next = seen->next;
-			free(seen);
-			seen = next;
-		}
-		seen_fsid_hash[slot] = NULL;
-	}
-}
-
 static const char * const filesystem_cmd_group_usage[] = {
 	"btrfs filesystem [<group>] <command> [<args>]",
 	NULL
@@ -355,7 +277,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices,
 	u64 devs_found = 0;
 	u64 total;
 
-	if (add_seen_fsid(fs_devices->fsid))
+	if (add_seen_fsid(fs_devices->fsid, seen_fsid_hash))
 		return;
 
 	uuid_unparse(fs_devices->fsid, uuidbuf);
@@ -402,7 +324,7 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
 	int ret;
 
-	ret = add_seen_fsid(fs_info->fsid);
+	ret = add_seen_fsid(fs_info->fsid, seen_fsid_hash);
 	if (ret == -EEXIST)
 		return 0;
 	else if (ret)
@@ -474,7 +396,7 @@ static int btrfs_scan_kernel(void *search, unsigned unit_mode)
 			goto out;
 
 		/* skip all fs already shown as mounted fs */
-		if (is_seen_fsid(fs_info_arg.fsid))
+		if (is_seen_fsid(fs_info_arg.fsid, seen_fsid_hash))
 			continue;
 
 		ret = get_label_mounted(mnt->mnt_dir, label);
@@ -676,7 +598,7 @@ static int search_umounted_fs_uuids(struct list_head *all_uuids,
 		}
 
 		/* skip all fs already shown as mounted fs */
-		if (is_seen_fsid(cur_fs->fsid))
+		if (is_seen_fsid(cur_fs->fsid, seen_fsid_hash))
 			continue;
 
 		fs_copy = calloc(1, sizeof(*fs_copy));
@@ -908,7 +830,7 @@ devs_only:
 		free_fs_devices(fs_devices);
 	}
 out:
-	free_seen_fsid();
+	free_seen_fsid(seen_fsid_hash);
 	return ret;
 }
 
diff --git a/utils.c b/utils.c
index 4a5dc60..f91d41e 100644
--- a/utils.c
+++ b/utils.c
@@ -1788,6 +1788,76 @@ out:
 	return ret;
 }
 
+int is_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[])
+{
+	u8 hash = fsid[0];
+	int slot = hash % SEEN_FSID_HASH_SIZE;
+	struct seen_fsid *seen = seen_fsid_hash[slot];
+
+	while (seen) {
+		if (memcmp(seen->fsid, fsid, BTRFS_FSID_SIZE) == 0)
+			return 1;
+
+		seen = seen->next;
+	}
+
+	return 0;
+}
+
+int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[])
+{
+	u8 hash = fsid[0];
+	int slot = hash % SEEN_FSID_HASH_SIZE;
+	struct seen_fsid *seen = seen_fsid_hash[slot];
+	struct seen_fsid *alloc;
+
+	if (!seen)
+		goto insert;
+
+	while (1) {
+		if (memcmp(seen->fsid, fsid, BTRFS_FSID_SIZE) == 0)
+			return -EEXIST;
+
+		if (!seen->next)
+			break;
+
+		seen = seen->next;
+	}
+
+insert:
+
+	alloc = malloc(sizeof(*alloc));
+	if (!alloc)
+		return -ENOMEM;
+
+	alloc->next = NULL;
+	memcpy(alloc->fsid, fsid, BTRFS_FSID_SIZE);
+
+	if (seen)
+		seen->next = alloc;
+	else
+		seen_fsid_hash[slot] = alloc;
+
+	return 0;
+}
+
+void free_seen_fsid(struct seen_fsid *seen_fsid_hash[])
+{
+	int slot;
+	struct seen_fsid *seen;
+	struct seen_fsid *next;
+
+	for (slot = 0; slot < SEEN_FSID_HASH_SIZE; slot++) {
+		seen = seen_fsid_hash[slot];
+		while (seen) {
+			next = seen->next;
+			free(seen);
+			seen = next;
+		}
+		seen_fsid_hash[slot] = NULL;
+	}
+}
+
 
 static int group_profile_devs_min(u64 flag)
 {
diff --git a/utils.h b/utils.h
index b3aabe1..da34e6c 100644
--- a/utils.h
+++ b/utils.h
@@ -28,6 +28,7 @@
 #include "btrfs-list.h"
 #include "sizes.h"
 #include "messages.h"
+#include "ioctl.h"
 
 #define BTRFS_SCAN_MOUNTED	(1ULL << 0)
 #define BTRFS_SCAN_LBLKID	(1ULL << 1)
@@ -101,6 +102,16 @@ void close_file_or_dir(int fd, DIR *dirstream);
 int get_fs_info(const char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		struct btrfs_ioctl_dev_info_args **di_ret);
 int get_fsid(const char *path, u8 *fsid, int silent);
+
+#define SEEN_FSID_HASH_SIZE 256
+struct seen_fsid {
+	u8 fsid[BTRFS_FSID_SIZE];
+	struct seen_fsid *next;
+};
+int is_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[]);
+int add_seen_fsid(u8 *fsid, struct seen_fsid *seen_fsid_hash[]);
+void free_seen_fsid(struct seen_fsid *seen_fsid_hash[]);
+
 int get_label(const char *btrfs_dev, char *label);
 int set_label(const char *btrfs_dev, const char *label);
 
-- 
2.9.5

