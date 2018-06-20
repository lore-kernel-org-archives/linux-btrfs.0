Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753594AbeFTO0r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 10:26:47 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C4678AD06
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 14:26:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Streamline log_extent_csums a bit
Date: Wed, 20 Jun 2018 17:26:42 +0300
Message-Id: <1529504802-10871-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20180620134303.GY24375@twin.jikos.cz>
References: <20180620134303.GY24375@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently this function takes the root as an argument only to get the
log_root from it. Simplify this by directly passing the log root from
the caller. Also eliminate the fs_info local var, since it's used only
once, so directly reference it from the transaction handle.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/tree-log.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index daf32dc94dc3..b52ca6b8503e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4064,11 +4064,9 @@ static int extent_cmp(void *priv, struct list_head *a, struct list_head *b)
 
 static int log_extent_csums(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode *inode,
-			    struct btrfs_root *root,
+			    struct btrfs_root *log,
 			    const struct extent_map *em)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_root *log = root->log_root;
 	u64 csum_offset;
 	u64 csum_len;
 	LIST_HEAD(ordered_sums);
@@ -4089,7 +4087,7 @@ static int log_extent_csums(struct btrfs_trans_handle *trans,
 	}
 
 	/* block start is already adjusted for the file extent offset. */
-	ret = btrfs_lookup_csums_range(fs_info->csum_root,
+	ret = btrfs_lookup_csums_range(trans->fs_info->csum_root,
 				       em->block_start + csum_offset,
 				       em->block_start + csum_offset +
 				       csum_len - 1, &ordered_sums, 0);
@@ -4125,7 +4123,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	int ret;
 	int extent_inserted = 0;
 
-	ret = log_extent_csums(trans, inode, root, em);
+	ret = log_extent_csums(trans, inode, log, em);
 	if (ret)
 		return ret;
 
-- 
2.7.4

