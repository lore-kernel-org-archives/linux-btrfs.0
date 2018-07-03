Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932074AbeGCNkn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 09:40:43 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 74BABACDE
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Jul 2018 13:40:42 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Don't BUG_ON() if we failed to load one device or one chunk
Date: Tue,  3 Jul 2018 21:40:40 +0800
Message-Id: <20180703134040.8108-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Don't panic for btrfs_read_chunk_tree() if one device or chunk is
corrupted.
Caller can already handle it pretty well.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=199839
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/volumes.c b/volumes.c
index 9379d2f61eff..24eb3e8b2578 100644
--- a/volumes.c
+++ b/volumes.c
@@ -2158,13 +2158,15 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 			dev_item = btrfs_item_ptr(leaf, slot,
 						  struct btrfs_dev_item);
 			ret = read_one_dev(fs_info, leaf, dev_item);
-			BUG_ON(ret);
+			if (ret < 0)
+				goto error;
 		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
 			struct btrfs_chunk *chunk;
 			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
 			ret = read_one_chunk(fs_info, &found_key, leaf, chunk,
 					     slot);
-			BUG_ON(ret);
+			if (ret < 0)
+				goto error;
 		}
 		path->slots[0]++;
 	}
-- 
2.18.0

