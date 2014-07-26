Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62355 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaGZQuA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Jul 2014 12:50:00 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so7366498pdj.14
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Jul 2014 09:50:00 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([223.65.36.6])
        by mx.google.com with ESMTPSA id ml5sm46335498pab.10.2014.07.26.09.49.58
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Jul 2014 09:49:59 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix some build warnings on 32bit platform
Date: Sun, 27 Jul 2014 00:49:55 +0800
Message-Id: <1406393395-4317-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix following build warnings on 32bit platform:

...
utils.c:1708:3: warning: left shift count >= width of
type [enabled by default]
   if (x << i & (1UL << 63))
   ^
qgroup-verify.c:393:9: warning: cast to pointer from integer
of different size [-Wint-to-pointer-cast]
  return (struct tree_block *)unode->aux;
         ^
qgroup-verify.c:407:38: warning: cast from pointer to integer
of different size [-Wpointer-to-int-cast]
   if (ulist_add(tree_blocks, bytenr, (unsigned long long)block, 0) >= 0)
                                      ^
cmds-restore.c:120:4: warning: format %lu expects argument of type
long unsigned int, but argument 3 has type size_t [-Wformat=]
    fprintf(stderr, "bad compress length %lu\n", in_len);
...

BTW, this patch also switches other castings with new helpers.

Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
---
 cmds-inspect.c  | 4 ++--
 cmds-restore.c  | 2 +-
 extent-tree.c   | 3 +--
 kerncompat.h    | 4 ++++
 qgroup-verify.c | 4 ++--
 utils.c         | 2 +-
 6 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index cd9d2c6..c6c17a5 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -49,7 +49,7 @@ static int __ino_to_path_fd(u64 inum, int fd, int verbose, const char *prepend)
 	memset(fspath, 0, sizeof(*fspath));
 	ipa.inum = inum;
 	ipa.size = 4096;
-	ipa.fspath = (uintptr_t)fspath;
+	ipa.fspath = ptr_to_u64(fspath);
 
 	ret = ioctl(fd, BTRFS_IOC_INO_PATHS, &ipa);
 	if (ret) {
@@ -185,7 +185,7 @@ static int cmd_logical_resolve(int argc, char **argv)
 	memset(inodes, 0, sizeof(*inodes));
 	loi.logical = arg_strtou64(argv[optind]);
 	loi.size = size;
-	loi.inodes = (uintptr_t)inodes;
+	loi.inodes = ptr_to_u64(inodes);
 
 	fd = open_file_or_dir(argv[optind+1], &dirstream);
 	if (fd < 0) {
diff --git a/cmds-restore.c b/cmds-restore.c
index 3465f84..abd9773 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -117,7 +117,7 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 		in_len = read_compress_length(inbuf);
 
 		if ((tot_in + LZO_LEN + in_len) > tot_len) {
-			fprintf(stderr, "bad compress length %lu\n", in_len);
+			fprintf(stderr, "bad compress length %u\n", in_len);
 			return -1;
 		}
 
diff --git a/extent-tree.c b/extent-tree.c
index 7979457..c46c92b 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3090,8 +3090,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 			break;
 		ret = get_state_private(&info->block_group_cache, start, &ptr);
 		if (!ret) {
-			cache = (struct btrfs_block_group_cache *)
-					(uintptr_t)ptr;
+			cache = u64_to_ptr(ptr);
 			if (cache->free_space_ctl) {
 				btrfs_remove_free_space_cache(cache);
 				kfree(cache->free_space_ctl);
diff --git a/kerncompat.h b/kerncompat.h
index 652275e..bb03194 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -28,6 +28,10 @@
 #include <assert.h>
 #include <stddef.h>
 #include <linux/types.h>
+#include <stdint.h>
+
+#define ptr_to_u64(x)	((u64)(uintptr_t)x)
+#define u64_to_ptr(x)	((void *)(uintptr_t)x)
 
 #ifndef READ
 #define READ 0
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 2e1716d..a5bd4f8 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -390,7 +390,7 @@ static u64 resolve_one_root(u64 bytenr)
 
 static inline struct tree_block *unode_tree_block(struct ulist_node *unode)
 {
-	return (struct tree_block *)unode->aux;
+	return u64_to_ptr(unode->aux);
 }
 static inline u64 unode_bytenr(struct ulist_node *unode)
 {
@@ -404,7 +404,7 @@ static int alloc_tree_block(u64 bytenr, u64 num_bytes, int level)
 	if (block) {
 		block->num_bytes = num_bytes;
 		block->level = level;
-		if (ulist_add(tree_blocks, bytenr, (unsigned long long)block, 0) >= 0)
+		if (ulist_add(tree_blocks, bytenr, ptr_to_u64(block), 0) >= 0)
 			return 0;
 		free(block);
 	}
diff --git a/utils.c b/utils.c
index 11250d9..241e5ff 100644
--- a/utils.c
+++ b/utils.c
@@ -1705,7 +1705,7 @@ static int fls64(u64 x)
 	int i;
 
 	for (i = 0; i <64; i++)
-		if (x << i & (1UL << 63))
+		if (x << i & (1ULL << 63))
 			return 64 - i;
 	return 64 - i;
 }
-- 
1.8.3.1

