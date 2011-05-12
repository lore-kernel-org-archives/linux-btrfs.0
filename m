From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/1] btrfs: use unsigned type for single bit bitfield
Date: Thu, 12 May 2011 18:15:48 +0200
Message-ID: <1305216948-27466-1-git-send-email-dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e37d441..343304d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -740,12 +740,12 @@ struct btrfs_space_info {
 	 */
 	unsigned long reservation_progress;
 
-	int full:1;		/* indicates that we cannot allocate any more
+	unsigned int full:1;	/* indicates that we cannot allocate any more
 				   chunks for this space */
-	int chunk_alloc:1;	/* set if we are allocating a chunk */
+	unsigned int chunk_alloc:1;	/* set if we are allocating a chunk */
 
-	int force_alloc;	/* set if we need to force a chunk alloc for
-				   this space */
+	unsigned int force_alloc;	/* set if we need to force a chunk
+					   alloc for this space */
 
 	struct list_head list;
 
-- 
1.7.5.1.169.g505a1

