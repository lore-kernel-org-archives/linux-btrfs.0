From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 17/18] btrfs: add NULL check for build_backref_tree()
Date: Thu, 25 Mar 2010 20:37:42 +0800
Message-ID: <4BAB5916.2030206@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Miao Xie <miaox@cn.fujitsu.com>

if passing NULL to btrfs_free_path(),oops will happen. so we must check the
pointer passed to it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/relocation.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0b23942..6737803 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -816,8 +816,10 @@ next:
 			list_add_tail(&edge->list[UPPER], &list);
 	}
 out:
-	btrfs_free_path(path1);
-	btrfs_free_path(path2);
+	if (path1)
+		btrfs_free_path(path1);
+	if (path2)
+		btrfs_free_path(path2);
 	if (err) {
 		INIT_LIST_HEAD(&list);
 		upper = node;
-- 
1.6.5.2


