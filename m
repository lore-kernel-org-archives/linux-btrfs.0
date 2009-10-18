From: Li Hong <lihong.hi@gmail.com>
Subject: [PATCH] btrfs: ctree.h Clean up some comments
Date: Sun, 18 Oct 2009 15:05:04 +0800
Message-ID: <20091018070504.GA4862@uhli>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>From eba78f3cf10205b6bf6dc608e623a12e004348ba Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Sun, 18 Oct 2009 15:01:49 +0800
Subject: [PATCH] btrfs: ctree.h Clean up some comments

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 fs/btrfs/ctree.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e5dd628..752f4fc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -288,13 +288,13 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
  * every tree block (leaf or node) starts with this header.
  */
 struct btrfs_header {
-	/* these first four must match the super block */
+	/* these first 4 fields must match struct btrfs_super_block */
 	u8 csum[BTRFS_CSUM_SIZE];
-	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
-	__le64 bytenr; /* which block this node is supposed to live in */
+	u8 fsid[BTRFS_FSID_SIZE];   /* FS specific uuid */
+	__le64 bytenr; /* byte offset this block is supposed to live in */
 	__le64 flags;
 
-	/* allowed to be different from the super from here on down */
+	/* different from the btrfs_super_block from here on down */
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
 	__le64 generation;
 	__le64 owner;
@@ -324,13 +324,13 @@ struct btrfs_header {
  * it currently lacks any block count etc etc
  */
 struct btrfs_super_block {
+	/* these first 4 fields must match struct btrfs_header */
 	u8 csum[BTRFS_CSUM_SIZE];
-	/* the first 4 fields must match struct btrfs_header */
 	u8 fsid[BTRFS_FSID_SIZE];    /* FS specific uuid */
-	__le64 bytenr; /* this block number */
+	__le64 bytenr; /* byte offset this block is supposed to live in */
 	__le64 flags;
 
-	/* allowed to be different from the btrfs_header from here own down */
+	/* different from the btrfs_header from here on down */
 	__le64 magic;
 	__le64 generation;
 	__le64 root;
-- 
1.6.0.4

