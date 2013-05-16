Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:62530 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab3EPOp7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 10:45:59 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.27 OK)
	with ESMTP id X03fadp4G8aoMS for <linux-btrfs@vger.kernel.org>;
	Thu, 16 May 2013 16:45:58 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 4/4] Btrfs-progs: add uuid_tree_gen field to btrfs-show-super
Date: Thu, 16 May 2013 16:45:58 +0200
Message-Id: <5f3bd8df48692667d3983b62e2a83a5dc3829679.1368713962.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368713962.git.sbehrens@giantdisaster.de>
References: <cover.1368713962.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368713962.git.sbehrens@giantdisaster.de>
References: <cover.1368713962.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 btrfs-show-super.c | 2 ++
 ctree.h            | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index f587f10..c815469 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -247,6 +247,8 @@ static void dump_superblock(struct btrfs_super_block *sb)
 	       (unsigned long long)btrfs_super_csum_size(sb));
 	printf("cache_generation\t%llu\n",
 	       (unsigned long long)btrfs_super_cache_generation(sb));
+	printf("uuid_tree_generation\t%llu\n",
+	       (unsigned long long)btrfs_super_uuid_tree_generation(sb));
 
 	uuid_unparse(sb->dev_item.uuid, buf);
 	printf("dev_item.uuid\t\t%s\n", buf);
diff --git a/ctree.h b/ctree.h
index e36cb17..cf068b1 100644
--- a/ctree.h
+++ b/ctree.h
@@ -437,9 +437,10 @@ struct btrfs_super_block {
 	char label[BTRFS_LABEL_SIZE];
 
 	__le64 cache_generation;
+	__le64 uuid_tree_generation;
 
 	/* future expansion */
-	__le64 reserved[31];
+	__le64 reserved[30];
 	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
 } __attribute__ ((__packed__));
@@ -1941,6 +1942,8 @@ BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
 			 csum_type, 16);
 BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
 			 cache_generation, 64);
+BTRFS_SETGET_STACK_FUNCS(super_uuid_tree_generation, struct btrfs_super_block,
+			 uuid_tree_generation, 64);
 
 static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 {
-- 
1.8.2.3

