Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46702 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbcE0BZP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 21:25:15 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/2] Btrfs-progs: make convert to allocate space from the desired type of block group
Date: Thu, 26 May 2016 18:26:49 -0700
Message-Id: <1464312410-10999-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During btrfs-convert, it can allocate space from METADATA block
group for data, which is not supposed to be correct, although it
doesn't cause any serious problem except eating METADATA space
 more quickly.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 btrfs-convert.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index b49775c..550aa8f 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -364,6 +364,12 @@ static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
 			continue;
 		}
 
+		if ((!!metadata) !=
+		    (!!(cache->flags & BTRFS_BLOCK_GROUP_METADATA))) {
+			last = cache->key.objectid + cache->key.offset;
+			continue;
+		}
+
 		if (metadata) {
 			BUG_ON(num_bytes != root->nodesize);
 			if (check_crossing_stripes(start, num_bytes)) {
-- 
2.5.0

