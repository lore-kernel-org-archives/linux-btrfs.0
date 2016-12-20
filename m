Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40026 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764599AbcLTS2h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 13:28:37 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 373D5AAB9
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Dec 2016 18:28:35 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/2 v2] btrfs: fix error handling when run_delayed_extent_op fails
Date: Tue, 20 Dec 2016 13:28:27 -0500
Message-Id: <1482258508-7594-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

In __btrfs_run_delayed_refs, the error path when run_delayed_extent_op
fails sets locked_ref->processing = 0 but doesn't re-increment
delayed_refs->num_heads_ready.  As a result, we end up triggering
the WARN_ON in btrfs_select_ref_head.

Fixes: d7df2c796d7 (Btrfs: attach delayed ref updates to delayed ref heads)
Reported-by: Jon Nelson <jnelson-suse@jamponi.net>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index db74889..d74adf1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2576,7 +2576,10 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 					 */
 					if (must_insert_reserved)
 						locked_ref->must_insert_reserved = 1;
+					spin_lock(&delayed_refs->lock);
 					locked_ref->processing = 0;
+					delayed_refs->num_heads_ready++;
+					spin_unlock(&delayed_refs->lock);
 					btrfs_debug(fs_info,
 						    "run_delayed_extent_op returned %d",
 						    ret);
-- 
1.8.5.6

