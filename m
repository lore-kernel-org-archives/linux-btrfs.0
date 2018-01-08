Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755969AbeAHI7q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 03:59:46 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3A273AAAD
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Jan 2018 08:59:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: handle failure of add_pending_csums
Date: Mon,  8 Jan 2018 10:59:43 +0200
Message-Id: <1515401983-28451-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20180105164449.GQ3553@twin.jikos.cz>
References: <20180105164449.GQ3553@twin.jikos.cz>
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

V2: 
 Moves the if/ret part after setting ->adding_csums to false. 

 fs/btrfs/inode.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index eebfe2615428..029399593049 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2039,12 +2039,15 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 			     struct inode *inode, struct list_head *list)
 {
 	struct btrfs_ordered_sum *sum;
+	int ret;
 
 	list_for_each_entry(sum, list, list) {
 		trans->adding_csums = true;
-		btrfs_csum_file_blocks(trans,
+		ret = btrfs_csum_file_blocks(trans,
 		       BTRFS_I(inode)->root->fs_info->csum_root, sum);
 		trans->adding_csums = false;
+		if (ret)
+			return ret;
 	}
 	return 0;
 }
@@ -3058,7 +3061,11 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
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

