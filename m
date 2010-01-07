From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] btrfs: free cluster before exit
Date: Thu,  7 Jan 2010 05:03:06 +0300
Message-ID: <1262829786-29662-1-git-send-email-a.beregalov@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	Alexander Beregalov <a.beregalov@gmail.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix possible memory leak.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 fs/btrfs/relocation.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a972868..ed3e4a2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3281,8 +3281,10 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 		return -ENOMEM;
 
 	path = btrfs_alloc_path();
-	if (!path)
+	if (!path) {
+		kfree(cluster);
 		return -ENOMEM;
+	}
 
 	rc->extents_found = 0;
 	rc->extents_skipped = 0;
-- 
1.6.6

