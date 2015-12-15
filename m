Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35966 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964870AbbLOLM1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 06:12:27 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id C0DCA4092558
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 19:11:43 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/4] btrfs: return all mirror whether need_raid_map set or not
Date: Tue, 15 Dec 2015 19:09:50 +0800
Message-ID: <77a0296e8261fa89dba93cc2d9bc39ebf3a19770.1450177455.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1450177455.git.zhaolei@cn.fujitsu.com>
References: <cover.1450177455.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_map_block() should return all mirror on WRITE,
REQ_GET_READ_MIRRORS, and RECOVERY case, whether need_raid_map set
or not.

need_raid_map only used to control is to set bbio->raid_map.

Current code works right because there is only one caller can
trigger above bug, which is readahead, and this function happened
to bypass on less mirror.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a6df8fd..4ee429b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5464,9 +5464,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
-		if (need_raid_map &&
-		    ((rw & (REQ_WRITE | REQ_GET_READ_MIRRORS)) ||
-		     mirror_num > 1)) {
+		if ((rw & (REQ_WRITE | REQ_GET_READ_MIRRORS)) ||
+		    mirror_num > 1) {
 			/* push stripe_nr back to the start of the full stripe */
 			stripe_nr = div_u64(raid56_full_stripe_start,
 					stripe_len * nr_data_stripes(map));
-- 
1.8.5.1



