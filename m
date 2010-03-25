From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 08/18] btrfs: Simplify num_stripes's calculation logical for
 __btrfs_alloc_chunk()
Date: Thu, 25 Mar 2010 20:32:59 +0800
Message-ID: <4BAB57FB.2050300@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

We can use this simple method to make source more readable.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 844c393..3ae1f42 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2198,9 +2198,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID1)) {
-		num_stripes = min_t(u64, 2, fs_devices->rw_devices);
-		if (num_stripes < 2)
+		if (fs_devices->rw_devices < 2)
 			return -ENOSPC;
+		num_stripes = 2;
 		min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
-- 
1.6.5.2


