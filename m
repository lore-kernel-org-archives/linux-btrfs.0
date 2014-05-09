Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp4-p00-ob.smtp.rzone.de ([81.169.146.137]:50502 "EHLO
	xp4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaEIN2K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 09:28:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (RZmta 33.3 OK)
	with ESMTP id p0419bq49DS703a
	for <linux-btrfs@vger.kernel.org>;
	Fri, 9 May 2014 15:28:07 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: check_int: propagate out-of-memory error upwards
Date: Fri,  9 May 2014 15:28:07 +0200
Message-Id: <1399642087-7272-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This issue was not causing any harm but IMO (and in the opinion of the
static code checker) it is better to propagate this error status upwards.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/btrfs/check-integrity.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 39bfd56a1f26..26f6d34a135b 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1093,6 +1093,7 @@ leaf_item_out_of_bounce_error:
 					next_stack =
 					    btrfsic_stack_frame_alloc();
 					if (NULL == next_stack) {
+						sf->error = -1;
 						btrfsic_release_block_ctx(
 								&sf->
 								next_block_ctx);
@@ -1190,8 +1191,10 @@ continue_with_current_node_stack_frame:
 				    sf->next_block_ctx.datav[0];
 
 				next_stack = btrfsic_stack_frame_alloc();
-				if (NULL == next_stack)
+				if (NULL == next_stack) {
+					sf->error = -1;
 					goto one_stack_frame_backwards;
+				}
 
 				next_stack->i = -1;
 				next_stack->block = sf->next_block;
-- 
1.9.2

