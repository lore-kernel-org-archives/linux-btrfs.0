Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:60994 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab2I1PxF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 11:53:05 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id XHim3BZ9aY5bSWGi (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 09:53:03 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: be smarter about dropping things from the tree log
Date: Fri, 28 Sep 2012 11:58:34 -0400
Message-ID: <1348847914-2192-1-git-send-email-jbacik@fusionio.com>
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
 fs/btrfs/tree-log.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4e468a0..90e1c28 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2872,12 +2872,15 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
 	int ret;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
+	int start_slot;
+	int del_nr = 0;
 
 	key.objectid = objectid;
 	key.type = max_key_type;
 	key.offset = (u64)-1;
 
 	while (1) {
+		del_nr = 0;
 		ret = btrfs_search_slot(trans, log, &key, path, -1, 1);
 		BUG_ON(ret == 0);
 		if (ret < 0)
@@ -2885,20 +2888,29 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
 
 		if (path->slots[0] == 0)
 			break;
-
+next_slot:
 		path->slots[0]--;
+
 		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
 				      path->slots[0]);
 
 		if (found_key.objectid != objectid)
 			break;
 
-		ret = btrfs_del_item(trans, log, path);
+		start_slot = path->slots[0];
+		del_nr++;
+		if (start_slot)
+			goto next_slot;
+
+		ret = btrfs_del_items(trans, log, path, start_slot, del_nr);
 		if (ret)
 			break;
 		btrfs_release_path(path);
 	}
+	if (!ret && del_nr)
+		ret = btrfs_del_items(trans, log, path, start_slot, del_nr);
 	btrfs_release_path(path);
+
 	if (ret > 0)
 		ret = 0;
 	return ret;
-- 
1.7.7.6

