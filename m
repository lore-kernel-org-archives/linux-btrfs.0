From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] fix definition of struct btrfs_extent_inline_ref
Date: Wed, 15 Jul 2009 15:33:39 +0800
Message-ID: <4A5D8653.2070808@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

use __le64 instead of u64 in on-disk structure definition.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.h 2/fs/btrfs/ctree.h
--- 1/fs/btrfs/ctree.h	2009-07-03 08:08:34.148847040 +0800
+++ 2/fs/btrfs/ctree.h	2009-07-15 14:59:31.779493061 +0800
@@ -483,7 +483,7 @@ struct btrfs_shared_data_ref {
 
 struct btrfs_extent_inline_ref {
 	u8 type;
-	u64 offset;
+	__le64 offset;
 } __attribute__ ((__packed__));
 
 /* old style backrefs item */
