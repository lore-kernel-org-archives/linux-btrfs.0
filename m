From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: put the right bio if we have an error
Date: Tue, 19 Apr 2011 08:17:48 -0400
Message-ID: <1303215468-12864-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_submit_direct_hook if the first btrfs_map_block fails we need to put
the orig_bio, not bio.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7624e6c..3217919 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6043,7 +6043,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	ret = btrfs_map_block(map_tree, READ, start_sector << 9,
 			      &map_length, NULL, 0);
 	if (ret) {
-		bio_put(bio);
+		bio_put(orig_bio);
 		return -EIO;
 	}
 
-- 
1.7.2.3

