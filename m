Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54301 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754073AbeAKFK0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:26 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 301DC48AEA0B
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:10:13 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 46/67] btrfs-progs: add the stack prefix for super_sys_array_size set/get function
Date: Thu, 11 Jan 2018 13:09:18 +0800
Message-ID: <20180111050939.21251-47-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super_sys_array_size set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 chunk-recover.c           | 2 +-
 cmds-inspect-dump-super.c | 4 ++--
 convert/common.c          | 6 +++---
 ctree.h                   | 2 +-
 disk-io.c                 | 9 +++++----
 extent-tree.c             | 6 +++---
 image/main.c              | 7 ++++---
 mkfs/common.c             | 2 +-
 volumes.c                 | 7 ++++---
 9 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index d0a7cfe0..df5e2850 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1294,7 +1294,7 @@ static int rebuild_sys_array(struct recover_control *rc,
 	int ret = 0;
 	u16 num_stripes;
 
-	btrfs_set_super_sys_array_size(fs_info->super_copy, 0);
+	btrfs_set_stack_super_sys_array_size(fs_info->super_copy, 0);
 
 	list_for_each_entry(chunk_rec, &rc->good_chunks, list) {
 		if (!(chunk_rec->type_flags & BTRFS_BLOCK_GROUP_SYSTEM))
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 44dab1bc..0f28f1c9 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -68,7 +68,7 @@ static void print_sys_chunk_array(struct btrfs_super_block *sb)
 	}
 	write_extent_buffer(buf, sb, 0, sizeof(*sb));
 	buf->len = sizeof(*sb);
-	array_size = btrfs_super_sys_array_size(sb);
+	array_size = btrfs_stack_super_sys_array_size(sb);
 
 	array_ptr = sb->sys_chunk_array;
 	sb_array_offset = offsetof(struct btrfs_super_block, sys_chunk_array);
@@ -374,7 +374,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("root\t\t\t%llu\n",
 	       (unsigned long long)btrfs_stack_super_root(sb));
 	printf("sys_array_size\t\t%llu\n",
-	       (unsigned long long)btrfs_super_sys_array_size(sb));
+	       (unsigned long long)btrfs_stack_super_sys_array_size(sb));
 	printf("chunk_root_generation\t%llu\n",
 	       (unsigned long long)btrfs_super_chunk_root_generation(sb));
 	printf("root_level\t\t%llu\n",
diff --git a/convert/common.c b/convert/common.c
index bca52547..58b071c8 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -400,15 +400,15 @@ static int insert_temp_chunk_item(int fd, struct extent_buffer *buf,
 		u32 array_size;
 
 		cur = (char *)sb->sys_chunk_array
-			+ btrfs_super_sys_array_size(sb);
+			+ btrfs_stack_super_sys_array_size(sb);
 		memcpy(cur, &disk_key, sizeof(disk_key));
 		cur += sizeof(disk_key);
 		read_extent_buffer(buf, cur, (unsigned long int)chunk,
 				   btrfs_chunk_item_size(1));
-		array_size = btrfs_super_sys_array_size(sb);
+		array_size = btrfs_stack_super_sys_array_size(sb);
 		array_size += btrfs_chunk_item_size(1) +
 					    sizeof(disk_key);
-		btrfs_set_super_sys_array_size(sb, array_size);
+		btrfs_set_stack_super_sys_array_size(sb, array_size);
 
 		ret = write_temp_super(fd, sb, cfg->super_bytenr);
 	}
diff --git a/ctree.h b/ctree.h
index 8e21ffa6..49b047c5 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2168,7 +2168,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_super_flags, struct btrfs_super_block, flags,
 BTRFS_SETGET_STACK_FUNCS(stack_super_generation, struct btrfs_super_block,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_super_root, struct btrfs_super_block, root, 64);
-BTRFS_SETGET_STACK_FUNCS(super_sys_array_size,
+BTRFS_SETGET_STACK_FUNCS(stack_super_sys_array_size,
 			 struct btrfs_super_block, sys_chunk_array_size, 32);
 BTRFS_SETGET_STACK_FUNCS(super_chunk_root_generation,
 			 struct btrfs_super_block, chunk_root_generation, 64);
diff --git a/disk-io.c b/disk-io.c
index 7dbac348..b077e8f0 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1399,16 +1399,17 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 	 * Obvious sys_chunk_array corruptions, it must hold at least one key
 	 * and one chunk
 	 */
-	if (btrfs_super_sys_array_size(sb) > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
+	if (btrfs_stack_super_sys_array_size(sb) >
+			BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
 		error("system chunk array too big %u > %u",
-		      btrfs_super_sys_array_size(sb),
+		      btrfs_stack_super_sys_array_size(sb),
 		      BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
 		goto error_out;
 	}
-	if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
+	if (btrfs_stack_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
 			+ sizeof(struct btrfs_chunk)) {
 		error("system chunk array too small %u < %zu",
-		      btrfs_super_sys_array_size(sb),
+		      btrfs_stack_super_sys_array_size(sb),
 		      sizeof(struct btrfs_disk_key) +
 		      sizeof(struct btrfs_chunk));
 		goto error_out;
diff --git a/extent-tree.c b/extent-tree.c
index a3e4bd1a..f4ca2348 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3598,12 +3598,12 @@ static int free_system_chunk_item(struct btrfs_super_block *super,
 {
 	struct btrfs_disk_key *disk_key;
 	struct btrfs_key cpu_key;
-	u32 array_size = btrfs_super_sys_array_size(super);
+	u32 array_size = btrfs_stack_super_sys_array_size(super);
 	char *ptr = (char *)super->sys_chunk_array;
 	int cur = 0;
 	int ret = -ENOENT;
 
-	while (cur < btrfs_super_sys_array_size(super)) {
+	while (cur < btrfs_stack_super_sys_array_size(super)) {
 		struct btrfs_chunk *chunk;
 		u32 num_stripes;
 		u32 chunk_len;
@@ -3627,7 +3627,7 @@ static int free_system_chunk_item(struct btrfs_super_block *super,
 			memmove(ptr + cur, ptr + cur + chunk_len,
 				array_size - cur - chunk_len);
 			array_size -= chunk_len;
-			btrfs_set_super_sys_array_size(super, array_size);
+			btrfs_set_stack_super_sys_array_size(super, array_size);
 			ret = 0;
 			goto out;
 		}
diff --git a/image/main.c b/image/main.c
index e9df95ad..bd10287d 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1116,7 +1116,8 @@ static void update_super_old(u8 *buffer)
 	chunk->stripe.devid = super->dev_item.devid;
 	btrfs_set_stack_stripe_offset(&chunk->stripe, 0);
 	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
-	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
+	btrfs_set_stack_super_sys_array_size(super,
+					     sizeof(*key) + sizeof(*chunk));
 	csum_block(buffer, BTRFS_SUPER_INFO_SIZE);
 }
 
@@ -1134,7 +1135,7 @@ static int update_super(struct mdrestore_struct *mdres, u8 *buffer)
 	int old_num_stripes;
 
 	write_ptr = ptr = super->sys_chunk_array;
-	array_size = btrfs_super_sys_array_size(super);
+	array_size = btrfs_stack_super_sys_array_size(super);
 
 	while (cur < array_size) {
 		disk_key = (struct btrfs_disk_key *)ptr;
@@ -1188,7 +1189,7 @@ static int update_super(struct mdrestore_struct *mdres, u8 *buffer)
 
 	flags |= BTRFS_SUPER_FLAG_METADUMP_V2;
 	btrfs_set_stack_super_flags(super, flags);
-	btrfs_set_super_sys_array_size(super, new_array_size);
+	btrfs_set_stack_super_sys_array_size(super, new_array_size);
 	btrfs_set_super_num_devices(super, 1);
 	csum_block(buffer, BTRFS_SUPER_INFO_SIZE);
 
diff --git a/mkfs/common.c b/mkfs/common.c
index 33cd5ed9..2d31b3e6 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -346,7 +346,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	read_extent_buffer(buf, ptr, (unsigned long)chunk, item_size);
 	array_size += item_size;
 	ptr += item_size;
-	btrfs_set_super_sys_array_size(&super, array_size);
+	btrfs_set_stack_super_sys_array_size(&super, array_size);
 
 	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_CHUNK_TREE]);
 	btrfs_set_header_owner(buf, BTRFS_CHUNK_TREE_OBJECTID);
diff --git a/volumes.c b/volumes.c
index 20203024..8601dbe6 100644
--- a/volumes.c
+++ b/volumes.c
@@ -712,7 +712,7 @@ int btrfs_add_system_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 	u32 array_size;
 	u8 *ptr;
 
-	array_size = btrfs_super_sys_array_size(super_copy);
+	array_size = btrfs_stack_super_sys_array_size(super_copy);
 	if (array_size + item_size + sizeof(disk_key)
 			> BTRFS_SYSTEM_CHUNK_ARRAY_SIZE)
 		return -EFBIG;
@@ -723,7 +723,8 @@ int btrfs_add_system_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 	ptr += sizeof(disk_key);
 	memcpy(ptr, chunk, item_size);
 	item_size += sizeof(disk_key);
-	btrfs_set_super_sys_array_size(super_copy, array_size + item_size);
+	btrfs_set_stack_super_sys_array_size(super_copy,
+					     array_size + item_size);
 	return 0;
 }
 
@@ -1995,7 +1996,7 @@ int btrfs_read_sys_array(struct btrfs_fs_info *fs_info)
 		return -ENOMEM;
 	btrfs_set_buffer_uptodate(sb);
 	write_extent_buffer(sb, super_copy, 0, sizeof(*super_copy));
-	array_size = btrfs_super_sys_array_size(super_copy);
+	array_size = btrfs_stack_super_sys_array_size(super_copy);
 
 	array_ptr = super_copy->sys_chunk_array;
 	sb_array_offset = offsetof(struct btrfs_super_block, sys_chunk_array);
-- 
2.15.1



