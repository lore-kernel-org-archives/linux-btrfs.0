Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750AbcA0OCX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 09:02:23 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 12A32ADC1
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 14:02:21 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: add free space tree to the cow-only list
Date: Wed, 27 Jan 2016 15:02:12 +0100
Message-Id: <3e4c5efbb3ac7c9c4fb5f33b659fa98afe568ab1.1453902967.git.dsterba@suse.com>
In-Reply-To: <cover.1453902967.git.dsterba@suse.com>
References: <cover.1453902967.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/relocation.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ef6d8fc85853..c5540302402d 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -575,7 +575,8 @@ static int is_cowonly_root(u64 root_objectid)
 	    root_objectid == BTRFS_TREE_LOG_OBJECTID ||
 	    root_objectid == BTRFS_CSUM_TREE_OBJECTID ||
 	    root_objectid == BTRFS_UUID_TREE_OBJECTID ||
-	    root_objectid == BTRFS_QUOTA_TREE_OBJECTID)
+	    root_objectid == BTRFS_QUOTA_TREE_OBJECTID ||
+	    root_objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
 		return 1;
 	return 0;
 }
-- 
2.6.3

