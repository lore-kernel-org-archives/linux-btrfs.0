Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57764 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbeAYTIq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 14:08:46 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0PJ7WpD022168
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:46 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2fqkb38hws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:45 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0PJ8jrl015843
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:45 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0PJ8iOv007084
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:45 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix use-after-free on root->orphan_block_rsv
Date: Thu, 25 Jan 2018 11:02:54 -0700
Message-Id: <20180125180256.10844-7-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got these from running generic/475,

WARNING: CPU: 0 PID: 26384 at fs/btrfs/inode.c:3326 btrfs_orphan_commit_root+0x1ac/0x2b0 [btrfs]
BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: btrfs_block_rsv_release+0x1c/0x70 [btrfs]
Call Trace:
  btrfs_orphan_release_metadata+0x9f/0x200 [btrfs]
  btrfs_orphan_del+0x10d/0x170 [btrfs]
  btrfs_setattr+0x500/0x640 [btrfs]
  notify_change+0x7ae/0x870
  do_truncate+0xca/0x130
  vfs_truncate+0x2ee/0x3d0
  do_sys_truncate+0xaf/0xf0
  SyS_truncate+0xe/0x10
  entry_SYSCALL_64_fastpath+0x1f/0x96

The race is between btrfs_orphan_commit_root and btrfs_orphan_del,
        t1                                        t2
btrfs_orphan_commit_root                     btrfs_orphan_del
   spin_lock
   check (&root->orphan_inodes)
   root->orphan_block_rsv = NULL;
   spin_unlock
                                             atomic_dec(&root->orphan_inodes);
                                             access root->orphan_block_rsv

Accessing root->orphan_block_rsv must be done before decreasing
root->orphan_inodes.

cc: <stable@vger.kernel.org> v3.12+
Fixes: 703c88e03524 ("Btrfs: fix tracking of orphan inode count")
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bc6ef73..b3fe0a8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3389,6 +3389,11 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 		ret = btrfs_orphan_reserve_metadata(trans, inode);
 		ASSERT(!ret);
 		if (ret) {
+			/*
+			 * dec doesn't need spin_lock as ->orphan_block_rsv
+			 * would be released only if ->orphan_inodes is
+			 * zero.
+			 */
 			atomic_dec(&root->orphan_inodes);
 			clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 				  &inode->runtime_flags);
@@ -3403,12 +3408,17 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 	if (insert >= 1) {
 		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
 		if (ret) {
-			atomic_dec(&root->orphan_inodes);
 			if (reserve) {
 				clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 					  &inode->runtime_flags);
 				btrfs_orphan_release_metadata(inode);
 			}
+			/*
+			 * btrfs_orphan_commit_root may race with us and set
+			 * ->orphan_block_rsv to zero, in order to avoid that,
+			 * decrease ->orphan_inodes after everything is done.
+			 */
+			atomic_dec(&root->orphan_inodes);
 			if (ret != -EEXIST) {
 				clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 					  &inode->runtime_flags);
@@ -3440,28 +3450,26 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *root = inode->root;
 	int delete_item = 0;
-	int release_rsv = 0;
 	int ret = 0;
 
-	spin_lock(&root->orphan_lock);
 	if (test_and_clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 			       &inode->runtime_flags))
 		delete_item = 1;
 
+	if (delete_item && trans)
+		ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
+
 	if (test_and_clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 			       &inode->runtime_flags))
-		release_rsv = 1;
-	spin_unlock(&root->orphan_lock);
+		btrfs_orphan_release_metadata(inode);
 
-	if (delete_item) {
+	/*
+	 * btrfs_orphan_commit_root may race with us and set ->orphan_block_rsv
+	 * to zero, in order to avoid that, decrease ->orphan_inodes after
+	 * everything is done.
+	 */
+	if (delete_item)
 		atomic_dec(&root->orphan_inodes);
-		if (trans)
-			ret = btrfs_del_orphan_item(trans, root,
-						    btrfs_ino(inode));
-	}
-
-	if (release_rsv)
-		btrfs_orphan_release_metadata(inode);
 
 	return ret;
 }
-- 
2.9.4

