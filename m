Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38653 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933606AbbIVQ3c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 12:29:32 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH 1/2] btrfs: check-integrity: Fix returned errno codes
Date: Tue, 22 Sep 2015 17:29:38 +0100
Message-Id: <311df0a5aadcb7578746ad7d0107045f6fcf43a1.1442939007.git.luis@debethencourt.com>
In-Reply-To: <cover.1442939007.git.luis@debethencourt.com>
References: <cover.1442939007.git.luis@debethencourt.com>
In-Reply-To: <cover.1442939007.git.luis@debethencourt.com>
References: <cover.1442939007.git.luis@debethencourt.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

check-integrity is using -1 instead of the -ENOMEM defined macro to
specify that a buffer allocation failed. Since the error number is
propagated, the caller will get a -EPERM which is the wrong error
condition.

Also, the smatch tool complains with the following warnings:
btrfsic_process_superblock() warn: returning -1 instead of -ENOMEM is sloppy
btrfsic_read_block() warn: returning -1 instead of -ENOMEM is sloppy

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---
 fs/btrfs/check-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index ce7dec8..a6257e1 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -667,7 +667,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 	selected_super = kzalloc(sizeof(*selected_super), GFP_NOFS);
 	if (NULL == selected_super) {
 		printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	list_for_each_entry(device, dev_head, dev_list) {
@@ -1660,7 +1660,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 					  sizeof(*block_ctx->pagev)) *
 					 num_pages, GFP_NOFS);
 	if (!block_ctx->mem_to_free)
-		return -1;
+		return -ENOMEM;
 	block_ctx->datav = block_ctx->mem_to_free;
 	block_ctx->pagev = (struct page **)(block_ctx->datav + num_pages);
 	for (i = 0; i < num_pages; i++) {
-- 
2.5.3

