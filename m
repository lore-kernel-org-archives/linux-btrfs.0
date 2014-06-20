Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966645AbaFTLCf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 07:02:35 -0400
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/8] btrfs: make close_ctree return void
Date: Fri, 20 Jun 2014 13:02:33 +0200
Message-Id: <eaf9b4abf66252b4b9bdbde2ba213e9ed58a2e4f.1403260619.git.dsterba@suse.cz>
In-Reply-To: <cover.1403260619.git.dsterba@suse.cz>
References: <cover.1403260619.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's no user of the return value and we can get rid of the comment in
put_super.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c |    4 +---
 fs/btrfs/disk-io.h |    2 +-
 fs/btrfs/super.c   |    8 +-------
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0ebcd9e8e8ec..43217afbcaf7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3616,7 +3616,7 @@ int btrfs_commit_super(struct btrfs_root *root)
 	return btrfs_commit_transaction(trans, root);
 }
 
-int close_ctree(struct btrfs_root *root)
+void close_ctree(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
@@ -3704,8 +3704,6 @@ int close_ctree(struct btrfs_root *root)
 
 	btrfs_free_block_rsv(root, root->orphan_block_rsv);
 	root->orphan_block_rsv = NULL;
-
-	return 0;
 }
 
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 23ce3ceba0a9..52a17db700fc 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -56,7 +56,7 @@ void clean_tree_block(struct btrfs_trans_handle *trans,
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options);
-int close_ctree(struct btrfs_root *root);
+void close_ctree(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int max_mirrors);
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4662d92a4b73..f8b64e8f97a1 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -307,13 +307,7 @@ void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 
 static void btrfs_put_super(struct super_block *sb)
 {
-	(void)close_ctree(btrfs_sb(sb)->tree_root);
-	/* FIXME: need to fix VFS to return error? */
-	/* AV: return it _where_?  ->put_super() can be triggered by any number
-	 * of async events, up to and including delivery of SIGKILL to the
-	 * last process that kept it busy.  Or segfault in the aforementioned
-	 * process...  Whom would you report that to?
-	 */
+	close_ctree(btrfs_sb(sb)->tree_root);
 }
 
 enum {
-- 
1.7.9

