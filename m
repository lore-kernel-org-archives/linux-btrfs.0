Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49842 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753387AbdKFSYy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 13:24:54 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E5D10AC9D
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 18:24:52 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: switch to on-stack csum buffer in csum_tree_block
Date: Mon,  6 Nov 2017 19:23:00 +0100
Message-Id: <20171106182300.11366-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The maximum size of a checksum buffer is known, BTRFS_CSUM_SIZE, and we
don't have to allocate it dynamically. This code path is not used at all
as we have only the crc32c and use an on-stack buffer already.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5713c50959e0..53c9145a56e9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -285,7 +285,7 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
 			   int verify)
 {
 	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
-	char *result = NULL;
+	char result[BTRFS_CSUM_SIZE];
 	unsigned long len;
 	unsigned long cur_len;
 	unsigned long offset = BTRFS_CSUM_SIZE;
@@ -294,7 +294,6 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
 	unsigned long map_len;
 	int err;
 	u32 crc = ~(u32)0;
-	unsigned long inline_result;
 
 	len = buf->len - offset;
 	while (len > 0) {
@@ -308,13 +307,7 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
 		len -= cur_len;
 		offset += cur_len;
 	}
-	if (csum_size > sizeof(inline_result)) {
-		result = kzalloc(csum_size, GFP_NOFS);
-		if (!result)
-			return -ENOMEM;
-	} else {
-		result = (char *)&inline_result;
-	}
+	memset(result, 0, BTRFS_CSUM_SIZE);
 
 	btrfs_csum_final(crc, result);
 
@@ -329,15 +322,12 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
 				"%s checksum verify failed on %llu wanted %X found %X level %d",
 				fs_info->sb->s_id, buf->start,
 				val, found, btrfs_header_level(buf));
-			if (result != (char *)&inline_result)
-				kfree(result);
 			return -EUCLEAN;
 		}
 	} else {
 		write_extent_buffer(buf, result, 0, csum_size);
 	}
-	if (result != (char *)&inline_result)
-		kfree(result);
+
 	return 0;
 }
 
-- 
2.14.3

