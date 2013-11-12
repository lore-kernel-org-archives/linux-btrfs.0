Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36115 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab3KLV1j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 16:27:39 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id B79137C06B3
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 14:27:38 -0700 (MST)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id VXiDG8vOZrLpaJD8 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 14:27:38 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make sure to copy everything if we rename
Date: Tue, 12 Nov 2013 16:27:35 -0500
Message-ID: <1384291655-5049-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we rename a file that is already in the log and we fsync again we will lose
the new name.  This is because we just log the inode update and not the new ref.
To fix this we just need to check if we are logging the new name of the inode
and copy all the metadata instead of just updating the inode itself.  With this
patch my testcase now passes.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index b985a3f..ba1c685 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3843,7 +3843,8 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			ret = btrfs_truncate_inode_items(trans, log,
 							 inode, 0, 0);
 		} else if (test_and_clear_bit(BTRFS_INODE_COPY_EVERYTHING,
-					      &BTRFS_I(inode)->runtime_flags)) {
+					      &BTRFS_I(inode)->runtime_flags) ||
+			   inode_only == LOG_INODE_EXISTS) {
 			if (inode_only == LOG_INODE_ALL)
 				fast_search = true;
 			max_key.type = BTRFS_XATTR_ITEM_KEY;
-- 
1.8.3.1

