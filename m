Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39448 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751062AbdEaRuX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 13:50:23 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C8C64AAB6
        for <linux-btrfs@vger.kernel.org>; Wed, 31 May 2017 17:50:21 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/5] btrfs: replace opencoded kvzalloc with the helper
Date: Wed, 31 May 2017 19:49:21 +0200
Message-Id: <002ad26cc203ff949f1da74733766e20f9111b94.1496252765.git.dsterba@suse.com>
In-Reply-To: <cover.1496252765.git.dsterba@suse.com>
References: <cover.1496252765.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The logic of kmalloc and vmalloc fallback is open coded in
several places, we can now use the existing helper.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/check-integrity.c | 11 ++++-------
 fs/btrfs/raid56.c          | 11 ++++-------
 fs/btrfs/send.c            |  9 +++------
 3 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 6cabc8acee2a..5f8006e4de9d 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -94,7 +94,7 @@
 #include <linux/mutex.h>
 #include <linux/genhd.h>
 #include <linux/blkdev.h>
-#include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include <linux/string.h>
 #include "ctree.h"
 #include "disk-io.h"
@@ -2920,13 +2920,10 @@ int btrfsic_mount(struct btrfs_fs_info *fs_info,
 		       fs_info->sectorsize, PAGE_SIZE);
 		return -1;
 	}
-	state = kzalloc(sizeof(*state), GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
+	state = kvzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state) {
-		state = vzalloc(sizeof(*state));
-		if (!state) {
-			pr_info("btrfs check-integrity: vzalloc() failed!\n");
-			return -1;
-		}
+		pr_info("btrfs check-integrity: allocation failed!\n");
+		return -1;
 	}
 
 	if (!btrfsic_is_initialized) {
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index d8ea0eb76325..d68af3c61b49 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -31,7 +31,7 @@
 #include <linux/hash.h>
 #include <linux/list_sort.h>
 #include <linux/raid/xor.h>
-#include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
@@ -218,12 +218,9 @@ int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info)
 	 * of a failing mount.
 	 */
 	table_size = sizeof(*table) + sizeof(*h) * num_entries;
-	table = kzalloc(table_size, GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
-	if (!table) {
-		table = vzalloc(table_size);
-		if (!table)
-			return -ENOMEM;
-	}
+	table = kvzalloc(table_size, GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
 
 	spin_lock_init(&table->cache_lock);
 	INIT_LIST_HEAD(&table->stripe_cache);
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e8185c83f667..924b1d941b53 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6389,13 +6389,10 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 
 	alloc_size = sizeof(struct clone_root) * (arg->clone_sources_count + 1);
 
-	sctx->clone_roots = kzalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN);
+	sctx->clone_roots = kzalloc(alloc_size, GFP_KERNEL);
 	if (!sctx->clone_roots) {
-		sctx->clone_roots = vzalloc(alloc_size);
-		if (!sctx->clone_roots) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	alloc_size = arg->clone_sources_count * sizeof(*arg->clone_sources);
-- 
2.12.0

