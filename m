From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v2 2/3] btrfs: heed alloc_start
Date: Tue, 12 Apr 2011 12:42:30 +0200
Message-ID: <7a53b9516d986fa7409bf242d1f31f65390e2dad.1302604903.git.sensille@gmx.net>
References: <cover.1302604903.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1302604903.git.sensille@gmx.net>
In-Reply-To: <cover.1302604903.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

currently alloc_start is disregarded if the requested
chunk size is bigger than (device size - alloc_start),
but smaller than the device size.
The only situation where I see this could have made sense
was when a chunk equal the size of the device has been
requested. This was possible as the allocator failed to
take alloc_start into account when calculating the request
chunk size. As this gets fixed by this patch, the workaround
is not necessary anymore.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/volumes.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a9f1fc2..45c592a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -849,10 +849,7 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
 	/* we don't want to overwrite the superblock on the drive,
 	 * so we make sure to start at an offset of at least 1MB
 	 */
-	search_start = 1024 * 1024;
-
-	if (root->fs_info->alloc_start + num_bytes <= search_end)
-		search_start = max(root->fs_info->alloc_start, search_start);
+	search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
 
 	max_hole_start = search_start;
 	max_hole_size = 0;
-- 
1.7.3.4

