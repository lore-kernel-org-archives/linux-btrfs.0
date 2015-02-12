Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:42803 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbbBLCVc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 21:21:32 -0500
Received: by mail-qg0-f49.google.com with SMTP id q107so5905572qgd.8
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2015 18:21:31 -0800 (PST)
From: Kevin Mulvey <kevin@kevinmulvey.net>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kevin Mulvey <kmulvey@linux.com>
Subject: [PATCH] fix spacing in btrfs/inode.c
Date: Wed, 11 Feb 2015 21:17:22 -0500
Message-Id: <1423707442-9485-1-git-send-email-kmulvey@linux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a patch to inode.c that fixes some spacing errors found by checkpatch.pl

Signed-off-by: Kevin Mulvey <kmulvey@linux.com>
---
 fs/btrfs/inode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8bf326a..6516839 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4545,7 +4545,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 			break;
 		}
 		last_byte = min(extent_map_end(em), block_end);
-		last_byte = ALIGN(last_byte , root->sectorsize);
+		last_byte = ALIGN(last_byte, root->sectorsize);
 		if (!test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
 			struct extent_map *hole_em;
 			hole_size = last_byte - cur_offset;
@@ -8829,9 +8829,9 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 */
 	trans = btrfs_start_transaction(root, 11);
 	if (IS_ERR(trans)) {
-                ret = PTR_ERR(trans);
-                goto out_notrans;
-        }
+		ret = PTR_ERR(trans);
+		goto out_notrans;
+	}
 
 	if (dest != root)
 		btrfs_record_root_in_trans(trans, dest);
@@ -9324,7 +9324,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			break;
 		}
 		btrfs_drop_extent_cache(inode, cur_offset,
-					cur_offset + ins.offset -1, 0);
+					cur_offset + ins.offset - 1, 0);
 
 		em = alloc_extent_map();
 		if (!em) {
-- 
2.1.0

