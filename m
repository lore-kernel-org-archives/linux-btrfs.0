Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41417 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933174AbeAIQEK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 11:04:10 -0500
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo.btrfs@gmx.com, dsterba@suse.cz,
        Nikolay Borisov <nborisov@suse.com>
Subject: [RFC PATCH] btrfs: Fix slight df misreporting when listing mixed block groups fs
Date: Tue,  9 Jan 2018 18:04:05 +0200
Message-Id: <1515513845-3749-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently when df (resp. statfs) is executed on a btrfs instance the
free space is calculated as the freespace of the block groups +
any unallocated space on the devices, constituting this filesystem.
There is a catch, however, in that the unallocated space from the
devices has 1 mb subtracted from each device to closely follow btrfs'
allocator behavior. This is all good except that when we have a file
system and the system chunk's allocation profile is single (as is the
default in mixed mode) it occupies the range 0..4mb and thus implicitly
prevents allocation starting in the range 0..1mb. In those cases
additionally subtracting 1mb during statfs makes us misreport the
actual free space and this causes generic/015 to fail.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
Hello,                                                                          
                                                                                
So with this patch and adding sync to generic/015 (which is a different issue)  
I can make generic/015 pass. In any case I think this behavior is correct       
though frankly I feel it's not really worth it, in the worst case we are        
underreporting by at most 1mb per device.

 fs/btrfs/super.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f33a55272deb..a4dfc9701220 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1925,12 +1925,13 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	struct btrfs_device_info *devices_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
-	u64 skip_space;
 	u64 type;
 	u64 avail_space;
 	u64 min_stripe_size;
 	int min_stripes = 1, num_stripes = 1;
 	int i = 0, nr_devices;
+	bool sys_chunk_single = !(btrfs_system_alloc_profile(fs_info) &
+				  ~BTRFS_BLOCK_GROUP_SYSTEM);
 
 	/*
 	 * We aren't under the device list lock, so this is racy-ish, but good
@@ -1988,18 +1989,18 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 		/*
 		 * In order to avoid overwriting the superblock on the drive,
 		 * btrfs starts at an offset of at least 1MB when doing chunk
-		 * allocation.
+		 * allocation. There is one notable exception, and that is
+		 * when the System chunk has allocation profile of single. In
+		 * this case it occupies 0..4m  and we don't really need to
+		 * subtract 1mb as it's implied
 		 */
-		skip_space = SZ_1M;
-
-		/*
-		 * we can use the free space in [0, skip_space - 1], subtract
-		 * it from the total.
-		 */
-		if (avail_space && avail_space >= skip_space)
-			avail_space -= skip_space;
-		else
-			avail_space = 0;
+		if (device->devid != 1 ||
+		    (!sys_chunk_single && device->devid == 1)) {
+			if (avail_space && avail_space >= SZ_1M)
+				avail_space -= SZ_1M;
+			else
+				avail_space = 0;
+		}
 
 		if (avail_space < min_stripe_size)
 			continue;
-- 
2.7.4

