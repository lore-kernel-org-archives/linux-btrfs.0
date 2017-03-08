Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:44888 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752177AbdCHSJP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Mar 2017 13:09:15 -0500
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: [PATCH] Btrfs: consistent usage of types in balance_args
Date: Wed,  8 Mar 2017 18:58:43 +0100
Message-Id: <20170308175843.4502-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs_balance_args are only used for the balance ioctl, so use __u
instead of __le here for consistency. The __le usage was introduced in
bc3094673f22d and dee32d0ac3719 and was probably a result of
copy/pasting when the code was written.

The usage of __le did not break anything, but it's unnecessary. Also,
this change makes the code less confusing for the careful reader.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---
 include/uapi/linux/btrfs.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index db4c253f8011..25122ed27718 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -291,10 +291,10 @@ struct btrfs_ioctl_feature_flags {
 struct btrfs_balance_args {
 	__u64 profiles;
 	union {
-		__le64 usage;
+		__u64 usage;
 		struct {
-			__le32 usage_min;
-			__le32 usage_max;
+			__u32 usage_min;
+			__u32 usage_max;
 		};
 	};
 	__u64 devid;
@@ -324,8 +324,8 @@ struct btrfs_balance_args {
 	 * Process chunks that cross stripes_min..stripes_max devices,
 	 * BTRFS_BALANCE_ARGS_STRIPES_RANGE
 	 */
-	__le32 stripes_min;
-	__le32 stripes_max;
+	__u32 stripes_min;
+	__u32 stripes_max;
 
 	__u64 unused[6];
 } __attribute__ ((__packed__));
-- 
2.11.0

