Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41595 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752229AbdBMJeZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:25 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0BBF4ABD3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 11/29] btrfs: remove unused parameter from btrfs_check_super_valid
Date: Mon, 13 Feb 2017 10:33:55 +0100
Message-Id: <30b7866b2b154b6bbdf3959dfd4ecc754e78c208.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

None of the checks need to know the RO/RW status.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 441a62cd0351..2b06f557c176 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -64,8 +64,7 @@
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
-				    int read_only);
+static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info);
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_fs_info *fs_info);
@@ -2801,7 +2800,7 @@ int open_ctree(struct super_block *sb,
 
 	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
 
-	ret = btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
+	ret = btrfs_check_super_valid(fs_info);
 	if (ret) {
 		btrfs_err(fs_info, "superblock contains fatal errors");
 		err = -EINVAL;
@@ -4115,8 +4114,7 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 	return btree_read_extent_buffer_pages(fs_info, buf, parent_transid);
 }
 
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
-			      int read_only)
+static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	u64 nodesize = btrfs_super_nodesize(sb);
-- 
2.10.1

