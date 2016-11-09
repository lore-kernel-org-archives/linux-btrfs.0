Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51246 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753745AbcKIREX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 12:04:23 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 35421AC34
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Nov 2016 17:04:22 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 02/12] btrfs: reada, remove unused parameter from __readahead_hook
Date: Wed,  9 Nov 2016 18:04:20 +0100
Message-Id: <fb3a1c62919563806850d396c618550154b639bc.1478710770.git.dsterba@suse.com>
In-Reply-To: <cover.1478710770.git.dsterba@suse.com>
References: <cover.1478710770.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'start' is not used since "btrfs: reada: Pass reada_extent into
__readahead_hook directly" (6e39dbe8b9e55280c).

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/reada.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 378043823dca..018a303c91fb 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -107,7 +107,7 @@ static int reada_add_block(struct reada_control *rc, u64 logical,
 /* in case of err, eb might be NULL */
 static void __readahead_hook(struct btrfs_fs_info *fs_info,
 			     struct reada_extent *re, struct extent_buffer *eb,
-			     u64 start, int err)
+			     int err)
 {
 	int nritems;
 	int i;
@@ -231,7 +231,7 @@ int btree_readahead_hook(struct btrfs_fs_info *fs_info,
 		goto start_machine;
 	}
 
-	__readahead_hook(fs_info, re, eb, start, err);
+	__readahead_hook(fs_info, re, eb, err);
 	reada_extent_put(fs_info, re);	/* our ref */
 
 start_machine:
@@ -713,9 +713,9 @@ static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
 	ret = reada_tree_block_flagged(fs_info->extent_root, logical,
 			mirror_num, &eb);
 	if (ret)
-		__readahead_hook(fs_info, re, NULL, logical, ret);
+		__readahead_hook(fs_info, re, NULL, ret);
 	else if (eb)
-		__readahead_hook(fs_info, re, eb, eb->start, ret);
+		__readahead_hook(fs_info, re, eb, ret);
 
 	if (eb)
 		free_extent_buffer(eb);
-- 
2.10.1

