Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:39832 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751821AbdIQTuf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 15:50:35 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH] load_chunk_info() : wrong search key 'type'
Date: Sun, 17 Sep 2017 21:50:28 +0200
Message-Id: <20170917195028.3124-2-kreijack@libero.it>
In-Reply-To: <20170917195028.3124-1-kreijack@libero.it>
References: <20170917195028.3124-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

The function load_chunk_info() doesn't initialize correctly the
sk->min/max_type when it calls the TREE_SEARCH ioctl: these keys are swapped.
Moreover this function assumes that all the items contained in the tree
BTRFS_CHUNK_TREE_OBJECTID are of type BTRFS_CHUNK_ITEM_KEY, however some
items are of type DEV_ITEM. Add an if( ) to pick only the right ones.

Signed-off-by: G.Baroncelli <kreijack@inwind.it>
---
 cmds-fi-usage.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 6c846c15..52d63524 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -147,8 +147,8 @@ static int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count
 
 	sk->min_objectid = 0;
 	sk->max_objectid = (u64)-1;
-	sk->max_type = 0;
-	sk->min_type = (u8)-1;
+	sk->min_type = 0;
+	sk->max_type = (u8)-1;
 	sk->min_offset = 0;
 	sk->max_offset = (u64)-1;
 	sk->min_transid = 0;
@@ -174,20 +174,21 @@ static int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count
 		off = 0;
 		for (i = 0; i < sk->nr_items; i++) {
 			struct btrfs_chunk *item;
+			u8 type;
 			sh = (struct btrfs_ioctl_search_header *)(args.buf +
 								  off);
-
+			type = btrfs_search_header_type(sh);
 			off += sizeof(*sh);
-			item = (struct btrfs_chunk *)(args.buf + off);
-
-			ret = add_info_to_list(info_ptr, info_count, item);
-			if (ret) {
-				*info_ptr = NULL;
-				return 1;
+			if (type == BTRFS_CHUNK_ITEM_KEY) {
+				item = (struct btrfs_chunk *)(args.buf + off);
+				ret = add_info_to_list(info_ptr, info_count, item);
+				if (ret) {
+					*info_ptr = NULL;
+					return 1;
+				}
 			}
 
 			off += btrfs_search_header_len(sh);
-
 			sk->min_objectid = btrfs_search_header_objectid(sh);
 			sk->min_type = btrfs_search_header_type(sh);
 			sk->min_offset = btrfs_search_header_offset(sh)+1;
-- 
2.14.1

