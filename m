Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750996AbeGIGmJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Jul 2018 02:42:09 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 25BB9ACBB
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Jul 2018 06:42:08 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: Exit gracefully when failed to add chunk map
Date: Mon,  9 Jul 2018 14:42:03 +0800
Message-Id: <20180709064203.32409-3-wqu@suse.com>
In-Reply-To: <20180709064203.32409-1-wqu@suse.com>
References: <20180709064203.32409-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's completely possible that a crafted btrfs image contains overlapping
chunks.

Although we can't detect such problem by tree-checker, but it's not a
catastrophic problem, current extent map can already detect such problem
and return -EEXIST.

We just only need to exit gracefully so btrfs can refuse to mount the
fs.

Reported-by: Xu Wen <wen.xu@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=200409
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 05e418cb37f3..affd288bb216 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6477,10 +6477,14 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 	write_lock(&map_tree->map_tree.lock);
 	ret = add_extent_mapping(&map_tree->map_tree, em, 0);
 	write_unlock(&map_tree->map_tree.lock);
-	BUG_ON(ret); /* Tree corruption */
+	if (ret < 0) {
+		btrfs_err(fs_info,
+			  "failed to add chunk map, start=%llu len=%llu: %d",
+			  em->start, em->len, ret);
+	}
 	free_extent_map(em);
 
-	return 0;
+	return ret;
 }
 
 static void fill_device_from_item(struct extent_buffer *leaf,
-- 
2.18.0

