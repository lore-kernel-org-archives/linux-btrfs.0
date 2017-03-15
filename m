Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40233 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753427AbdCOQD7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 12:03:59 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AD952ADD9
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Mar 2017 16:03:18 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 7/7] btrfs: remove local blocksize variable in reada_find_extent
Date: Wed, 15 Mar 2017 17:02:42 +0100
Message-Id: <9355f3bb85dcdb05a30ad8f7e11bedae2f08afb0.1489593696.git.dsterba@suse.com>
In-Reply-To: <cover.1489593696.git.dsterba@suse.com>
References: <cover.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The name is misleading and the local variable serves no purpose.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/reada.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 91df381a60ce..64425c3fe4f5 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -318,7 +318,6 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 	struct btrfs_bio *bbio = NULL;
 	struct btrfs_device *dev;
 	struct btrfs_device *prev_dev;
-	u32 blocksize;
 	u64 length;
 	int real_stripes;
 	int nzones = 0;
@@ -339,7 +338,6 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 	if (!re)
 		return NULL;
 
-	blocksize = fs_info->nodesize;
 	re->logical = logical;
 	re->top = *top;
 	INIT_LIST_HEAD(&re->extctl);
@@ -349,10 +347,10 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 	/*
 	 * map block
 	 */
-	length = blocksize;
+	length = fs_info->nodesize;
 	ret = btrfs_map_block(fs_info, BTRFS_MAP_GET_READ_MIRRORS, logical,
 			&length, &bbio, 0);
-	if (ret || !bbio || length < blocksize)
+	if (ret || !bbio || length < fs_info->nodesize)
 		goto error;
 
 	if (bbio->num_stripes > BTRFS_MAX_MIRRORS) {
-- 
2.12.0

