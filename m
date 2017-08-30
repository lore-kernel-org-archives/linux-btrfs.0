Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:33466 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752409AbdH3R2t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Aug 2017 13:28:49 -0400
Received: by mail-pg0-f42.google.com with SMTP id t3so21768466pgt.0
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Aug 2017 10:28:49 -0700 (PDT)
From: Yingyi Luo <yingyil@google.com>
To: linux-btrfs@vger.kernel.org
Cc: drosen@google.com, yingyil <yingyil@google.com>
Subject: [PATCH 3/4 v2] btrfs-progs: mkfs: refactor create_data_reloc_tree
Date: Wed, 30 Aug 2017 10:24:49 -0700
Message-Id: <20170830172450.27460-4-yingyil@google.com>
In-Reply-To: <20170830172450.27460-1-yingyil@google.com>
References: <20170825232101.10859-1-yingyil@google.com>
 <20170830172450.27460-1-yingyil@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: yingyil <yingyil@google.com>

Add an objectid parameter to make the function a general one for
inserting root items and rename it to create_tree. The change cascades
down to the callchain.

Signed-off-by: yingyil <yingyil@google.com>
---
v2: utilize create_tree() function for creating a subvolume, instead of
create_subvol() in convert/main.c.

 mkfs/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index afd68bc5..869c11fa 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -320,13 +320,12 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int create_data_reloc_tree(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root)
+static int create_tree(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, u64 objectid)
 {
 	struct btrfs_key location;
 	struct btrfs_root_item root_item;
 	struct extent_buffer *tmp;
-	u64 objectid = BTRFS_DATA_RELOC_TREE_OBJECTID;
 	int ret;
 
 	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
@@ -1846,7 +1845,7 @@ raid_groups:
 		}
 	}
 
-	ret = create_data_reloc_tree(trans, root);
+	ret = create_tree(trans, root, BTRFS_DATA_RELOC_TREE_OBJECTID);
 	if (ret) {
 		error("unable to create data reloc tree: %d", ret);
 		goto out;
-- 
2.14.1.342.g6490525c54-goog

