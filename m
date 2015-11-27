Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbbK0Pd3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 10:33:29 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 47AF1AB13
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 15:31:48 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: use smaller type for btrfs_path lowest_level
Date: Fri, 27 Nov 2015 16:31:42 +0100
Message-Id: <b49c7436746ae42a2e7876ff32228fcdbb8d81d4.1448637387.git.dsterba@suse.com>
In-Reply-To: <cover.1448637387.git.dsterba@suse.com>
References: <cover.1448637387.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The level is 0..7, we can use smaller type. The size of btrfs_path is now
136 bytes from 144, which is +2 objects that fit into a 4k slab.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 64c1d96d9bf9..4e00412dc5ff 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -598,7 +598,7 @@ struct btrfs_path {
 	int locks[BTRFS_MAX_LEVEL];
 	u8 reada;
 	/* keep some upper locks as we walk down */
-	int lowest_level;
+	u8 lowest_level;
 
 	/*
 	 * set by btrfs_split_item, tells search_slot to keep all locks
-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
