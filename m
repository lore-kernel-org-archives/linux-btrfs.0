From: Sage Weil <sage@newdream.net>
Subject: [PATCH 2/2] Btrfs: warn when partial user transactions commit
Date: Mon, 15 Mar 2010 10:26:32 -0700
Message-ID: <1268673992-5250-2-git-send-email-sage@newdream.net>
References: <1268673992-5250-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1268673992-5250-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Print a warning to the console when a btrfs ioctl transaction prematurely
commits a possibly partial result.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/file.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2e6404f..33975e7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1046,8 +1046,11 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
 		if (inode->i_size > BTRFS_ORDERED_OPERATIONS_FLUSH_LIMIT)
 			filemap_flush(inode->i_mapping);
 	}
-	if (filp->private_data)
+	if (filp->private_data) {
+		pr_warning("aborted btrfs user transaction, committing "
+			   "partial result\n");
 		btrfs_ioctl_trans_end(filp);
+	}
 	return 0;
 }
 
-- 
1.7.0

