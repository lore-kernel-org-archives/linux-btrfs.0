From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 1/5] Btrfs: fix btrfs_copy_root warning
Date: Mon, 21 Nov 2011 18:10:20 +0800
Message-ID: <1321870224-20241-2-git-send-email-liubo2009@cn.fujitsu.com>
References: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <sensille@gmx.net>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Should check for sub transid instead.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index fa34b74..4a96337 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -259,7 +259,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 			    (unsigned long)btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
-	WARN_ON(btrfs_header_generation(buf) > trans->transid);
+	WARN_ON(btrfs_header_generation(buf) > trans->transaction->sub_transid);
 	if (new_root_objectid == BTRFS_TREE_RELOC_OBJECTID)
 		ret = btrfs_inc_ref(trans, root, cow, 1);
 	else
-- 
1.6.5.2

