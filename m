Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55132 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728021AbeIJWRx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 18:17:53 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4B802AF44
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 17:22:46 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: tests: group declarations of self-test helpers
Date: Mon, 10 Sep 2018 19:22:29 +0200
Message-Id: <f97be987031016b1f48e819261aa69db2c609647.1536599879.git.dsterba@suse.com>
In-Reply-To: <cover.1536599879.git.dsterba@suse.com>
References: <cover.1536599879.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ee05857cc8ac..32d2fce4ac53 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3194,9 +3194,6 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
 				    u64 start, u64 num_bytes, u64 min_size,
 				    loff_t actual_len, u64 *alloc_hint);
 extern const struct dentry_operations btrfs_dentry_operations;
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-void btrfs_test_inode_set_ops(struct inode *inode);
-#endif
 
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
@@ -3709,6 +3706,7 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
 
 /* Sanity test specific functions */
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+void btrfs_test_inode_set_ops(struct inode *inode);
 void btrfs_test_destroy_inode(struct inode *inode);
 #endif
 
-- 
2.18.0
