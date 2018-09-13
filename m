Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50922 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727600AbeIMROW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 13:14:22 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80213B00C
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 12:05:11 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs-progs: check: lowmem: Refactor extent type checks in check_file_extent
Date: Thu, 13 Sep 2018 15:05:07 +0300
Message-Id: <20180913120507.18197-4-nborisov@suse.com>
In-Reply-To: <20180913120507.18197-1-nborisov@suse.com>
References: <20180913120507.18197-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make the checks in check_file_extent a bit more explicit. First we check
for unknown type and fail accordingly. Then we check for inline extent
and handle it in the newly introduced check_file_extent_inline. Finally
if none of the above checks triggered then we must have a regular or
prealloc extents.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/mode-lowmem.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 3a6fbb33c858..aa946a1307de 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1915,21 +1915,23 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 
 	btrfs_item_key_to_cpu(node, &fkey, slot);
 	fi = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
-
-	/* Check inline extent */
 	extent_type = btrfs_file_extent_type(node, fi);
-	if (extent_type == BTRFS_FILE_EXTENT_INLINE)
-		return check_file_extent_inline(root, path, size, end);
 
 	/* Check extent type */
 	if (extent_type != BTRFS_FILE_EXTENT_REG &&
-			extent_type != BTRFS_FILE_EXTENT_PREALLOC) {
+	    extent_type != BTRFS_FILE_EXTENT_PREALLOC &&
+	    extent_type != BTRFS_FILE_EXTENT_INLINE) {
 		err |= FILE_EXTENT_ERROR;
 		error("root %llu EXTENT_DATA[%llu %llu] type bad",
 		      root->objectid, fkey.objectid, fkey.offset);
 		return err;
 	}
 
+	/* Check inline extent */
+	if (extent_type == BTRFS_FILE_EXTENT_INLINE)
+		return check_file_extent_inline(root, path, size, end);
+
+
 	/* Check REG_EXTENT/PREALLOC_EXTENT */
 	disk_bytenr = btrfs_file_extent_disk_bytenr(node, fi);
 	disk_num_bytes = btrfs_file_extent_disk_num_bytes(node, fi);
-- 
2.17.1
