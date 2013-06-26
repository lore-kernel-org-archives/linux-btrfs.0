Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab3FZF02 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 01:26:28 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r5Q5QOhv002515
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 13:26:25 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH] btrfs-progs: Cleanup for using BTRFS_SETGET_STACK instead of raw convert
Date: Wed, 26 Jun 2013 13:27:08 +0800
Message-Id: <1372224428-5597-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some codes still use the cpu_to_lexx instead of the
BTRFS_SETGET_STACK_FUNCS declared in ctree.h.

Also added some BTRFS_SETGET_STACK_FUNCS for btrfs_header and
btrfs_super.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c    | 2 +-
 btrfs-find-root.c  | 6 +++---
 btrfs-image.c      | 2 +-
 btrfs-show-super.c | 2 +-
 ctree.h            | 7 +++++++
 disk-io.c          | 6 +++---
 utils.c            | 4 ++--
 volumes.c          | 2 +-
 8 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 399856f..cb96790 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1802,7 +1802,7 @@ static int prepare_system_chunk_sb(struct btrfs_super_block *super)
 	btrfs_set_stack_chunk_num_stripes(chunk, 1);
 	btrfs_set_stack_chunk_sub_stripes(chunk, 0);
 	chunk->stripe.devid = super->dev_item.devid;
-	chunk->stripe.offset = cpu_to_le64(0);
+	btrfs_set_stack_stripe_offset(&chunk->stripe, 0);
 	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
 	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
 	return 0;
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 810d835..d3f4ccc 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -247,10 +247,10 @@ static int search_iobuf(struct btrfs_root *root, void *iobuf,
 		u64 h_byte, h_level, h_gen, h_owner;
 
 //		printf("searching %Lu\n", offset + block_off);
-		h_byte = le64_to_cpu(header->bytenr);
-		h_owner = le64_to_cpu(header->owner);
+		h_byte = btrfs_stack_header_bytenr(header);
+		h_owner = btrfs_stack_header_owner(header);
 		h_level = header->level;
-		h_gen = le64_to_cpu(header->generation);
+		h_gen = btrfs_stack_header_generation(header);
 
 		if (h_owner != objectid)
 			goto next;
diff --git a/btrfs-image.c b/btrfs-image.c
index 22239fe..599a35f 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1332,7 +1332,7 @@ static void update_super_old(u8 *buffer)
 	btrfs_set_stack_chunk_num_stripes(chunk, 1);
 	btrfs_set_stack_chunk_sub_stripes(chunk, 0);
 	chunk->stripe.devid = super->dev_item.devid;
-	chunk->stripe.offset = cpu_to_le64(0);
+	btrfs_set_stack_stripe_offset(&chunk->stripe, 0);
 	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
 	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
 	csum_block(buffer, 4096);
diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index f587f10..3e2567e 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -186,7 +186,7 @@ static void dump_superblock(struct btrfs_super_block *sb)
 	s = (char *) &sb->magic;
 	for (i = 0; i < 8; i++)
 		putchar(isprint(s[i]) ? s[i] : '.');
-	if (sb->magic == cpu_to_le64(BTRFS_MAGIC))
+	if (btrfs_super_magic(sb) == BTRFS_MAGIC)
 		printf(" [match]\n");
 	else
 		printf(" [DON'T MATCH]\n");
diff --git a/ctree.h b/ctree.h
index 3fe14b0..4c2f430 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1712,6 +1712,12 @@ BTRFS_SETGET_HEADER_FUNCS(header_owner, struct btrfs_header, owner, 64);
 BTRFS_SETGET_HEADER_FUNCS(header_nritems, struct btrfs_header, nritems, 32);
 BTRFS_SETGET_HEADER_FUNCS(header_flags, struct btrfs_header, flags, 64);
 BTRFS_SETGET_HEADER_FUNCS(header_level, struct btrfs_header, level, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_header_bytenr, struct btrfs_header, bytenr, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_header_nritems, struct btrfs_header, nritems,
+			 32);
+BTRFS_SETGET_STACK_FUNCS(stack_header_owner, struct btrfs_header, owner, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_header_generation, struct btrfs_header,
+			 generation, 64);
 
 static inline int btrfs_header_flag(struct extent_buffer *eb, u64 flag)
 {
@@ -1918,6 +1924,7 @@ BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
 			 csum_type, 16);
 BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
 			 cache_generation, 64);
+BTRFS_SETGET_STACK_FUNCS(super_magic, struct btrfs_super_block, magic, 64);
 
 static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 {
diff --git a/disk-io.c b/disk-io.c
index 9ffe6e4..4eef029 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1104,7 +1104,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 			return -1;
 
 		if (btrfs_super_bytenr(&buf) != sb_bytenr ||
-		    buf.magic != cpu_to_le64(BTRFS_MAGIC))
+		    btrfs_super_magic(&buf) != BTRFS_MAGIC)
 			return -1;
 
 		memcpy(sb, &buf, sizeof(*sb));
@@ -1120,9 +1120,9 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 		if (btrfs_super_bytenr(&buf) != bytenr )
 			continue;
 		/* if magic is NULL, the device was removed */
-		if (buf.magic == 0 && i == 0) 
+		if (btrfs_super_magic(&buf) == 0 && i == 0)
 			return -1;
-		if (buf.magic != cpu_to_le64(BTRFS_MAGIC))
+		if (btrfs_super_magic(&buf) != BTRFS_MAGIC)
 			continue;
 
 		if (!fsid_is_initialized) {
diff --git a/utils.c b/utils.c
index 7b4cd74..1eeda0f 100644
--- a/utils.c
+++ b/utils.c
@@ -115,7 +115,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 
 	btrfs_set_super_bytenr(&super, blocks[0]);
 	btrfs_set_super_num_devices(&super, 1);
-	super.magic = cpu_to_le64(BTRFS_MAGIC);
+	btrfs_set_super_magic(&super, BTRFS_MAGIC);
 	btrfs_set_super_generation(&super, 1);
 	btrfs_set_super_root(&super, blocks[1]);
 	btrfs_set_super_chunk_root(&super, blocks[3]);
@@ -1139,7 +1139,7 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 
 	ret = 0;
 	disk_super = (struct btrfs_super_block *)buf;
-	if (disk_super->magic != cpu_to_le64(BTRFS_MAGIC))
+	if (btrfs_super_magic(disk_super) != BTRFS_MAGIC)
 		goto brelse;
 
 	if (!memcmp(disk_super->fsid, root->fs_info->super_copy->fsid,
diff --git a/volumes.c b/volumes.c
index d6f81f8..05608a5 100644
--- a/volumes.c
+++ b/volumes.c
@@ -231,7 +231,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 		ret = -EIO;
 		goto error_brelse;
 	}
-	devid = le64_to_cpu(disk_super->dev_item.devid);
+	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_METADUMP)
 		*total_devs = 1;
 	else
-- 
1.8.3.1

