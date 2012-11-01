Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26475 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab2KAHfC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 03:35:02 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qA17Z0RG031302
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 15:35:00 +0800
Message-ID: <5092263B.7070500@cn.fujitsu.com>
Date: Thu, 01 Nov 2012 15:35:23 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] Btrfs: fix missing log when BTRFS_INODE_NEEDS_FULL_SYNC
 is set
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we set BTRFS_INODE_NEEDS_FULL_SYNC, we should log all the extent,
but now we forget to take it into account, and set a wrong max key,
if so, we will skip the file extent metadata when doing logging. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f7e9387..c495b47 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3394,7 +3394,10 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 
 	/* today the code can only do partial logging of directories */
-	if (inode_only == LOG_INODE_EXISTS || S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode) ||
+	    (!test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+		       &BTRFS_I(inode)->runtime_flags) &&
+	     inode_only == LOG_INODE_EXISTS))
 		max_key.type = BTRFS_XATTR_ITEM_KEY;
 	else
 		max_key.type = (u8)-1;
-- 
1.7.6.5
