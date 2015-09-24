Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39116 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbbIXTNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 15:13:42 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH v2 2/2] btrfs: reada: Fix returned errno code
Date: Thu, 24 Sep 2015 20:13:33 +0100
Message-Id: <cae144357b99745472aad5d3e98acb8028bfb2ee.1443121865.git.luisbg@osg.samsung.com>
In-Reply-To: <cover.1443121865.git.luisbg@osg.samsung.com>
References: <cover.1443121865.git.luisbg@osg.samsung.com>
In-Reply-To: <cover.1443121865.git.luisbg@osg.samsung.com>
References: <cover.1443121865.git.luisbg@osg.samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

reada is using -1 instead of the -ENOMEM defined macro to specify that
a buffer allocation failed. Since the error number is propagated, the
caller will get a -EPERM which is the wrong error condition.

Also, updating the caller to return the exact value from
reada_add_block.

Smatch tool warning:
reada_add_block() warn: returning -1 instead of -ENOMEM is sloppy

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---
 fs/btrfs/reada.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 4645cd1..619f929 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -569,7 +569,7 @@ static int reada_add_block(struct reada_control *rc, u64 logical,
 	rec = kzalloc(sizeof(*rec), GFP_NOFS);
 	if (!rec) {
 		reada_extent_put(root->fs_info, re);
-		return -1;
+		return -ENOMEM;
 	}
 
 	rec->rc = rc;
@@ -918,6 +918,7 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 	u64 start;
 	u64 generation;
 	int level;
+	int ret;
 	struct extent_buffer *node;
 	static struct btrfs_key max_key = {
 		.objectid = (u64)-1,
@@ -943,9 +944,10 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 	generation = btrfs_header_generation(node);
 	free_extent_buffer(node);
 
-	if (reada_add_block(rc, start, &max_key, level, generation)) {
+	ret = reada_add_block(rc, start, &max_key, level, generation);
+	if (ret) {
 		kfree(rc);
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(ret);
 	}
 
 	reada_start_machine(root->fs_info);
-- 
2.5.1

