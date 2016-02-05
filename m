Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbcBEBYy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 20:24:54 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v6 16/19] btrfs: dedup: add an inode nodedup flag
Date: Fri,  5 Feb 2016 09:22:36 +0800
Message-Id: <1454635359-10013-17-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce BTRFS_INODE_NODEDUP flag, then we can explicitly disable
online data deduplication for specified files.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h | 1 +
 fs/btrfs/ioctl.c | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8c04920..bd68b97 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2401,6 +2401,7 @@ do {                                                                   \
 #define BTRFS_INODE_NOATIME		(1 << 9)
 #define BTRFS_INODE_DIRSYNC		(1 << 10)
 #define BTRFS_INODE_COMPRESS		(1 << 11)
+#define BTRFS_INODE_NODEDUP		(1 << 12)
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2bd1a97..0dab40c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -159,7 +159,8 @@ void btrfs_update_iflags(struct inode *inode)
 /*
  * Inherit flags from the parent inode.
  *
- * Currently only the compression flags and the cow flags are inherited.
+ * Currently only the compression flags, the dedup flags and the cow
+ * flags are inherited.
  */
 void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 {
@@ -184,6 +185,9 @@ void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
 	}
 
+	if (flags & BTRFS_INODE_NODEDUP)
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NODEDUP;
+
 	btrfs_update_iflags(inode);
 }
 
-- 
2.7.0



