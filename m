Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760875Ab3BIXiL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Feb 2013 18:38:11 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 9285BA4E0C
	for <linux-btrfs@vger.kernel.org>; Sun, 10 Feb 2013 00:38:09 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: add cancellation points to defrag
Date: Sun, 10 Feb 2013 00:38:06 +0100
Message-Id: <1360453086-10683-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The defrag operation can take very long, we want to have a way how to
cancel it. The code checks for a pending signal at safe points in the
defrag loops and returns EAGAIN. This means a user can press ^C after
running 'btrfs fi defrag', woks for both defrag modes, files and root.

Returning from the command was instant in my light tests, but may take
longer depending on the aging factor of the filesystem.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h       |    7 +++++++
 fs/btrfs/ioctl.c       |    6 ++++++
 fs/btrfs/transaction.c |    6 ++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 547b7b0..4b41d7c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3745,4 +3745,11 @@ static inline int is_fstree(u64 rootid)
 		return 1;
 	return 0;
 }
+
+static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
+{
+	return signal_pending(current);
+}
+
+
 #endif
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 338f259..78a5580 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1206,6 +1206,12 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		if (!(inode->i_sb->s_flags & MS_ACTIVE))
 			break;
 
+		if (btrfs_defrag_cancelled(root->fs_info)) {
+			printk(KERN_DEBUG "btrfs: defrag_file cancelled\n");
+			ret = -EAGAIN;
+			break;
+		}
+
 		if (!should_defrag_range(inode, (u64)i << PAGE_CACHE_SHIFT,
 					 extent_thresh, &last_len, &skip,
 					 &defrag_end, range->flags &
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index fc03aa6..2c509c4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -986,6 +986,12 @@ int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
 
 		if (btrfs_fs_closing(root->fs_info) || ret != -EAGAIN)
 			break;
+
+		if (btrfs_defrag_cancelled(root->fs_info)) {
+			printk(KERN_DEBUG "btrfs: defrag_root cancelled\n");
+			ret = -EAGAIN;
+			break;
+		}
 	}
 	root->defrag_running = 0;
 	return ret;
-- 
1.7.9

