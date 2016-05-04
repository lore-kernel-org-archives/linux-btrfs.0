Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbcEDJcY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 05:32:24 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4D69AABB4
	for <linux-btrfs@vger.kernel.org>; Wed,  4 May 2016 09:32:23 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: add write protection to SET_FEATURES ioctl
Date: Wed,  4 May 2016 11:32:00 +0200
Message-Id: <1462354320-17526-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: David Sterba <dsterba@suse.cz>

Perform the want_write check if we get far enough to do any writes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5a23806ae418..e3239272fa61 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5394,9 +5394,15 @@ static int btrfs_ioctl_set_features(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
 	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_drop_write;
+	}
 
 	spin_lock(&root->fs_info->super_lock);
 	newflags = btrfs_super_compat_flags(super_block);
@@ -5415,7 +5421,11 @@ static int btrfs_ioctl_set_features(struct file *file, void __user *arg)
 	btrfs_set_super_incompat_flags(super_block, newflags);
 	spin_unlock(&root->fs_info->super_lock);
 
-	return btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
+out_drop_write:
+	mnt_drop_write_file(file);
+
+	return ret;
 }
 
 long btrfs_ioctl(struct file *file, unsigned int
-- 
2.7.1

