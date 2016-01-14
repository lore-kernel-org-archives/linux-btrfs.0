Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60958 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752140AbcANGAP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 01:00:15 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 1022641896DC
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 13:59:47 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v4 16/18] btrfs: dedup: add an inode nodedup flag
Date: Thu, 14 Jan 2016 13:57:32 +0800
Message-ID: <1452751054-2365-17-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index a68e23d..ddc6ff2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2400,6 +2400,7 @@ do {                                                                   \
 #define BTRFS_INODE_NOATIME		(1 << 9)
 #define BTRFS_INODE_DIRSYNC		(1 << 10)
 #define BTRFS_INODE_COMPRESS		(1 << 11)
+#define BTRFS_INODE_NODEDUP		(1 << 12)
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c18be18..32c3aa2 100644
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



