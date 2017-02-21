Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48784 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdBUUN6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 15:13:58 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: use the correct type when creating cow dio extent
Date: Tue, 21 Feb 2017 12:12:58 -0800
Message-Id: <1487707978-25047-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'BTRFS_ORDERED_REGULAR' was introduced for the cow case in patch
'Btrfs: specify a new ordered extent type for create_io_em',
but it missed the directIO cow case.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d90b5b3..3060d5c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7185,7 +7185,7 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 
 	em = btrfs_create_dio_extent(inode, start, ins.offset, start,
 				     ins.objectid, ins.offset, ins.offset,
-				     ins.offset, 0);
+				     ins.offset, BTRFS_ORDERED_REGULAR);
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 	if (IS_ERR(em))
 		btrfs_free_reserved_extent(fs_info, ins.objectid,
-- 
1.8.3.1

