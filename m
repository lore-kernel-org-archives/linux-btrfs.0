Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54412 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab3FCUwI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 16:52:08 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id BC1487C0434
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Jun 2013 14:52:07 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id O9idNVmBtnPwCLtG (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 03 Jun 2013 14:52:07 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add some missing iput()'s in btrfs_orphan_cleanup
Date: Mon, 3 Jun 2013 16:52:05 -0400
Message-ID: <1370292725-1568-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are some error cases that we don't do an iput() on our inode, fix this.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b11a95e..d37bccf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3234,13 +3234,16 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 			/* 1 for the orphan item deletion. */
 			trans = btrfs_start_transaction(root, 1);
 			if (IS_ERR(trans)) {
+				iput(inode);
 				ret = PTR_ERR(trans);
 				goto out;
 			}
 			ret = btrfs_orphan_add(trans, inode);
 			btrfs_end_transaction(trans, root);
-			if (ret)
+			if (ret) {
+				iput(inode);
 				goto out;
+			}
 
 			ret = btrfs_truncate(inode);
 			if (ret)
-- 
1.7.7.6

