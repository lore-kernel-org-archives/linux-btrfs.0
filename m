Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:40954 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762170Ab3DBVCj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Apr 2013 17:02:39 -0400
Received: from f18.lab.localdomain (unknown [192.168.242.141])
	by tetsuo.zabbo.net (Postfix) with ESMTP id 5790772001F0
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Apr 2013 14:02:38 -0700 (PDT)
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: abort unlink trans in missed error case
Date: Tue,  2 Apr 2013 17:02:16 -0400
Message-Id: <1364936536-13130-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_unlink_inode() aborts its transaction when it sees errors after
it removes the directory item.  But it missed the case where
btrfs_del_dir_entries_in_log() returns an error.  If this happens then
the unlink appears to fail but the items have been removed without
updating the directory size.  The directory then has leaked bytes in
i_size and can never be removed.

Adding the missing transaction abort at least makes this failure
consistent with the other failure cases.

I noticed this while reading the code after someone on irc reported
having a directory with i_size but no entries.  I tested it by forcing
btrfs_del_dir_entries_in_log() to return -ENOMEM.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d96ee30..80676ee 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3619,6 +3619,8 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 					   dir, index);
 	if (ret == -ENOENT)
 		ret = 0;
+	else if (ret)
+		btrfs_abort_transaction(trans, root, ret);
 err:
 	btrfs_free_path(path);
 	if (ret)
-- 
1.8.1.4

