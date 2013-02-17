Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:52853 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab3BQJkE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Feb 2013 04:40:04 -0500
Message-ID: <5120A5AC.8020107@inwind.it>
Date: Sun, 17 Feb 2013 10:41:00 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH][BTRFS] raid5/6: chunk allocation
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I am playing with the raid5/6 code, to adapt my "disk-usage" 
patches to the raid5/6 code.
During this develop I found that the chunk allocation is strange. 
Looking at the code I found in volume.c the following codes:

3576 static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,

3730         /*
3731          * this will have to be fixed for RAID1 and RAID10 over
3732          * more drives
3733          */
3734         data_stripes = num_stripes / ncopies;
3735
3736         if (stripe_size * ndevs > max_chunk_size * ncopies) {
3737                 stripe_size = max_chunk_size * ncopies;
3738                 do_div(stripe_size, ndevs);
3739         }

This code decides how big is a chunk, following two mains roles:
1) the chunk stripe shall be less than max_stripe_size
2) the chunk capability (the space usable by the user) shall 
be less than max_chunk_size.

The code above works well in case of RAID0/RAID1/DUP/SINGLE/RAID10
but doesn't play well in case of RAID5/6. In fact in case the chunk
type is BTRFS_BLOCK_GROUP_METADATA then max_stripe_size is 1GB 
and max_chunk_size is 1GB too. If the number of devices (ndevs) is 7
and the raid profile is RAID6, then ncopies is 3, the stripe_size is
1GB*3/7 = 438MB, which lead to a chunk size of 2.14GB ! Which is 
not the expected value. 
I think that we should change the test above in raid6 case to

	data_stripes = ndevs - 2;
	if (stripe_size * data_stripes > max_chunk_size) {
		stripe_size = max_chunk_size;
                do_div(stripe_size, data_stripes);
	}


The patch below should solve this issue, and clean up a bit the logic
separating the code of raid5, raid6 from the code of the others
raid profiles.

Anyway I would like to point out another possible issue: the 
fragmentation. To avoid the fragmentation should we round up 
the stripe size to a more sane value like like 256MB ? 

I know that this could led to an "insane" chunk size when 
the number of disk is higher; but the current logic (
the stripe_size is equal to the chunk_size / number_of_device)
could lead to fragmentation problem when different raid profiles
where used together.

BR
G.Baroncelli

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c372264..88d17b4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3724,25 +3724,32 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	stripe_size = devices_info[ndevs-1].max_avail;
 	num_stripes = ndevs * dev_stripes;
 
-	/*
-	 * this will have to be fixed for RAID1 and RAID10 over
-	 * more drives
-	 */
-	data_stripes = num_stripes / ncopies;
-
-	if (stripe_size * ndevs > max_chunk_size * ncopies) {
-		stripe_size = max_chunk_size * ncopies;
-		do_div(stripe_size, ndevs);
-	}
 	if (type & BTRFS_BLOCK_GROUP_RAID5) {
 		raid_stripe_len = find_raid56_stripe_len(ndevs - 1,
 				 btrfs_super_stripesize(info->super_copy));
-		data_stripes = num_stripes - 1;
-	}
-	if (type & BTRFS_BLOCK_GROUP_RAID6) {
+		data_stripes = ndevs - 1;
+		if (stripe_size * data_stripes > max_chunk_size) {
+			stripe_size = max_chunk_size;
+			do_div(stripe_size, data_stripes);
+		}
+	} else if (type & BTRFS_BLOCK_GROUP_RAID6) {
 		raid_stripe_len = find_raid56_stripe_len(ndevs - 2,
 				 btrfs_super_stripesize(info->super_copy));
-		data_stripes = num_stripes - 2;
+		data_stripes = ndevs - 2;
+		if (stripe_size * data_stripes > max_chunk_size) {
+			stripe_size = max_chunk_size;
+			do_div(stripe_size, data_stripes);
+		}
+	} else { /* RAID1, RAID0, RAID10, SINGLE, SUP */
+		/*
+		 * this will have to be fixed for RAID1 and RAID10 over
+		 * more drives
+		 */
+		data_stripes = num_stripes / ncopies;
+		if (stripe_size * ndevs > max_chunk_size * ncopies) {
+			stripe_size = max_chunk_size * ncopies;
+			do_div(stripe_size, ndevs);
+		}
 	}
 	do_div(stripe_size, dev_stripes);
 

 



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
