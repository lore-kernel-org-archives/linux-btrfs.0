From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 3/6] btrfs: fix wrong calculation of stripe size
Date: Wed, 22 Dec 2010 18:47:27 +0800
Message-ID: <4D11D73F.8050008@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There are two tiny problem:
- One is When we check the chunk size is greater than the max chunk size or not,
  we should take mirrors into account, but the original code didn't.
- The other is btrfs shouldn't use the size of the residual free space as the
  length of of a dup chunk when doing chunk allocation. It is because the device
  space that a dup chunk needs is twice as large as the chunk size, if we use
  the size of the residual free space as the length of a dup chunk, we can not
  get enough free space. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 177b731..e1028f4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2177,6 +2177,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	int num_stripes = 1;
 	int min_stripes = 1;
 	int sub_stripes = 0;
+	int ncopies = 1;
 	int looped = 0;
 	int ret;
 	int index;
@@ -2197,12 +2198,14 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	if (type & (BTRFS_BLOCK_GROUP_DUP)) {
 		num_stripes = 2;
 		min_stripes = 2;
+		ncopies = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID1)) {
 		if (fs_devices->rw_devices < 2)
 			return -ENOSPC;
 		num_stripes = 2;
 		min_stripes = 2;
+		ncopies = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
 		num_stripes = fs_devices->rw_devices;
@@ -2210,6 +2213,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			return -ENOSPC;
 		num_stripes &= ~(u32)1;
 		sub_stripes = 2;
+		ncopies = 2;
 		min_stripes = 4;
 	}
 
@@ -2239,8 +2243,8 @@ again:
 		map->num_stripes = num_stripes;
 	}
 
-	if (calc_size * num_stripes > max_chunk_size) {
-		calc_size = max_chunk_size;
+	if (calc_size * num_stripes / ncopies > max_chunk_size) {
+		calc_size = max_chunk_size * ncopies;
 		do_div(calc_size, num_stripes);
 		do_div(calc_size, stripe_len);
 		calc_size *= stripe_len;
@@ -2321,6 +2325,8 @@ again:
 		if (!looped && max_avail > 0) {
 			looped = 1;
 			calc_size = max_avail;
+			if (type & BTRFS_BLOCK_GROUP_DUP)
+				calc_size /= 2;
 			goto again;
 		}
 		kfree(map);
-- 
1.7.0.1
