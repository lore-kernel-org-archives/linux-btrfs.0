Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34999 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934311AbdBQOnz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:43:55 -0500
Received: by mail-wr0-f196.google.com with SMTP id q39so5486632wrb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:43:55 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 07/38] btrfs: make btrfs_alloc_data_chunk_ondemand take btrfs_inode
Date: Fri, 17 Feb 2017 16:42:58 +0200
Message-Id: <1487342609-20652-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 2 +-
 fs/btrfs/extent-tree.c | 8 ++++----
 fs/btrfs/file.c        | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8ab0ce65a218..76e661d00822 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2687,7 +2687,7 @@ enum btrfs_flush_state {
 };
 
 int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len);
-int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes);
+int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 start, u64 len);
 void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
 					    u64 len);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 883819c5abc0..293ca5d34d44 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4135,10 +4135,10 @@ static u64 btrfs_space_info_used(struct btrfs_space_info *s_info,
 		(may_use_included ? s_info->bytes_may_use : 0);
 }
 
-int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes)
+int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 {
 	struct btrfs_space_info *data_sinfo;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 used;
 	int ret = 0;
@@ -4148,7 +4148,7 @@ int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes)
 	/* make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, fs_info->sectorsize);
 
-	if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
+	if (btrfs_is_free_space_inode(inode)) {
 		need_commit = 0;
 		ASSERT(current->journal_info);
 	}
@@ -4281,7 +4281,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
 	      round_down(start, fs_info->sectorsize);
 	start = round_down(start, fs_info->sectorsize);
 
-	ret = btrfs_alloc_data_chunk_ondemand(inode, len);
+	ret = btrfs_alloc_data_chunk_ondemand(BTRFS_I(inode), len);
 	if (ret < 0)
 		return ret;
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 18e5146df864..7cdaafff4764 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2747,7 +2747,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	 *
 	 * For qgroup space, it will be checked later.
 	 */
-	ret = btrfs_alloc_data_chunk_ondemand(inode, alloc_end - alloc_start);
+	ret = btrfs_alloc_data_chunk_ondemand(BTRFS_I(inode), alloc_end - alloc_start);
 	if (ret < 0)
 		return ret;
 
-- 
2.7.4

