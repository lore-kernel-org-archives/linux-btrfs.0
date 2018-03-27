Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57981 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbeC0Suy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 14:50:54 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4905FAC98
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 18:50:53 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/6] btrfs: update barrier in should_cow_block
Date: Tue, 27 Mar 2018 20:48:27 +0200
Message-Id: <fd48cd0164b296422da688c00ff3b8c0942b0289.1522176187.git.dsterba@suse.com>
In-Reply-To: <cover.1522176187.git.dsterba@suse.com>
References: <cover.1522176187.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Once there was a simple int force_cow that was used with the plain
barriers, and then converted to a bit, so we should use the appropriate
barrier helper.

Other variables in the complex if condition do not depend on a barrier,
so we should be fine in case the atomic barrier becomes a no-op.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b88a79e69ddf..4c75df2eea2e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1502,8 +1502,8 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 	if (btrfs_is_testing(root->fs_info))
 		return 0;
 
-	/* ensure we can see the force_cow */
-	smp_rmb();
+	/* Ensure we can see the FORCE_COW bit */
+	smp_mb__before_atomic();
 
 	/*
 	 * We do not need to cow a block if
-- 
2.16.2

