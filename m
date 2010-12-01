From: liubo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH 2/4 v2] Btrfs: avoid transaction stuff when readonly
Date: Wed, 01 Dec 2010 18:20:25 +0800
Message-ID: <4CF62169.8000702@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, liubo <liubo2009@cn.fujitsu.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When the filesystem is readonly, avoid transaction stuff by checking MS_RDONLY at 
start transaction time.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 1fffbc0..14a597d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -181,6 +181,9 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 	struct btrfs_trans_handle *h;
 	struct btrfs_transaction *cur_trans;
 	int ret;
+
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return ERR_PTR(-EROFS);
 again:
 	h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
 	if (!h)
-- 
1.7.1
