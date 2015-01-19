Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbbASNVG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 08:21:06 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3D903ACB2
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 13:21:04 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@suse.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH 3.19-rc] btrfs: sync ioctl, handle errors after transaction start
Date: Mon, 19 Jan 2015 14:21:02 +0100
Message-Id: <1421673662-11530-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The version merged to 3.19 did not handle errors from start_trancaction
and could pass an invalid pointer to commit_transaction.

Fixes: 6b5fe46dfa52441f ("btrfs: do commit in sync_fs if there are pending changes")
Reported-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---

This is a followup to a patch merged during this dev cycle.

 fs/btrfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 60f7cbe815e9..c86fb5438454 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1001,9 +1001,9 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 			if (fs_info->pending_changes == 0)
 				return 0;
 			trans = btrfs_start_transaction(root, 0);
-		} else {
-			return PTR_ERR(trans);
 		}
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
 	}
 	return btrfs_commit_transaction(trans, root);
 }
-- 
1.8.4.5

