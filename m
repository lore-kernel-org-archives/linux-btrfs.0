Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:49795 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab2IXRhY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 13:37:24 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id hegywwRRzNwF1WXO (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 11:37:23 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: run delayed refs first when out of space
Date: Mon, 24 Sep 2012 13:42:55 -0400
Message-ID: <1348508575-3977-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running delayed refs is faster than running delalloc, so lets do that first
to try and reclaim space.  This makes my fs_mark test about 20% faster.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ed5ea43..efb044e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3800,10 +3800,10 @@ commit:
 }
 
 enum flush_state {
-	FLUSH_DELALLOC		=	1,
-	FLUSH_DELALLOC_WAIT	=	2,
-	FLUSH_DELAYED_ITEMS_NR	=	3,
-	FLUSH_DELAYED_ITEMS	=	4,
+	FLUSH_DELAYED_ITEMS_NR	=	1,
+	FLUSH_DELAYED_ITEMS	=	2,
+	FLUSH_DELALLOC		=	3,
+	FLUSH_DELALLOC_WAIT	=	4,
 	ALLOC_CHUNK		=	5,
 	COMMIT_TRANS		=	6,
 };
@@ -3817,11 +3817,6 @@ static int flush_space(struct btrfs_root *root,
 	int ret = 0;
 
 	switch (state) {
-	case FLUSH_DELALLOC:
-	case FLUSH_DELALLOC_WAIT:
-		shrink_delalloc(root, num_bytes, orig_bytes,
-				state == FLUSH_DELALLOC_WAIT);
-		break;
 	case FLUSH_DELAYED_ITEMS_NR:
 	case FLUSH_DELAYED_ITEMS:
 		if (state == FLUSH_DELAYED_ITEMS_NR) {
@@ -3842,6 +3837,11 @@ static int flush_space(struct btrfs_root *root,
 		ret = btrfs_run_delayed_items_nr(trans, root, nr);
 		btrfs_end_transaction(trans, root);
 		break;
+	case FLUSH_DELALLOC:
+	case FLUSH_DELALLOC_WAIT:
+		shrink_delalloc(root, num_bytes, orig_bytes,
+				state == FLUSH_DELALLOC_WAIT);
+		break;
 	case ALLOC_CHUNK:
 		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans)) {
@@ -3886,7 +3886,7 @@ static int reserve_metadata_bytes(struct btrfs_root *root,
 	struct btrfs_space_info *space_info = block_rsv->space_info;
 	u64 used;
 	u64 num_bytes = orig_bytes;
-	int flush_state = FLUSH_DELALLOC;
+	int flush_state = FLUSH_DELAYED_ITEMS_NR;
 	int ret = 0;
 	bool flushing = false;
 	bool committed = false;
-- 
1.7.7.6

