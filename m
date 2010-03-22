From: jim owens <owens6336@gmail.com>
Subject: [PATCH V3 02/18] Btrfs: Do not limit RAID1 and DUP transfer length
 to one stripe.
Date: Sun, 21 Mar 2010 23:20:02 -0400
Message-ID: <4BA6E1E2.2090909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


The 65k stripe length should be ignored as the stripes are
physically contiguous on disk so transfers can span stripes.

Signed-off-by: jim owens <owens6336@gmail.com>
---
 fs/btrfs/volumes.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9df8e3f..8c8908c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2711,13 +2711,13 @@ again:
 	/* stripe_offset is the offset of this block in its stripe*/
 	stripe_offset = offset - stripe_offset;
 
-	if (map->type & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
-			 BTRFS_BLOCK_GROUP_RAID10 |
-			 BTRFS_BLOCK_GROUP_DUP)) {
+	if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
+			 BTRFS_BLOCK_GROUP_RAID10)) {
 		/* we limit the length of each bio to what fits in a stripe */
 		*length = min_t(u64, em->len - offset,
 			      map->stripe_len - stripe_offset);
 	} else {
+		/* RAID1, DUP, and simple disk stripes are all contiguous */
 		*length = em->len - offset;
 	}
 
-- 
1.6.3.3
