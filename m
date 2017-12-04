Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751934AbdLDSLt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 13:11:49 -0500
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: fix missing error return in btrfs_drop_snapshot
Date: Mon,  4 Dec 2017 13:11:45 -0500
Message-Id: <20171204181145.10335-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

If btrfs_del_root fails in btrfs_drop_snapshot, we'll pick up the
error but then return 0 anyway due to mixing err and ret.

Fixes: 79787eaab4612 ("btrfs: replace many BUG_ONs with proper error handling")
Cc: <stable@vger.kernel.org> # v3.4+
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4497f937e8fb..2f4328511ac8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9206,6 +9206,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	ret = btrfs_del_root(trans, fs_info, &root->root_key);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
+		err = ret;
 		goto out_end_trans;
 	}
 
-- 
2.14.2

