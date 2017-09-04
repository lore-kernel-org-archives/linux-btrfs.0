Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59507 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753198AbdIDDn3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 Sep 2017 23:43:29 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/2] btrfs-progs: mkfs: Fix wrong file type for dir items and indexes when specifying root directory
Date: Mon,  4 Sep 2017 12:43:19 +0900
Message-Id: <20170904034320.25744-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Bug]
If using mkfs.btrfs with "-r" parameter and specified direct has
fifo/socket/char/block special file, then created btrfs can't pass fsck:

------
checking fs roots
	unresolved ref dir 241158 index 3 namelen 9 name S.dirmngr filetype 0 errors 80, filetype mismatch
ERROR: errors found in fs roots
------

[Reason]
Btrfs dir items/indexes records inode type, while "-r" only handles
directors, regular files and soft link, it makes such special files type
to be regular file and caused the problem.

[Fix]
Add missing types for add_directory_items(), so that result of
"mkfs.btrfs -r" can pass mkfs.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 mkfs/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index afd68bc5..84ff300b 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -435,6 +435,14 @@ static int add_directory_items(struct btrfs_trans_handle *trans,
 		filetype = BTRFS_FT_REG_FILE;
 	if (S_ISLNK(st->st_mode))
 		filetype = BTRFS_FT_SYMLINK;
+	if (S_ISSOCK(st->st_mode))
+		filetype = BTRFS_FT_SOCK;
+	if (S_ISCHR(st->st_mode))
+		filetype = BTRFS_FT_CHRDEV;
+	if (S_ISBLK(st->st_mode))
+		filetype = BTRFS_FT_BLKDEV;
+	if (S_ISFIFO(st->st_mode))
+		filetype = BTRFS_FT_FIFO;
 
 	ret = btrfs_insert_dir_item(trans, root, name, name_len,
 				    parent_inum, &location,
-- 
2.14.1

