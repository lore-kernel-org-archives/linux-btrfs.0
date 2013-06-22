Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36194 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3FVFdD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Jun 2013 01:33:03 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH 1/5] Btrfs-progs: fix misuse of skinny metadata in btrfs-image
Date: Sat, 22 Jun 2013 13:32:41 +0800
Message-Id: <1371879165-4993-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1371879165-4993-1-git-send-email-bo.li.liu@oracle.com>
References: <1371879165-4993-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As for skinny metadata, key.offset stores levels rather than extent length.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 btrfs-image.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 22239fe..30c1a9a 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1169,9 +1169,9 @@ static int copy_from_extent_tree(struct metadump_struct *metadump,
 
 		bytenr = key.objectid;
 		if (key.type == BTRFS_METADATA_ITEM_KEY)
-			num_bytes = key.offset;
-		else
 			num_bytes = extent_root->leafsize;
+		else
+			num_bytes = key.offset;
 
 		if (btrfs_item_size_nr(leaf, path->slots[0]) > sizeof(*ei)) {
 			ei = btrfs_item_ptr(leaf, path->slots[0],
-- 
1.7.7

