Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51686 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2KTJRW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Nov 2012 04:17:22 -0500
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: yan@linux.vnet.ibm.com, Zheng Liu <wenqing.lz@taobao.com>
Subject: [PATCH 3/4][RFC] btrfs: remove duplicated check from btrfs_fallocate
Date: Tue, 20 Nov 2012 17:29:44 +0800
Message-Id: <1353403785-3489-4-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
References: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Remove a sanity check from btrfs_fallocate because vfs has already checked it.

Reported-by: Guo Chao <yan@linux.vnet.ibm.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/btrfs/file.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9ab1bed..fd260a0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1999,10 +1999,6 @@ static long btrfs_fallocate(struct file *file, int mode,
 	alloc_start = offset & ~mask;
 	alloc_end =  (offset + len + mask) & ~mask;
 
-	/* Make sure we aren't being give some crap mode */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
-		return -EOPNOTSUPP;
-
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		return btrfs_punch_hole(inode, offset, len);
 
-- 
1.7.12.rc2.18.g61b472e

