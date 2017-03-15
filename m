Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40231 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753353AbdCOQD6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 12:03:58 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 977E5ADD0
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Mar 2017 16:03:12 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/7] btrfs: remove redundant parameter from reada_find_zone
Date: Wed, 15 Mar 2017 17:02:36 +0100
Message-Id: <ab9356d6b2db1095d1f09f9039e46df0099240d9.1489593696.git.dsterba@suse.com>
In-Reply-To: <cover.1489593696.git.dsterba@suse.com>
References: <cover.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can read fs_info from dev.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/reada.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 5edf7328f67d..c1fc79cd4b2a 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -235,10 +235,10 @@ int btree_readahead_hook(struct extent_buffer *eb, int err)
 	return ret;
 }
 
-static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
-					  struct btrfs_device *dev, u64 logical,
+static struct reada_zone *reada_find_zone(struct btrfs_device *dev, u64 logical,
 					  struct btrfs_bio *bbio)
 {
+	struct btrfs_fs_info *fs_info = dev->fs_info;
 	int ret;
 	struct reada_zone *zone;
 	struct btrfs_block_group_cache *cache = NULL;
@@ -372,7 +372,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 		 if (!dev->bdev)
 			continue;
 
-		zone = reada_find_zone(fs_info, dev, logical, bbio);
+		zone = reada_find_zone(dev, logical, bbio);
 		if (!zone)
 			continue;
 
-- 
2.12.0

