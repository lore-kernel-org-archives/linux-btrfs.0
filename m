Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1690 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304AbbBTB7j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 20:59:39 -0500
Date: Thu, 19 Feb 2015 20:59:30 -0500
From: Chris Mason <clm@fb.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zhao Lei <zhaolei@cn.fujitsu.com>, <dsterba@suse.cz>
Subject: [PATCH] Btrfs: fix allocation size calculations in alloc_btrfs_bio
Message-ID: <20150220015930.GA28726@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit 8e5cfb55d3f (Btrfs: Make raid_map array be inlined in
btrfs_bio structure), the raid map array is allocated along with the
btrfs bio in alloc_btrfs_bio.  The calculation used to decide how much
we need to allocate was using the wrong parameter passed into the
allocation function.

The passed in real_stripes will be zero if a target replace operation
is not currently running.  We want to use total_stripes instead.

Signed-off-by: Chris Mason <clm@fb.com>
Reported-by: Dave Sterba <dsterba@suse.cz>

---
 fs/btrfs/volumes.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cd4d131..8222f6f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4903,10 +4903,17 @@ static void sort_parity_stripes(struct btrfs_bio *bbio, int num_stripes)
 static struct btrfs_bio *alloc_btrfs_bio(int total_stripes, int real_stripes)
 {
 	struct btrfs_bio *bbio = kzalloc(
+		 /* the size of the btrfs_bio */
 		sizeof(struct btrfs_bio) +
+		/* plus the variable array for the stripes */
 		sizeof(struct btrfs_bio_stripe) * (total_stripes) +
+		/* plus the variable array for the tgt dev */
 		sizeof(int) * (real_stripes) +
-		sizeof(u64) * (real_stripes),
+		/*
+		 * plus the raid_map, which includes both the tgt dev
+		 * and the stripes
+		 */
+		sizeof(u64) * (total_stripes),
 		GFP_NOFS);
 	if (!bbio)
 		return NULL;
-- 
1.8.1

