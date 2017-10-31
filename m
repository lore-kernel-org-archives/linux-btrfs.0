Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:53755 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbdJaGIh (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 31 Oct 2017 02:08:37 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: Don't generate UUID for non-fs tree
Date: Tue, 31 Oct 2017 14:08:16 +0800
Message-Id: <20171031060816.683-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_create_tree() will unconditionally generate UUID for any root.
So for quota tree and data reloc tree created by kernel, they will have
unique UUIDs.

However UUID in root item is only referred by UUID tree, which only
records UUID for fs trees.
This makes unique UUIDs for quota/data reloc tree meaningless.

Leave the UUID as zero for non-fs tree, making btrfs-debug-tree output
less confusing.

Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dfdab849037b..d85e04a675fe 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1403,7 +1403,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root;
 	struct btrfs_key key;
 	int ret = 0;
-	uuid_le uuid;
+	uuid_le uuid = { 0 };
 
 	root = btrfs_alloc_root(fs_info, GFP_KERNEL);
 	if (!root)
@@ -1444,7 +1444,8 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	btrfs_set_root_used(&root->root_item, leaf->len);
 	btrfs_set_root_last_snapshot(&root->root_item, 0);
 	btrfs_set_root_dirid(&root->root_item, 0);
-	uuid_le_gen(&uuid);
+	if (is_fstree(objectid))
+		uuid_le_gen(&uuid);
 	memcpy(root->root_item.uuid, uuid.b, BTRFS_UUID_SIZE);
 	root->root_item.drop_level = 0;
 
-- 
2.14.3

