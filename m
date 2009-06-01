From: Hu Tao <cnhutao@gmail.com>
Subject: [PATCH] Make an error msg look nicer by inserting a space between number and word.
Date: Mon,  1 Jun 2009 11:08:12 +0800
Message-ID: <1243825692-31516-1-git-send-email-hu.taoo@gmail.com>
Cc: trivial@kernel.org, Hu Tao <hu.taoo@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Hu Tao <hu.taoo@gmail.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3e2c7c7..8bb0550 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1843,7 +1843,7 @@ again:
 
 		printk(KERN_ERR "no space left, need %llu, %llu delalloc bytes"
 		       ", %llu bytes_used, %llu bytes_reserved, "
-		       "%llu bytes_pinned, %llu bytes_readonly, %llu may use"
+		       "%llu bytes_pinned, %llu bytes_readonly, %llu may use "
 		       "%llu total\n", (unsigned long long)bytes,
 		       (unsigned long long)data_sinfo->bytes_delalloc,
 		       (unsigned long long)data_sinfo->bytes_used,
-- 
1.6.3.1

