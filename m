From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: fix unlocked access of delalloc_inodes
Date: Thu,  9 Jun 2011 12:02:51 +0200
Message-ID: <1307613771-7729-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

list_splice_init will make delalloc_inodes empty, but without a spinlock
around, this may produce corrupted list head, accessed in many placess,
The race window is very tight and nobody seems to have hit it so far.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 98b6a71..11dda73 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2911,9 +2911,8 @@ static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
 
 	INIT_LIST_HEAD(&splice);
 
-	list_splice_init(&root->fs_info->delalloc_inodes, &splice);
-
 	spin_lock(&root->fs_info->delalloc_lock);
+	list_splice_init(&root->fs_info->delalloc_inodes, &splice);
 
 	while (!list_empty(&splice)) {
 		btrfs_inode = list_entry(splice.next, struct btrfs_inode,
-- 
1.7.5.2.353.g5df3e

