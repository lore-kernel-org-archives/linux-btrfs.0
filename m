Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41355 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751411AbdJPN37 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 09:29:59 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1008CAAAD
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 13:29:58 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Replace opencoded sizes with their symbolic constants
Date: Mon, 16 Oct 2017 16:29:56 +0300
Message-Id: <1508160596-30915-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs' code uses a mix of opencoded sizes and defines from sizes.h.
Let's unifiy the code base to always use the symbolic constants. No functional
changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h             | 2 +-
 fs/btrfs/disk-io.c           | 2 +-
 fs/btrfs/file.c              | 2 +-
 fs/btrfs/raid56.c            | 2 +-
 fs/btrfs/super.c             | 2 +-
 fs/btrfs/tests/inode-tests.c | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e2afe524e25e..7bda8429e93f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -523,7 +523,7 @@ struct btrfs_caching_control {
 };
 
 /* Once caching_thread() finds this much free space, it will wake up waiters. */
-#define CACHING_CTL_WAKE_UP (1024 * 1024 * 2)
+#define CACHING_CTL_WAKE_UP SZ_2M
 
 struct btrfs_io_ctl {
 	void *cur, *orig;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 69ce738c00d0..484cf8fc952c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2733,7 +2733,7 @@ int open_ctree(struct super_block *sb,
 	sb->s_bdi->congested_fn = btrfs_congested_fn;
 	sb->s_bdi->congested_data = fs_info;
 	sb->s_bdi->capabilities |= BDI_CAP_CGROUP_WRITEBACK;
-	sb->s_bdi->ra_pages = VM_MAX_READAHEAD * 1024 / PAGE_SIZE;
+	sb->s_bdi->ra_pages = VM_MAX_READAHEAD * SZ_1K / PAGE_SIZE;
 	sb->s_bdi->ra_pages *= btrfs_super_num_devices(disk_super);
 	sb->s_bdi->ra_pages = max(sb->s_bdi->ra_pages, SZ_4M / PAGE_SIZE);
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d3c1725f03e4..7d338e497097 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -281,7 +281,7 @@ void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info)
 	spin_unlock(&fs_info->defrag_inodes_lock);
 }
 
-#define BTRFS_DEFRAG_BATCH	1024
+#define BTRFS_DEFRAG_BATCH	SZ_1K
 
 static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 				    struct inode_defrag *defrag)
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index a7f79254ecca..553172271913 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -58,7 +58,7 @@
  */
 #define RBIO_CACHE_READY_BIT	3
 
-#define RBIO_CACHE_SIZE 1024
+#define RBIO_CACHE_SIZE SZ_1K
 
 enum btrfs_rbio_ops {
 	BTRFS_RBIO_WRITE,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6b279d873440..72160cf5d934 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2126,7 +2126,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	 * succeed even if the Avail is zero. But this is better than the other
 	 * way around.
 	 */
-	thresh = 4 * 1024 * 1024;
+	thresh = SZ_4M;
 
 	if (!mixed && total_free_meta - thresh < block_rsv->size)
 		buf->f_bavail = 0;
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 8c91d03cc82d..330815eb07b4 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -770,7 +770,7 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, 4096 * 1024, 0);
+	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, SZ_4M, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
-- 
2.7.4

