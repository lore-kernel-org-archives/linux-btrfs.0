Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:11124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727427AbeHPTsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 15:48:46 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <dsterba@suse.com>
CC: <jbacik@fb.com>, <clm@fb.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv4 1/3] btrfs: remove unneeded variable "ret" in btrfs_destroy_delayed_refs
Date: Fri, 17 Aug 2018 00:37:13 +0800
Message-ID: <1534437435-51605-2-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1534437435-51605-1-git-send-email-zhongjiang@huawei.com>
References: <1534437435-51605-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_destroy_delayed_refs defines the variable "ret" for return value,
but it is not modified after initialization. So it is safe to drop the
unneeded value "ret".

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 fs/btrfs/disk-io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5124c15..6cdc23a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4192,7 +4192,6 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	struct rb_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
-	int ret = 0;
 
 	delayed_refs = &trans->delayed_refs;
 
@@ -4200,7 +4199,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	if (atomic_read(&delayed_refs->num_entries) == 0) {
 		spin_unlock(&delayed_refs->lock);
 		btrfs_info(fs_info, "delayed_refs has NO entry");
-		return ret;
+		return 0;
 	}
 
 	while ((node = rb_first(&delayed_refs->href_root)) != NULL) {
@@ -4255,7 +4254,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 
 	spin_unlock(&delayed_refs->lock);
 
-	return ret;
+	return 0;
 }
 
 static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
-- 
1.7.12.4
