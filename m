Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbcDAUOj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 16:14:39 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 84666AC34
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Apr 2016 20:14:37 +0000 (UTC)
From: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 4/8] btrfs: uapi/linux/btrfs.h migration, move feature flags
Date: Fri,  1 Apr 2016 16:14:26 -0400
Message-Id: <1459541670-4097-5-git-send-email-jeffm@suse.com>
In-Reply-To: <1459541670-4097-1-git-send-email-jeffm@suse.com>
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The compat/compat_ro/incompat feature flags are used by the feature set/get
ioctls.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h           | 25 -------------------------
 include/uapi/linux/btrfs.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c228b39..378482c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -506,31 +506,6 @@ struct btrfs_super_block {
  * Compat flags that we support.  If any incompat flags are set other than the
  * ones specified below then we will fail to mount
  */
-#define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
-
-#define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
-#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
-#define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
-#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
-/*
- * some patches floated around with a second compression method
- * lets save that incompat here for when they do get in
- * Note we don't actually support it, we're just reserving the
- * number
- */
-#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZOv2	(1ULL << 4)
-
-/*
- * older kernels tried to do bigger metadata blocks, but the
- * code was pretty buggy.  Lets not let them try anymore.
- */
-#define BTRFS_FEATURE_INCOMPAT_BIG_METADATA	(1ULL << 5)
-
-#define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
-#define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
-#define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
-#define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
-
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 0316e23..de98717 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -222,6 +222,37 @@ struct btrfs_ioctl_fs_info_args {
 	__u64 reserved[122];			/* pad to 1k */
 };
 
+/*
+ * feature flags
+ *
+ * Used by:
+ * struct btrfs_ioctl_feature_flags
+ */
+#define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
+
+#define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
+#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
+#define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
+#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
+/*
+ * some patches floated around with a second compression method
+ * lets save that incompat here for when they do get in
+ * Note we don't actually support it, we're just reserving the
+ * number
+ */
+#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZOv2	(1ULL << 4)
+
+/*
+ * older kernels tried to do bigger metadata blocks, but the
+ * code was pretty buggy.  Lets not let them try anymore.
+ */
+#define BTRFS_FEATURE_INCOMPAT_BIG_METADATA	(1ULL << 5)
+
+#define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
+#define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
+#define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
+#define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
 	__u64 compat_ro_flags;
-- 
2.7.1

