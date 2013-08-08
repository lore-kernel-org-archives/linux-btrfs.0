Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48323 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab3HHVpz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 17:45:55 -0400
Received: by mail-wg0-f50.google.com with SMTP id m15so3058924wgh.29
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Aug 2013 14:45:54 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: set default max_inline to 8KiB instead of 8MiB
Date: Thu,  8 Aug 2013 22:45:48 +0100
Message-Id: <1375998348-20639-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

8MiB is way too large and likely set by mistake. This is not
a significant issue as in practice the max amount of data
added to an inline extent is also limited by the page cache
and btree leaf sizes.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/disk-io.c |    2 +-
 fs/btrfs/disk-io.h |    2 ++
 fs/btrfs/super.c   |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5de9ad7..aff37bd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2189,7 +2189,7 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->defrag_running, 0);
 	atomic64_set(&fs_info->tree_mod_seq, 0);
 	fs_info->sb = sb;
-	fs_info->max_inline = 8192 * 1024;
+	fs_info->max_inline = BTRFS_DEFAULT_MAX_INLINE;
 	fs_info->metadata_ratio = 0;
 	fs_info->defrag_inodes = RB_ROOT;
 	fs_info->free_chunk_space = 0;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index b71acd6e..e76c1a2 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -25,6 +25,8 @@
 #define BTRFS_SUPER_MIRROR_MAX	 3
 #define BTRFS_SUPER_MIRROR_SHIFT 12
 
+#define BTRFS_DEFAULT_MAX_INLINE 8192
+
 enum {
 	BTRFS_WQ_ENDIO_DATA = 0,
 	BTRFS_WQ_ENDIO_METADATA = 1,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1967903..7359a9e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -941,7 +941,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",nodatacow");
 	if (btrfs_test_opt(root, NOBARRIER))
 		seq_puts(seq, ",nobarrier");
-	if (info->max_inline != 8192 * 1024)
+	if (info->max_inline != BTRFS_DEFAULT_MAX_INLINE)
 		seq_printf(seq, ",max_inline=%llu",
 			   (unsigned long long)info->max_inline);
 	if (info->alloc_start != 0)
-- 
1.7.9.5

