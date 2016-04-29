Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbcD2JVB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:21:01 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0CB6FAD6E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:21:00 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 10/16] btrfs: untangle gotos a bit in __clear_extent_bit
Date: Fri, 29 Apr 2016 11:20:47 +0200
Message-Id: <7ab5cb2a9e3161de3a288bafd100515b5f44f27e.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f5eda54e225f..3ecd8b1f239f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -726,14 +726,6 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	start = last_end + 1;
 	if (start <= end && state && !need_resched())
 		goto hit_next;
-	goto search_again;
-
-out:
-	spin_unlock(&tree->lock);
-	if (prealloc)
-		free_extent_state(prealloc);
-
-	return 0;
 
 search_again:
 	if (start > end)
@@ -742,6 +734,14 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	if (gfpflags_allow_blocking(mask))
 		cond_resched();
 	goto again;
+
+out:
+	spin_unlock(&tree->lock);
+	if (prealloc)
+		free_extent_state(prealloc);
+
+	return 0;
+
 }
 
 static void wait_on_state(struct extent_io_tree *tree,
-- 
2.7.1

