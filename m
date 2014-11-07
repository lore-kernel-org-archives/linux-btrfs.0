Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbaKGQrL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 11:47:11 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 6A5AAAD06
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Nov 2014 16:47:10 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/4] btrfs: cleanup, rename a few variables in btrfs_read_sys_array
Date: Fri,  7 Nov 2014 17:47:09 +0100
Message-Id: <4814fbf2536c6e03c5a774037af14a411cd6a743.1415378049.git.dsterba@suse.cz>
In-Reply-To: <cover.1415378049.git.dsterba@suse.cz>
References: <cover.1415378049.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's a pointer to buffer, integer offset and offset passed as
pointer, try to find matching names for them.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/volumes.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d47289c715c8..fbdfed2e0ba8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6212,13 +6212,13 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	struct extent_buffer *sb;
 	struct btrfs_disk_key *disk_key;
 	struct btrfs_chunk *chunk;
-	u8 *ptr;
-	unsigned long sb_ptr;
+	u8 *array_ptr;
+	unsigned long sb_array_offset;
 	int ret = 0;
 	u32 num_stripes;
 	u32 array_size;
 	u32 len = 0;
-	u32 cur;
+	u32 cur_offset;
 	struct btrfs_key key;
 
 	sb = btrfs_find_create_tree_block(root, BTRFS_SUPER_INFO_OFFSET,
@@ -6245,20 +6245,21 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	write_extent_buffer(sb, super_copy, 0, BTRFS_SUPER_INFO_SIZE);
 	array_size = btrfs_super_sys_array_size(super_copy);
 
-	ptr = super_copy->sys_chunk_array;
-	sb_ptr = offsetof(struct btrfs_super_block, sys_chunk_array);
-	cur = 0;
+	array_ptr = super_copy->sys_chunk_array;
+	sb_array_offset = offsetof(struct btrfs_super_block, sys_chunk_array);
+	cur_offset = 0;
 
-	while (cur < array_size) {
-		disk_key = (struct btrfs_disk_key *)ptr;
+	while (cur_offset < array_size) {
+		disk_key = (struct btrfs_disk_key *)array_ptr;
 		btrfs_disk_key_to_cpu(&key, disk_key);
 
-		len = sizeof(*disk_key); ptr += len;
-		sb_ptr += len;
-		cur += len;
+		len = sizeof(*disk_key);
+		array_ptr += len;
+		sb_array_offset += len;
+		cur_offset += len;
 
 		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
-			chunk = (struct btrfs_chunk *)sb_ptr;
+			chunk = (struct btrfs_chunk *)sb_array_offset;
 			ret = read_one_chunk(root, &key, sb, chunk);
 			if (ret)
 				break;
@@ -6268,9 +6269,9 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 			ret = -EIO;
 			break;
 		}
-		ptr += len;
-		sb_ptr += len;
-		cur += len;
+		array_ptr += len;
+		sb_array_offset += len;
+		cur_offset += len;
 	}
 	free_extent_buffer(sb);
 	return ret;
-- 
1.8.4.5

