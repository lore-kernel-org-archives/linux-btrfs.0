Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:29757 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbeEKH1f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:27:35 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 9442CAC01DC
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:29 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id B263632881B
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:28 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 02/11] btrfs-progs: libbtrfsutil: Factor out btrfs_util_subvolume_info_fd()
Date: Fri, 11 May 2018 16:29:40 +0900
Message-ID: <20180511072949.15269-3-misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
References: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Factor out main logic of btrfs_util_subvolume_info_fd().
This is a preparation work to relax the root privilege of this function.

No functional change happens.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 libbtrfsutil/subvolume.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 867b3e10..0d7ef5bf 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -295,8 +295,8 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_info(const char *path,
 	return err;
 }
 
-PUBLIC enum btrfs_util_error btrfs_util_subvolume_info_fd(int fd, uint64_t id,
-							  struct btrfs_util_subvolume_info *subvol)
+static enum btrfs_util_error get_subvolume_info_root(int fd, uint64_t id,
+						     struct btrfs_util_subvolume_info *subvol)
 {
 	struct btrfs_ioctl_search_args search = {
 		.key = {
@@ -310,27 +310,10 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_info_fd(int fd, uint64_t id,
 			.nr_items = 0,
 		},
 	};
-	enum btrfs_util_error err;
 	size_t items_pos = 0, buf_off = 0;
 	bool need_root_item = true, need_root_backref = true;
 	int ret;
 
-	if (id == 0) {
-		err = btrfs_util_is_subvolume_fd(fd);
-		if (err)
-			return err;
-
-		err = btrfs_util_subvolume_id_fd(fd, &id);
-		if (err)
-			return err;
-	}
-
-	if ((id < BTRFS_FIRST_FREE_OBJECTID && id != BTRFS_FS_TREE_OBJECTID) ||
-	    id > BTRFS_LAST_FREE_OBJECTID) {
-		errno = ENOENT;
-		return BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND;
-	}
-
 	search.key.min_objectid = search.key.max_objectid = id;
 
 	if (subvol) {
@@ -400,6 +383,30 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_info_fd(int fd, uint64_t id,
 	return BTRFS_UTIL_OK;
 }
 
+PUBLIC enum btrfs_util_error btrfs_util_subvolume_info_fd(int fd, uint64_t id,
+							  struct btrfs_util_subvolume_info *subvol)
+{
+	enum btrfs_util_error err;
+
+	if (id == 0) {
+		err = btrfs_util_is_subvolume_fd(fd);
+		if (err)
+			return err;
+
+		err = btrfs_util_subvolume_id_fd(fd, &id);
+		if (err)
+			return err;
+	}
+
+	if ((id < BTRFS_FIRST_FREE_OBJECTID && id != BTRFS_FS_TREE_OBJECTID) ||
+	    id > BTRFS_LAST_FREE_OBJECTID) {
+		errno = ENOENT;
+		return BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND;
+	}
+
+	return get_subvolume_info_root(fd, id, subvol);
+}
+
 PUBLIC enum btrfs_util_error btrfs_util_get_subvolume_read_only_fd(int fd,
 								   bool *read_only_ret)
 {
-- 
2.14.3


