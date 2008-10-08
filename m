From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Progs: Count space allocated to file in bytes
Date: Wed, 08 Oct 2008 15:51:22 +0800
Message-ID: <48EC667A.1030408@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch updates btrfs-progs for counting space
allocated to file in bytes.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff --git a/ctree.h b/ctree.h
index fe5f2bf..cc5e0c7 100644
--- a/ctree.h
+++ b/ctree.h
@@ -388,7 +388,7 @@ struct btrfs_inode_item {
 	/* transid that last touched this inode */
 	__le64 transid;
 	__le64 size;
-	__le64 nblocks;
+	__le64 nbytes;
 	__le64 block_group;
 	__le32 nlink;
 	__le32 uid;
@@ -829,7 +829,7 @@ BTRFS_SETGET_FUNCS(inode_ref_index, struct btrfs_inode_ref, index, 64);
 BTRFS_SETGET_FUNCS(inode_generation, struct btrfs_inode_item, generation, 64);
 BTRFS_SETGET_FUNCS(inode_transid, struct btrfs_inode_item, transid, 64);
 BTRFS_SETGET_FUNCS(inode_size, struct btrfs_inode_item, size, 64);
-BTRFS_SETGET_FUNCS(inode_nblocks, struct btrfs_inode_item, nblocks, 64);
+BTRFS_SETGET_FUNCS(inode_nbytes, struct btrfs_inode_item, nbytes, 64);
 BTRFS_SETGET_FUNCS(inode_block_group, struct btrfs_inode_item, block_group, 64);
 BTRFS_SETGET_FUNCS(inode_nlink, struct btrfs_inode_item, nlink, 32);
 BTRFS_SETGET_FUNCS(inode_uid, struct btrfs_inode_item, uid, 32);
@@ -844,8 +844,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_inode_generation,
 			 struct btrfs_inode_item, generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_size,
 			 struct btrfs_inode_item, size, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_nblocks,
-			 struct btrfs_inode_item, nblocks, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_nbytes,
+			 struct btrfs_inode_item, nbytes, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_block_group,
 			 struct btrfs_inode_item, block_group, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_nlink,
diff --git a/utils.c b/utils.c
index 99223fb..d1304bc 100644
--- a/utils.c
+++ b/utils.c
@@ -126,7 +126,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_stack_inode_generation(inode_item, 1);
 	btrfs_set_stack_inode_size(inode_item, 3);
 	btrfs_set_stack_inode_nlink(inode_item, 1);
-	btrfs_set_stack_inode_nblocks(inode_item, 1);
+	btrfs_set_stack_inode_nbytes(inode_item, leafsize);
 	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
 	btrfs_set_root_refs(&root_item, 1);
 	btrfs_set_root_used(&root_item, leafsize);
@@ -544,7 +544,7 @@ int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_inode_generation(&inode_item, trans->transid);
 	btrfs_set_stack_inode_size(&inode_item, 0);
 	btrfs_set_stack_inode_nlink(&inode_item, 1);
-	btrfs_set_stack_inode_nblocks(&inode_item, 1);
+	btrfs_set_stack_inode_nbytes(&inode_item, root->leafsize);
 	btrfs_set_stack_inode_mode(&inode_item, S_IFDIR | 0555);
 
 	if (root->fs_info->tree_root == root)
