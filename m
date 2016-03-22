Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758099AbcCVBiv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:51 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 16/27] btrfs: dedupe: add an inode nodedupe flag
Date: Tue, 22 Mar 2016 09:35:41 +0800
Message-Id: <1458610552-9845-17-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce BTRFS_INODE_NODEDUP flag, then we can explicitly disable
online data dedupelication for specified files.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h | 1 +
 fs/btrfs/ioctl.c | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bed9273..b19c1f1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2428,6 +2428,7 @@ do {                                                                   \
 #define BTRFS_INODE_NOATIME		(1 << 9)
 #define BTRFS_INODE_DIRSYNC		(1 << 10)
 #define BTRFS_INODE_COMPRESS		(1 << 11)
+#define BTRFS_INODE_NODEDUPE		(1 << 12)
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 49bca5f..3c226b0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -161,7 +161,8 @@ void btrfs_update_iflags(struct inode *inode)
 /*
  * Inherit flags from the parent inode.
  *
- * Currently only the compression flags and the cow flags are inherited.
+ * Currently only the compression flags, dedupe flags and the cow flags
+ * are inherited.
  */
 void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 {
@@ -186,6 +187,9 @@ void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
 	}
 
+	if (flags & BTRFS_INODE_NODEDUPE)
+		BTRFS_I(inode)->flags |= BTRFS_INODE_NODEDUPE;
+
 	btrfs_update_iflags(inode);
 }
 
-- 
2.7.3



