Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbcFXWPc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 33B5AADDD
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:28 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 18/31] btrfs: alloc_reserved_file_extent trace point should use extent_root
Date: Fri, 24 Jun 2016 18:15:11 -0400
Message-Id: <1466806524-27508-19-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
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
index e6ad776..49775d4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7866,7 +7866,8 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
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

