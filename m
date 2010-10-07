From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix memory leak in free_log_tree
Date: Thu, 07 Oct 2010 16:22:13 +0800
Message-ID: <4CAD8335.8040707@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

To avoid memory leak, log->commit_root should be free, too.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 2c3ed40..f2465f1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2124,6 +2124,7 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 	}
 
 	free_extent_buffer(log->node);
+	free_extent_buffer(log->commit_root);
 	kfree(log);
 }
 
-- 
1.6.2.5



