Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:33786 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbdFFXpm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 19:45:42 -0400
Received: by mail-pg0-f46.google.com with SMTP id f185so39481227pgc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 16:45:42 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        kernel-team@fb.com
Subject: [PATCH 1/7] Btrfs: make add_pinned_bytes() take an s64 num_bytes instead of u64
Date: Tue,  6 Jun 2017 16:45:26 -0700
Message-Id: <c13a2336c1d68648413e7c4beac574999c5d1ba4.1496792333.git.osandov@fb.com>
In-Reply-To: <cover.1496792333.git.osandov@fb.com>
References: <cover.1496792333.git.osandov@fb.com>
In-Reply-To: <cover.1496792333.git.osandov@fb.com>
References: <cover.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

There are a few places where we pass in a negative num_bytes, so make it
signed for clarity. Also move it up in the file since later patches will
need it there.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e390451c72e6..7c01b4e9e3b6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -766,6 +766,26 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 	return NULL;
 }
 
+static void add_pinned_bytes(struct btrfs_fs_info *fs_info, s64 num_bytes,
+			     u64 owner, u64 root_objectid)
+{
+	struct btrfs_space_info *space_info;
+	u64 flags;
+
+	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
+		if (root_objectid == BTRFS_CHUNK_TREE_OBJECTID)
+			flags = BTRFS_BLOCK_GROUP_SYSTEM;
+		else
+			flags = BTRFS_BLOCK_GROUP_METADATA;
+	} else {
+		flags = BTRFS_BLOCK_GROUP_DATA;
+	}
+
+	space_info = __find_space_info(fs_info, flags);
+	BUG_ON(!space_info); /* Logic bug */
+	percpu_counter_add(&space_info->total_bytes_pinned, num_bytes);
+}
+
 /*
  * after adding space to the filesystem, we need to clear the full flags
  * on all the space infos.
@@ -6793,27 +6813,6 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static void add_pinned_bytes(struct btrfs_fs_info *fs_info, u64 num_bytes,
-			     u64 owner, u64 root_objectid)
-{
-	struct btrfs_space_info *space_info;
-	u64 flags;
-
-	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		if (root_objectid == BTRFS_CHUNK_TREE_OBJECTID)
-			flags = BTRFS_BLOCK_GROUP_SYSTEM;
-		else
-			flags = BTRFS_BLOCK_GROUP_METADATA;
-	} else {
-		flags = BTRFS_BLOCK_GROUP_DATA;
-	}
-
-	space_info = __find_space_info(fs_info, flags);
-	BUG_ON(!space_info); /* Logic bug */
-	percpu_counter_add(&space_info->total_bytes_pinned, num_bytes);
-}
-
-
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *info,
 				struct btrfs_delayed_ref_node *node, u64 parent,
-- 
2.13.0

