Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:51700 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030391Ab2HHQHz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 12:07:55 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id FvKeCOXfw4OLKqOF (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 08 Aug 2012 10:07:54 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix enospc problems when deleting a subvol
Date: Wed, 8 Aug 2012 12:12:59 -0400
Message-ID: <1344442379-5645-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Subvol delete is a special kind of awful where we use the global reserve to
cover the ENOSPC requirements.  The problem is once we're done removing
everything we do a btrfs_update_inode(), which by default will try to do the
delayed update stuff which will use it's own reserve.  There will be no
space in this reserve and we'll return ENOSPC.  So instead use
btrfs_update_inode_fallback() which will just fallback to updating the inode
item in the case of enospc.  This is fine because the global reserve covers
the space requirements for this.  With this patch I can now delete a subvol
on a problem image Dave Sterba sent me.  Thanks,

Reported-by: David Sterba <dave@jikos.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7ab714f..1a58373 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3172,7 +3172,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
 	inode_inc_iversion(dir);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
-	ret = btrfs_update_inode(trans, root, dir);
+	ret = btrfs_update_inode_fallback(trans, root, dir);
 	if (ret)
 		btrfs_abort_transaction(trans, root, ret);
 out:
-- 
1.7.7.6

