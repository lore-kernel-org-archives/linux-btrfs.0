Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbaKGQrO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 11:47:14 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B9073ACF9
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Nov 2014 16:47:13 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/4] btrfs: add more checks to btrfs_read_sys_array
Date: Fri,  7 Nov 2014 17:47:13 +0100
Message-Id: <c5f2c87bc8a306962cf9ba355477ed191eb25e8b.1415378049.git.dsterba@suse.cz>
In-Reply-To: <cover.1415378049.git.dsterba@suse.cz>
References: <cover.1415378049.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Verify that the sys_array has enough bytes to read the next item.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/volumes.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fbdfed2e0ba8..92f4f011882e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6251,20 +6251,34 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 
 	while (cur_offset < array_size) {
 		disk_key = (struct btrfs_disk_key *)array_ptr;
+		len = sizeof(*disk_key);
+		if (cur_offset + len > array_size)
+			goto out_short_read;
+
 		btrfs_disk_key_to_cpu(&key, disk_key);
 
-		len = sizeof(*disk_key);
 		array_ptr += len;
 		sb_array_offset += len;
 		cur_offset += len;
 
 		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
 			chunk = (struct btrfs_chunk *)sb_array_offset;
+			/*
+			 * At least one btrfs_chunk with one stripe must be
+			 * present, exact stripe count check comes afterwards
+			 */
+			len = btrfs_chunk_item_size(1);
+			if (cur_offset + len > array_size)
+				goto out_short_read;
+
+			num_stripes = btrfs_chunk_num_stripes(sb, chunk);
+			len = btrfs_chunk_item_size(num_stripes);
+			if (cur_offset + len > array_size)
+				goto out_short_read;
+
 			ret = read_one_chunk(root, &key, sb, chunk);
 			if (ret)
 				break;
-			num_stripes = btrfs_chunk_num_stripes(sb, chunk);
-			len = btrfs_chunk_item_size(num_stripes);
 		} else {
 			ret = -EIO;
 			break;
@@ -6275,6 +6289,12 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	}
 	free_extent_buffer(sb);
 	return ret;
+
+out_short_read:
+	printk(KERN_ERR "BTRFS: sys_array too short to read %u bytes at offset %u\n",
+			len, cur_offset);
+	free_extent_buffer(sb);
+	return -EIO;
 }
 
 int btrfs_read_chunk_tree(struct btrfs_root *root)
-- 
1.8.4.5

