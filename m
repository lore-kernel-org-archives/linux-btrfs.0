Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:45742 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab3IKQKz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 12:10:55 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C5DC97C06A2
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 10:10:54 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id WMFwfTzxSK8VrmPK (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 10:10:54 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: replay dir_index items before other items
Date: Wed, 11 Sep 2013 12:10:47 -0400
Message-ID: <1378915847-6300-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a bug where his log would not replay because he was getting
-EEXIST back.  This was because he had a file moved into a directory that was
logged.  What happens is the file had a lower inode number, and so it is
processed first when replaying the log, and so we add the inode ref in for the
directory it was moved to.  But then we process the directories DIR_INDEX item
and try to add the inode ref for that inode and it fails because we already
added it when we replayed the inode.  To solve this problem we need to just
process any DIR_INDEX items we have in the log first so this all is taken care
of, and then we can replay the rest of the items.  With this patch my reproducer
can remount the file system properly instead of erroring out.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index aaa2e2b..c91309d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -93,7 +93,8 @@
  */
 #define LOG_WALK_PIN_ONLY 0
 #define LOG_WALK_REPLAY_INODES 1
-#define LOG_WALK_REPLAY_ALL 2
+#define LOG_WALK_REPLAY_DIR_INDEX 2
+#define LOG_WALK_REPLAY_ALL 3
 
 static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, struct inode *inode,
@@ -2027,6 +2028,15 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 			if (ret)
 				break;
 		}
+
+		if (key.type == BTRFS_DIR_INDEX_KEY &&
+		    wc->stage == LOG_WALK_REPLAY_DIR_INDEX) {
+			ret = replay_one_dir_item(wc->trans, root, path,
+						  eb, i, &key);
+			if (ret)
+				break;
+		}
+
 		if (wc->stage < LOG_WALK_REPLAY_ALL)
 			continue;
 
@@ -2048,8 +2058,7 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 						eb, i, &key);
 			if (ret)
 				break;
-		} else if (key.type == BTRFS_DIR_ITEM_KEY ||
-			   key.type == BTRFS_DIR_INDEX_KEY) {
+		} else if (key.type == BTRFS_DIR_ITEM_KEY) {
 			ret = replay_one_dir_item(wc->trans, root, path,
 						  eb, i, &key);
 			if (ret)
-- 
1.7.7.6

