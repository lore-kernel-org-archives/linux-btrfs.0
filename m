Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34765 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751670AbeFELjO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 07:39:14 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4A939AC2F
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Jun 2018 11:39:13 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs-progs: check: Fix wrong error message in case of corrupted extent
Date: Tue,  5 Jun 2018 14:39:10 +0300
Message-Id: <1528198750-27840-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs check detects a freespace tree extent which ends beyond the
blockgroup containing it a misleading error messages is printed. For
example if we have the following extent in the freespace tree:

    item 5 key (30408704 FREE_SPACE_INFO 1073741824) itemoff 16259 itemsize 8
            free space info extent count 3 flags 0
    item 6 key (30425088 FREE_SPACE_EXTENT 49152) itemoff 16259 itemsize 0
            free space extent
    item 7 key (30507008 FREE_SPACE_EXTENT 65536) itemoff 16259 itemsize 0
            free space extent
    item 8 key (30654464 FREE_SPACE_EXTENT 14524648038063310901) itemoff 16259 itemsize 0

Clearly the last extent is corrupted so we should print something
along the lines of:

free space extent ends at 14524648038063310901, beyond end of block group 30408704-1104150528

Instead currently this is printed:

free space extent ends at 30654464, beyond end of block group 30408704-1104150528

So instead of printing the actual erroneous end, we print the beginning
of the extent. Fix this by printing the actual corrupted end.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 free-space-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/free-space-tree.c b/free-space-tree.c
index 69a4eca8a74f..747f8778e610 100644
--- a/free-space-tree.c
+++ b/free-space-tree.c
@@ -276,7 +276,7 @@ static int load_free_space_extents(struct btrfs_fs_info *fs_info,
 		if (key.objectid + key.offset > end) {
 			fprintf(stderr,
 	"free space extent ends at %llu, beyond end of block group %llu-%llu\n",
-				key.objectid, start, end);
+				key.objectid+key.offset, start, end);
 			(*errors)++;
 			break;
 		}
-- 
2.7.4

