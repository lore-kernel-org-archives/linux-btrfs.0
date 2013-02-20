Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49431 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3BTVcc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 16:32:32 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 122367C0358
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 14:32:32 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id GdNgSF5FrkEQNpoN (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 14:32:31 -0700 (MST)
Date: Wed, 20 Feb 2013 16:32:29 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix max chunk size on raid5/6
Message-ID: <20130220213229.GC21291@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

This spot in the chunk allocation code has seen a lot of little tweaks,
so I wanted to send this patch out for more eyes.

--

We try to limit the size of a chunk to 10GB, which keeps the unit of
work reasonable during balance and resize operations.  The limit checks
were taking into account the number of copies of the data we had but
what they really should be doing is comparing against the logical
size of the chunk we're creating.

This moves the code around a little to use the count of data stripes
from raid5/6.

Signed-off-by: Chris Mason <chris.mason@fusionio.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5d6010b..538c5cf 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3837,10 +3837,6 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	 */
 	data_stripes = num_stripes / ncopies;
 
-	if (stripe_size * ndevs > max_chunk_size * ncopies) {
-		stripe_size = max_chunk_size * ncopies;
-		do_div(stripe_size, ndevs);
-	}
 	if (type & BTRFS_BLOCK_GROUP_RAID5) {
 		raid_stripe_len = find_raid56_stripe_len(ndevs - 1,
 				 btrfs_super_stripesize(info->super_copy));
@@ -3851,6 +3847,27 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 				 btrfs_super_stripesize(info->super_copy));
 		data_stripes = num_stripes - 2;
 	}
+
+	/*
+	 * Use the number of data stripes to figure out how big this chunk
+	 * is really going to be in terms of logical address space,
+	 * and compare that answer with the max chunk size
+	 */
+	if (stripe_size * data_stripes > max_chunk_size) {
+		u64 mask = (1ULL << 24) - 1;
+		stripe_size = max_chunk_size;
+		do_div(stripe_size, data_stripes);
+
+		/* bump the answer up to a 16MB boundary */
+		stripe_size = (stripe_size + mask) & ~mask;
+
+		/* but don't go higher than the limits we found
+		 * while searching for free extents
+		 */
+		if (stripe_size > devices_info[ndevs-1].max_avail)
+			stripe_size = devices_info[ndevs-1].max_avail;
+	}
+
 	do_div(stripe_size, dev_stripes);
 
 	/* align to BTRFS_STRIPE_LEN */
