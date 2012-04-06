From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH 4/4] Btrfs: fix the comment for find_first_extent_bit
Date: Fri, 06 Apr 2012 14:35:47 +0800
Message-ID: <4F7E8EC3.9030306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The return value of find_first_extent_bit is 1 or 0, no < 0.
And if found something, return 0; if nothing was found, return 1.
Fix the comment.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ddfc1d5..26fbe1c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1288,7 +1288,7 @@ out:
  * returned if we find something, and *start_ret and *end_ret are
  * set to reflect the state struct that was found.
  *
- * If nothing was found, 1 is returned, < 0 on error
+ * If nothing was found, 1 is returned. If found something, return 0.
  */
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, int bits)
-- 
1.7.1
