Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:48905 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755800AbeDXEsU (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Apr 2018 00:48:20 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/4] btrfs: Rename btrfs_check_super_valid() to btrfs_validate_super()
Date: Tue, 24 Apr 2018 12:48:06 +0800
Message-Id: <20180424044809.29838-2-wqu@suse.com>
In-Reply-To: <20180424044809.29838-1-wqu@suse.com>
References: <20180424044809.29838-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Makes the function name a little shorter and easier to read.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 60caa68c3618..23b5c90cdbb2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -55,7 +55,7 @@
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info);
+static int btrfs_validate_super(struct btrfs_fs_info *fs_info);
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_fs_info *fs_info);
@@ -2668,7 +2668,7 @@ int open_ctree(struct super_block *sb,
 
 	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
 
-	ret = btrfs_check_super_valid(fs_info);
+	ret = btrfs_validate_super(fs_info);
 	if (ret) {
 		btrfs_err(fs_info, "superblock contains fatal errors");
 		err = -EINVAL;
@@ -3974,7 +3974,7 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level,
 					      level, first_key);
 }
 
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
+static int btrfs_validate_super(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	u64 nodesize = btrfs_super_nodesize(sb);
-- 
2.17.0

