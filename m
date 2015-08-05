Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28845 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751464AbbHEKBx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 06:01:53 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t759xldi021989
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Aug 2015 17:59:47 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs: Cleanup: Remove objectid's init-value in create_reloc_inode()
Date: Wed, 5 Aug 2015 18:00:03 +0800
Message-ID: <3fbb7f3239e285eb7d14b0f3c61944159b91813a.1438768766.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <f6eb7359bee352cc27f91d26bcffa6c6f8b1a5fe.1438768766.git.zhaolei@cn.fujitsu.com>
References: <f6eb7359bee352cc27f91d26bcffa6c6f8b1a5fe.1438768766.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

objectid's init-value is not used in any case, remove it.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1659c94..4698928 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4144,7 +4144,7 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root;
 	struct btrfs_key key;
-	u64 objectid = BTRFS_FIRST_FREE_OBJECTID;
+	u64 objectid;
 	int err = 0;
 
 	root = read_fs_root(fs_info, BTRFS_DATA_RELOC_TREE_OBJECTID);
-- 
1.8.5.1

