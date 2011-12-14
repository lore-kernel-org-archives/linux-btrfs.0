From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH RESEND] Btrfs: fix inaccurate available space on raid0 profile
Date: Wed, 14 Dec 2011 15:50:23 +0800
Message-ID: <4EE8553F.8080608@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When we use raid0 as the data profile, df command may show us a very
inaccurate value of the available space, which may be much less than the
real one. It may make the users puzzled. Fix it by changing the calculation
of the available space, and making it be more similar to a fake chunk
allocation.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8bd9d6d..01de53a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1079,7 +1079,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	u64 avail_space;
 	u64 used_space;
 	u64 min_stripe_size;
-	int min_stripes = 1;
+	int min_stripes = 1, num_stripes = 1;
 	int i = 0, nr_devices;
 	int ret;
 
@@ -1093,12 +1093,16 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 
 	/* calc min stripe number for data space alloction */
 	type = btrfs_get_alloc_profile(root, 1);
-	if (type & BTRFS_BLOCK_GROUP_RAID0)
+	if (type & BTRFS_BLOCK_GROUP_RAID0) {
 		min_stripes = 2;
-	else if (type & BTRFS_BLOCK_GROUP_RAID1)
+		num_stripes = nr_devices;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID1) {
 		min_stripes = 2;
-	else if (type & BTRFS_BLOCK_GROUP_RAID10)
+		num_stripes = 2;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
 		min_stripes = 4;
+		num_stripes = 4;
+	}
 
 	if (type & BTRFS_BLOCK_GROUP_DUP)
 		min_stripe_size = 2 * BTRFS_STRIPE_LEN;
@@ -1167,13 +1171,16 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	i = nr_devices - 1;
 	avail_space = 0;
 	while (nr_devices >= min_stripes) {
+		if (num_stripes > nr_devices)
+			num_stripes = nr_devices;
+
 		if (devices_info[i].max_avail >= min_stripe_size) {
 			int j;
 			u64 alloc_size;
 
-			avail_space += devices_info[i].max_avail * min_stripes;
+			avail_space += devices_info[i].max_avail * num_stripes;
 			alloc_size = devices_info[i].max_avail;
-			for (j = i + 1 - min_stripes; j <= i; j++)
+			for (j = i + 1 - num_stripes; j <= i; j++)
 				devices_info[j].max_avail -= alloc_size;
 		}
 		i--;
-- 1.7.6.4
