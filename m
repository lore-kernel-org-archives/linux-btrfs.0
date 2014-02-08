Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:44889 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaBHPq7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Feb 2014 10:46:59 -0500
Message-ID: <52F65147.2080505@libero.it>
Date: Sat, 08 Feb 2014 16:46:15 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>, kreijack@inwind.it
CC: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
References: <20140206021516.304732cd@natsu>	<52F33BE7.4020708@swiftspirit.co.za>	<20140206184502.128b7dbe@natsu>	<52F3E86B.4030805@libero.it> <20140207104005.7bd1438a@natsu>
In-Reply-To: <20140207104005.7bd1438a@natsu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/07/2014 05:40 AM, Roman Mamedov wrote:
> On Thu, 06 Feb 2014 20:54:19 +0100
> Goffredo Baroncelli <kreijack@libero.it> wrote:
> 
[...]

Even I am not entirely convinced, I update the Roman's PoC in order
to take in account all the RAID levels.

I performed some tests with 7 48.8GB disks. Here my "df" results

Profile: single
Filesystem                          Size  Used Avail Use% Mounted on
/dev/vdc                            342G  512K  340G   1% /mnt/btrfs1

Profile: raid1
Filesystem                          Size  Used Avail Use% Mounted on
/dev/vdc                            342G  1.3M  147G   1% /mnt/btrfs1

Profile: raid10
Filesystem                          Size  Used Avail Use% Mounted on
/dev/vdc                            342G  2.3M  102G   1% /mnt/btrfs1

Profile: raid5
Filesystem                          Size  Used Avail Use% Mounted on
/dev/vdc                            342G  2.0M  291G   1% /mnt/btrfs1

Profile: raid6
Filesystem                          Size  Used Avail Use% Mounted on
/dev/vdc                            342G  1.8M  243G   1% /mnt/btrfs1

Note that RAID1 can only uses 6 disks; raid 10 only four, but I think that it 
is due to a previous bug. 
Still the mixing mode (data and metadata raid in the same chunk) is unsupported

below my patch.

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d71a11d..e5c58b3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1485,6 +1485,12 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
        } else if (type & BTRFS_BLOCK_GROUP_RAID10) {
                min_stripes = 4;
                num_stripes = 4;
+       } else if (type & BTRFS_BLOCK_GROUP_RAID5) {
+               min_stripes = 3;
+               num_stripes = nr_devices;
+       } else if (type & BTRFS_BLOCK_GROUP_RAID6) {
+               min_stripes = 4;
+               num_stripes = nr_devices;
        }
 
        if (type & BTRFS_BLOCK_GROUP_DUP)
@@ -1561,8 +1567,30 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
                if (devices_info[i].max_avail >= min_stripe_size) {
                        int j;
                        u64 alloc_size;
+                       int k;
 
-                       avail_space += devices_info[i].max_avail * num_stripes;
+                       /*
+                        * Depending by the RAID profile, we use some
+                        * disk space as redundancy:
+                        * RAID1, RAID10, DUP -> half of space used as redundancy
+                        * RAID5              -> 1 stripe used as redundancy
+                        * RAID6              -> 2 stripes used as redundancy
+                        * RAID0,LINEAR       -> no redundancy
+                        */
+                       if (type & BTRFS_BLOCK_GROUP_RAID1) {
+                               k = num_stripes >> 1;
+                       } else if (type & BTRFS_BLOCK_GROUP_DUP) {
+                               k = num_stripes >> 1;
+                       } else if (type & BTRFS_BLOCK_GROUP_RAID10) {
+                               k = num_stripes >> 1;
+                       } else if (type & BTRFS_BLOCK_GROUP_RAID5) {
+                               k = num_stripes-1;
+                       } else if (type & BTRFS_BLOCK_GROUP_RAID6) {
+                               k = num_stripes-2;
+                       } else { /* RAID0/LINEAR */
+                               k = num_stripes;
+                       }
+                       avail_space += devices_info[i].max_avail * k;
                        alloc_size = devices_info[i].max_avail;
                        for (j = i + 1 - num_stripes; j <= i; j++)
                                devices_info[j].max_avail -= alloc_size;




-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
