From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Btrfs: fix unaligned access at btrfs_csum_final()
Date: Mon, 22 Mar 2010 02:31:08 +0300
Message-ID: <1269214268-1151-1-git-send-email-a.beregalov@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs on Sparc64 produces a lot of warnings
Kernel unaligned access at TPC[10148c84] btrfs_csum_final+0x44/0x60 [btrfs]

It happens when btrfs_csum_final is called from write_dev_supers():
2195:	btrfs_csum_final(crc, sb->csum);

crc is u32, aligning sb->csum on 4-byte boundary fixes the problem.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 fs/btrfs/ctree.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0af2e38..4dbf330 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -327,7 +327,7 @@ struct btrfs_header {
  * it currently lacks any block count etc etc
  */
 struct btrfs_super_block {
-	u8 csum[BTRFS_CSUM_SIZE];
+	u8 csum[BTRFS_CSUM_SIZE] __attribute__ ((aligned(4)));
 	/* the first 4 fields must match struct btrfs_header */
 	u8 fsid[BTRFS_FSID_SIZE];    /* FS specific uuid */
 	__le64 bytenr; /* this block number */
-- 
1.7.0.2

