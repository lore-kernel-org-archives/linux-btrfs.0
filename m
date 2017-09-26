Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46384 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S969603AbdIZO1q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 10:27:46 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 398D1AC10
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 14:27:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: Abort transaction if btrfs_update_root fails in btrfs_ioctl_subvol_setflags
Date: Tue, 26 Sep 2017 17:27:41 +0300
Message-Id: <1506436062-23825-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_update_root can fail for any number of reasons, however the only error
handling we do is to revert the modified flags, yet we do not abort the
transaction but proceed to commit it. Fix this by explicitly checking if the
update root routine has failed and abort the transaction.

Fixes: 0caa102da827 ("Btrfs: Add BTRFS_IOC_SUBVOL_GETFLAGS/SETFLAGS ioctls")
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d6715c2bcdc4..09fcd51f0e8c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1842,8 +1842,11 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
+	if (ret < 0)
+		btrfs_abort_transaction(trans, ret);
 
 	btrfs_commit_transaction(trans);
+
 out_reset:
 	if (ret)
 		btrfs_set_root_flags(&root->root_item, root_flags);
-- 
2.7.4

