Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18638 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751744AbbEOFNY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 01:13:24 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: Fix a bug in chunk item extra check and allow degraded chunk.
Date: Fri, 15 May 2015 13:11:14 +0800
Message-ID: <1431666674-23322-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For DUP profile, the num_stripes should be 2 not 1.
This causes btrfs offline tool fails on valid image.

Also, num_stripes check is too restrict for btrfsck self test,
as there is some image in degraded mode, so modify it to allow degraded
chunk.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/volumes.c b/volumes.c
index 77cc305..14ce33e 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1649,12 +1649,11 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	/*
 	 * Device number check against profile
 	 */
-	if ((map->type & BTRFS_BLOCK_GROUP_RAID10 && num_stripes < 4 &&
-	     map->sub_stripes < 2) ||
-	    (map->type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 2) ||
-	    (map->type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 3) ||
-	    (map->type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 4) ||
-	    (map->type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 1) ||
+	if ((map->type & BTRFS_BLOCK_GROUP_RAID10 && map->sub_stripes == 0) ||
+	    (map->type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
+	    (map->type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
+	    (map->type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
+	    (map->type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
 	    ((map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
 	     num_stripes != 1)) {
 		fprintf(stderr,
-- 
2.4.0

