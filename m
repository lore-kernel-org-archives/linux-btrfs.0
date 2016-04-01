Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbcDAUOj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 16:14:39 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 80410ABED
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Apr 2016 20:14:37 +0000 (UTC)
From: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 3/8] btrfs: uapi/linux/btrfs.h migration, document subvol flags
Date: Fri,  1 Apr 2016 16:14:25 -0400
Message-Id: <1459541670-4097-4-git-send-email-jeffm@suse.com>
In-Reply-To: <1459541670-4097-1-git-send-email-jeffm@suse.com>
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 include/uapi/linux/btrfs.h | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 9651af3..0316e23 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -34,9 +34,6 @@ struct btrfs_ioctl_vol_args {
 
 #define BTRFS_DEVICE_PATH_NAME_MAX 1024
 
-#define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
-#define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
-#define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_UUID_SIZE 16
 #define BTRFS_UUID_UNPARSED_SIZE	37
@@ -85,6 +82,20 @@ struct btrfs_ioctl_qgroup_limit_args {
 	struct btrfs_qgroup_limit lim;
 };
 
+/*
+ * flags for subvolumes
+ *
+ * Used by:
+ * struct btrfs_ioctl_vol_args_v2.flags
+ *
+ * BTRFS_SUBVOL_RDONLY is also provided/consumed by the following ioctls:
+ * - BTRFS_IOC_SUBVOL_GETFLAGS
+ * - BTRFS_IOC_SUBVOL_SETFLAGS
+ */
+#define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
+#define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
+#define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
+
 #define BTRFS_SUBVOL_NAME_MAX 4039
 struct btrfs_ioctl_vol_args_v2 {
 	__s64 fd;
-- 
2.7.1

