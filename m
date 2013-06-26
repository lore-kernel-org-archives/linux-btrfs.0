Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:40915 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3FZPSA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 11:18:00 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp3) (RZmta 31.28 OK)
	with ESMTP id p06a59p5QF6WIL for <linux-btrfs@vger.kernel.org>;
	Wed, 26 Jun 2013 17:17:59 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 4/5] Btrfs-progs: add uuid_tree_gen field to btrfs-show-super
Date: Wed, 26 Jun 2013 17:17:58 +0200
Message-Id: <4c91a2534fe03dfc49921ea01cda3efb52fc25da.1372252739.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372252739.git.sbehrens@giantdisaster.de>
References: <cover.1372252739.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372252739.git.sbehrens@giantdisaster.de>
References: <cover.1372252739.git.sbehrens@giantdisaster.de>
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
index e4bca8f..1ae8715 100644
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
@@ -1933,6 +1934,8 @@ BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
 			 csum_type, 16);
 BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
 			 cache_generation, 64);
+BTRFS_SETGET_STACK_FUNCS(super_uuid_tree_generation, struct btrfs_super_block,
+			 uuid_tree_generation, 64);
 
 static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 {
-- 
1.8.3

