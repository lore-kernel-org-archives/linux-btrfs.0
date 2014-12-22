Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47262 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753731AbaLVCzi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 21:55:38 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <fdmanana@gmail.com>
Subject: [PATCH] btrfs-progs: Don't increase error count if the inode can be repaired.
Date: Mon, 22 Dec 2014 10:53:36 +0800
Message-ID: <1419216816-13171-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original check_inode_recs() will return -1 if found any error in a
inode_record. This is OK for original design since there is almost
nothing can repair at that time.

However more and more error from nlink mismatch to missing inode item
can be repaired in try_repair_inode(), check_inode_recs() should not
increase the error count if the inode can be repair.

With this patch, repair function for leaf-corruption will not return
error if all corruption inode can be recovered.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 3e7a4eb..aa47984 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2302,7 +2302,7 @@ static int check_inode_recs(struct btrfs_root *root,
 	struct inode_record *rec;
 	struct inode_backref *backref;
 	int stage = 0;
-	int ret;
+	int ret = 0;
 	int err = 0;
 	u64 error = 0;
 	u64 root_dirid = btrfs_root_dirid(&root->root_item);
@@ -2452,7 +2452,8 @@ static int check_inode_recs(struct btrfs_root *root,
 			ret = 0;
 		}
 
-		error++;
+		if (!(repair && ret == 0))
+			error++;
 		print_inode_error(root, rec);
 		list_for_each_entry(backref, &rec->backrefs, list) {
 			if (!backref->found_dir_item)
-- 
2.2.0

