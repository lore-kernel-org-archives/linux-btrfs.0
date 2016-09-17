Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34466 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932119AbcIQXKd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 19:10:33 -0400
Received: by mail-wm0-f65.google.com with SMTP id l132so7941132wmf.1
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Sep 2016 16:10:33 -0700 (PDT)
From: =?UTF-8?q?Domagoj=20Tr=C5=A1an?= <domagoj.trsan@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        =?UTF-8?q?Domagoj=20Tr=C5=A1an?= <domagoj.trsan@gmail.com>
Subject: [PATCH] btrfs-progs: change btrfs_csum_final result param type to u8
Date: Sun, 18 Sep 2016 00:10:23 +0100
Message-Id: <1474153823-6671-2-git-send-email-domagoj.trsan@gmail.com>
In-Reply-To: <1474153823-6671-1-git-send-email-domagoj.trsan@gmail.com>
References: <1474153823-6671-1-git-send-email-domagoj.trsan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Domagoj Tršan <domagoj.trsan@gmail.com>
---
 btrfs-image.c             |  2 +-
 chunk-recover.c           |  2 +-
 cmds-check.c              |  2 +-
 cmds-inspect-dump-super.c |  2 +-
 disk-io.c                 | 10 +++++-----
 disk-io.h                 |  2 +-
 file-item.c               |  2 +-
 free-space-cache.c        |  2 +-
 super-recover.c           |  2 +-
 utils.c                   |  2 +-
 10 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 953d368..6de163c 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -163,7 +163,7 @@ static struct extent_buffer *alloc_dummy_eb(u64 bytenr, u32 size);
 
 static void csum_block(u8 *buf, size_t len)
 {
-	char result[BTRFS_CRC32_SIZE];
+	u8 result[BTRFS_CRC32_SIZE];
 	u32 crc = ~(u32)0;
 	crc = crc32c(crc, buf + BTRFS_CSUM_SIZE, len - BTRFS_CSUM_SIZE);
 	btrfs_csum_final(crc, result);
diff --git a/chunk-recover.c b/chunk-recover.c
index 4a081db..32d2805 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1914,7 +1914,7 @@ static int check_one_csum(int fd, u64 start, u32 len, u32 tree_csum)
 	}
 	ret = 0;
 	csum_result = btrfs_csum_data(NULL, data, csum_result, len);
-	btrfs_csum_final(csum_result, (char *)&csum_result);
+	btrfs_csum_final(csum_result, (u8 *)&csum_result);
 	if (csum_result != tree_csum)
 		ret = 1;
 out:
diff --git a/cmds-check.c b/cmds-check.c
index a453696..a36693d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5740,7 +5740,7 @@ again:
 
 			csum = btrfs_csum_data(NULL, (char *)data + tmp,
 					       csum, root->sectorsize);
-			btrfs_csum_final(csum, (char *)&csum);
+			btrfs_csum_final(csum, (u8 *)&csum);
 
 			csum_offset = leaf_offset +
 				 tmp / root->sectorsize * csum_size;
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index aab5075..2f2c628 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -37,7 +37,7 @@
 
 static int check_csum_sblock(void *sb, int csum_size)
 {
-	char result[BTRFS_CSUM_SIZE];
+	u8 result[BTRFS_CSUM_SIZE];
 	u32 crc = ~(u32)0;
 
 	crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE,
diff --git a/disk-io.c b/disk-io.c
index f5340c3..c16eda2 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -123,7 +123,7 @@ u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)
 	return crc32c(seed, data, len);
 }
 
-void btrfs_csum_final(u32 crc, char *result)
+void btrfs_csum_final(u32 crc, u8 *result)
 {
 	put_unaligned_le32(~crc, result);
 }
@@ -131,7 +131,7 @@ void btrfs_csum_final(u32 crc, char *result)
 static int __csum_tree_block_size(struct extent_buffer *buf, u16 csum_size,
 				  int verify, int silent)
 {
-	char result[BTRFS_CSUM_SIZE];
+	u8 result[BTRFS_CSUM_SIZE];
 	u32 len;
 	u32 crc = ~(u32)0;
 
@@ -1423,7 +1423,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
  */
 static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 {
-	char result[BTRFS_CSUM_SIZE];
+	u8 result[BTRFS_CSUM_SIZE];
 	u32 crc;
 	u16 csum_type;
 	int csum_size;
@@ -1647,7 +1647,7 @@ static int write_dev_supers(struct btrfs_root *root,
 		crc = ~(u32)0;
 		crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE, crc,
 				      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
-		btrfs_csum_final(crc, (char *)&sb->csum[0]);
+		btrfs_csum_final(crc, &sb->csum[0]);
 
 		/*
 		 * super_copy is BTRFS_SUPER_INFO_SIZE bytes and is
@@ -1671,7 +1671,7 @@ static int write_dev_supers(struct btrfs_root *root,
 		crc = ~(u32)0;
 		crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE, crc,
 				      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
-		btrfs_csum_final(crc, (char *)&sb->csum[0]);
+		btrfs_csum_final(crc, &sb->csum[0]);
 
 		/*
 		 * super_copy is BTRFS_SUPER_INFO_SIZE bytes and is
diff --git a/disk-io.h b/disk-io.h
index c404d3f..1080fc1 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -175,7 +175,7 @@ int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
 int wait_on_tree_block_writeback(struct btrfs_root *root,
 				 struct extent_buffer *buf);
 u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len);
-void btrfs_csum_final(u32 crc, char *result);
+void btrfs_csum_final(u32 crc, u8 *result);
 
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root);
diff --git a/file-item.c b/file-item.c
index 7a3bbf3..dc3d404 100644
--- a/file-item.c
+++ b/file-item.c
@@ -297,7 +297,7 @@ csum:
 					  csum_offset * csum_size);
 found:
 	csum_result = btrfs_csum_data(root, data, csum_result, len);
-	btrfs_csum_final(csum_result, (char *)&csum_result);
+	btrfs_csum_final(csum_result, (u8 *)&csum_result);
 	if (csum_result == 0) {
 		printk("csum result is 0 for block %llu\n",
 		       (unsigned long long)bytenr);
diff --git a/free-space-cache.c b/free-space-cache.c
index 357d69e..1919d90 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -210,7 +210,7 @@ static int io_ctl_check_crc(struct io_ctl *io_ctl, int index)
 
 	io_ctl_map_page(io_ctl, 0);
 	crc = crc32c(crc, io_ctl->orig + offset, io_ctl->root->sectorsize - offset);
-	btrfs_csum_final(crc, (char *)&crc);
+	btrfs_csum_final(crc, (u8 *)&crc);
 	if (val != crc) {
 		printk("btrfs: csum mismatch on free space cache\n");
 		io_ctl_unmap_page(io_ctl);
diff --git a/super-recover.c b/super-recover.c
index 635e804..ecd1215 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -91,7 +91,7 @@ void free_recover_superblock(struct btrfs_recover_superblock *recover)
 static int check_super(u64 bytenr, struct btrfs_super_block *sb)
 {
 	int csum_size = btrfs_super_csum_size(sb);
-	char result[csum_size];
+	u8 result[csum_size];
 	u32 crc = ~(u32)0;
 
 	if (btrfs_super_bytenr(sb) != bytenr)
diff --git a/utils.c b/utils.c
index cec7c73..511e91f 100644
--- a/utils.c
+++ b/utils.c
@@ -223,7 +223,7 @@ static inline int write_temp_super(int fd, struct btrfs_super_block *sb,
 
 	crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE, crc,
 			      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
-	btrfs_csum_final(crc, (char *)&sb->csum[0]);
+	btrfs_csum_final(crc, &sb->csum[0]);
 	ret = pwrite(fd, sb, BTRFS_SUPER_INFO_SIZE, sb_bytenr);
 	if (ret < BTRFS_SUPER_INFO_SIZE)
 		ret = (ret < 0 ? -errno : -EIO);
-- 
2.7.4

