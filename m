From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs: fix that check_int_data mount option was ignored
Date: Fri, 30 Mar 2012 13:58:32 +0200
Message-ID: <daf37d5ff1e0454797c9f5ff0397df7690ba5b4d.1333107802.git.sbehrens@giantdisaster.de>
References: <a1550959ef3f5776fcd0b0bf97487f1ef0863ef0.1333107802.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a1550959ef3f5776fcd0b0bf97487f1ef0863ef0.1333107802.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

The bitfield member mount_opt was too small by one bit to hold the mount
option that enabled to include data extents in the integrity checker.
Since the same issue happened when the BTRFS_MOUNT_PANIC_ON_FATAL_ERROR
option was added (git rebase silently merges so that the increase of the
size of the bitfield member is lost), the bit limit was removed entirely.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
The patch is based on cmason/integration as of 3/30/2012.

 fs/btrfs/ctree.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5b8ef8e..ec42a24 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1078,7 +1078,7 @@ struct btrfs_fs_info {
 	 * is required instead of the faster short fsync log commits
 	 */
 	u64 last_trans_log_full_commit;
-	unsigned long mount_opt:21;
+	unsigned long mount_opt;
 	unsigned long compress_type:4;
 	u64 max_inline;
 	u64 alloc_start;
-- 
1.7.3.4

