Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:36707 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab3HOPL3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Aug 2013 11:11:29 -0400
Received: from pizpot.store ([192.168.43.236])
 by josoe.store (RZmta 31.40 OK) with ESMTP id 604766p7FEesyp
 for <linux-btrfs@vger.kernel.org>;
 Thu, 15 Aug 2013 17:11:24 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v8 6/8] Btrfs: introduce uuid-tree-gen field
Date: Thu, 15 Aug 2013 17:11:22 +0200
Message-Id: <8b1531ffe09c32b5699d4f64e8183add3ef5d1dc.1376575048.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1376575048.git.sbehrens@giantdisaster.de>
References: <cover.1376575048.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1376575048.git.sbehrens@giantdisaster.de>
References: <cover.1376575048.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to be able to detect the case that a filesystem is mounted
with an old kernel, add a uuid-tree-gen field like the free space
cache is doing it. It is part of the super block and written with
each commit. Old kernels do not know this field and don't update it.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h       | 5 ++++-
 fs/btrfs/transaction.c | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e6b71ad..f71d254 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -482,9 +482,10 @@ struct btrfs_super_block {
 	char label[BTRFS_LABEL_SIZE];
 
 	__le64 cache_generation;
+	__le64 uuid_tree_generation;
 
 	/* future expansion */
-	__le64 reserved[31];
+	__le64 reserved[30];
 	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
 } __attribute__ ((__packed__));
@@ -2893,6 +2894,8 @@ BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
 BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
 			 cache_generation, 64);
 BTRFS_SETGET_STACK_FUNCS(super_magic, struct btrfs_super_block, magic, 64);
+BTRFS_SETGET_STACK_FUNCS(super_uuid_tree_generation, struct btrfs_super_block,
+			 uuid_tree_generation, 64);
 
 static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 06ae6ef..32eb543 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1380,6 +1380,7 @@ static void update_super_roots(struct btrfs_root *root)
 	super->root_level = root_item->level;
 	if (btrfs_test_opt(root, SPACE_CACHE))
 		super->cache_generation = root_item->generation;
+	super->uuid_tree_generation = root_item->generation;
 }
 
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info)
-- 
1.8.3.4

