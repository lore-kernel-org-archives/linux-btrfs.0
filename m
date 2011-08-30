From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: skip locking if searching the commit root in lookup_csums
Date: Tue, 30 Aug 2011 15:44:59 -0400
Message-ID: <1314733499-4374-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It's not enough to just search the commit root, since we could be cow'ing the
very block we need to search through, which would mean that its locked and we'll
still deadlock.  So use path->skip_locking as well.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file-item.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index b910694..a1cb782 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -183,8 +183,10 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	 * read from the commit root and sidestep a nasty deadlock
 	 * between reading the free space cache and updating the csum tree.
 	 */
-	if (btrfs_is_free_space_inode(root, inode))
+	if (btrfs_is_free_space_inode(root, inode)) {
 		path->search_commit_root = 1;
+		path->skip_locking = 1;
+	}
 
 	disk_bytenr = (u64)bio->bi_sector << 9;
 	if (dio)
-- 
1.7.5.2

