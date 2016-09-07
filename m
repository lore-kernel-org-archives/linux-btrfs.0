Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34918 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754791AbcIGHjJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2016 03:39:09 -0400
Received: by mail-wm0-f50.google.com with SMTP id i204so71080124wma.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Sep 2016 00:39:07 -0700 (PDT)
From: Nikolay Borisov <kernel@kyup.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <kernel@kyup.com>
Subject: [PATCH] btrfs: Fix handling of -ENOENT from btrfs_uuid_iter_rem
Date: Wed,  7 Sep 2016 10:38:58 +0300
Message-Id: <1473233938-21560-1-git-send-email-kernel@kyup.com>
In-Reply-To: <b369cabe-9269-800c-cce7-5f5c71147660@fb.com>
References: <b369cabe-9269-800c-cce7-5f5c71147660@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_uuid_iter_rem is able to return -ENOENT, however this condition
is not handled in btrfs_uuid_tree_iterate which can lead to calling
btrfs_next_item with freed path argument, leading to a null pointer
dereference. Fix it by redoing the search but with an incremented
objectid so we don't loop over the same key.

Signed-off-by: Nikolay Borisov <kernel@kyup.com>
Suggested-by: Chris Mason <clm@fb.com>
Link: https://lkml.kernel.org/r/57A473B0.2040203@kyup.com
---
 fs/btrfs/uuid-tree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Hello Chris, 

Since I keep getting those crashes I (hopefully correctly) implemented
your suggestion of redoing the search with an incremented key so we 
don't end up in a loop. Does that look correct? 


diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index 778282944530..6e5b3866a65c 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -329,8 +329,12 @@ again_search_slot:
 					 * entry per UUID exists.
 					 */
 					goto again_search_slot;
-				}
-				if (ret < 0 && ret != -ENOENT)
+				} else if (ret == -ENOENT) {
+					key.type = 0;
+					key.offset = 0;
+					key.objectid++;
+					goto again_search_slot;
+				} else if (ret < 0)
 					goto out;
 			}
 			item_size -= sizeof(subid_le);
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
