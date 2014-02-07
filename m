Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbaBGNeA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 08:34:00 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4B022ABA6
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Feb 2014 13:34:00 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/4] btrfs: commit transaction after setting label and features
Date: Fri,  7 Feb 2014 14:33:57 +0100
Message-Id: <cbcf98e954a26f6bd43b819e48814d1e1d81bf8f.1391779611.git.dsterba@suse.cz>
In-Reply-To: <cover.1391779611.git.dsterba@suse.cz>
References: <cover.1391779611.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The set_fslabel ioctl uses btrfs_end_transaction, which means it's
possible that the change will be lost if the system crashes, same for
the newly set features. Let's use btrfs_commit_transaction instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b0134892dc70..8e48b81e1515 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4525,7 +4525,7 @@ static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
 	spin_lock(&root->fs_info->super_lock);
 	strcpy(super_block->label, label);
 	spin_unlock(&root->fs_info->super_lock);
-	ret = btrfs_end_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
 
 out_unlock:
 	mnt_drop_write_file(file);
@@ -4689,7 +4689,7 @@ static int btrfs_ioctl_set_features(struct file *file, void __user *arg)
 	btrfs_set_super_incompat_flags(super_block, newflags);
 	spin_unlock(&root->fs_info->super_lock);
 
-	return btrfs_end_transaction(trans, root);
+	return btrfs_commit_transaction(trans, root);
 }
 
 long btrfs_ioctl(struct file *file, unsigned int
-- 
1.8.5.2

