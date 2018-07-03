Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:43464 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753484AbeGCE1r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 00:27:47 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <wen.xu@gatech.edu>, <xuwen.sjtu@gmail.com>
Subject: [PATCH] btrfs: Add chunk type check in read a chunk
Date: Tue, 3 Jul 2018 12:27:36 +0800
Message-ID: <1530592056-7940-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reported in https://bugzilla.kernel.org/show_bug.cgi?id=199839,
which has a invalid chunk, not return error opportunlly.

Add chunk type check in btrfs_check_chunk_valid,
to make error be returned in advance.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e034ad9e23b4..67732c910c3d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6439,6 +6439,12 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 			  btrfs_chunk_type(leaf, chunk));
 		return -EIO;
 	}
+
+	if (!(type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
+		btrfs_err(fs_info, "missing chunk type flag: %llu", type);
+		return -EIO;
+	}
+
 	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
-- 
2.17.1



