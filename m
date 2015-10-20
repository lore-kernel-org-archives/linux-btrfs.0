Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38303 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbbJTN4h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 09:56:37 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, jbacik@fb.com, clm@fb.com,
        Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [RESEND PATCH 1/2] btrfs: check-integrity: Fix returned errno codes
Date: Tue, 20 Oct 2015 14:56:22 +0100
Message-Id: <1445349383-21722-2-git-send-email-luisbg@osg.samsung.com>
In-Reply-To: <1445349383-21722-1-git-send-email-luisbg@osg.samsung.com>
References: <1445349383-21722-1-git-send-email-luisbg@osg.samsung.com>
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
Reviewed-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/check-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 541fbfa..9cacd06 100644
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

