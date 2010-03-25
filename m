From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 14/18] btrfs: Simplify write_ctree_super()
Date: Thu, 25 Mar 2010 20:36:11 +0800
Message-ID: <4BAB58BB.4080000@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Remove a useless local variant and return it directly.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 79d9196..731270f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2306,10 +2306,7 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int max_mirrors)
 {
-	int ret;
-
-	ret = write_all_supers(root, max_mirrors);
-	return ret;
+	return write_all_supers(root, max_mirrors);
 }
 
 int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
-- 
1.6.5.2


