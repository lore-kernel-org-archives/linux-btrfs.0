From: jim owens <jowens@hp.com>
Subject: [RFC 08/12 PATCH] Btrfs: add direct I/O helper routines to decode
 em map_lookup.
Date: Mon, 04 Jan 2010 16:13:56 -0500
Message-ID: <4B425A14.2030102@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Direct I/O needs the total number of block devices and the
struct block_device for each to allocate control structures
prior to building bios for an extent.  When building a bio,
the device's base physical address of the chunk is needed.

Signed-off-by: jim owens <jowens@hp.com>
---
 fs/btrfs/volumes.c |   15 +++++++++++++++
 fs/btrfs/volumes.h |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 48727ee..6aa04e4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2614,6 +2614,21 @@ static int find_live_mirror(struct map_lookup *map, int first, int num,
 	return optimal;
 }
 
+int btrfs_map_stripe_count(struct extent_map *em)
+{
+	return ((struct map_lookup *)em->bdev)->num_stripes;
+}
+
+struct block_device *btrfs_map_stripe_bdev(struct extent_map *em, int stripe)
+{
+	return ((struct map_lookup *)em->bdev)->stripes[stripe].dev->bdev;
+}
+
+u64 btrfs_map_stripe_physical(struct extent_map *em, int stripe)
+{
+	return ((struct map_lookup *)em->bdev)->stripes[stripe].physical;
+}
+
 void btrfs_map_to_stripe(struct extent_map *em, int rw, int mirror_num,
 			u64 logical, u64 *length,
 			struct btrfs_stripe_info *stripe_info)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 76c4394..226200d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -192,4 +192,7 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
+int btrfs_map_stripe_count(struct extent_map *em);
+struct block_device *btrfs_map_stripe_bdev(struct extent_map *em, int stripe);
+u64 btrfs_map_stripe_physical(struct extent_map *em, int stripe);
 #endif
-- 
1.5.6.3
