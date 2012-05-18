Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46037 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab2ERKDv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 06:03:51 -0400
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q4IA3lS0025150
	for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2012 18:03:48 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: avoid memory leak of extent state in error handling routine
Date: Fri, 18 May 2012 18:07:49 +0800
Message-Id: <1337335671-24926-1-git-send-email-liubo2009@cn.fujitsu.com>
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
index a7ffc88..046a737 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3595,6 +3595,8 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 
 	btrfs_destroy_marked_extents(root, &cur_trans->dirty_pages,
 				     EXTENT_DIRTY);
+	btrfs_destroy_pinned_extent(root,
+				    root->fs_info->pinned_extents);
 
 	/*
 	memset(cur_trans, 0, sizeof(*cur_trans));
-- 
1.6.5.2

