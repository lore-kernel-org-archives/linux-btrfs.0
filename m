Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11194 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751172AbbBWIAE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Feb 2015 03:00:04 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1N7xCME022578
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Feb 2015 15:59:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Fix a infinite loop when fixing nlink if file name conflicts twice.
Date: Mon, 23 Feb 2015 16:00:04 +0800
Message-ID: <1424678404-5493-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a case that can cause nlink fix function.

For example, lost+found dir already has the following files:
---------------------------
|ino	|filename	  |
|-------------------------|
|258	|normal_file	  |
|259	|normal_file.260  |
---------------------------
The next inode to be fixed is the following:
---------------------------
|260	|normail_file	  |
---------------------------

And when trying to move inode to lost+found dir, its file name conflicts
with inode 258, and even add ".INO" suffix, it still conflicts with
inode 259.

Since the move failed, the LINK_COUNT_ERR flag is not cleared, the inode
record will not be freed, btrfsck will try fix it again and again,
causing the infinite loop.

The patch will first change the ".INO" suffix naming to a loop behavior,
and clear the LINK_COUNT_ERR flag anyway to avoid infinite loop.

Reported-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ce0ac88..62aee83 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2364,7 +2364,11 @@ static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
 		}
 		ret = btrfs_add_link(trans, root, rec->ino, lost_found_ino,
 				     namebuf, namelen, type, NULL, 1);
-		if (ret == -EEXIST) {
+		/*
+		 * Add ".INO" suffix several times to handle case where
+		 * "FILENAME.INO" is already taken by another file.
+		 */
+		while (ret == -EEXIST) {
 			/*
 			 * Conflicting file name, add ".INO" as suffix * +1 for '.'
 			 */
@@ -2396,9 +2400,14 @@ static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
 		printf("Moving file '%.*s' to '%s' dir since it has no valid backref\n",
 		       namelen, namebuf, dir_name);
 	}
-	rec->errors &= ~I_ERR_LINK_COUNT_WRONG;
 	printf("Fixed the nlink of inode %llu\n", rec->ino);
 out:
+	/*
+	 * Clear the flag anyway, or we will loop forever for the same inode
+	 * as it will not be removed from the bad inode list and the dead loop
+	 * happens.
+	 */
+	rec->errors &= ~I_ERR_LINK_COUNT_WRONG;
 	btrfs_release_path(path);
 	return ret;
 }
-- 
2.3.0

