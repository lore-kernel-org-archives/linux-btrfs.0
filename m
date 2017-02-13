Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35027 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbdBMXoY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 18:44:24 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: fix if style in find_free_extent
Date: Mon, 13 Feb 2017 15:43:29 -0800
Message-Id: <1487029409-13562-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This puts '&&' on the first line of if statement.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6832047..4cf332c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7789,8 +7789,8 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 	}
 	up_read(&space_info->groups_sem);
 
-	if ((loop == LOOP_CACHING_NOWAIT) && have_caching_bg
-		&& !orig_have_caching_bg)
+	if ((loop == LOOP_CACHING_NOWAIT) && have_caching_bg &&
+	    !orig_have_caching_bg)
 		orig_have_caching_bg = true;
 
 	if (!ins->objectid && loop >= LOOP_CACHING_WAIT && have_caching_bg)
-- 
2.5.5

