Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbcDAUOj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 16:14:39 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 80462AC28
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Apr 2016 20:14:37 +0000 (UTC)
From: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/8] btrfs: uapi/linux/btrfs.h migration, qgroup limit flags
Date: Fri,  1 Apr 2016 16:14:24 -0400
Message-Id: <1459541670-4097-3-git-send-email-jeffm@suse.com>
In-Reply-To: <1459541670-4097-1-git-send-email-jeffm@suse.com>
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The BTRFS_QGROUP_LIMIT_* flags are required to tell the kernel which
fields are valid when using the BTRFS_IOC_QGROUP_LIMIT ioctl.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h           |  8 --------
 include/uapi/linux/btrfs.h | 22 +++++++++++++++++++++-
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3beaa24..c228b39 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1154,14 +1154,6 @@ struct btrfs_qgroup_info_item {
 	__le64 excl_cmpr;
 } __attribute__ ((__packed__));
 
-/* flags definition for qgroup limits */
-#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0)
-#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1)
-#define BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2)
-#define BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3)
-#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4)
-#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5)
-
 struct btrfs_qgroup_limit_item {
 	/*
 	 * only updated when any of the other values change
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 11eee34..9651af3 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -41,7 +41,19 @@ struct btrfs_ioctl_vol_args {
 #define BTRFS_UUID_SIZE 16
 #define BTRFS_UUID_UNPARSED_SIZE	37
 
-#define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
+/*
+ * flags definition for qgroup limits
+ *
+ * Used by:
+ * struct btrfs_qgroup_limit.flags
+ * struct btrfs_qgroup_limit_item.flags
+ */
+#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0)
+#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1)
+#define BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2)
+#define BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3)
+#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4)
+#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5)
 
 struct btrfs_qgroup_limit {
 	__u64	flags;
@@ -51,6 +63,14 @@ struct btrfs_qgroup_limit {
 	__u64	rsv_excl;
 };
 
+/*
+ * flags definition for qgroup inheritance
+ *
+ * Used by:
+ * struct btrfs_qgroup_inherit.flags
+ */
+#define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
+
 struct btrfs_qgroup_inherit {
 	__u64	flags;
 	__u64	num_qgroups;
-- 
2.7.1

