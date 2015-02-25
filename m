Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbbBYSZF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 13:25:05 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 50D24AAC8
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2015 18:25:04 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 10/11] btrfs: remove shadowing variables in __btrfs_map_block
Date: Wed, 25 Feb 2015 19:25:04 +0100
Message-Id: <789b7da8d9cce6d78b1a4d38a2669aec87af81d7.1424880058.git.dsterba@suse.cz>
In-Reply-To: <cover.1424880058.git.dsterba@suse.cz>
References: <cover.1424880058.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1) We can safely use the function's 'i'. Fixes warning

fs/btrfs/volumes.c:5257:7: warning: declaration of 'i' shadows a previous local
fs/btrfs/volumes.c:4951:6: warning: shadowed declaration is here

2) A local variable duplicates name of an argument, we can use the value
directly. Fixes warning

fs/btrfs/volumes.c:5433:8: warning: declaration of 'length' shadows a parameter
fs/btrfs/volumes.c:4935:27: warning: shadowed declaration is here

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/volumes.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 11bd47ba6a48..0ac03e4f962a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5264,7 +5264,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	    need_raid_map && ((rw & (REQ_WRITE | REQ_GET_READ_MIRRORS)) ||
 	    mirror_num > 1)) {
 		u64 tmp;
-		int i;
 		unsigned rot;
 
 		bbio->raid_map = (u64 *)((void *)bbio->stripes +
@@ -5440,9 +5439,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			}
 		}
 		if (found) {
-			u64 length = map->stripe_len;
-
-			if (physical_of_found + length <=
+			if (physical_of_found + map->stripe_len <=
 			    dev_replace->cursor_left) {
 				struct btrfs_bio_stripe *tgtdev_stripe =
 					bbio->stripes + num_stripes;
-- 
2.1.3

