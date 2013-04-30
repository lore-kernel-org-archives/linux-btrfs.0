Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760826Ab3D3QwR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 12:52:17 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3583DA5359
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 18:52:16 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/3] btrfs: move ifdef around sanity checks out of init_btrfs_fs
Date: Tue, 30 Apr 2013 18:51:58 +0200
Message-Id: <73933128ae8fbbd185d1a33f1a53a49bfccb4738.1367339998.git.dsterba@suse.cz>
In-Reply-To: <cover.1367339998.git.dsterba@suse.cz>
References: <cover.1367339998.git.dsterba@suse.cz>
In-Reply-To: <cover.1367339998.git.dsterba@suse.cz>
References: <cover.1367339998.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/free-space-cache.c |    4 +++-
 fs/btrfs/free-space-cache.h |    2 --
 fs/btrfs/super.c            |    2 --
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 3808303..d61eae9 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3493,4 +3493,6 @@ out:
 	test_msg("Free space cache tests finished\n");
 }
 #undef test_msg
-#endif /* CONFIG_BTRFS_FS_RUN_SANITY_TESTS */
+#else /* !CONFIG_BTRFS_FS_RUN_SANITY_TESTS */
+void btrfs_test_free_space_cache(void) {}
+#endif /* !CONFIG_BTRFS_FS_RUN_SANITY_TESTS */
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 4dc17d8..37a3447 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -111,8 +111,6 @@ int btrfs_return_cluster_to_free_space(
 int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 			   u64 *trimmed, u64 start, u64 end, u64 minlen);
 
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_free_space_cache(void);
-#endif
 
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a4807ce..0a51ed3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1732,9 +1732,7 @@ static int __init init_btrfs_fs(void)
 
 	btrfs_init_lockdep();
 
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	btrfs_test_free_space_cache();
-#endif
 
 	printk(KERN_INFO "%s loaded\n", BTRFS_BUILD_VERSION);
 	return 0;
-- 
1.7.9


