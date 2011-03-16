From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH v3 3/6] btrfs: add scrub code and prototypes
Date: Wed, 16 Mar 2011 16:54:45 +0200
Message-ID: <20110316145445.GA7007@kwango.lan.net>
References: <cover.1299941055.git.sensille@gmx.net> <7ccafb5250b72ca706369a8d5b45f06e8d5a4f8a.1299941055.git.sensille@gmx.net> <20110316143525.GA2546@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110316143525.GA2546@kwango.lan.net>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, that was too fast.  Here is the right patch.

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ef59200..8926438 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1111,7 +1111,7 @@ static noinline_for_stack int scrub_chunk(struct scrub_dev *sdev,
 	struct map_lookup *map;
 	struct extent_map *em;
 	int i;
-	int ret;
+	int ret = 0;
 
 	read_lock(&map_tree->map_tree.lock);
 	em = lookup_extent_mapping(&map_tree->map_tree, chunk_offset, 1);
@@ -1121,20 +1121,27 @@ static noinline_for_stack int scrub_chunk(struct scrub_dev *sdev,
 		return -EINVAL;
 
 	map = (struct map_lookup *)em->bdev;
-	if (em->start != chunk_offset)
-		return -EINVAL;
+	if (em->start != chunk_offset) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (em->len < length)
-		return -EINVAL;
+	if (em->len < length) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	for (i = 0; i < map->num_stripes; ++i) {
 		if (map->stripes[i].dev == sdev->dev) {
 			ret = scrub_stripe(sdev, map, i, chunk_offset, length);
 			if (ret)
-				return ret;
+				goto out;
 		}
 	}
-	return 0;
+
+out:
+	free_extent_map(em);
+	return ret;
 }
 
 static noinline_for_stack
