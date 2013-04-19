Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:8648 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030512Ab3DSPIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 11:08:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp3) (RZmta 31.27 OK)
	with ESMTP id p0498cp3JEKjFp for <linux-btrfs@vger.kernel.org>;
	Fri, 19 Apr 2013 17:08:05 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: set UUID in root_item for created trees
Date: Fri, 19 Apr 2013 17:08:05 +0200
Message-Id: <1366384085-26890-2-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1366384085-26890-1-git-send-email-sbehrens@giantdisaster.de>
References: <1366384085-26890-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is a rare exception that a new tree is created, like the qgroups
tree. So far these new trees have an all-zero UUID in their root
items. All trees that mkfs.btrfs has created get an UUID during the
first mount when btrfs_read_root_item() rewrites the root_item to
the v2 structure style. These UUID are never used so far, but
anyway, since it is better to have it uniform for all trees, this
commit adds some lines that generate and write an UUID for newly
created trees.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/disk-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a284421..9d61fff 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/migrate.h>
 #include <linux/ratelimit.h>
+#include <linux/uuid.h>
 #include <asm/unaligned.h>
 #include "compat.h"
 #include "ctree.h"
@@ -1313,6 +1314,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	int ret = 0;
 	u64 bytenr;
+	uuid_le uuid;
 
 	root = btrfs_alloc_root(fs_info);
 	if (!root)
@@ -1362,6 +1364,8 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	btrfs_set_root_used(&root->root_item, leaf->len);
 	btrfs_set_root_last_snapshot(&root->root_item, 0);
 	btrfs_set_root_dirid(&root->root_item, 0);
+	uuid_le_gen(&uuid);
+	memcpy(root->root_item.uuid, uuid.b, BTRFS_UUID_SIZE);
 	root->root_item.drop_level = 0;
 
 	key.objectid = objectid;
-- 
1.8.2.1

