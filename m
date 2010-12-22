From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 1/6] btrfs: fix wrong data space statistics
Date: Wed, 22 Dec 2010 18:47:17 +0800
Message-ID: <4D11D735.9060206@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Josef has implemented mixed data/metadata chunks, we must add those chunks'
space just like data chunks.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 61bd79a..1d21208 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -768,11 +768,10 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
-		if (found->flags & (BTRFS_BLOCK_GROUP_METADATA |
-				    BTRFS_BLOCK_GROUP_SYSTEM))
-			total_used_data += found->disk_total;
-		else
+		if (found->flags & BTRFS_BLOCK_GROUP_DATA)
 			total_used_data += found->disk_used;
+		else
+			total_used_data += found->disk_total;
 		total_used += found->disk_used;
 	}
 	rcu_read_unlock();
-- 
1.7.0.1
