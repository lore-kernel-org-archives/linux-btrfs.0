From: jim owens <jowens@hp.com>
Subject: [RFC 01/12 RESEND PATCH] Btrfs: Do not limit RAID1 and DUP transfer
 length to one stripe.
Date: Mon, 04 Jan 2010 16:12:31 -0500
Message-ID: <4B4259BF.9020607@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


The 65k stripe length should be ignored as the stripes are
physically contiguous on disk so transfers can span stripes.

Signed-off-by: jim owens <jowens@hp.com>
---
 fs/btrfs/volumes.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 198cff2..f4b5666 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2697,13 +2697,13 @@ again:
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
1.5.6.3
