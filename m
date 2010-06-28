From: Dan Carpenter <error27@gmail.com>
Subject: [patch] btrfs: make code reachable in btrfs_insert_some_items()
Date: Mon, 28 Jun 2010 13:17:26 +0200
Message-ID: <20100628111726.GI19184@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>,
	Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The break was in front of the "nr = i" assignment so that was never hit.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0d1d966..ceb8ad2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3453,8 +3453,8 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
 	for (i = 0; i < nr; i++) {
 		if (total_size + data_size[i] + sizeof(struct btrfs_item) >
 		    BTRFS_LEAF_DATA_SIZE(root)) {
-			break;
 			nr = i;
+			break;
 		}
 		total_data += data_size[i];
 		total_size += data_size[i] + sizeof(struct btrfs_item);
