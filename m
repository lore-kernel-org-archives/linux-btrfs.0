Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbaH0Rrs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 13:47:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D00E8AD0A
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Aug 2014 17:47:47 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: readahead errors are not fatal
Date: Wed, 27 Aug 2014 19:47:45 +0200
Message-Id: <1409161665-28234-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kill the BUG_ON.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index 8db0335bc81b..7ddd4b90836f 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -152,7 +152,8 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 	length = blocksize;
 	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
 			      bytenr, &length, &multi, 0, NULL);
-	BUG_ON(ret);
+	if (ret)
+		return 0
 	device = multi->stripes[0].dev;
 	device->total_ios++;
 	blocksize = min(blocksize, (u32)(64 * 1024));
-- 
1.9.0

