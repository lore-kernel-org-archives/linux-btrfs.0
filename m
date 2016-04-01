Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbcDAUOl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 16:14:41 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B0FD6AC8F
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Apr 2016 20:14:38 +0000 (UTC)
From: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 5/8] btrfs: uapi/linux/btrfs.h migration, move balance flags
Date: Fri,  1 Apr 2016 16:14:27 -0400
Message-Id: <1459541670-4097-6-git-send-email-jeffm@suse.com>
In-Reply-To: <1459541670-4097-1-git-send-email-jeffm@suse.com>
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The BTRFS_BALANCE_* flags are used by struct btrfs_ioctl_balance_args.flags
and btrfs_ioctl_balance_args.{data,meta,sys}.flags in the BTRFS_IOC_BALANCE
ioctl.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/volumes.h         | 46 ---------------------------------
 include/uapi/linux/btrfs.h | 64 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1939ebd..144cec3 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -357,52 +357,6 @@ struct map_lookup {
 #define map_lookup_size(n) (sizeof(struct map_lookup) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
-/*
- * Restriper's general type filter
- */
-#define BTRFS_BALANCE_DATA		(1ULL << 0)
-#define BTRFS_BALANCE_SYSTEM		(1ULL << 1)
-#define BTRFS_BALANCE_METADATA		(1ULL << 2)
-
-#define BTRFS_BALANCE_TYPE_MASK		(BTRFS_BALANCE_DATA |	    \
-					 BTRFS_BALANCE_SYSTEM |	    \
-					 BTRFS_BALANCE_METADATA)
-
-#define BTRFS_BALANCE_FORCE		(1ULL << 3)
-#define BTRFS_BALANCE_RESUME		(1ULL << 4)
-
-/*
- * Balance filters
- */
-#define BTRFS_BALANCE_ARGS_PROFILES	(1ULL << 0)
-#define BTRFS_BALANCE_ARGS_USAGE	(1ULL << 1)
-#define BTRFS_BALANCE_ARGS_DEVID	(1ULL << 2)
-#define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
-#define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
-#define BTRFS_BALANCE_ARGS_LIMIT	(1ULL << 5)
-#define BTRFS_BALANCE_ARGS_LIMIT_RANGE	(1ULL << 6)
-#define BTRFS_BALANCE_ARGS_STRIPES_RANGE (1ULL << 7)
-#define BTRFS_BALANCE_ARGS_USAGE_RANGE	(1ULL << 10)
-
-#define BTRFS_BALANCE_ARGS_MASK			\
-	(BTRFS_BALANCE_ARGS_PROFILES |		\
-	 BTRFS_BALANCE_ARGS_USAGE |		\
-	 BTRFS_BALANCE_ARGS_DEVID | 		\
-	 BTRFS_BALANCE_ARGS_DRANGE |		\
-	 BTRFS_BALANCE_ARGS_VRANGE |		\
-	 BTRFS_BALANCE_ARGS_LIMIT |		\
-	 BTRFS_BALANCE_ARGS_LIMIT_RANGE |	\
-	 BTRFS_BALANCE_ARGS_STRIPES_RANGE |	\
-	 BTRFS_BALANCE_ARGS_USAGE_RANGE)
-
-/*
- * Profile changing flags.  When SOFT is set we won't relocate chunk if
- * it already has the target profile (even though it may be
- * half-filled).
- */
-#define BTRFS_BALANCE_ARGS_CONVERT	(1ULL << 8)
-#define BTRFS_BALANCE_ARGS_SOFT		(1ULL << 9)
-
 struct btrfs_balance_args;
 struct btrfs_balance_progress;
 struct btrfs_balance_control {
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index de98717..abae362 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -317,6 +317,70 @@ struct btrfs_balance_progress {
 	__u64 completed;	/* # of chunks relocated so far */
 };
 
+/*
+ * flags definition for balance
+ *
+ * Restriper's general type filter
+ *
+ * Used by:
+ * btrfs_ioctl_balance_args.flags
+ * btrfs_balance_control.flags (internal)
+ */
+#define BTRFS_BALANCE_DATA		(1ULL << 0)
+#define BTRFS_BALANCE_SYSTEM		(1ULL << 1)
+#define BTRFS_BALANCE_METADATA		(1ULL << 2)
+
+#define BTRFS_BALANCE_TYPE_MASK		(BTRFS_BALANCE_DATA |	    \
+					 BTRFS_BALANCE_SYSTEM |	    \
+					 BTRFS_BALANCE_METADATA)
+
+#define BTRFS_BALANCE_FORCE		(1ULL << 3)
+#define BTRFS_BALANCE_RESUME		(1ULL << 4)
+
+/*
+ * flags definitions for per-type balance args
+ *
+ * Balance filters
+ *
+ * Used by:
+ * struct btrfs_balance_args
+ */
+#define BTRFS_BALANCE_ARGS_PROFILES	(1ULL << 0)
+#define BTRFS_BALANCE_ARGS_USAGE	(1ULL << 1)
+#define BTRFS_BALANCE_ARGS_DEVID	(1ULL << 2)
+#define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
+#define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
+#define BTRFS_BALANCE_ARGS_LIMIT	(1ULL << 5)
+#define BTRFS_BALANCE_ARGS_LIMIT_RANGE	(1ULL << 6)
+#define BTRFS_BALANCE_ARGS_STRIPES_RANGE (1ULL << 7)
+#define BTRFS_BALANCE_ARGS_USAGE_RANGE	(1ULL << 10)
+
+#define BTRFS_BALANCE_ARGS_MASK			\
+	(BTRFS_BALANCE_ARGS_PROFILES |		\
+	 BTRFS_BALANCE_ARGS_USAGE |		\
+	 BTRFS_BALANCE_ARGS_DEVID | 		\
+	 BTRFS_BALANCE_ARGS_DRANGE |		\
+	 BTRFS_BALANCE_ARGS_VRANGE |		\
+	 BTRFS_BALANCE_ARGS_LIMIT |		\
+	 BTRFS_BALANCE_ARGS_LIMIT_RANGE |	\
+	 BTRFS_BALANCE_ARGS_STRIPES_RANGE |	\
+	 BTRFS_BALANCE_ARGS_USAGE_RANGE)
+
+/*
+ * Profile changing flags.  When SOFT is set we won't relocate chunk if
+ * it already has the target profile (even though it may be
+ * half-filled).
+ */
+#define BTRFS_BALANCE_ARGS_CONVERT	(1ULL << 8)
+#define BTRFS_BALANCE_ARGS_SOFT		(1ULL << 9)
+
+
+/*
+ * flags definition for balance state
+ *
+ * Used by:
+ * struct btrfs_ioctl_balance_args.state
+ */
 #define BTRFS_BALANCE_STATE_RUNNING	(1ULL << 0)
 #define BTRFS_BALANCE_STATE_PAUSE_REQ	(1ULL << 1)
 #define BTRFS_BALANCE_STATE_CANCEL_REQ	(1ULL << 2)
-- 
2.7.1

