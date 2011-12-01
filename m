From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: forced readonly when free_log_tree fails
Date: Thu, 01 Dec 2011 19:09:43 +0900
Message-ID: <201112011009.AA00038@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The filesystem turns to readonly instead of BUG_ON() when 
free_log_tree fails.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/tree-log.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f4d81c0..44bcfba 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2171,7 +2171,10 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 	};
 
 	ret = walk_log_tree(trans, log, &wc);
-	BUG_ON(ret);
+	if (ret) {
+		btrfs_std_error(log->fs_info, ret);
+		return;
+	}
 
 	while (1) {
 		ret = find_first_extent_bit(&log->dirty_log_pages,

