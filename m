Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:57031 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934006AbeGDKQp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 06:16:45 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <nborisov@suse.com>, <quwenruo.btrfs@gmx.com>
Subject: [PATCH v3] btrfs: Add chunk type check in read a chunk
Date: Wed, 4 Jul 2018 18:16:39 +0800
Message-ID: <1530699399-23573-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reported in https://bugzilla.kernel.org/show_bug.cgi?id=199839,
which has a invalid chunk, not return error opportunlly.

Add chunk type check in btrfs_check_chunk_valid,
to make error be returned in advance.

Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v3:
deal with comment by Nikolay Borisov, change the error message
more appropriate.

v2:
deal with comment by Qu, add precise check for chunk type.

 fs/btrfs/volumes.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b33bf29130b6..deea169cc276 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6401,6 +6401,8 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	u16 num_stripes;
 	u16 sub_stripes;
 	u64 type;
+	u64 features;
+	int mixed = 0;
 
 	length = btrfs_chunk_length(leaf, chunk);
 	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
@@ -6439,6 +6441,33 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 			  btrfs_chunk_type(leaf, chunk));
 		return -EIO;
 	}
+
+	if (!(type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
+		btrfs_err(fs_info, "missing chunk type flag: %llu", type);
+		return -EIO;
+	}
+
+	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
+	(type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
+		btrfs_err(fs_info,
+"system chunk type, meanwhile with metadata or data chunk type flag: %llu",
+				type);
+		return -EIO;
+	}
+
+	features = btrfs_super_incompat_flags(fs_info->super_copy);
+	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
+		mixed = 1;
+
+	if (!mixed) {
+		if (type &
+		(BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA)) {
+			btrfs_err(fs_info,
+			"mixed chunk type flag in non-mixed mode: %llu", type);
+			return -EIO;
+		}
+	}
+
 	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
-- 
2.17.1



