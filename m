Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58462 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3CZTUx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 15:20:53 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id CAA3C7C0401
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 13:20:52 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id OrSus6HvfDsO1a7N (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 13:20:52 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix space accounting for unlink and rename
Date: Tue, 26 Mar 2013 15:28:16 -0400
Message-ID: <1364326096-7959-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are way over-reserving for unlink and rename.  Rename is just some random
huge number and unlink accounts for tree log operations that don't actually
happen during unlink, not to mention the tree log doesn't take from the trans
block rsv anyway so it's completely useless.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 106b261..d38c9b3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3683,11 +3683,9 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	 * 1 for the dir item
 	 * 1 for the dir index
 	 * 1 for the inode ref
-	 * 1 for the inode ref in the tree log
-	 * 2 for the dir entries in the log
 	 * 1 for the inode
 	 */
-	trans = btrfs_start_transaction(root, 8);
+	trans = btrfs_start_transaction(root, 5);
 	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
 		return trans;
 
@@ -8130,7 +8128,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * inodes.  So 5 * 2 is 10, plus 1 for the new link, so 11 total items
 	 * should cover the worst case number of items we'll modify.
 	 */
-	trans = btrfs_start_transaction(root, 20);
+	trans = btrfs_start_transaction(root, 11);
 	if (IS_ERR(trans)) {
                 ret = PTR_ERR(trans);
                 goto out_notrans;
-- 
1.7.7.6

