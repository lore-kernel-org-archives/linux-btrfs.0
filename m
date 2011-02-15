From: Tim Peters <darksecond@darksecond.nl>
Subject: [PATCH] btrfs: fixed a braces code style issue
Date: Wed, 16 Feb 2011 00:35:27 +0100
Message-ID: <20110215233526.GA6726@free>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

i fixed a braces code style issue on inode.c

Signed-off-by: Tim Peters <mail@darksecond.nl>
---
 fs/btrfs/inode.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fb9bd78..46125c3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -467,11 +467,10 @@ again:
 		 */
 		total_in = (total_in + PAGE_CACHE_SIZE - 1) &
 			~(PAGE_CACHE_SIZE - 1);
-		if (total_compressed >= total_in) {
+		if (total_compressed >= total_in)
 			will_compress = 0;
-		} else {
+		else
 			num_bytes = total_in;
-		}
 	}
 	if (!will_compress && pages) {
 		/*
-- 
1.7.4
