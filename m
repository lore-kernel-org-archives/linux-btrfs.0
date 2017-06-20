Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750957AbdFTMPO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 08:15:14 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39B74AAB9
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 12:15:13 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: add cond_resched to btrfs_qgroup_trace_leaf_items
Date: Tue, 20 Jun 2017 08:15:26 -0400
Message-Id: <20170620121526.13661-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

On an uncontended system, we can end up hitting soft lockups while
doing replace_path.  At the core, and frequently called is
btrfs_qgroup_trace_leaf_items, so it makes sense to add a cond_resched
there.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/qgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index deffbeb74a0b..7a3cfa22e178 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1559,6 +1559,7 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
 		if (ret)
 			return ret;
 	}
+	cond_resched();
 	return 0;
 }
 
-- 
2.11.0

