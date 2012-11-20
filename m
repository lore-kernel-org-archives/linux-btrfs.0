Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40222 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2KTJRQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Nov 2012 04:17:16 -0500
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: yan@linux.vnet.ibm.com, Zheng Liu <wenqing.lz@taobao.com>
Subject: [PATCH 1/4][RFC] ext4: remove duplicated check from ext4_fallocate
Date: Tue, 20 Nov 2012 17:29:42 +0800
Message-Id: <1353403785-3489-2-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
References: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Remove a sanity check from ext4_fallocate because vfs has already checked it.

Reported-by: Guo Chao <yan@linux.vnet.ibm.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7011ac9..c2eb409 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4427,10 +4427,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		return -EOPNOTSUPP;
 
-	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
-		return -EOPNOTSUPP;
-
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		return ext4_punch_hole(file, offset, len);
 
-- 
1.7.12.rc2.18.g61b472e

