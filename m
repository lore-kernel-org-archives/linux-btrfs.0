Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2FNIQA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 04:16:00 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <chris.mason@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 02/10] Btrfs: fix missing inherited flag in rename
Date: Thu, 14 Jun 2012 16:23:18 +0800
Message-Id: <1339662206-5307-3-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we move a file into a directory with compression flag, we need to
inherite BTRFS_INODE_COMPRESS and clear BTRFS_INODE_NOCOMPRESS as well.
But if we move a file into a directory without compression flag, we need
to clear both of them.

It is the way how our setflags deals with compression flag, so keep
the same behaviour here.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 92df0a5..bc66330 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7082,10 +7082,13 @@ static void fixup_inode_flags(struct inode *dir, struct inode *inode)
 	else
 		b_inode->flags &= ~BTRFS_INODE_NODATACOW;
 
-	if (b_dir->flags & BTRFS_INODE_COMPRESS)
+	if (b_dir->flags & BTRFS_INODE_COMPRESS) {
 		b_inode->flags |= BTRFS_INODE_COMPRESS;
-	else
-		b_inode->flags &= ~BTRFS_INODE_COMPRESS;
+		b_inode->flags &= ~BTRFS_INODE_NOCOMPRESS;
+	} else {
+		b_inode->flags &= ~(BTRFS_INODE_COMPRESS |
+				    BTRFS_INODE_NOCOMPRESS);
+	}
 }
 
 static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-- 
1.6.5.2

