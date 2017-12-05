Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53185 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751255AbdLELvs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 06:51:48 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E0C67AE1A
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 11:51:46 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: handle failure of add_pending_csums
Date: Tue,  5 Dec 2017 13:51:43 +0200
Message-Id: <1512474703-30066-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

add_pending_csums was added as part of the new data=ordered implementation in
e6dcd2dc9c48 ("Btrfs: New data=ordered implementation"). Even back then it
called the btrfs_csum_file_blocks which can fail but it never bothered handling
the failure. In ENOMEM situation this could lead to the filesystem failing to
write the checksums for a particular extent and not detect this. On read this
could lead to the filesystem erroring out due to crc mismatch. Fix it by
propagating failure from add_pending_csums and handling them

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e87ec11c0986..432bffdbb02f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2039,11 +2039,14 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 			     struct inode *inode, struct list_head *list)
 {
 	struct btrfs_ordered_sum *sum;
+	int ret;
 
 	list_for_each_entry(sum, list, list) {
 		trans->adding_csums = true;
-		btrfs_csum_file_blocks(trans,
+		ret = btrfs_csum_file_blocks(trans,
 		       BTRFS_I(inode)->root->fs_info->csum_root, sum);
+		if (ret)
+			return ret;
 		trans->adding_csums = false;
 	}
 	return 0;
@@ -3051,7 +3054,11 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		goto out;
 	}
 
-	add_pending_csums(trans, inode, &ordered_extent->list);
+	ret = add_pending_csums(trans, inode, &ordered_extent->list);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	}
 
 	btrfs_ordered_update_i_size(inode, 0, ordered_extent);
 	ret = btrfs_update_inode_fallback(trans, root, inode);
-- 
2.7.4

