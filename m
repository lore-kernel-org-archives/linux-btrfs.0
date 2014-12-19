Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaLSRij (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 12:38:39 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 4CAFAAC18
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 17:38:38 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/4] btrfs: update message levels for errors
Date: Fri, 19 Dec 2014 18:38:37 +0100
Message-Id: <edfef4f89026c46900999d62740ad9848c11ce1f.1419010347.git.dsterba@suse.cz>
In-Reply-To: <cover.1419010347.git.dsterba@suse.cz>
References: <cover.1419010347.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several messages that point to some internal problem, level INFO is
wrong here.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c | 9 +++++----
 fs/btrfs/inode.c   | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 30965120772b..8beb74ffb075 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -367,7 +367,8 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 		ret = 0;
 		goto out;
 	}
-	printk_ratelimited(KERN_INFO "BTRFS (device %s): parent transid verify failed on %llu wanted %llu found %llu\n",
+	printk_ratelimited(KERN_ERR
+	    "BTRFS (device %s): parent transid verify failed on %llu wanted %llu found %llu\n",
 			eb->fs_info->sb->s_id, eb->start,
 			parent_transid, btrfs_header_generation(eb));
 	ret = 1;
@@ -633,21 +634,21 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != eb->start) {
-		printk_ratelimited(KERN_INFO "BTRFS (device %s): bad tree block start "
+		printk_ratelimited(KERN_ERR "BTRFS (device %s): bad tree block start "
 			       "%llu %llu\n",
 			       eb->fs_info->sb->s_id, found_start, eb->start);
 		ret = -EIO;
 		goto err;
 	}
 	if (check_tree_block_fsid(root, eb)) {
-		printk_ratelimited(KERN_INFO "BTRFS (device %s): bad fsid on block %llu\n",
+		printk_ratelimited(KERN_ERR "BTRFS (device %s): bad fsid on block %llu\n",
 			       eb->fs_info->sb->s_id, eb->start);
 		ret = -EIO;
 		goto err;
 	}
 	found_level = btrfs_header_level(eb);
 	if (found_level >= BTRFS_MAX_LEVEL) {
-		btrfs_info(root->fs_info, "bad tree block level %d",
+		btrfs_err(root->fs_info, "bad tree block level %d",
 			   (int)btrfs_header_level(eb));
 		ret = -EIO;
 		goto err;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e687bb0dc73a..ff6d98d8dc20 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3407,7 +3407,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 
 out:
 	if (ret)
-		btrfs_crit(root->fs_info,
+		btrfs_err(root->fs_info,
 			"could not do orphan cleanup %d", ret);
 	btrfs_free_path(path);
 	return ret;
-- 
2.1.3

