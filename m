Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:37968 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab3FDBlJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 21:41:09 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 126D89A0365
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Jun 2013 19:41:08 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id NmbOMBzZQqFYAznF (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 03 Jun 2013 19:41:07 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: put our inode if orphan cleanup fails
Date: Mon, 3 Jun 2013 21:41:05 -0400
Message-ID: <1370310065-1823-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we cross into a different subvol when doing a lookup we will run the orhpan
cleanup.  If this fails however we do not drop the ref to the inode we were
looking up before we return an error, which leads to busy inodes on umount.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d37bccf..0368a16 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4941,8 +4941,10 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 		if (!(inode->i_sb->s_flags & MS_RDONLY))
 			ret = btrfs_orphan_cleanup(sub_root);
 		up_read(&root->fs_info->cleanup_work_sem);
-		if (ret)
+		if (ret) {
+			iput(inode);
 			inode = ERR_PTR(ret);
+		}
 	}
 
 	return inode;
-- 
1.7.7.6

