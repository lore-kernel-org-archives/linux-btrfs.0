From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] btrfs/extent_io.c: cleanup the comment for clear_state_bit
Date: Sat, 31 Mar 2012 14:40:15 +0800
Message-ID: <4F76A6CF.6080007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

No 'delete' arg is used for clear_state_bit anymore.
Cleanup the comment.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2862454..b67814c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -394,8 +394,7 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 
 /*
  * utility function to clear some bits in an extent state struct.
- * it will optionally wake up any one waiting on this state (wake == 1), or
- * forcibly remove the state from the tree (delete == 1).
+ * it will optionally wake up any one waiting on this state (wake == 1).
  *
  * If no bits are set on the state struct after clearing things, the
  * struct is freed and removed from the tree
-- 
1.7.1
