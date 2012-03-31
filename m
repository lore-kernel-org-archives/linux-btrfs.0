From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] btrfs/extent_io.c: return -ENOMEM instead of BUG_ON on allocation
 failure in set_extent_bit if __GFP_WAIT is set in the mask
Date: Sat, 31 Mar 2012 15:25:17 +0800
Message-ID: <4F76B15D.9010801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If __GFP_WAIT is set in the mask, set_extent_bit should return
-ENOMEM to its caller to decide what to do on allocation failure,
instead of BUG_ON.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b67814c..fd2411e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -720,7 +720,8 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
 		prealloc = alloc_extent_state(mask);
-		BUG_ON(!prealloc);
+		if (!prealloc)
+			return -ENOMEM;
 	}
 
 	spin_lock(&tree->lock);
-- 
1.7.1

