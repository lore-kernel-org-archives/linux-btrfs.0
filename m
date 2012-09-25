Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:41309 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab2IYTXI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 15:23:08 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id qOQfcHbOB6n3PMcs (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2012 13:23:00 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not hold the file extent leaf locked when adding extent item
Date: Tue, 25 Sep 2012 15:28:29 -0400
Message-ID: <1348601309-21090-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For some reason we unlock everything except the leaf we are on, set the path
blocking and then add the extent item for the extent we just finished
writing.  I can't for the life of me figure out why we would want to do
this, and the history doesn't really indicate that there was a real reason
for it, so just remove it.  This will reduce our tree lock contention on
heavy writes.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cad0c57..50a54b3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1823,10 +1823,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_file_extent_encryption(leaf, fi, encryption);
 	btrfs_set_file_extent_other_encoding(leaf, fi, other_encoding);
 
-	btrfs_unlock_up_safe(path, 1);
-	btrfs_set_lock_blocking(leaf);
-
 	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(path);
 
 	inode_add_bytes(inode, num_bytes);
 
-- 
1.7.7.6

