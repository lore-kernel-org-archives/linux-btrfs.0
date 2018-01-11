Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54301 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753809AbeAKFKK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:10 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1C44C48AEA0A
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:54 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 09/67] btrfs-progs: add the stack prefix for root_level set/get function
Date: Thu, 11 Jan 2018 13:08:41 +0800
Message-ID: <20180111050939.21251-10-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_level set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 backref.c      |  2 +-
 cmds-check.c   | 10 +++++-----
 cmds-restore.c |  2 +-
 convert/main.c |  2 +-
 ctree.h        |  2 +-
 mkfs/main.c    |  2 +-
 print-tree.c   |  2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/backref.c b/backref.c
index 27309e07..171da777 100644
--- a/backref.c
+++ b/backref.c
@@ -332,7 +332,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
-	root_level = btrfs_root_level(&root->root_item);
+	root_level = btrfs_stack_root_level(&root->root_item);
 
 	if (root_level + 1 == level)
 		goto out;
diff --git a/cmds-check.c b/cmds-check.c
index 3c366109..cd2ad5f4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11541,7 +11541,7 @@ again:
 			last_snapshot = btrfs_root_last_snapshot(&ri);
 			if (btrfs_stack_disk_key_objectid(&ri.drop_progress)
 					== 0) {
-				level = btrfs_root_level(&ri);
+				level = btrfs_stack_root_level(&ri);
 				ret = add_root_item_to_list(&normal_trees,
 						found_key.objectid,
 						btrfs_stack_root_bytenr(&ri),
@@ -11550,7 +11550,7 @@ again:
 				if (ret < 0)
 					goto out;
 			} else {
-				level = btrfs_root_level(&ri);
+				level = btrfs_stack_root_level(&ri);
 				objectid = found_key.objectid;
 				btrfs_disk_key_to_cpu(&found_key,
 						      &ri.drop_progress);
@@ -14377,7 +14377,7 @@ static int maybe_repair_root_item(struct btrfs_path *path,
 	read_extent_buffer(path->nodes[0], &ri, offset, sizeof(ri));
 
 	if (btrfs_stack_root_bytenr(&ri) != rii->bytenr ||
-	    btrfs_root_level(&ri) != rii->level ||
+	    btrfs_stack_root_level(&ri) != rii->level ||
 	    btrfs_stack_root_generation(&ri) != rii->gen) {
 
 		/*
@@ -14396,7 +14396,7 @@ static int maybe_repair_root_item(struct btrfs_path *path,
 				root_id,
 				btrfs_stack_root_bytenr(&ri),
 				btrfs_stack_root_generation(&ri),
-				btrfs_root_level(&ri),
+				btrfs_stack_root_level(&ri),
 				rii->bytenr, rii->gen, rii->level);
 
 		if (btrfs_stack_root_generation(&ri) > rii->gen) {
@@ -14409,7 +14409,7 @@ static int maybe_repair_root_item(struct btrfs_path *path,
 
 		if (!read_only_mode) {
 			btrfs_set_stack_root_bytenr(&ri, rii->bytenr);
-			btrfs_set_root_level(&ri, rii->level);
+			btrfs_set_stack_root_level(&ri, rii->level);
 			btrfs_set_stack_root_generation(&ri, rii->gen);
 			write_extent_buffer(path->nodes[0], &ri,
 					    offset, sizeof(ri));
diff --git a/cmds-restore.c b/cmds-restore.c
index 2f72fbbf..37368766 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1264,7 +1264,7 @@ static int do_list_roots(struct btrfs_root *root)
 		printf(" tree ");
 		btrfs_print_key(&disk_key);
 		printf(" %Lu level %d\n", btrfs_stack_root_bytenr(&ri),
-		       btrfs_root_level(&ri));
+		       btrfs_stack_root_level(&ri));
 		path.slots[0]++;
 	}
 	btrfs_release_path(&path);
diff --git a/convert/main.c b/convert/main.c
index 8f0921c0..7453077a 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -854,7 +854,7 @@ static int create_subvol(struct btrfs_trans_handle *trans,
 
 	memcpy(&root_item, &root->root_item, sizeof(root_item));
 	btrfs_set_stack_root_bytenr(&root_item, tmp->start);
-	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
+	btrfs_set_stack_root_level(&root_item, btrfs_header_level(tmp));
 	btrfs_set_stack_root_generation(&root_item, trans->transid);
 	free_extent_buffer(tmp);
 
diff --git a/ctree.h b/ctree.h
index f27326bb..d954c032 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2054,7 +2054,7 @@ BTRFS_SETGET_FUNCS(disk_root_level, struct btrfs_root_item, level, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_root_generation, struct btrfs_root_item,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_root_bytenr, struct btrfs_root_item, bytenr, 64);
-BTRFS_SETGET_STACK_FUNCS(root_level, struct btrfs_root_item, level, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_root_level, struct btrfs_root_item, level, 8);
 BTRFS_SETGET_STACK_FUNCS(root_dirid, struct btrfs_root_item, root_dirid, 64);
 BTRFS_SETGET_STACK_FUNCS(root_refs, struct btrfs_root_item, refs, 32);
 BTRFS_SETGET_STACK_FUNCS(root_flags, struct btrfs_root_item, flags, 64);
diff --git a/mkfs/main.c b/mkfs/main.c
index cda0c65b..ae237e14 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -337,7 +337,7 @@ static int create_tree(struct btrfs_trans_handle *trans,
 
 	memcpy(&root_item, &root->root_item, sizeof(root_item));
 	btrfs_set_stack_root_bytenr(&root_item, tmp->start);
-	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
+	btrfs_set_stack_root_level(&root_item, btrfs_header_level(tmp));
 	btrfs_set_stack_root_generation(&root_item, trans->transid);
 	free_extent_buffer(tmp);
 
diff --git a/print-tree.c b/print-tree.c
index 6f5f362b..741fc9a9 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -591,7 +591,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 		(unsigned long long)btrfs_stack_root_generation(&root_item),
 		(unsigned long long)btrfs_root_dirid(&root_item),
 		(unsigned long long)btrfs_stack_root_bytenr(&root_item),
-		btrfs_root_level(&root_item),
+		btrfs_stack_root_level(&root_item),
 		btrfs_root_refs(&root_item));
 	printf("\t\tlastsnap %llu byte_limit %llu bytes_used %llu flags 0x%llx(%s)\n",
 		(unsigned long long)btrfs_root_last_snapshot(&root_item),
-- 
2.15.1



