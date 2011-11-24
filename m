From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: reduce btrfs_path size
Date: Thu, 24 Nov 2011 19:03:27 +0100
Message-ID: <1322157807-31254-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Reduce size of struct btrfs_path from 144 to 96 bytes and save one
cacheline. This will allow packing of 42 objects into a PAGE_SIZE slab,
(previously 28, measured on x86_64).

Let 'slots' hold at most 65536, which is enough to index items for
reasonably big blocksizes (4k, 64k).
Maximum is 2M: 65536 * 33 (sizeof struct btrfs_key_ptr)

(Making it u8 would allow only 256 * 33 = 8448 ie 8k blocksize)

A 'locks' item holds at most 5 values of lock type.

'lowest_level': maximum level is 8

The 'reada' is set to {-1,0,1,2}, has to be signed.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 04a5dfc..0b5bd2c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -514,12 +514,12 @@ struct btrfs_node {
  */
 struct btrfs_path {
 	struct extent_buffer *nodes[BTRFS_MAX_LEVEL];
-	int slots[BTRFS_MAX_LEVEL];
+	u16 slots[BTRFS_MAX_LEVEL];
 	/* if there is real range locking, this locks field will change */
-	int locks[BTRFS_MAX_LEVEL];
-	int reada;
+	u8 locks[BTRFS_MAX_LEVEL];
 	/* keep some upper locks as we walk down */
-	int lowest_level;
+	u8 lowest_level;
+	s8 reada;	/* sign represents direction  */
 
 	/*
 	 * set by btrfs_split_item, tells search_slot to keep all locks
-- 
1.7.6

