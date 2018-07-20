Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:43499 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726555AbeGTGPX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 02:15:23 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 8A71D4B625E5
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 13:28:49 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: fix bug of chunk type check
Date: Fri, 20 Jul 2018 13:17:38 +0800
Message-ID: <1532063858-32620-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

chunk type BTRFS_BLOCK_GROUP_METADATA and BTRFS_BLOCK_GROUP_DATA
should not be set in a non-mixed chunk at the same time.

Since BTRFS_BLOCK_GROUP_METADATA is 0x4 and BTRFS_BLOCK_GROUP_DATA is 0x1,
BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA will be 0x0,
so we should judge type is one of them separately.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3f2f01ad9356..c7d009e45472 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6384,8 +6384,8 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 		mixed = 1;
 
 	if (!mixed) {
-		if (type &
-		    (BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA)) {
+		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
+			(type & BTRFS_BLOCK_GROUP_DATA)) {
 			btrfs_err(fs_info,
 			"mixed chunk type in non-mixed mode: %llu", type);
 			return -EIO;
-- 
2.17.1



