Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965171AbaKNMeq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 07:34:46 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4075AAAC3
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Nov 2014 12:34:45 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/6 v2] btrfs: do commit in sync_fs if there are pending changes
Date: Fri, 14 Nov 2014 13:34:44 +0100
Message-Id: <1415968484-9648-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <6b5fe46dfa52441f49c7432b1c1b1cb767834708.1415894837.git.dsterba@suse.cz>
References: <6b5fe46dfa52441f49c7432b1c1b1cb767834708.1415894837.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a pending change is requested, it's not processed unless there is a
transaction commit about to happen, not even after sync or SYNC_FS
ioctl. For example a remount that toggles the inode_cache option will
not take effect after sync on a quiescent filesystem.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

v2: catch error from btrfs_start_transaction

 fs/btrfs/super.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 54bd91ece35b..0cf589402d8d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -993,9 +993,17 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
 		/* no transaction, don't bother */
-		if (PTR_ERR(trans) == -ENOENT)
-			return 0;
-		return PTR_ERR(trans);
+		if (PTR_ERR(trans) == -ENOENT) {
+			/*
+			 * Exit unless we have some pending changes
+			 * that need to go through commit
+			 */
+			if (fs_info->pending_changes == 0)
+				return 0;
+			trans = btrfs_start_transaction(root, 0);
+		}
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
 	}
 	return btrfs_commit_transaction(trans, root);
 }
-- 
2.1.3

