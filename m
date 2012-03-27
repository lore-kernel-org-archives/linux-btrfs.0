From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 06/10] Btrfs: add a check to decide if we should defrag the range
Date: Tue, 27 Mar 2012 14:44:34 +0800
Message-ID: <1332830678-3992-7-git-send-email-liubo2009@cn.fujitsu.com>
References: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

If our file's layout is as follows:
| hole | data1 | hole | data2 |

we do not need to defrag this file, because this file has holes and
cannot be merged into one extent.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   36 +++++++++++++++++++++++++++++++++++-
 1 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 81faa78..66a4933 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -769,6 +769,31 @@ none:
 	return -ENOENT;
 }
 
+/*
+ * Validaty check of prev em and next em:
+ * 1) no prev/next em
+ * 2) prev/next em is an hole/inline extent
+ */
+static int check_adjacent_extents(struct inode *inode, struct extent_map *em)
+{
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_map *prev = NULL, *next = NULL;
+	int ret = 0;
+
+	read_lock(&em_tree->lock);
+	prev = lookup_extent_mapping(em_tree, em->start - 1, (u64)-1);
+	next = lookup_extent_mapping(em_tree, em->start + em->len, (u64)-1);
+	read_unlock(&em_tree->lock);
+
+	if ((!prev || prev->block_start >= EXTENT_MAP_LAST_BYTE) &&
+	    (!next || next->block_start >= EXTENT_MAP_LAST_BYTE))
+		ret = 1;
+	free_extent_map(prev);
+	free_extent_map(next);
+
+	return ret;
+}
+
 static int should_defrag_range(struct inode *inode, u64 start, u64 len,
 			       int thresh, u64 *last_len, u64 *skip,
 			       u64 *defrag_end)
@@ -806,8 +831,16 @@ static int should_defrag_range(struct inode *inode, u64 start, u64 len,
 	}
 
 	/* this will cover holes, and inline extents */
-	if (em->block_start >= EXTENT_MAP_LAST_BYTE)
+	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
+		ret = 0;
+		goto out;
+	}
+
+	/* If we have nothing to merge with us, just skip. */
+	if (check_adjacent_extents(inode, em)) {
 		ret = 0;
+		goto out;
+	}
 
 	/*
 	 * we hit a real extent, if it is big don't bother defragging it again
@@ -815,6 +848,7 @@ static int should_defrag_range(struct inode *inode, u64 start, u64 len,
 	if ((*last_len == 0 || *last_len >= thresh) && em->len >= thresh)
 		ret = 0;
 
+out:
 	/*
 	 * last_len ends up being a counter of how many bytes we've defragged.
 	 * every time we choose not to defrag an extent, we reset *last_len
-- 
1.6.5.2

