Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752366AbdI1Hx0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 03:53:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9A85AAAB9
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 07:53:24 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, fdmanana@suse.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: Explicitly handle btrfs_update_root failure
Date: Thu, 28 Sep 2017 10:53:17 +0300
Message-Id: <1506585198-32494-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20170927140007.GH31640@twin.jikos.cz>
References: <20170927140007.GH31640@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_udpate_root can fail and it aborts the transaction, the correct way to
handle an aborted transaction is to explicitly end with btrfs_end_transaction.
Even now the code is correct since btrfs_commit_transaction would handle an
aborted transaction but this is more of an implementation detail. So let's be
explicit in handling failure in btrfs_update_root.

Furthermore btrfs_commit_transaction can also fail and by ignoring it's return
value we could have left the in-memory copy of the root item in an inconsistent
state. So capture the error value which allows us to correctly revert the RO/RW
flags in case of commit failure.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d6715c2bcdc4..ee4ee7cbba72 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1842,8 +1842,13 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
+	if (ret < 0) {
+		btrfs_end_transaction(trans);
+		goto out_reset;
+	}
+
+	ret = btrfs_commit_transaction(trans);
 
-	btrfs_commit_transaction(trans);
 out_reset:
 	if (ret)
 		btrfs_set_root_flags(&root->root_item, root_flags);
-- 
2.7.4

