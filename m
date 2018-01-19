Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:53637 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753175AbeASFhs (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:37:48 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 06/16] btrfs-progs: check: Move imode_to_type function to check/common.h
Date: Fri, 19 Jan 2018 13:37:21 +0800
Message-Id: <20180119053731.10795-7-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is shared between original and lowmem mode, and it's small
enough, so move it to check/common.h.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/common.h | 19 +++++++++++++++++++
 check/main.c   | 17 -----------------
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/check/common.h b/check/common.h
index 8d93ddbf4afb..3e0a5ebee54b 100644
--- a/check/common.h
+++ b/check/common.h
@@ -20,6 +20,8 @@
  */
 #ifndef __BTRFS_CHECK_COMMON_H__
 #define __BTRFS_CHECK_COMMON_H__
+
+#include <sys/stat.h>
 #include "ctree.h"
 
 /*
@@ -53,4 +55,21 @@ extern struct btrfs_fs_info *global_info;
 extern struct task_ctx ctx;
 extern struct cache_tree *roots_info_cache;
 
+static inline u8 imode_to_type(u32 imode)
+{
+#define S_SHIFT 12
+	static unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
+		[S_IFREG >> S_SHIFT]	= BTRFS_FT_REG_FILE,
+		[S_IFDIR >> S_SHIFT]	= BTRFS_FT_DIR,
+		[S_IFCHR >> S_SHIFT]	= BTRFS_FT_CHRDEV,
+		[S_IFBLK >> S_SHIFT]	= BTRFS_FT_BLKDEV,
+		[S_IFIFO >> S_SHIFT]	= BTRFS_FT_FIFO,
+		[S_IFSOCK >> S_SHIFT]	= BTRFS_FT_SOCK,
+		[S_IFLNK >> S_SHIFT]	= BTRFS_FT_SYMLINK,
+	};
+
+	return btrfs_type_by_mode[(imode & S_IFMT) >> S_SHIFT];
+#undef S_SHIFT
+}
+
 #endif
diff --git a/check/main.c b/check/main.c
index bb927ecc87ee..eaa8e7fbde20 100644
--- a/check/main.c
+++ b/check/main.c
@@ -425,23 +425,6 @@ static void record_root_in_trans(struct btrfs_trans_handle *trans,
 	}
 }
 
-static u8 imode_to_type(u32 imode)
-{
-#define S_SHIFT 12
-	static unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
-		[S_IFREG >> S_SHIFT]	= BTRFS_FT_REG_FILE,
-		[S_IFDIR >> S_SHIFT]	= BTRFS_FT_DIR,
-		[S_IFCHR >> S_SHIFT]	= BTRFS_FT_CHRDEV,
-		[S_IFBLK >> S_SHIFT]	= BTRFS_FT_BLKDEV,
-		[S_IFIFO >> S_SHIFT]	= BTRFS_FT_FIFO,
-		[S_IFSOCK >> S_SHIFT]	= BTRFS_FT_SOCK,
-		[S_IFLNK >> S_SHIFT]	= BTRFS_FT_SYMLINK,
-	};
-
-	return btrfs_type_by_mode[(imode & S_IFMT) >> S_SHIFT];
-#undef S_SHIFT
-}
-
 static int device_record_compare(struct rb_node *node1, struct rb_node *node2)
 {
 	struct device_record *rec1;
-- 
2.15.1

