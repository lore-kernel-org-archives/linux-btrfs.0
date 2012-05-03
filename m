From: Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] Fix break before assignment
Date: Thu,  3 May 2012 21:44:49 +0800
Message-ID: <1336052689-30973-1-git-send-email-daniel@quora.org>
Cc: "Josef Bacik" <josef@redhat.com>,
	"Linux BTRFS" <linux-btrfs@vger.kernel.org>,
	"Chris Mason" <chris.mason@oracle.com>,
	Daniel J Blueman <daniel@quora.org>
To: "Yan Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix control flow to store count before breaking loop.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 fs/btrfs/ctree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index e801f22..2227420 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3465,8 +3465,8 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
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
1.7.9.5

