Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8547 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932662AbaIRPar (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 11:30:47 -0400
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s8IF6nfU015335
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 08:30:47 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1peexnne5b-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 08:30:47 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: try not to ENOSPC on log replay V2
Date: Thu, 18 Sep 2014 11:30:44 -0400
Message-ID: <1411054244-20638-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When doing log replay we may have to update inodes, which traditionally goes
through our delayed inode stuff.  This will try to move space over from the
trans handle, but we don't reserve space in our trans handle on replay since we
don't know how much we will need, so instead we try to flush.  But because we
have a trans handle open we won't flush anything, so if we are out of reserve
space we will simply return ENOSPC.  Since we know that if an operation made it
into the log then we definitely had space before the box bought the farm then we
don't need to worry about doing this space reservation.  Use the
fs_info->log_root_recovering flag to skip the delayed inode stuff and update the
item directly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: Use fs_info->log_root_recovering instead of adding yet another flag.

 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 28e693e..acecf86 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3705,7 +3705,8 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	 * without delay
 	 */
 	if (!btrfs_is_free_space_inode(inode)
-	    && root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID) {
+	    && root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
+	    && !root->fs_info->log_root_recovering) {
 		btrfs_update_root_times(trans, root);
 
 		ret = btrfs_delayed_update_inode(trans, root, inode);
-- 
1.8.3.1

