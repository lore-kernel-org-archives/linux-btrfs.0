Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:28821 "EHLO
	mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbcBOFjh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 00:39:37 -0500
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id C93F7AC0235
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Feb 2016 14:39:31 +0900 (JST)
Received: from g01jpexchyt33.g01.fujitsu.local (unknown [10.128.193.4])
	by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id D29AA46E46D
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Feb 2016 14:38:09 +0900 (JST)
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] btrfs: Avoid BUG_ON()s because of ENOMEM caused by kmalloc()
 failure
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <56C16441.5030000@jp.fujitsu.com>
Date: Mon, 15 Feb 2016 14:38:09 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are some BUG_ON()'s after kmalloc() as follows.

=====
foo = kmalloc();
BUG_ON(!foo);	/* -ENOMEM case */
=====

A Docker + memory cgroup user hit these BUG_ON()s.

https://bugzilla.kernel.org/show_bug.cgi?id=112101

Since it's very hard to handle these ENOMEMs properly,
preventing these kmalloc() failures to avoid these
BUG_ON()s for now, are a bit better than the current
implementation anyway.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 fs/btrfs/extent_io.c  | 6 ++----
 fs/btrfs/inode.c      | 6 ++----
 fs/btrfs/relocation.c | 3 +--
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2e7c97a..5f92450 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -874,10 +874,8 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,

 	bits |= EXTENT_FIRST_DELALLOC;
 again:
-	if (!prealloc && gfpflags_allow_blocking(mask)) {
-		prealloc = alloc_extent_state(mask);
-		BUG_ON(!prealloc);
-	}
+	if (!prealloc && gfpflags_allow_blocking(mask))
+		prealloc = alloc_extent_state(mask|__GFP_NOFAIL);

 	spin_lock(&tree->lock);
 	if (cached_state && *cached_state) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 85afe66..d20e5c5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -357,8 +357,7 @@ static noinline int add_async_extent(struct async_cow *cow,
 {
 	struct async_extent *async_extent;

-	async_extent = kmalloc(sizeof(*async_extent), GFP_NOFS);
-	BUG_ON(!async_extent); /* -ENOMEM */
+	async_extent = kmalloc(sizeof(*async_extent), GFP_NOFS|__GFP_NOFAIL);
 	async_extent->start = start;
 	async_extent->ram_size = ram_size;
 	async_extent->compressed_size = compressed_size;
@@ -1143,8 +1142,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
 			 1, 0, NULL, GFP_NOFS);
 	while (start < end) {
-		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
-		BUG_ON(!async_cow); /* -ENOMEM */
+		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS|__GFP_NOFAIL);
 		async_cow->inode = igrab(inode);
 		async_cow->root = root;
 		async_cow->locked_page = locked_page;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ef6d8fc..6b9f718 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1373,8 +1373,7 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 	u64 last_snap = 0;
 	int ret;

-	root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
-	BUG_ON(!root_item);
+	root_item = kmalloc(sizeof(*root_item), GFP_NOFS|__GFP_NOFAIL);

 	root_key.objectid = BTRFS_TREE_RELOC_OBJECTID;
 	root_key.type = BTRFS_ROOT_ITEM_KEY;
-- 
2.5.0
