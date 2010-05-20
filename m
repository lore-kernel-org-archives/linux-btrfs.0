From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 02/10] btrfs: fix break phase in btrfs_insert_some_items()
Date: Thu, 20 May 2010 15:14:47 +0800
Message-ID: <4BF4E167.9070201@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liubo2009@cn.fujitsu.com>

"nr = i" should be placed before "break" in order to get right "nr". 

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index babf7fb..7adff4e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3430,8 +3430,8 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
 	for (i = 0; i < nr; i++) {
 		if (total_size + data_size[i] + sizeof(struct btrfs_item) >
 		    BTRFS_LEAF_DATA_SIZE(root)) {
-			break;
 			nr = i;
+			break;
 		}
 		total_data += data_size[i];
 		total_size += data_size[i] + sizeof(struct btrfs_item);
-- 
1.6.5.2


