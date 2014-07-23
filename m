Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaGWMjj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 08:39:39 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: mfasheh@suse.de, zab@zabbo.net, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: wake up transaction thread from SYNC_FS ioctl
Date: Wed, 23 Jul 2014 14:39:35 +0200
Message-Id: <1406119175-29530-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The transaction thread may want to do more work, namely it pokes the
cleaner ktread that will start processing uncleaned subvols.

This can be triggered by user via the 'btrfs fi sync' command, otherwise
there was a delay up to 30 seconds before the cleaner started to clean
old snapshots.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 47aceb494d1d..33ba5d0445b5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5309,6 +5309,12 @@ long btrfs_ioctl(struct file *file, unsigned int
 		if (ret)
 			return ret;
 		ret = btrfs_sync_fs(file->f_dentry->d_sb, 1);
+		/*
+		 * The transaction thread may want to do more work,
+		 * namely it pokes the cleaner ktread that will start
+		 * processing uncleaned subvols.
+		 */
+		wake_up_process(root->fs_info->transaction_kthread);
 		return ret;
 	}
 	case BTRFS_IOC_START_SYNC:
-- 
1.8.4.5

