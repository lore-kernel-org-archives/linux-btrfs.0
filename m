Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:39747 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499AbcHCUht (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Aug 2016 16:37:49 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u73Jsa4t021220
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Aug 2016 19:54:36 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: check btree node's nritems
Date: Wed,  3 Aug 2016 12:57:28 -0700
Message-Id: <1470254248-24041-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When btree node (level = 1) has nritems which equals to zero,
we can end up with panic due to insert_ptr()'s

BUG_ON(slot > nritems);

where slot is 1 and nritems is 0, as copy_for_split() calls
insert_ptr(.., path->slots[1] + 1, ...);

A invalid value results in the whole mess, this adds the check
for btree's node nritems so that we stop reading block when
when something is wrong.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 37d1780..a5a22be 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -612,6 +612,20 @@ static noinline int check_leaf(struct btrfs_root *root,
 	return 0;
 }
 
+static noinline int check_node(struct btrfs_root *root,
+			       struct extent_buffer *node)
+{
+	unsigned long nr = btrfs_header_nritems(node);
+
+	if (nr <= 0 || nr >= BTRFS_NODEPTRS_PER_BLOCK(root)) {
+		btrfs_crit(root->fs_info,
+			   "corrupt node: block %llu root %llu nritems %lu\n",
+			   node->start, root->objectid, nr);
+		return -EIO;
+	}
+	return 0;
+}
+
 static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 				      u64 phy_offset, struct page *page,
 				      u64 start, u64 end, int mirror)
@@ -682,6 +696,9 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		ret = -EIO;
 	}
 
+	if (found_level > 0 && check_node(root, eb))
+		ret = -EIO;
+
 	if (!ret)
 		set_extent_buffer_uptodate(eb);
 err:
-- 
2.5.5

