Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726902AbeINV5Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 17:57:25 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: osandov@osandov.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4 v2] btrfs: tests: polish ifdefs around testing helper
Date: Fri, 14 Sep 2018 18:42:03 +0200
Message-Id: <20180914164203.19235-1-dsterba@suse.com>
In-Reply-To: <20180911191447.GA26631@vader>
References: <20180911191447.GA26631@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Avoid the inline ifdefs and use two sections for self-tests enabled and
disabled.

Though there could be no ifdef and unconditional test_bit of
BTRFS_FS_STATE_DUMMY_FS_INFO, the static inline can help to optimize out
any code that would depend on conditions using btrfs_is_testing.

As this is only for the testing code, drop unlikely().

Signed-off-by: David Sterba <dsterba@suse.com>
---

v2:
- remove unlikely
- simplify to: return test_bit(...)

 fs/btrfs/ctree.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 32d2fce4ac53..1656ada9200b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3708,17 +3708,17 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_inode_set_ops(struct inode *inode);
 void btrfs_test_destroy_inode(struct inode *inode);
-#endif
 
 static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
 {
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	if (unlikely(test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO,
-			      &fs_info->fs_state)))
-		return 1;
-#endif
+	return test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO, &fs_info->fs_state);
+}
+#else
+static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
+{
 	return 0;
 }
+#endif
 
 static inline void cond_wake_up(struct wait_queue_head *wq)
 {
-- 
2.18.0
