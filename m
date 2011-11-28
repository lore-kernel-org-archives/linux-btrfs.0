From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: wrong / too less space on raid
Date: Mon, 28 Nov 2011 17:42:27 +0800
Message-ID: <4ED35783.9030406@cn.fujitsu.com>
References: <1322397922.11404.15.camel@master.beowulf.me>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: source <source@disable-microsoft.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1322397922.11404.15.camel@master.beowulf.me>
List-ID: <linux-btrfs.vger.kernel.org>

On sun, 27 Nov 2011 13:45:22 +0100, source wrote:
> i tried to create several btrfs filesystems with success and tests about
> performance and reliability but the free amount given to the system is
> far too small, one example :
> 
> #mkfs.btrfs -m raid0 -d raid0 /dev/sda8 /dev/sdb8 /dev/sdc8
> 
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> adding device /dev/sdb8 id 2
> adding device /dev/sdc8 id 3
> fs created label (null) on /dev/sda8
> 	nodesize 4096 leafsize 4096 sectorsize 4096 size 131.44GB
> Btrfs Btrfs v0.19
> 
> # mkdir /test && mount /dev/sda8 /test
> # df
> Filesystem     1K-blocks      Used Available Use% Mounted on
> /dev/md0       292911488 174222808 118688680  60% /
> tmpfs               5120         4      5116   1% /lib/init/rw
> tmpfs             611976       544    611432   1% /run
> udev               10240         0     10240   0% /dev
> tmpfs            1223952        76   1223876   1% /run/shm
> /dev/md2       292833568     33312 292800256   1% /or
> /dev/md1       292833568 202533276  90300292  70% /root/workplace
> /dev/sdc1          90297     52782     32698  62% /boot
> myon400:/      976694528 485310720 491383808  50% /srv
> /dev/sda8      137821156        28  90827392   1% /test
> 
> in this case, you can see a raid0 setup for meta and data, also
> acknowledged by "sdb8 id2" and "sdc8 id3", the overall amount
> of 1k blocks in df = 137821156 but the available amount is 
> only 90827392 1-k blocks while 28 are in use. this looks like
> the calculation of raid0 outputs something i would assume 
> for raid5 or in other words just 2 of 3 raid-members usable.
> 
> maybe i misinterpreted something or made a mistake by creation
> however any documentation around gave me no idea.
> 
> this test was made on a debian sid, using btrfs v0.19.

Could you try this patch? Maybe it can make you comfortable.

Subject: [PATCH] Btrfs: fix wrong inaccurate available space on raid0 profile

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
-- 
1.7.6.4

