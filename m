Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51131 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756510AbaJ3CqN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 22:46:13 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9U2k3Ax032455
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 10:46:03 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: make the search target device routine more clear for fi show
Date: Thu, 30 Oct 2014 10:44:49 +0800
Message-ID: <1414637090-4476-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Extract the procedure of searching for a target device for fi show
from the @map_seed_devices() function to make it more clear.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index bb5881e..6437e57 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -742,14 +742,10 @@ static int find_and_copy_seed(struct btrfs_fs_devices *seed,
 	return 1;
 }
 
-static int map_seed_devices(struct list_head *all_uuids,
-			    char *search, int *found)
+static int search_umounted_fs_uuids(struct list_head *all_uuids,
+				    char *search)
 {
-	struct btrfs_fs_devices *cur_fs, *cur_seed;
-	struct btrfs_fs_devices *fs_copy, *seed_copy;
-	struct btrfs_fs_devices *opened_fs;
-	struct btrfs_device *device;
-	struct btrfs_fs_info *fs_info;
+	struct btrfs_fs_devices *cur_fs, *fs_copy;
 	struct list_head *fs_uuids;
 	int ret = 0;
 
@@ -764,7 +760,7 @@ static int map_seed_devices(struct list_head *all_uuids,
 		if (search) {
 			if (uuid_search(cur_fs, search) == 0)
 				continue;
-			*found = 1;
+			ret = 1;
 		}
 
 		fs_copy = malloc(sizeof(*fs_copy));
@@ -782,6 +778,22 @@ static int map_seed_devices(struct list_head *all_uuids,
 		list_add(&fs_copy->list, all_uuids);
 	}
 
+out:
+	return ret;
+}
+
+static int map_seed_devices(struct list_head *all_uuids)
+{
+	struct btrfs_fs_devices *cur_fs, *cur_seed;
+	struct btrfs_fs_devices *seed_copy;
+	struct btrfs_fs_devices *opened_fs;
+	struct btrfs_device *device;
+	struct btrfs_fs_info *fs_info;
+	struct list_head *fs_uuids;
+	int ret = 0;
+
+	fs_uuids = btrfs_scanned_uuids();
+
 	list_for_each_entry(cur_fs, all_uuids, list) {
 		device = list_first_entry(&cur_fs->devices,
 						struct btrfs_device, dev_list);
@@ -943,11 +955,18 @@ devs_only:
 		return 1;
 	}
 
+	found = search_umounted_fs_uuids(&all_uuids, search);
+	if (found < 0) {
+		fprintf(stderr,
+			"ERROR: %d while searching target device\n", ret);
+		return 1;
+	}
+
 	/*
 	 * scan_for_btrfs() don't build seed/sprout mapping,
 	 * do mapping build for each scanned fs here
 	 */
-	ret = map_seed_devices(&all_uuids, search, &found);
+	ret = map_seed_devices(&all_uuids);
 	if (ret) {
 		fprintf(stderr,
 			"ERROR: %d while mapping seed devices\n", ret);
-- 
1.8.1.4

