From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6/8] Btrfs: improve the logic in btrfs_can_relocate()
Date: Tue, 27 Mar 2012 18:04:26 +0300
Message-ID: <1332860668-27298-7-git-send-email-idryomov@gmail.com>
References: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332860668-27298-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Currently if we don't have enough space allocated we go ahead and loop
though devices in the hopes of finding enough space for a chunk of the
*same* type as the one we are trying to relocate.  The problem with that
is that if we are trying to restripe the chunk its target type can be
more relaxed than the current one (eg require less devices or less
space).  So, when restriping, run checks against the target profile
instead of the current one.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/extent-tree.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c44aa96..9454045 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7136,6 +7136,7 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	u64 min_free;
 	u64 dev_min = 1;
 	u64 dev_nr = 0;
+	u64 target;
 	int index;
 	int full = 0;
 	int ret = 0;
@@ -7176,13 +7177,11 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	/*
 	 * ok we don't have enough space, but maybe we have free space on our
 	 * devices to allocate new chunks for relocation, so loop through our
-	 * alloc devices and guess if we have enough space.  However, if we
-	 * were marked as full, then we know there aren't enough chunks, and we
-	 * can just return.
+	 * alloc devices and guess if we have enough space.  if this block
+	 * group is going to be restriped, run checks against the target
+	 * profile instead of the current one.
 	 */
 	ret = -1;
-	if (full)
-		goto out;
 
 	/*
 	 * index:
@@ -7192,7 +7191,20 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	 *      3: raid0
 	 *      4: single
 	 */
-	index = get_block_group_index(block_group);
+	target = get_restripe_target(root->fs_info, block_group->flags);
+	if (target) {
+		index = __get_block_group_index(extended_to_chunk(target));
+	} else {
+		/*
+		 * this is just a balance, so if we were marked as full
+		 * we know there is no space for a new chunk
+		 */
+		if (full)
+			goto out;
+
+		index = get_block_group_index(block_group);
+	}
+
 	if (index == 0) {
 		dev_min = 4;
 		/* Divide by 2 */
-- 
1.7.9.1

