Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from irs1ma.bb4u.ne.jp ([202.229.9.180]:50368 "EHLO
	irs1ma.bb4u.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2KRAdv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Nov 2012 19:33:51 -0500
Received: from prime (nc221141.bb4u.ne.jp [58.89.221.141])
	by irs1ma.bb4u.ne.jp (Postfix) with SMTP id 63D394E0358
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Nov 2012 09:14:00 +0900 (JST)
Date: Sun, 18 Nov 2012 09:14:00 +0900
From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: check next slot type in log_one_extent()
Message-Id: <20121118091400.8566b5c7deeec9e5e676c54d@cl.bb4u.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs-next fails xfstest 127 when checking length of an extent in 
log_one_extent().  Fix this by doing the item type check.

Signed-off-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 40b9efd..0c20bb4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3207,6 +3207,11 @@ again:
                args->src = path->nodes[0];
 next_slot:
                btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+               if (key.objectid != btrfs_ino(inode) ||
+                       key.type != BTRFS_EXTENT_DATA_KEY) {
+                       btrfs_release_path(path);
+                       return -ENOENT;
+               }
                num_bytes = btrfs_file_extent_length(path);
                if (args->nr &&
                    args->start_slot + args->nr == path->slots[0]) {
