Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62129 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750930AbdEaF40 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 01:56:26 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 5/6] btrfs-progs: lowmem check: Fix false alert on missing chunk or dev extent
Date: Wed, 31 May 2017 13:56:09 +0800
Message-ID: <20170531055610.11606-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170531055610.11606-1-quwenruo@cn.fujitsu.com>
References: <20170531055610.11606-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When checking chunk or dev extent, lowmem mode uses chunk length as dev
extent length, and if they mismatch, report missing chunk or dev extent
like:
------
ERROR: chunk[256 4324327424) stripe 0 did not find the related dev extent
ERROR: chunk[256 4324327424) stripe 1 did not find the related dev extent
ERROR: chunk[256 4324327424) stripe 2 did not find the related dev extent
------

However, only for Single/DUP/RAID1 profiles chunk length is the same as
dev extent length.
For other profiles, this will cause tons of false alert.

Fix it by using correct stripe length when checking chunk and dev extent
items.

This fixes the mkfs test failure when using lowmem mode check.

Reported-by: Kai Krakow <hurikhan77@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index b19d5a28..52091325 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10920,7 +10920,12 @@ static int check_dev_extent_item(struct btrfs_fs_info *fs_info,
 
 	l = path.nodes[0];
 	chunk = btrfs_item_ptr(l, path.slots[0], struct btrfs_chunk);
-	if (btrfs_chunk_length(l, chunk) != length)
+	ret = btrfs_check_chunk_valid(chunk_root, l, chunk, path.slots[0],
+				      chunk_key.offset);
+	if (ret < 0)
+		goto out;
+
+	if (btrfs_stripe_length(fs_info, l, chunk) != length)
 		goto out;
 
 	num_stripes = btrfs_chunk_num_stripes(l, chunk);
@@ -11160,6 +11165,7 @@ static int check_chunk_item(struct btrfs_fs_info *fs_info,
 	struct btrfs_dev_extent *ptr;
 	u64 length;
 	u64 chunk_end;
+	u64 stripe_len;
 	u64 type;
 	int num_stripes;
 	u64 offset;
@@ -11209,6 +11215,7 @@ static int check_chunk_item(struct btrfs_fs_info *fs_info,
 	}
 
 	num_stripes = btrfs_chunk_num_stripes(eb, chunk);
+	stripe_len = btrfs_stripe_length(fs_info, eb, chunk);
 	for (i = 0; i < num_stripes; i++) {
 		btrfs_release_path(&path);
 		btrfs_init_path(&path);
@@ -11228,7 +11235,7 @@ static int check_chunk_item(struct btrfs_fs_info *fs_info,
 		offset = btrfs_dev_extent_chunk_offset(leaf, ptr);
 		if (objectid != chunk_key.objectid ||
 		    offset != chunk_key.offset ||
-		    btrfs_dev_extent_length(leaf, ptr) != length)
+		    btrfs_dev_extent_length(leaf, ptr) != stripe_len)
 			goto not_match_dev;
 		continue;
 not_match_dev:
-- 
2.13.0



