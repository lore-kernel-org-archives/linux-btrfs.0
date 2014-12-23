Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40519 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753380AbaLWB3w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 20:29:52 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBN1TN1E032074
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Dec 2014 09:29:23 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Fix a bug in reset_nlink() which may deletes the recovered file
Date: Tue, 23 Dec 2014 09:29:44 +0800
Message-ID: <1419298184-8540-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In reset_nlink(), we believe rec->found_link as accurate number of the
valid links. However it only records the number of found DIR_ITEM, so we
can't use it as reliable value.

Before this patch, in some case, leaf corruption recovery will believe
there is a valid backref but don't add_link() since it can't find any
valid one and don't put it into the lost+found dir.
So the recovered inode will be considered as an orphan item without
orphan item and repair_inode_orphan_item() will add orphan item for it,
causing all the filename/filetype we recovered being a waste of time.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index aa47984..1bb95dc 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1959,6 +1959,9 @@ static int reset_nlink(struct btrfs_trans_handle *trans,
 	struct btrfs_inode_item *inode_item;
 	int ret = 0;
 
+	/* We don't believe this either, reset it and iterate backref */
+	rec->found_link = 0;
+
 	/* Remove all backref including the valid ones */
 	list_for_each_entry_safe(backref, tmp, &rec->backrefs, list) {
 		ret = btrfs_unlink(trans, root, rec->ino, backref->dir,
@@ -1973,7 +1976,8 @@ static int reset_nlink(struct btrfs_trans_handle *trans,
 		      backref->found_inode_ref)) {
 			list_del(&backref->list);
 			free(backref);
-		}
+		} else
+			rec->found_link++;
 	}
 
 	/* Set nlink to 0 */
-- 
2.2.1

