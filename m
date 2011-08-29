From: David Sterba <dsterba@suse.cz>
Subject: [PATCH debug] btrfs: ratelimit WARN_ON in use_block_rsv
Date: Mon, 29 Aug 2011 20:42:32 +0200
Message-ID: <1314643352-10195-1-git-send-email-dsterba@suse.cz>
References: <4E52109A.3090403@itwm.fraunhofer.de>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E52109A.3090403@itwm.fraunhofer.de>
List-ID: <linux-btrfs.vger.kernel.org>

A debugging helper, not really intended for merge.

From: David Sterba <dsterba@suse.cz>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent-tree.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 44a3107..c5c1e7d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -23,6 +23,7 @@
 #include <linux/rcupdate.h>
 #include <linux/kthread.h>
 #include <linux/slab.h>
+#include <linux/ratelimit.h>
 #include "compat.h"
 #include "hash.h"
 #include "ctree.h"
@@ -5703,7 +5704,13 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 	if (!ret)
 		return block_rsv;
 	if (ret) {
-		WARN_ON(1);
+		static DEFINE_RATELIMIT_STATE(_rs,
+				DEFAULT_RATELIMIT_INTERVAL,
+				/*DEFAULT_RATELIMIT_BURST*/ 2);
+		if (__ratelimit(&_rs)) {
+			printk(KERN_DEBUG "btrfs: block rsv returned %d\n", ret);
+			WARN_ON(1);
+		}
 		ret = reserve_metadata_bytes(trans, root, block_rsv, blocksize,
 					     0);
 		if (!ret) {
-- 
1.7.6

