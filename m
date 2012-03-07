From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] btrfs/locking.c: minor fix on the comment for btrfs_try_tree_write_lock
Date: Wed, 07 Mar 2012 16:13:32 +0800
Message-ID: <4F5718AC.80705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_try_tree_write_lock is used for write lock, not for read lock.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/locking.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 5e178d8..4e4705c 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -142,7 +142,7 @@ int btrfs_try_tree_read_lock(struct extent_buffer *eb)
 }
 
 /*
- * returns 1 if we get the read lock and 0 if we don't
+ * returns 1 if we get the write lock and 0 if we don't
  * this won't wait for blocking writers or readers
  */
 int btrfs_try_tree_write_lock(struct extent_buffer *eb)
-- 
1.7.1

