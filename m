Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046AbaJaSkR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 14:40:17 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, clm@fb.com
Subject: [PATCH] btrfs: fix typos in btrfs_check_super_valid
Date: Fri, 31 Oct 2014 19:40:14 +0100
Message-Id: <1414780814-19222-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copy&paste errors in some messages and add few more missing macro
accessors.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

This is for 3.18-rc, a fixup to "btrfs: use macro accessors in superblock
validation checks"

 fs/btrfs/disk-io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1bf9f897065d..7af9a1978a2f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3839,12 +3839,12 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 */
 	if (!IS_ALIGNED(btrfs_super_root(sb), 4096))
 		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
-				sb->root);
+				btrfs_super_root(sb));
 	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), 4096))
-		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
-				sb->chunk_root);
+		printk(KERN_WARNING "BTRFS: chunk_root block unaligned: %llu\n",
+				btrfs_super_chunk_root(sb));
 	if (!IS_ALIGNED(btrfs_super_log_root(sb), 4096))
-		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
+		printk(KERN_WARNING "BTRFS: log_root block unaligned: %llu\n",
 				btrfs_super_log_root(sb));
 
 	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_UUID_SIZE) != 0) {
-- 
1.8.4.5

