Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28647 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752282AbdHMD4B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 23:56:01 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/4] btrfs: convert enum btrfs_compression_type to define
Date: Sun, 13 Aug 2017 12:02:42 +0800
Message-Id: <20170813040244.18841-3-anand.jain@oracle.com>
In-Reply-To: <20170813040244.18841-1-anand.jain@oracle.com>
References: <20170813040244.18841-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There isn't a huge list to manage the types, which can be managed
with defines. It helps to easily print the types in tracing as well.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/compression.h          | 7 -------
 fs/btrfs/super.c                | 2 +-
 include/uapi/linux/btrfs_tree.h | 5 +++++
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index e749df6dd39a..f28a501e7828 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -95,13 +95,6 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags);
 
-enum btrfs_compression_type {
-	BTRFS_COMPRESS_NONE  = 0,
-	BTRFS_COMPRESS_ZLIB  = 1,
-	BTRFS_COMPRESS_LZO   = 2,
-	BTRFS_COMPRESS_TYPES = 2,
-};
-
 struct btrfs_compress_op {
 	struct list_head *(*alloc_workspace)(void);
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 12540b6104b5..b711357352f8 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -404,7 +404,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 	int ret = 0;
 	char *compress_type;
 	bool compress_force = false;
-	enum btrfs_compression_type saved_compress_type;
+	unsigned int saved_compress_type;
 	bool saved_compress_force;
 	int no_compress = 0;
 
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 10689e1fdf11..7a1fec2d10ab 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -733,6 +733,11 @@ struct btrfs_balance_item {
 #define BTRFS_FILE_EXTENT_REG 1
 #define BTRFS_FILE_EXTENT_PREALLOC 2
 
+#define BTRFS_COMPRESS_NONE	0
+#define BTRFS_COMPRESS_TYPES	2
+#define BTRFS_COMPRESS_ZLIB	1
+#define BTRFS_COMPRESS_LZO	2
+
 struct btrfs_file_extent_item {
 	/*
 	 * transaction id that created this extent
-- 
2.13.1

