Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:43829 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab2JAR4e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Oct 2012 13:56:34 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id azPfPVTJKqN1bmGK (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 01 Oct 2012 11:56:32 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: be smarter about dropping things from the tree log V2
Date: Mon, 1 Oct 2012 14:02:07 -0400
Message-ID: <1349114527-4440-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we truncate existing items in the tree log we've been searching for
each individual item and removing them.  This is unnecessary churn and
searching, just keep track of the slot we are on and how many items we need
to delete and delete them all at once.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: do as zach suggested and bin search down to the lowest key in this leaf
and delete from there.  In practice this won't be more than 2 or 3 items, but if
you have lots of xattrs it could be a lot more.

 fs/btrfs/tree-log.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4e468a0..a5dcf71 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2872,6 +2872,7 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
 	int ret;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
+	int start_slot;
 
 	key.objectid = objectid;
 	key.type = max_key_type;
@@ -2893,8 +2894,18 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
 		if (found_key.objectid != objectid)
 			break;
 
-		ret = btrfs_del_item(trans, log, path);
-		if (ret)
+		found_key.offset = 0;
+		found_key.type = 0;
+		ret = btrfs_bin_search(path->nodes[0], &found_key, 0,
+				       &start_slot);
+
+		ret = btrfs_del_items(trans, log, path, start_slot,
+				      path->slots[0] - start_slot + 1);
+		/*
+		 * If start slot isn't 0 then we don't need to re-search, we've
+		 * found the last guy with the objectid in this tree.
+		 */
+		if (ret || start_slot != 0)
 			break;
 		btrfs_release_path(path);
 	}
-- 
1.7.7.6

