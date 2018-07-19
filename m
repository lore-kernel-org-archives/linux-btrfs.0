Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48140 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727528AbeGSHq4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 03:46:56 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CC7D5AE12
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:05:17 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: Add DATA_RELOC tree to essential non-empty tree list
Date: Thu, 19 Jul 2018 15:05:14 +0800
Message-Id: <20180719070514.10740-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

DATA RELOC tree should also never be empty.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=200407
Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
It's possible just fold this fix into commit "btrfs: tree-checker: Detect
invalid empty essential tree".

And for the test image, it can already be rejected by misc-next branch
by the enhanced dev-extent checker.
---
 fs/btrfs/tree-checker.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 4c82a628df85..db835635372f 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -504,7 +504,8 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 		    owner == BTRFS_CHUNK_TREE_OBJECTID ||
 		    owner == BTRFS_EXTENT_TREE_OBJECTID ||
 		    owner == BTRFS_DEV_TREE_OBJECTID ||
-		    owner == BTRFS_FS_TREE_OBJECTID) {
+		    owner == BTRFS_FS_TREE_OBJECTID ||
+		    owner == BTRFS_DATA_RELOC_TREE_OBJECTID) {
 			generic_err(fs_info, leaf, 0,
 			"invalid root, root %llu must never be empty",
 				    owner);
-- 
2.18.0

