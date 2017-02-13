Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41626 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752312AbdBMJep (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:45 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 89C5DABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:39 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 16/29] btrfs: remove unused parameter from add_pending_csums
Date: Mon, 13 Feb 2017 10:34:10 +0100
Message-Id: <9ceb2cc30952a3af639e31c4f51c380f3ce0ffad.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Never used.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7ed693294498..3ac7474f921d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1961,8 +1961,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, struct bio *bio,
  * at IO completion time based on sums calculated at bio submission time.
  */
 static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
-			     struct inode *inode, u64 file_offset,
-			     struct list_head *list)
+			     struct inode *inode, struct list_head *list)
 {
 	struct btrfs_ordered_sum *sum;
 
@@ -2956,8 +2955,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		goto out_unlock;
 	}
 
-	add_pending_csums(trans, inode, ordered_extent->file_offset,
-			  &ordered_extent->list);
+	add_pending_csums(trans, inode, &ordered_extent->list);
 
 	btrfs_ordered_update_i_size(inode, 0, ordered_extent);
 	ret = btrfs_update_inode_fallback(trans, root, inode);
-- 
2.10.1

