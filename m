Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38402 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752275AbeCNPDV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 11:03:21 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 64BBAADF9
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 15:03:20 +0000 (UTC)
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add missing initialization in btrfs_check_shared
Date: Wed, 14 Mar 2018 09:03:11 -0600
Message-Id: <20180314150311.20152-2-enadolski@suse.com>
In-Reply-To: <20180314150311.20152-1-enadolski@suse.com>
References: <20180314150311.20152-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_check_shared calls find_parent_nodes in a loop. In each
iteration it passes in a share_check struct to request a check for
a shared extent.  The share_check::share_count must be re-initialized
to zero for each iteration in order to avoid using a stale count
value from the previous iteration, thus causing a false
shared extent indication.

Signed-off-by: Edmund Nadolski <enadolski@suse.com>
---
 fs/btrfs/backref.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 4e89598..4a33448 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1519,6 +1519,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
 		if (!node)
 			break;
 		bytenr = node->val;
+		shared.share_count = 0;
 		cond_resched();
 	}
 
-- 
2.10.2

