Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:28189 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968189AbeFRIiN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:13 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 3FA38AC00EA
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:09 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 5EF36BD6705
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:08 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 04/20] btrfs-porgs: libbtrfsutil: Relax the privileges of util_subvolume_info()
Date: Mon, 18 Jun 2018 17:40:52 +0900
Message-ID: <880ea64b797fd93f12c64116416d92f6e0d9778b.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit relaxes the privileges of util_subvolume_info() if kernel
supports new ioctl (BTRFS_IOC_GET_SUBVOL_INFO) and @id is zero
(i.e. when getting the information of the given path/fd).
For older kernel (< 4.18), the behavior is the same.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 libbtrfsutil/btrfsutil.h |  7 +++++-
 libbtrfsutil/errors.c    |  4 ++++
 libbtrfsutil/subvolume.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 6d655f49..3f21d163 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -63,6 +63,8 @@ enum btrfs_util_error {
 	BTRFS_UTIL_ERROR_SYNC_FAILED,
 	BTRFS_UTIL_ERROR_START_SYNC_FAILED,
 	BTRFS_UTIL_ERROR_WAIT_SYNC_FAILED,
+	BTRFS_UTIL_ERROR_INVALID_ARGUMENT_FOR_USER,
+	BTRFS_UTIL_ERROR_GET_SUBVOL_INFO_FAILED,
 };
 
 /**
@@ -266,7 +268,10 @@ struct btrfs_util_subvolume_info {
  * to check whether the subvolume exists; %BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND
  * will be returned if it does not.
  *
- * This requires appropriate privilege (CAP_SYS_ADMIN).
+ * This requires appropriate privilege (CAP_SYS_ADMIN) for kernel < 4.18.
+ * From kernel >= 4.18 which supports BTRFS_IOC_GET_SUGBVOL_INFO,
+ * non-privileged user with appropriate permission for @path can use this too
+ * (in that case @id must be zero).
  *
  * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
  */
diff --git a/libbtrfsutil/errors.c b/libbtrfsutil/errors.c
index 634edc65..f196fa71 100644
--- a/libbtrfsutil/errors.c
+++ b/libbtrfsutil/errors.c
@@ -45,6 +45,10 @@ static const char * const error_messages[] = {
 	[BTRFS_UTIL_ERROR_SYNC_FAILED] = "Could not sync filesystem",
 	[BTRFS_UTIL_ERROR_START_SYNC_FAILED] = "Could not start filesystem sync",
 	[BTRFS_UTIL_ERROR_WAIT_SYNC_FAILED] = "Could not wait for filesystem sync",
+	[BTRFS_UTIL_ERROR_INVALID_ARGUMENT_FOR_USER] =
+		"Non-root user cannot specify subvolume id",
+	[BTRFS_UTIL_ERROR_GET_SUBVOL_INFO_FAILED] =
+	"Could not get subvolume information by BTRFS_IOC_GET_SUBVOL_INFO",
 };
 
 PUBLIC const char *btrfs_util_strerror(enum btrfs_util_error err)
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 0d7ef5bf..e94c7079 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -31,6 +31,14 @@
 
 #include "btrfsutil_internal.h"
 
+static bool is_root(void)
+{
+	uid_t uid;
+
+	uid = geteuid();
+	return (uid == 0);
+}
+
 /*
  * This intentionally duplicates btrfs_util_is_subvolume_fd() instead of opening
  * a file descriptor and calling it, because fstat() and fstatfs() don't accept
@@ -383,11 +391,61 @@ static enum btrfs_util_error get_subvolume_info_root(int fd, uint64_t id,
 	return BTRFS_UTIL_OK;
 }
 
+static enum btrfs_util_error get_subvolume_info_user(int fd,
+						     struct btrfs_util_subvolume_info *subvol)
+{
+	struct btrfs_ioctl_get_subvol_info_args info;
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_GET_SUBVOL_INFO, &info);
+	if (ret < 0)
+		return BTRFS_UTIL_ERROR_GET_SUBVOL_INFO_FAILED;
+
+	subvol->id = info.treeid;
+	subvol->parent_id = info.parent_id;
+	subvol->dir_id = info.dirid;
+	subvol->flags = info.flags;
+	subvol->generation = info.generation;
+
+	memcpy(subvol->uuid, info.uuid, sizeof(subvol->uuid));
+	memcpy(subvol->parent_uuid, info.parent_uuid,
+			sizeof(subvol->parent_uuid));
+	memcpy(subvol->received_uuid, info.received_uuid,
+			sizeof(subvol->received_uuid));
+
+	subvol->ctransid = info.ctransid;
+	subvol->otransid = info.otransid;
+	subvol->stransid = info.stransid;
+	subvol->rtransid = info.rtransid;
+
+	subvol->ctime.tv_sec  = info.ctime.sec;
+	subvol->ctime.tv_nsec = info.ctime.nsec;
+	subvol->otime.tv_sec  = info.otime.sec;
+	subvol->otime.tv_nsec = info.otime.nsec;
+	subvol->stime.tv_sec  = info.stime.sec;
+	subvol->stime.tv_nsec = info.stime.nsec;
+	subvol->rtime.tv_sec  = info.rtime.sec;
+	subvol->rtime.tv_nsec = info.rtime.nsec;
+
+	return BTRFS_UTIL_OK;
+}
+
 PUBLIC enum btrfs_util_error btrfs_util_subvolume_info_fd(int fd, uint64_t id,
 							  struct btrfs_util_subvolume_info *subvol)
 {
 	enum btrfs_util_error err;
 
+	if (!is_root()) {
+		if (id != 0)
+			return BTRFS_UTIL_ERROR_INVALID_ARGUMENT_FOR_USER;
+
+		err = btrfs_util_is_subvolume_fd(fd);
+		if (err)
+			return err;
+
+		return get_subvolume_info_user(fd, subvol);
+	}
+
 	if (id == 0) {
 		err = btrfs_util_is_subvolume_fd(fd);
 		if (err)
-- 
2.14.4


