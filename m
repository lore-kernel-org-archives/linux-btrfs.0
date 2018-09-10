Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55120 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728021AbeIJWRv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 18:17:51 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00DAAAF44
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 17:22:44 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: tests: move testing members of struct btrfs_root to the end
Date: Mon, 10 Sep 2018 19:22:26 +0200
Message-Id: <f8b15d6ea41fc91c7e8608352cd242722c4c1b3b.1536599879.git.dsterba@suse.com>
In-Reply-To: <cover.1536599879.git.dsterba@suse.com>
References: <cover.1536599879.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The data used only for tests are better placed at the end of the
structure so that they don't change the structure layout. All new
members of btrfs_root should be placed before.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 45b7029d0f23..ee05857cc8ac 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1203,11 +1203,6 @@ struct btrfs_root {
 
 	u64 highest_objectid;
 
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	/* only used with CONFIG_BTRFS_FS_RUN_SANITY_TESTS is enabled */
-	u64 alloc_bytenr;
-#endif
-
 	u64 defrag_trans_start;
 	struct btrfs_key defrag_progress;
 	struct btrfs_key defrag_max;
@@ -1280,6 +1275,10 @@ struct btrfs_root {
 	spinlock_t qgroup_meta_rsv_lock;
 	u64 qgroup_meta_rsv_pertrans;
 	u64 qgroup_meta_rsv_prealloc;
+
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	u64 alloc_bytenr;
+#endif
 };
 
 struct btrfs_file_private {
-- 
2.18.0
