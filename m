Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbcD2JVE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:21:04 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5FA9EAD6E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:21:03 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 11/16] btrfs: untangle gotos a bit in convert_extent_bit
Date: Fri, 29 Apr 2016 11:20:50 +0200
Message-Id: <03bf5387708069194fbe5072fb57f9542e7a8b82.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3ecd8b1f239f..d39e2241ceb7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1262,15 +1262,6 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		goto out;
 	}
 
-	goto search_again;
-
-out:
-	spin_unlock(&tree->lock);
-	if (prealloc)
-		free_extent_state(prealloc);
-
-	return err;
-
 search_again:
 	if (start > end)
 		goto out;
@@ -1279,6 +1270,13 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		cond_resched();
 	first_iteration = false;
 	goto again;
+
+out:
+	spin_unlock(&tree->lock);
+	if (prealloc)
+		free_extent_state(prealloc);
+
+	return err;
 }
 
 /* wrappers around set/clear extent bit */
-- 
2.7.1

