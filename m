From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs: don't check DUP chunks twice
Date: Thu,  9 Feb 2012 15:09:02 +0100
Message-ID: <1328796542-12433-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Because scrub enumerates the dev extent tree to find the chunks to scrub,
it currently finds each DUP chunk twice and also scrubs it twice. This
patch makes sure that scrub_chunk only checks that part of the chunk the
dev extent has been found for. This only changes the behaviour for DUP
chunks.

Reported-and-tested-by: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/scrub.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9770cc5..abc0fbf 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1367,7 +1367,8 @@ out:
 }
 
 static noinline_for_stack int scrub_chunk(struct scrub_dev *sdev,
-	u64 chunk_tree, u64 chunk_objectid, u64 chunk_offset, u64 length)
+	u64 chunk_tree, u64 chunk_objectid, u64 chunk_offset, u64 length,
+	u64 dev_offset)
 {
 	struct btrfs_mapping_tree *map_tree =
 		&sdev->dev->dev_root->fs_info->mapping_tree;
@@ -1391,7 +1392,8 @@ static noinline_for_stack int scrub_chunk(struct scrub_dev *sdev,
 		goto out;
 
 	for (i = 0; i < map->num_stripes; ++i) {
-		if (map->stripes[i].dev == sdev->dev) {
+		if (map->stripes[i].dev == sdev->dev &&
+		    map->stripes[i].physical == dev_offset) {
 			ret = scrub_stripe(sdev, map, i, chunk_offset, length);
 			if (ret)
 				goto out;
@@ -1487,7 +1489,7 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 			break;
 		}
 		ret = scrub_chunk(sdev, chunk_tree, chunk_objectid,
-				  chunk_offset, length);
+				  chunk_offset, length, found_key.offset);
 		btrfs_put_block_group(cache);
 		if (ret)
 			break;
-- 
1.7.3.4

