Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:47073 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753071AbcLMXwx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 18:52:53 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id uBDNqoZI015659
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Dec 2016 23:52:50 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] Btrfs: fix lockdep warning about log_mutex
Date: Tue, 13 Dec 2016 15:59:29 -0800
Message-Id: <1481673569-31042-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1480628704-18216-1-git-send-email-bo.li.liu@oracle.com>
References: <1480628704-18216-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While checking INODE_REF/INODE_EXTREF for a corner case, we may acquire a
different inode's log_mutex with holding the current inode's log_mutex, and
lockdep has complained this with a possilble deadlock warning.

Fix this by using mutex_lock_nested() when processing the other inode's
log_mutex.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Use SINGLE_DEPTH_NESTING to avoid magic number.

 fs/btrfs/tree-log.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3d33c4e..298ab3b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -37,6 +37,7 @@
  */
 #define LOG_INODE_ALL 0
 #define LOG_INODE_EXISTS 1
+#define LOG_OTHER_INODE 2
 
 /*
  * directory trouble cases
@@ -4624,7 +4625,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	if (S_ISDIR(inode->i_mode) ||
 	    (!test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
 		       &BTRFS_I(inode)->runtime_flags) &&
-	     inode_only == LOG_INODE_EXISTS))
+	     inode_only >= LOG_INODE_EXISTS))
 		max_key.type = BTRFS_XATTR_ITEM_KEY;
 	else
 		max_key.type = (u8)-1;
@@ -4648,7 +4649,13 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	mutex_lock(&BTRFS_I(inode)->log_mutex);
+	if (inode_only == LOG_OTHER_INODE) {
+		inode_only = LOG_INODE_EXISTS;
+		mutex_lock_nested(&BTRFS_I(inode)->log_mutex,
+				  SINGLE_DEPTH_NESTING);
+	} else {
+		mutex_lock(&BTRFS_I(inode)->log_mutex);
+	}
 
 	/*
 	 * a brute force approach to making sure we get the most uptodate
@@ -4800,7 +4807,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 				 * unpin it.
 				 */
 				err = btrfs_log_inode(trans, root, other_inode,
-						      LOG_INODE_EXISTS,
+						      LOG_OTHER_INODE,
 						      0, LLONG_MAX, ctx);
 				iput(other_inode);
 				if (err)
-- 
2.5.5

