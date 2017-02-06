Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59299 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750924AbdBFFrw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 00:47:52 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <calestyo@scientia.net>, <chris@colorremedies.com>, <dsterba@suse.cz>
Subject: [PATCH v2 05/12] btrfs-progs: lowmem check: Fix false alert on inline compressed extent
Date: Mon, 6 Feb 2017 13:47:28 +0800
Message-ID: <20170206054735.5227-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
References: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Old lowmem check doesn't check if the inline extent is compressed and
always check extent numbytes against inline item size.

And when it finds the extent numbytes mismatch with inline item size it
doesn't output any error message, just return error silently, making it
quite hard to debug.

Fix it by only checking extent numbytes against inline item size when
the extent is not compressed, and output error message.

Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index eb146432..cf5a08ce 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4715,17 +4715,28 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 
 	fi = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
 
+	/* Check inline extent */
 	extent_type = btrfs_file_extent_type(node, fi);
-	/* Skip if file extent is inline */
 	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 		struct btrfs_item *e = btrfs_item_nr(slot);
 		u32 item_inline_len;
 
 		item_inline_len = btrfs_file_extent_inline_item_len(node, e);
 		extent_num_bytes = btrfs_file_extent_inline_len(node, slot, fi);
-		if (extent_num_bytes == 0 ||
-		    extent_num_bytes != item_inline_len)
+		compressed = btrfs_file_extent_compression(node, fi);
+		if (extent_num_bytes == 0) {
+			error(
+		"root %llu EXTENT_DATA[%llu %llu] has empty inline extent",
+				root->objectid, fkey->objectid, fkey->offset);
 			err |= FILE_EXTENT_ERROR;
+		}
+		if (!compressed && extent_num_bytes != item_inline_len) {
+			error(
+		"root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, expect: %u",
+				root->objectid, fkey->objectid, fkey->offset,
+				extent_num_bytes, item_inline_len);
+			err |= FILE_EXTENT_ERROR;
+		}
 		*size += extent_num_bytes;
 		return err;
 	}
-- 
2.11.0



