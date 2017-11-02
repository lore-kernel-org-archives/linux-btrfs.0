Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36067 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934556AbdKCAYA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 20:24:00 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA30Nx9e026987
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 3 Nov 2017 00:23:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA30NwIJ029745
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 3 Nov 2017 00:23:59 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA30Nw5L005806
        for <linux-btrfs@vger.kernel.org>; Fri, 3 Nov 2017 00:23:58 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: add __init macro to btrfs init function
Date: Thu,  2 Nov 2017 17:21:50 -0600
Message-Id: <20171102232150.20522-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adding __init macro gives kernel a hint that this function is only
used during the initialization phase and its memory resources can be
freed up after.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/compression.h | 2 +-
 fs/btrfs/ctree.h       | 6 +++---
 fs/btrfs/delayed-ref.c | 2 +-
 fs/btrfs/delayed-ref.h | 2 +-
 fs/btrfs/file.c        | 2 +-
 fs/btrfs/inode.c       | 2 +-
 fs/btrfs/super.c       | 4 ++--
 fs/btrfs/sysfs.c       | 2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index dc45b94..936b046 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -73,7 +73,7 @@ struct compressed_bio {
 	u32 sums;
 };
 
-void btrfs_init_compress(void);
+void __init btrfs_init_compress(void);
 void btrfs_exit_compress(void);
 
 int btrfs_compress_pages(int type, struct address_space *mapping,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8fc6903..c652ffc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3190,7 +3190,7 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc);
 struct inode *btrfs_alloc_inode(struct super_block *sb);
 void btrfs_destroy_inode(struct inode *inode);
 int btrfs_drop_inode(struct inode *inode);
-int btrfs_init_cachep(void);
+int __init btrfs_init_cachep(void);
 void btrfs_destroy_cachep(void);
 long btrfs_ioctl_trans_end(struct file *file);
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
@@ -3241,7 +3241,7 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
 			   struct file *dst_file, u64 dst_loff);
 
 /* file.c */
-int btrfs_auto_defrag_init(void);
+int __init btrfs_auto_defrag_init(void);
 void btrfs_auto_defrag_exit(void);
 int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 			   struct btrfs_inode *inode);
@@ -3276,7 +3276,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root);
 
 /* sysfs.c */
-int btrfs_init_sysfs(void);
+int __init btrfs_init_sysfs(void);
 void btrfs_exit_sysfs(void);
 int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info);
 void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 93ffa89..3ff772f 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -947,7 +947,7 @@ void btrfs_delayed_ref_exit(void)
 	kmem_cache_destroy(btrfs_delayed_extent_op_cachep);
 }
 
-int btrfs_delayed_ref_init(void)
+int __init btrfs_delayed_ref_init(void)
 {
 	btrfs_delayed_ref_head_cachep = kmem_cache_create(
 				"btrfs_delayed_ref_head",
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index ce88e4a..3afff23 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -204,7 +204,7 @@ extern struct kmem_cache *btrfs_delayed_tree_ref_cachep;
 extern struct kmem_cache *btrfs_delayed_data_ref_cachep;
 extern struct kmem_cache *btrfs_delayed_extent_op_cachep;
 
-int btrfs_delayed_ref_init(void);
+int __init btrfs_delayed_ref_init(void);
 void btrfs_delayed_ref_exit(void);
 
 static inline struct btrfs_delayed_extent_op *
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index aafcc78..e43da6c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3143,7 +3143,7 @@ void btrfs_auto_defrag_exit(void)
 	kmem_cache_destroy(btrfs_inode_defrag_cachep);
 }
 
-int btrfs_auto_defrag_init(void)
+int __init btrfs_auto_defrag_init(void)
 {
 	btrfs_inode_defrag_cachep = kmem_cache_create("btrfs_inode_defrag",
 					sizeof(struct inode_defrag), 0,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9a2bdd9..1635b0f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9655,7 +9655,7 @@ void btrfs_destroy_cachep(void)
 	kmem_cache_destroy(btrfs_free_space_cachep);
 }
 
-int btrfs_init_cachep(void)
+int __init btrfs_init_cachep(void)
 {
 	btrfs_inode_cachep = kmem_cache_create("btrfs_inode",
 			sizeof(struct btrfs_inode), 0,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 161694b..a31281e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2297,7 +2297,7 @@ static struct miscdevice btrfs_misc = {
 MODULE_ALIAS_MISCDEV(BTRFS_MINOR);
 MODULE_ALIAS("devname:btrfs-control");
 
-static int btrfs_interface_init(void)
+static int __init btrfs_interface_init(void)
 {
 	return misc_register(&btrfs_misc);
 }
@@ -2307,7 +2307,7 @@ static void btrfs_interface_exit(void)
 	misc_deregister(&btrfs_misc);
 }
 
-static void btrfs_print_mod_info(void)
+static void __init btrfs_print_mod_info(void)
 {
 	pr_info("Btrfs loaded, crc32c=%s"
 #ifdef CONFIG_BTRFS_DEBUG
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 883881b..4dd83dd 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -896,7 +896,7 @@ static int btrfs_init_debugfs(void)
 	return 0;
 }
 
-int btrfs_init_sysfs(void)
+int __init btrfs_init_sysfs(void)
 {
 	int ret;
 
-- 
2.9.4

