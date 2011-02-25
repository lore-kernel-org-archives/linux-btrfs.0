From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: fix infinite loop in btrfs_shrink_device()
Date: Sat, 26 Feb 2011 01:43:10 +0200
Message-ID: <20110225234310.GA2567@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In case of an ENOSPC error from btrfs_relocate_chunk() (line 2202) while
relocating a block group with offset 0 we end up endlessly looping.
This happens because key.offset -= 1 statement then unconditionally
brings us back to the beginnig of the loop (key.offset == (u64)-1).

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index dd13eb8..0cb94ce 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2212,7 +2212,8 @@ again:
 			goto done;
 		if (ret == -ENOSPC)
 			failed++;
-		key.offset -= 1;
+		if (--key.offset == -1)
+			break;
 	}
 
 	if (failed && !retried) {
-- 
1.7.2.3

