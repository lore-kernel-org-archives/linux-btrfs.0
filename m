Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38586 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756467Ab3BTJMq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 04:12:46 -0500
Message-ID: <512493BC.4070105@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 17:13:32 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 1/3] Btrfs: fix the qgroup reserved space is released prematurely
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In start_transactio(), we will try to join the transaction again after
the current transaction is committed, so we should not release the
reserved space of the qgroup. Fix it.

Cc: Arne Jansen <sensille@gmx.net>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index fc03aa6..bc2f2d1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -383,7 +383,7 @@ again:
 	h->block_rsv = NULL;
 	h->orig_rsv = NULL;
 	h->aborted = 0;
-	h->qgroup_reserved = qgroup_reserved;
+	h->qgroup_reserved = 0;
 	h->delayed_ref_elem.seq = 0;
 	h->type = type;
 	INIT_LIST_HEAD(&h->qgroup_ref_list);
@@ -401,6 +401,7 @@ again:
 		h->block_rsv = &root->fs_info->trans_block_rsv;
 		h->bytes_reserved = num_bytes;
 	}
+	h->qgroup_reserved = qgroup_reserved;
 
 got_it:
 	btrfs_record_root_in_trans(h, root);
-- 
1.6.5.2
