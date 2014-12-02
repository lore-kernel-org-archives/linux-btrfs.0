Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58192 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754600AbaLBMiG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 07:38:06 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB2CbfGf001456
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Dec 2014 20:37:41 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v4 01/10] Btrfs: remove noused bbio_ret in __btrfs_map_block in condition
Date: Tue, 2 Dec 2014 20:39:22 +0800
Message-ID: <1417523971-15553-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1417523971-15553-1-git-send-email-miaox@cn.fujitsu.com>
References: <1417523971-15553-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

bbio_ret in this condition is always !NULL because previous code
already have a check-and-skip:
4908 if (!bbio_ret)
4909     goto out;

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
Changelog v1 -> v4:
- None.
---
 fs/btrfs/volumes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 54db1fb..6f80aef 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5167,8 +5167,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 				BTRFS_BLOCK_GROUP_RAID6)) {
 		u64 tmp;
 
-		if (bbio_ret && ((rw & REQ_WRITE) || mirror_num > 1)
-		    && raid_map_ret) {
+		if (raid_map_ret && ((rw & REQ_WRITE) || mirror_num > 1)) {
 			int i, rot;
 
 			/* push stripe_nr back to the start of the full stripe */
-- 
1.9.3

