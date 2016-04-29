Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbcD2JU5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:20:57 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A08C5AD6E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:20:56 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 09/16] btrfs: untangle gotos a bit in __set_extent_bit
Date: Fri, 29 Apr 2016 11:20:43 +0200
Message-Id: <b5a4ba14e0caa9da1b3b98939274bdeda71859e3.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0c9b11924f74..f5eda54e225f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1037,7 +1037,13 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		goto out;
 	}
 
-	goto search_again;
+search_again:
+	if (start > end)
+		goto out;
+	spin_unlock(&tree->lock);
+	if (gfpflags_allow_blocking(mask))
+		cond_resched();
+	goto again;
 
 out:
 	spin_unlock(&tree->lock);
@@ -1046,13 +1052,6 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 	return err;
 
-search_again:
-	if (start > end)
-		goto out;
-	spin_unlock(&tree->lock);
-	if (gfpflags_allow_blocking(mask))
-		cond_resched();
-	goto again;
 }
 
 int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-- 
2.7.1

