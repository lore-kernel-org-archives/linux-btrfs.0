Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59460 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab2FNIP7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 04:15:59 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <chris.mason@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 04/10 RESEND] Btrfs: avoid memory leak of extent state in error handling routine
Date: Thu, 14 Jun 2012 16:23:20 +0800
Message-Id: <1339662206-5307-5-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've forgotten to clear extent states in pinned tree, which will results in
space counter mismatch and memory leak:

WARNING: at fs/btrfs/extent-tree.c:7537 btrfs_free_block_groups+0x1f3/0x2e0 [btrfs]()
...
space_info 2 has 8380416 free, is not full
space_info total=12582912, used=4096, pinned=4096, reserved=0, may_use=0, readonly=4194304
btrfs state leak: start 29364224 end 29376511 state 1 in tree ffff880075f20090 refs 1
...

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b99d512..1030cff 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3600,6 +3600,8 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 
 	btrfs_destroy_marked_extents(root, &cur_trans->dirty_pages,
 				     EXTENT_DIRTY);
+	btrfs_destroy_pinned_extent(root,
+				    root->fs_info->pinned_extents);
 
 	/*
 	memset(cur_trans, 0, sizeof(*cur_trans));
-- 
1.6.5.2

