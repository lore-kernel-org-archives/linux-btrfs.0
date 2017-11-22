Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:51148 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbdKVJEC (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 22 Nov 2017 04:04:02 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 03/11] btrfs-progs: lowmem check: Fix inlined data extent ref lookup
Date: Wed, 22 Nov 2017 17:03:17 +0800
Message-Id: <20171122090325.29458-4-wqu@suse.com>
In-Reply-To: <20171122090325.29458-1-wqu@suse.com>
References: <20171122090325.29458-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When lowmem fsck tries to find backref of a specified file extent, it
searches inlined data ref first.

However, extent data ref contains both owner root objectid, inode number
and calculated offset (file offset - extent offset).

The code only checks owner root objectid, not checking inode number nor
calculated offset.

This makes lowmem mode fails to detect any backref mismatch if there is
a inlined data ref with the same owner objectid.

Fix it by also checking extent data ref's objectid and offset.

Fixes: b0d360b541f0 ("btrfs-progs: check: introduce function to check data backref in extent tree")
Reported-by: Chris Murphy <chris@colorremedies.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-check.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 03ff89a4221c..9f9eb504ae8e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12005,11 +12005,11 @@ static int check_extent_data_item(struct btrfs_root *root,
 	u64 disk_num_bytes;
 	u64 extent_num_bytes;
 	u64 extent_flags;
+	u64 offset;
 	u32 item_size;
 	unsigned long end;
 	unsigned long ptr;
 	int type;
-	u64 ref_root;
 	int found_dbackref = 0;
 	int slot = pathp->slots[0];
 	int err = 0;
@@ -12027,6 +12027,7 @@ static int check_extent_data_item(struct btrfs_root *root,
 	disk_bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
 	disk_num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
 	extent_num_bytes = btrfs_file_extent_num_bytes(eb, fi);
+	offset = btrfs_file_extent_offset(eb, fi);
 
 	/* Check unaligned disk_num_bytes and num_bytes */
 	if (!IS_ALIGNED(disk_num_bytes, root->fs_info->sectorsize)) {
@@ -12081,6 +12082,11 @@ static int check_extent_data_item(struct btrfs_root *root,
 	strict = should_check_extent_strictly(root, nrefs, -1);
 
 	while (ptr < end) {
+		u64 ref_root;
+		u64 ref_objectid;
+		u64 ref_offset;
+		bool match = false;
+
 		iref = (struct btrfs_extent_inline_ref *)ptr;
 		type = btrfs_extent_inline_ref_type(leaf, iref);
 		dref = (struct btrfs_extent_data_ref *)(&iref->offset);
@@ -12092,9 +12098,15 @@ static int check_extent_data_item(struct btrfs_root *root,
 		}
 		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
 			ref_root = btrfs_extent_data_ref_root(leaf, dref);
-			if (ref_root == root->objectid)
+			ref_objectid = btrfs_extent_data_ref_objectid(leaf, dref);
+			ref_offset = btrfs_extent_data_ref_offset(leaf, dref);
+
+			if (ref_objectid == fi_key.objectid &&
+			    ref_offset == fi_key.offset - offset)
+				match = true;
+			if (ref_root == root->objectid && match)
 				found_dbackref = 1;
-			else if (!strict && owner == ref_root)
+			else if (!strict && owner == ref_root && match)
 				found_dbackref = 1;
 		} else if (type == BTRFS_SHARED_DATA_REF_KEY) {
 			found_dbackref = !check_tree_block_ref(root, NULL,
-- 
2.15.0

