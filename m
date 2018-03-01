Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:60232 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965487AbeCACsP (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 28 Feb 2018 21:48:15 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, peteryuchuang@gmail.com
Subject: [PATCH 3/4] btrfs-progs: check/lowmem mode: Check inline extent size
Date: Thu,  1 Mar 2018 10:47:46 +0800
Message-Id: <20180301024747.26192-4-wqu@suse.com>
In-Reply-To: <20180301024747.26192-1-wqu@suse.com>
References: <20180301024747.26192-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 62bcf3d2e126..44c58163f8f7 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1417,6 +1417,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 	u64 csum_found;		/* In byte size, sectorsize aligned */
 	u64 search_start;	/* Logical range start we search for csum */
 	u64 search_len;		/* Logical range len we search for csum */
+	u32 max_inline_extent_size = BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info);
 	unsigned int extent_type;
 	unsigned int is_hole;
 	int compressed = 0;
@@ -1440,6 +1441,13 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 				root->objectid, fkey->objectid, fkey->offset);
 			err |= FILE_EXTENT_ERROR;
 		}
+		if (extent_num_bytes > max_inline_extent_size) {
+			error(
+		"root %llu EXTENT_DATA[%llu %llu] too large inline extent size, have %llu, max: %u",
+				root->objectid, fkey->objectid, fkey->offset,
+				extent_num_bytes, max_inline_extent_size);
+			err |= FILE_EXTENT_ERROR;
+		}
 		if (!compressed && extent_num_bytes != item_inline_len) {
 			error(
 		"root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, expected: %u",
-- 
2.16.2

