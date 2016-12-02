Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45060 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752006AbcLBFHr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:47 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BCCF4ABC3
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:45 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 04/18] btrfs: alloc_reserved_file_extent trace point should use extent_root
Date: Fri,  2 Dec 2016 00:07:24 -0500
Message-Id: <1480655258-15400-5-git-send-email-jeffm@suse.com>
In-Reply-To: <1480655258-15400-1-git-send-email-jeffm@suse.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Even though a separate root is passed in, we're still operating on the
extent root.  Let's use that for the trace point.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e4b3fc0..e8b8e30 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8105,7 +8105,8 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 			ins->objectid, ins->offset);
 		BUG();
 	}
-	trace_btrfs_reserved_extent_alloc(root, ins->objectid, ins->offset);
+	trace_btrfs_reserved_extent_alloc(fs_info->extent_root,
+					  ins->objectid, ins->offset);
 	return ret;
 }
 
-- 
2.7.1

