Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:12797 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab2KFQis (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:48 -0500
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp2) (RZmta 30.22 OK)
	with ESMTP id g03dbeoA6AsjWt for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 21/26] Btrfs: introduce GET_READ_MIRRORS functionality for btrfs_map_block()
Date: Tue,  6 Nov 2012 17:38:39 +0100
Message-Id: <bdb465c374538cd56e3fd0f9ac24cdceb8e8311f.1352217244.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

Before this commit, btrfs_map_block() was called with REQ_WRITE
in order to retrieve the list of mirrors for a disk block.
This needs to be changed for the device replace procedure since
it makes a difference whether you are asking for read mirrors
or for locations to write to.
GET_READ_MIRRORS is introduced as a new interface to call
btrfs_map_block().
In the current commit, the functionality is not yet changed,
only the interface for GET_READ_MIRRORS is introduced and all
the places that should use this new interface are adapted.

The reason that REQ_WRITE cannot be abused anymore to retrieve
a list of read mirrors is that during a running dev replace
operation all write requests to the live filesystem are
duplicated to also write to the target drive.
Keep in mind that the target disk is only partially a valid
copy of the source disk while the operation is ongoing. All
writes go to the target disk, but not all reads would return
valid data on the target disk. Therefore it is not possible
anymore to abuse a REQ_WRITE interface to find valid mirrors
for a REQ_READ.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h   | 3 +++
 fs/btrfs/reada.c   | 3 ++-
 fs/btrfs/scrub.c   | 4 ++--
 fs/btrfs/volumes.c | 8 ++++----
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7c9e4f7..01fcfcb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -174,6 +174,9 @@ static int btrfs_csum_sizes[] = { 4, 0 };
 /* four bytes for CRC32 */
 #define BTRFS_EMPTY_DIR_SIZE 0
 
+/* spefic to btrfs_map_block(), therefore not in include/linux/blk_types.h */
+#define REQ_GET_READ_MIRRORS	(1 << 30)
+
 #define BTRFS_FT_UNKNOWN	0
 #define BTRFS_FT_REG_FILE	1
 #define BTRFS_FT_DIR		2
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index c705a48..96b93da 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -359,7 +359,8 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	 * map block
 	 */
 	length = blocksize;
-	ret = btrfs_map_block(fs_info, REQ_WRITE, logical, &length, &bbio, 0);
+	ret = btrfs_map_block(fs_info, REQ_GET_READ_MIRRORS, logical, &length,
+			      &bbio, 0);
 	if (ret || !bbio || length < blocksize)
 		goto error;
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 8bfe782..ba46eb0 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1193,8 +1193,8 @@ static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
 		 * with a length of PAGE_SIZE, each returned stripe
 		 * represents one mirror
 		 */
-		ret = btrfs_map_block(fs_info, WRITE, logical, &mapped_length,
-				      &bbio, 0);
+		ret = btrfs_map_block(fs_info, REQ_GET_READ_MIRRORS, logical,
+				      &mapped_length, &bbio, 0);
 		if (ret || !bbio || mapped_length < sublen) {
 			kfree(bbio);
 			return -EIO;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3ef0df2..208cc13 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4108,7 +4108,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 					    stripe_nr_end - stripe_nr_orig);
 		stripe_index = do_div(stripe_nr, map->num_stripes);
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
-		if (rw & (REQ_WRITE | REQ_DISCARD))
+		if (rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS))
 			num_stripes = map->num_stripes;
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
@@ -4120,7 +4120,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
-		if (rw & (REQ_WRITE | REQ_DISCARD)) {
+		if (rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS)) {
 			num_stripes = map->num_stripes;
 		} else if (mirror_num) {
 			stripe_index = mirror_num - 1;
@@ -4134,7 +4134,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		stripe_index = do_div(stripe_nr, factor);
 		stripe_index *= map->sub_stripes;
 
-		if (rw & REQ_WRITE)
+		if (rw & (REQ_WRITE | REQ_GET_READ_MIRRORS))
 			num_stripes = map->sub_stripes;
 		else if (rw & REQ_DISCARD)
 			num_stripes = min_t(u64, map->sub_stripes *
@@ -4247,7 +4247,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		}
 	}
 
-	if (rw & REQ_WRITE) {
+	if (rw & (REQ_WRITE | REQ_GET_READ_MIRRORS)) {
 		if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
 				 BTRFS_BLOCK_GROUP_RAID10 |
 				 BTRFS_BLOCK_GROUP_DUP)) {
-- 
1.8.0

