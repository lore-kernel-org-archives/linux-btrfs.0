From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 12/18] btrfs: Add error handle for btrfs_search_slot() in
 btrfs_read_chunk_tree()
Date: Thu, 25 Mar 2010 20:34:49 +0800
Message-ID: <4BAB5869.6040903@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

We need to check return value of btrfs_search_slot() in
btrfs_read_chunk_tree() and do corresponding error handing.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3ae1f42..546de6b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3389,6 +3389,8 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 	key.type = 0;
 again:
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto error;
 	while (1) {
 		leaf = path->nodes[0];
 		slot = path->slots[0];
-- 
1.6.5.2


