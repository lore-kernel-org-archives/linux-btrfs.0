Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24407 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965024AbbLOLMa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 06:12:30 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id E94534092563
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 19:11:44 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 4/4] btrfs: Use direct way to determine raid56 write/recover mode
Date: Tue, 15 Dec 2015 19:09:52 +0800
Message-ID: <28d51b8df8225be1798b3ffe2e9315c93ad03d92.1450177455.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1450177455.git.zhaolei@cn.fujitsu.com>
References: <cover.1450177455.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Old code use bbio->raid_map to determine whether in raid56
write/recover operation, because we don't have bbio->map_type
that time, and have to use above workaround.

Now we have direct way for this condition, to get gid of using
the function-relative data, and make code readable.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 367e8ec..d411444 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6056,7 +6056,8 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	bbio->fs_info = root->fs_info;
 	atomic_set(&bbio->stripes_pending, bbio->num_stripes);
 
-	if (bbio->raid_map) {
+	if ((bbio->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK) &&
+	    ((rw & WRITE) || (mirror_num > 1))) {
 		/* In this case, map_length has been set to the length of
 		   a single stripe; not the whole write */
 		if (rw & WRITE) {
-- 
1.8.5.1



