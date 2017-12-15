Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43356 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754727AbdLOKFj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 05:05:39 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BA089ACAC
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 10:05:38 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Add enospc_debug printing in metadata_reserve_bytes
Date: Fri, 15 Dec 2017 12:05:37 +0200
Message-Id: <1513332337-7068-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently when enoscp_debug mount option is turned on we do not print
any debug info in case metadata reservation failures happen. Fix this
by adding the necessary hook in reserve_metadata_bytes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4497f937e8fb..7a281fc97bc5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5382,10 +5382,15 @@ static int reserve_metadata_bytes(struct btrfs_root *root,
 		    !block_rsv_use_bytes(global_rsv, orig_bytes))
 			ret = 0;
 	}
-	if (ret == -ENOSPC)
+	if (ret == -ENOSPC) {
 		trace_btrfs_space_reservation(fs_info, "space_info:enospc",
 					      block_rsv->space_info->flags,
 					      orig_bytes, 1);
+
+		if (btrfs_test_opt(fs_info, ENOSPC_DEBUG))
+			dump_space_info(fs_info, block_rsv->space_info,
+					orig_bytes, 0);
+	}
 	return ret;
 }
 
-- 
2.7.4

