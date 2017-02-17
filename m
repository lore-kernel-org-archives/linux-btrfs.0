Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35420 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934564AbdBQOoZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:25 -0500
Received: by mail-wm0-f66.google.com with SMTP id u63so2926928wmu.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:25 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 28/38] btrfs: make btrfs_free_io_failure_record take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:19 +0200
Message-Id: <1487342609-20652-29-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 fs/btrfs/extent_io.h | 2 +-
 fs/btrfs/inode.c     | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 16860ab7cb5e..aecc3d87255e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2151,9 +2151,9 @@ int clean_io_failure(struct btrfs_inode *inode, u64 start, struct page *page,
  * - under ordered extent
  * - the inode is freeing
  */
-void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end)
+void btrfs_free_io_failure_record(struct btrfs_inode *inode, u64 start, u64 end)
 {
-	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
+	struct extent_io_tree *failure_tree = &inode->io_failure_tree;
 	struct io_failure_record *failrec;
 	struct extent_state *state, *next;
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 81c9f678ada5..a6150f1be662 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -482,7 +482,7 @@ struct io_failure_record {
 };
 
 
-void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end);
+void btrfs_free_io_failure_record(struct btrfs_inode *inode, u64 start, u64 end);
 int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
 				struct io_failure_record **failrec_ret);
 int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a472d13a9ecb..52387c033e3f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2806,7 +2806,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		goto out;
 	}
 
-	btrfs_free_io_failure_record(inode, ordered_extent->file_offset,
+	btrfs_free_io_failure_record(BTRFS_I(inode), ordered_extent->file_offset,
 				     ordered_extent->file_offset +
 				     ordered_extent->len - 1);
 
@@ -5190,7 +5190,7 @@ void btrfs_evict_inode(struct inode *inode)
 	if (!special_file(inode->i_mode))
 		btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
-	btrfs_free_io_failure_record(inode, 0, (u64)-1);
+	btrfs_free_io_failure_record(BTRFS_I(inode), 0, (u64)-1);
 
 	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags)) {
 		BUG_ON(test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-- 
2.7.4

