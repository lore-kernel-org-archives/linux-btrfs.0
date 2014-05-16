Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaEPNPu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 09:15:50 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CE3E3AABF
	for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 13:15:48 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: remove newline from inode cache kthread name
Date: Fri, 16 May 2014 15:15:45 +0200
Message-Id: <1400246145-17493-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1400170989-20584-1-git-send-email-dsterba@suse.cz>
References: <1400170989-20584-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---

Sorry for the stupid typo in subject, I'm resending so there's a correct patch
in patchwork.

 fs/btrfs/inode-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 86935f5ae291..888fbe19079f 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -174,7 +174,7 @@ static void start_caching(struct btrfs_root *root)
 				       BTRFS_LAST_FREE_OBJECTID - objectid + 1);
 	}
 
-	tsk = kthread_run(caching_kthread, root, "btrfs-ino-cache-%llu\n",
+	tsk = kthread_run(caching_kthread, root, "btrfs-ino-cache-%llu",
 			  root->root_key.objectid);
 	if (IS_ERR(tsk)) {
 		btrfs_warn(root->fs_info, "failed to start inode caching task");
-- 
1.9.0

