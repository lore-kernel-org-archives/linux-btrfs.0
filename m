Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:52135 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdKMEcO (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Sun, 12 Nov 2017 23:32:14 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris@colorremedies.com
Subject: [PATCH 1/3] btrfs-progs: lowmem fsck: Fix inlined data extent ref lookup
Date: Mon, 13 Nov 2017 12:32:01 +0800
Message-Id: <20171113043203.9859-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When lowmem fsck tries to find backref of a specified file extent, it
searches inlined data ref first.

However, extent data ref contains owner root objectid, inode number
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
 cmds-check.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 5c822b848608..0ceff5b7bbea 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10411,11 +10411,11 @@ static int check_extent_data_item(struct btrfs_root *root,
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
 	int err = 0;
 	int ret;
@@ -10431,6 +10431,7 @@ static int check_extent_data_item(struct btrfs_root *root,
 	disk_bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
 	disk_num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
 	extent_num_bytes = btrfs_file_extent_num_bytes(eb, fi);
+	offset = btrfs_file_extent_offset(eb, fi);
 
 	/* Check unaligned disk_num_bytes and num_bytes */
 	if (!IS_ALIGNED(disk_num_bytes, root->fs_info->sectorsize)) {
@@ -10483,13 +10484,22 @@ static int check_extent_data_item(struct btrfs_root *root,
 	ptr = (unsigned long)iref;
 	end = (unsigned long)ei + item_size;
 	while (ptr < end) {
+		u64 ref_root;
+		u64 ref_objectid;
+		u64 ref_offset;
+
 		iref = (struct btrfs_extent_inline_ref *)ptr;
 		type = btrfs_extent_inline_ref_type(leaf, iref);
 		dref = (struct btrfs_extent_data_ref *)(&iref->offset);
 
 		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
 			ref_root = btrfs_extent_data_ref_root(leaf, dref);
-			if (ref_root == owner || ref_root == root->objectid)
+			ref_objectid = btrfs_extent_data_ref_objectid(leaf, dref);
+			ref_offset = btrfs_extent_data_ref_offset(leaf, dref);
+
+			if ((ref_root == owner || ref_root == root->objectid) &&
+			     ref_objectid == fi_key.objectid &&
+			     ref_offset == fi_key.offset - offset)
 				found_dbackref = 1;
 		} else if (type == BTRFS_SHARED_DATA_REF_KEY) {
 			found_dbackref = !check_tree_block_ref(root, NULL,
-- 
2.15.0

