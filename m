Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49294 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbcFAI3u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 04:29:50 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: convert: Insert needed holes for superblock migration
Date: Wed,  1 Jun 2016 16:29:43 +0800
Message-Id: <20160601082943.10364-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New convert doesn't insert holes for superblock migration range.

Unlike old design, which only relocate 4K(superblock size) to other
places.
In new design, to make sure convert can handle different page size and
align chunk bytenr, we relocate the whole 64K range.

And if there is only a 4K used block inside 64K superblock migration range, it
will make converted fs has discontinuous file extents.

This patch will fix it by inserting needed holes to avoid such
discontinuous error.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
David, I'm very sorry, all these recently exposed bugs are related to
superblock migration range, and will only be triggered by special build
ext* images(Needs special space range be allocated in ext*)

I'll try my best to create the minimal trigger e2image dump, our current
image is too large for test cases.

Thanks,
Qu
---
 btrfs-convert.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 42d646c..25c0d17 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1375,6 +1375,8 @@ static int migrate_one_reserved_range(struct btrfs_trans_handle *trans,
 {
 	u64 cur_off = start;
 	u64 cur_len = len;
+	u64 hole_start = start;
+	u64 hole_len;
 	struct cache_extent *cache;
 	struct btrfs_key key;
 	struct extent_buffer *eb;
@@ -1426,9 +1428,23 @@ static int migrate_one_reserved_range(struct btrfs_trans_handle *trans,
 			ret = csum_disk_extent(trans, root, key.objectid,
 					       key.offset);
 
+		/* Don't forget to insert hole */
+		hole_len = cur_off - hole_start;
+		if (hole_len) {
+			ret = btrfs_record_file_extent(trans, root, ino, inode,
+					hole_start, 0, hole_len);
+			if (ret < 0)
+				break;
+		}
+
 		cur_off += key.offset;
+		hole_start = cur_off;
 		cur_len = start + len - cur_off;
 	}
+	/* Last hole */
+	if (start + len - hole_start > 0)
+		ret = btrfs_record_file_extent(trans, root, ino, inode,
+				hole_start, 0, start + len - hole_start);
 	return ret;
 }
 
-- 
2.8.3



