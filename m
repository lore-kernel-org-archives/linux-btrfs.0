Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45241 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751480AbdBMJxn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:53:43 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C4F47AC53
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:53:41 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: make space cache inode readahead failure nonfatal
Date: Mon, 13 Feb 2017 10:53:12 +0100
Message-Id: <20170213095312.18495-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We do a readahead of the free space cache inode to speed things up but
the failure is not fatal, like in other readahead cases. Proper reads
would need to happen anyway and any errors would be caught there.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/free-space-cache.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 437580e84d9d..e96e981ef01e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -286,14 +286,14 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 	return ret;
 }
 
-static int readahead_cache(struct inode *inode)
+static void readahead_cache(struct inode *inode)
 {
 	struct file_ra_state *ra;
 	unsigned long last_index;
 
 	ra = kzalloc(sizeof(*ra), GFP_NOFS);
 	if (!ra)
-		return -ENOMEM;
+		return;
 
 	file_ra_state_init(ra, inode->i_mapping);
 	last_index = (i_size_read(inode) - 1) >> PAGE_SHIFT;
@@ -301,8 +301,6 @@ static int readahead_cache(struct inode *inode)
 	page_cache_sync_readahead(inode->i_mapping, ra, NULL, 0, last_index);
 
 	kfree(ra);
-
-	return 0;
 }
 
 static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
@@ -730,9 +728,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	if (ret)
 		return ret;
 
-	ret = readahead_cache(inode);
-	if (ret)
-		goto out;
+	readahead_cache(inode);
 
 	ret = io_ctl_prepare_pages(&io_ctl, inode, 1);
 	if (ret)
-- 
2.10.1

