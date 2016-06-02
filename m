Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1184 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbcFBHXA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 03:23:00 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: convert: Fix a bug which fails to insert hole file extent
Date: Thu,  2 Jun 2016 15:22:49 +0800
Message-Id: <20160602072250.25214-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When copying inode, if there is a file referring part of a hole range,
convert will fail.

The problem is, when calculating real extent bytenr, it doesn't check if
the original extent is a hole.

In case the orinal extent is a hole, we still calculate bytenr using
file_pos - found_extent_file_pos, causing non-zero value, and later
btrfs_record_file_extent() detects that we are pointing to non-exist
extent and aborts convert.

Fix it by checking the disk_bytenr before calculating real disk bytenr.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
These commits (especially for next testcase commits, which includes 4
80+K e2image raw dumps) can also be fetched from my github:
https://github.com/adam900710/btrfs-progs.git convert_fixes
---
 btrfs-convert.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 5f6b44c..43b8b08 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -572,7 +572,11 @@ static int record_file_blocks(struct blk_iterate_data *data,
 		BUG_ON(cur_off - key.offset >= extent_num_bytes);
 		btrfs_release_path(path);
 
-		real_disk_bytenr = cur_off - key.offset + extent_disk_bytenr;
+		if (extent_disk_bytenr)
+			real_disk_bytenr = cur_off - key.offset +
+					   extent_disk_bytenr;
+		else
+			real_disk_bytenr = 0;
 		cur_len = min(key.offset + extent_num_bytes,
 			      old_disk_bytenr + num_bytes) - cur_off;
 		ret = btrfs_record_file_extent(data->trans, data->root,
-- 
2.8.3



