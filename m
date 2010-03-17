From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix chunk allocate size calculation
Date: Wed, 17 Mar 2010 16:45:56 -0400
Message-ID: <20100317204556.GA4409@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If the amount of free space left in a device is less than what we think should
be the minimum size, just ignore the minimum size and use the amount we have.  I
ran into this running tests on a 600mb volume, the chunk allocator wouldn't let
me allocate the last 52mb of the disk for data because we want to have at least
64mb chunks for data.  This patch fixes that problem.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9df8e3f..1c5b5ba 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2244,8 +2244,10 @@ again:
 		do_div(calc_size, stripe_len);
 		calc_size *= stripe_len;
 	}
+
 	/* we don't want tiny stripes */
-	calc_size = max_t(u64, min_stripe_size, calc_size);
+	if (!looped)
+		calc_size = max_t(u64, min_stripe_size, calc_size);
 
 	do_div(calc_size, stripe_len);
 	calc_size *= stripe_len;
-- 
1.6.6

