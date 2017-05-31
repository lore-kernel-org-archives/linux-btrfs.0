Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58416 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750862AbdEaF4Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 01:56:25 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 2/6] btrfs-progs: Enhance chunk item validation check
Date: Wed, 31 May 2017 13:56:06 +0800
Message-ID: <20170531055610.11606-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170531055610.11606-1-quwenruo@cn.fujitsu.com>
References: <20170531055610.11606-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_check_chunk_valid() doesn't check if
1) chunk flag has conflicting flags
   For example chunk type DATA|METADATA|RAID1|RAID10 is completely
   invalid, while current check_chunk_valid() can't detect it.
2) num_stripes is invalid for RAID10
   Num_stripes 5 is not valid for RAID10.

This patch will enhance btrfs_check_chunk_valid() to handle above cases.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/volumes.c b/volumes.c
index 62e23aee..57534314 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1725,6 +1725,20 @@ int btrfs_check_chunk_valid(struct btrfs_root *root,
 			BTRFS_BLOCK_GROUP_PROFILE_MASK) & type);
 		return -EIO;
 	}
+	if (!(type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
+		error("missing chunk type flag: %llu", type);
+		return -EIO;
+	}
+	if (!(is_power_of_2(type & BTRFS_BLOCK_GROUP_PROFILE_MASK) ||
+	      (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0)) {
+		error("conflicting chunk type detected: %llu", type);
+		return -EIO;
+	}
+	if ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) &&
+	    !is_power_of_2(type & BTRFS_BLOCK_GROUP_PROFILE_MASK)) {
+		error("conflicting chunk profile detected: %llu", type);
+		return -EIO;
+	}
 
 	chunk_ondisk_size = btrfs_chunk_item_size(num_stripes);
 	/*
@@ -1741,7 +1755,8 @@ int btrfs_check_chunk_valid(struct btrfs_root *root,
 	/*
 	 * Device number check against profile
 	 */
-	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes == 0) ||
+	if ((type & BTRFS_BLOCK_GROUP_RAID10 && (sub_stripes != 2 ||
+		  !IS_ALIGNED(num_stripes, sub_stripes))) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
-- 
2.13.0



