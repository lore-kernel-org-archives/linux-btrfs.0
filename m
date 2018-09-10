Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55158 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728021AbeIJWR4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 18:17:56 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9CF45AF44
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 17:22:48 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: tests: polish ifdefs around testing helper
Date: Mon, 10 Sep 2018 19:22:31 +0200
Message-Id: <7a6c4814d8467999d9a9eb12906ff28a3f90b284.1536599879.git.dsterba@suse.com>
In-Reply-To: <cover.1536599879.git.dsterba@suse.com>
References: <cover.1536599879.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Avoid the inline ifdefs and use two sections for self-tests enabled and
disabled.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 32d2fce4ac53..8dafc7bb6ad8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3708,17 +3708,20 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_inode_set_ops(struct inode *inode);
 void btrfs_test_destroy_inode(struct inode *inode);
-#endif
 
 static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
 {
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	if (unlikely(test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO,
 			      &fs_info->fs_state)))
 		return 1;
-#endif
 	return 0;
 }
+#else
+static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
+{
+	return 0;
+}
+#endif
 
 static inline void cond_wake_up(struct wait_queue_head *wq)
 {
-- 
2.18.0
