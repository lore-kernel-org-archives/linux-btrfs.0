Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:40528 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754305AbeDCFkE (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 3 Apr 2018 01:40:04 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: check: Skip data csum verification for metadata dump
Date: Tue,  3 Apr 2018 13:39:46 +0800
Message-Id: <20180403053947.5908-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For metadata dump (fs restored by btrfs-image), since no data is
restored check sum verification will definitely report error.

Add such check in check_csums() and prompt for user.

Issue: #103
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 891a6d797756..15c94543946a 100644
--- a/check/main.c
+++ b/check/main.c
@@ -5601,6 +5601,7 @@ static int check_csums(struct btrfs_root *root)
 	int ret;
 	u64 data_len;
 	unsigned long leaf_offset;
+	bool verify_csum = !!check_data_csum;
 
 	root = root->fs_info->csum_root;
 	if (!extent_buffer_uptodate(root->node)) {
@@ -5623,6 +5624,16 @@ static int check_csums(struct btrfs_root *root)
 		path.slots[0]--;
 	ret = 0;
 
+	/*
+	 * For metadata dump (btrfs-image) all data is wiped so verifying data
+	 * csum is meaningless and will always report csum error.
+	 */
+	if (check_data_csum && (btrfs_super_flags(root->fs_info->super_copy) &
+	    (BTRFS_SUPER_FLAG_METADUMP | BTRFS_SUPER_FLAG_METADUMP_V2))) {
+		printf("skip data csum verification for metadata dump\n");
+		verify_csum = false;
+	}
+
 	while (1) {
 		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
 			ret = btrfs_next_leaf(root, &path);
@@ -5644,7 +5655,7 @@ static int check_csums(struct btrfs_root *root)
 
 		data_len = (btrfs_item_size_nr(leaf, path.slots[0]) /
 			      csum_size) * root->fs_info->sectorsize;
-		if (!check_data_csum)
+		if (!verify_csum)
 			goto skip_csum_check;
 		leaf_offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
 		ret = check_extent_csums(root, key.offset, data_len,
-- 
2.16.3

