Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58082 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751445AbeCPNyf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 09:54:35 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH] Revert "btrfs: use proper endianness accessors for super_copy"
Date: Fri, 16 Mar 2018 14:51:54 +0100
Message-Id: <20180316135154.31682-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 3c181c12c431fe33b669410d663beb9cceefcd1b.

The offending patch was merged in 4.16-rc4 and was promptly applied to
stable kernels 4.14.25 and 4.15.8.

The patch causes a corruption in several superblock items on big-endian
machines because of messed up endianity conversions. The damage is
manually repairable. A filesystem cannot be mounted again after it has
been unmounted once.

We do a full revert and not a fixup so stable can pick that patch ASAP.

Fixes: 3c181c12c431 ("btrfs: use proper endianness accessors for super_copy")
Link: https://lkml.kernel.org/r/1521139304@msgid.manchmal.in-ulm.de
CC: stable@vger.kernel.org # 4.14+
Reported-by: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c       |  8 +++++---
 fs/btrfs/transaction.c | 20 ++++++++------------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index d11c70bff5a9..a8bafed931f4 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -423,7 +423,7 @@ static ssize_t btrfs_nodesize_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->nodesize);
+	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->nodesize);
 }
 
 BTRFS_ATTR(, nodesize, btrfs_nodesize_show);
@@ -433,7 +433,8 @@ static ssize_t btrfs_sectorsize_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->sectorsize);
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			fs_info->super_copy->sectorsize);
 }
 
 BTRFS_ATTR(, sectorsize, btrfs_sectorsize_show);
@@ -443,7 +444,8 @@ static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->sectorsize);
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			fs_info->super_copy->sectorsize);
 }
 
 BTRFS_ATTR(, clone_alignment, btrfs_clone_alignment_show);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 9220f004001c..04f07144b45c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1722,23 +1722,19 @@ static void update_super_roots(struct btrfs_fs_info *fs_info)
 
 	super = fs_info->super_copy;
 
-	/* update latest btrfs_super_block::chunk_root refs */
 	root_item = &fs_info->chunk_root->root_item;
-	btrfs_set_super_chunk_root(super, root_item->bytenr);
-	btrfs_set_super_chunk_root_generation(super, root_item->generation);
-	btrfs_set_super_chunk_root_level(super, root_item->level);
+	super->chunk_root = root_item->bytenr;
+	super->chunk_root_generation = root_item->generation;
+	super->chunk_root_level = root_item->level;
 
-	/* update latest btrfs_super_block::root refs */
 	root_item = &fs_info->tree_root->root_item;
-	btrfs_set_super_root(super, root_item->bytenr);
-	btrfs_set_super_generation(super, root_item->generation);
-	btrfs_set_super_root_level(super, root_item->level);
-
+	super->root = root_item->bytenr;
+	super->generation = root_item->generation;
+	super->root_level = root_item->level;
 	if (btrfs_test_opt(fs_info, SPACE_CACHE))
-		btrfs_set_super_cache_generation(super, root_item->generation);
+		super->cache_generation = root_item->generation;
 	if (test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags))
-		btrfs_set_super_uuid_tree_generation(super,
-						     root_item->generation);
+		super->uuid_tree_generation = root_item->generation;
 }
 
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info)
-- 
2.16.2

