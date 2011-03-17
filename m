From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs scrub: extent_map reference not freed
Date: Thu, 17 Mar 2011 19:56:00 +0100
Message-ID: <1300388160-10892-1-git-send-email-sensille@gmx.net>
Cc: idryomov@gmail.com
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

scrub_chunk failed to free all extent_maps it referenced, leading to a leak
of these maps on unmount.

Reported-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/scrub.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ef59200..ee7671f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1111,7 +1111,7 @@ static noinline_for_stack int scrub_chunk(struct scrub_dev *sdev,
 	struct map_lookup *map;
 	struct extent_map *em;
 	int i;
-	int ret;
+	int ret = -EINVAL;
 
 	read_lock(&map_tree->map_tree.lock);
 	em = lookup_extent_mapping(&map_tree->map_tree, chunk_offset, 1);
@@ -1122,19 +1122,22 @@ static noinline_for_stack int scrub_chunk(struct scrub_dev *sdev,
 
 	map = (struct map_lookup *)em->bdev;
 	if (em->start != chunk_offset)
-		return -EINVAL;
+		goto out;
 
 	if (em->len < length)
-		return -EINVAL;
+		goto out;
 
 	for (i = 0; i < map->num_stripes; ++i) {
 		if (map->stripes[i].dev == sdev->dev) {
 			ret = scrub_stripe(sdev, map, i, chunk_offset, length);
 			if (ret)
-				return ret;
+				goto out;
 		}
 	}
-	return 0;
+out:
+	free_extent_map(em);
+
+	return ret;
 }
 
 static noinline_for_stack
-- 
1.7.3.4

