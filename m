From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: do not mark the chunk as readonly if in degraded
	mode
Date: Tue, 26 Jan 2010 21:07:59 -0500
Message-ID: <20100127020758.GA11767@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If a RAID setup has chunks that span multiple disks, and one of those disks has
failed, btrfs_chunk_readonly will return 1 since one of the disks in that
chunk's stripes is dead and therefore not writeable.  So instead if we are in
degraded mode, return 0 so we can go ahead and allocate stuff.  Without this
patch all of the block groups in a RAID1 setup will end up read-only, which will
mean we can't add new disks to the array since we won't be able to make
allocations.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/volumes.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3dda2ce..68fe767 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2538,6 +2538,11 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
 	if (!em)
 		return 1;
 
+	if (btrfs_test_opt(root, DEGRADED)) {
+		free_extent_map(em);
+		return 0;
+	}
+
 	map = (struct map_lookup *)em->bdev;
 	for (i = 0; i < map->num_stripes; i++) {
 		if (!map->stripes[i].dev->writeable) {
-- 
1.5.4.3

