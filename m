Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbaJBQtz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:49:55 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id ED23DAAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:49:53 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 02/14] btrfs: remove unused variable from btrfs_parse_options
Date: Thu,  2 Oct 2014 18:49:53 +0200
Message-Id: <143f363618558478fd7b5156c343d21e74194987.1412264872.git.dsterba@suse.cz>
In-Reply-To: <cover.1412264871.git.dsterba@suse.cz>
References: <cover.1412264871.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 2375f94fb780..1c6da8e00c1b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -395,7 +395,6 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	int ret = 0;
 	char *compress_type;
 	bool compress_force = false;
-	bool compress = false;
 
 	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
 	if (cache_gen)
@@ -473,7 +472,6 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			/* Fallthrough */
 		case Opt_compress:
 		case Opt_compress_type:
-			compress = true;
 			if (token == Opt_compress ||
 			    token == Opt_compress_force ||
 			    strcmp(args[0].from, "zlib") == 0) {
@@ -503,7 +501,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				btrfs_set_and_info(root, FORCE_COMPRESS,
 						   "force %s compression",
 						   compress_type);
-			} else if (compress) {
+			} else {
 				if (!btrfs_test_opt(root, COMPRESS))
 					btrfs_info(root->fs_info,
 						   "btrfs: use %s compression",
-- 
1.8.4.5

