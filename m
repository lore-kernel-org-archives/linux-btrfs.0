Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:60287 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaBIRVF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Feb 2014 12:21:05 -0500
Message-ID: <52F7B8F9.6040004@libero.it>
Date: Sun, 09 Feb 2014 18:20:57 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Roman Mamedov <rm@romanrm.net>, Brendan Hide <brendan@swiftspirit.co.za>
Subject: [PATCH][V3] Provide a better free space estimate [was]Re: Provide
 a better free space estimate on RAID1
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

As Roman pointed out, df show the "raw" space available. However
when a RAID level is used, the space available to the user is
less.
This patch try to address this estimation correcting the value
on the basis of the RAID level.

This is my third revision of this patch. In this last issue, I
addressed the bugs related to an uncorrected evaluation of the 
free space in case of RAID1 [1] and DUP.

I have to point out that the free space estimation is quite
approximative, because it assumes:

a) all the new files are allocated in data "chunk"
b) the free space will not consumed by metadata
c) the already allocated chunk are not evaluated for the free
space estimation

Both these assumptions are unrelated to my patch.

I performed some tests with a filesystem composed by 7 51GB disks. 
Here my "df" results:

Profile: single
Filesystem                          Size  Used Avail Use% Mounted on
/dev/vdb                            351G  512K  348G   1% /mnt/btrfs1

Profile: raid1
Filesystem                          Size  Used Avail Use% Mounted on
/dev/vdb                            351G  1.3M  175G   1% /mnt/btrfs1

Profile: raid10
Filesystem                          Size  Used Avail Use% Mounted on
/dev/vdb                            351G  2.3M  177G   1% /mnt/btrfs1

Profile: raid5
Filesystem                          Size  Used Avail Use% Mounted on
/dev/vdb                            351G  2.0M  298G   1% /mnt/btrfs1

Profile: raid6
Filesystem                          Size  Used Avail Use% Mounted on
/dev/vdb                            351G  1.8M  248G   1% /mnt/btrfs1


Profile: DUP (only one 50GB disk was used)
Filesystem                          Size  Used Avail Use% Mounted on
/dev/vdc                             51G  576K   26G   1% /mnt/btrfs1


Below my patch.

BR
G.Baroncelli

[1] the bug is before my patch; try to see what happens when you 
create a RAID1 filesystem with three disks.

Changes history:
V1	First issue
V2	Correct a (old) bug when in RAID10 the disks aren't 
        a multiple of 4
V3	Correct the free space estimation in RAID1 (when the
        number of disks are odd) and DUP



diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d71a11d..4064a5f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1481,10 +1481,16 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 		num_stripes = nr_devices;
 	} else if (type & BTRFS_BLOCK_GROUP_RAID1) {
 		min_stripes = 2;
-		num_stripes = 2;
+		num_stripes = nr_devices;
 	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
 		min_stripes = 4;
-		num_stripes = 4;
+		num_stripes = nr_devices;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID5) {
+		min_stripes = 3;
+		num_stripes = nr_devices;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID6) {
+		min_stripes = 4;
+		num_stripes = nr_devices;
 	}
 
 	if (type & BTRFS_BLOCK_GROUP_DUP)
@@ -1560,9 +1566,44 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 
 		if (devices_info[i].max_avail >= min_stripe_size) {
 			int j;
-			u64 alloc_size;
+			u64 alloc_size, delta;
+			int k, div;
+
+			/*
+			 * Depending by the RAID profile, we use some
+			 * disk space as redundancy:
+			 * RAID1, RAID10, DUP -> half of space used as redundancy
+			 * RAID5              -> 1 stripe used as redundancy
+			 * RAID6              -> 2 stripes used as redundancy
+			 * RAID0,LINEAR       -> no redundancy
+			 */
+			if (type & BTRFS_BLOCK_GROUP_RAID1) {
+				k = num_stripes;
+				div = 2;
+			} else if (type & BTRFS_BLOCK_GROUP_DUP) {
+				k = num_stripes;
+				div = 2;
+			} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
+				k = num_stripes;
+				div = 2;
+			} else if (type & BTRFS_BLOCK_GROUP_RAID5) {
+				k = num_stripes-1;
+				div = 1;
+			} else if (type & BTRFS_BLOCK_GROUP_RAID6) {
+				k = num_stripes-2;
+				div = 1;
+			} else { /* RAID0/LINEAR */
+				k = num_stripes;
+				div = 1;
+			}
+
+			delta = devices_info[i].max_avail*k;
+			if (div==2)
+				delta >>= 1;
+			else if (div>2)
+				do_div(delta, div);
+			avail_space += delta;
 
-			avail_space += devices_info[i].max_avail * num_stripes;
 			alloc_size = devices_info[i].max_avail;
 			for (j = i + 1 - num_stripes; j <= i; j++)
 				devices_info[j].max_avail -= alloc_size;


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
