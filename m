Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A858CC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 18:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63F4A22419
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 18:32:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="it/sQ2G6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63F4A22419
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbeKOEhL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 23:37:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbeKOEhL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 23:37:11 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D2DE223DD;
        Wed, 14 Nov 2018 18:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542220371;
        bh=qOFn2N+zPbXwX0AaMflISddsKyZ97il/1io/hAnj8TQ=;
        h=From:To:Cc:Subject:Date:From;
        b=it/sQ2G6AGhNCuar04cbH2ufcH3IchO8aXDberA6wxP1Hw4YOU+yKZRbrGiLlWTwI
         jaN65SSKWE9IxtSMUhgrPVmJERm0bq6Z5hOnG5KmRC1xXFRI8Gd+6ev/kw3bsaBeew
         nu53rzdMU8vr3BSQMO2SVAsrVNqXuZPn9m3uHgnk=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     robbieko@synology.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: send, fix infinite loop due to directory rename dependencies
Date:   Wed, 14 Nov 2018 18:32:37 +0000
Message-Id: <20181114183237.19884-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

When doing an incremental send, due to the need of delaying directory move
(rename) operations we can end up in infinite loop at
apply_children_dir_moves().

An example scenario that triggers this problem is described below, where
directory names correspond to the numbers of their respective inodes.

Parent snapshot:

 .
 |--- 261/
       |--- 271/
             |--- 266/
                   |--- 259/
                   |--- 260/
                   |     |--- 267
                   |
                   |--- 264/
                   |     |--- 258/
                   |           |--- 257/
                   |
                   |--- 265/
                   |--- 268/
                   |--- 269/
                   |     |--- 262/
                   |
                   |--- 270/
                   |--- 272/
                   |     |--- 263/
                   |     |--- 275/
                   |
                   |--- 274/
                         |--- 273/

Send snapshot:

 .
 |-- 275/
      |-- 274/
           |-- 273/
                |-- 262/
                     |-- 269/
                          |-- 258/
                               |-- 271/
                                    |-- 268/
                                         |-- 267/
                                              |-- 270/
                                                   |-- 259/
                                                   |    |-- 265/
                                                   |
                                                   |-- 272/
                                                        |-- 257/
                                                             |-- 260/
                                                             |-- 264/
                                                                  |-- 263/
                                                                       |-- 261/
                                                                            |-- 266/

When processing inode 257 we delay its move (rename) operation because its
new parent in the send snapshot, inode 272, was not yet processed. Then
when processing inode 272, we delay the move operation for that inode
because inode 274 is its ancestor in the send snapshot. Finally we delay
the move operation for inode 274 when processing it because inode 275 is
its new parent in the send snapshot and was not yet moved.

When finishing processing inode 275, we start to do the move operations
that were previously delayed (at apply_children_dir_moves()), resulting in
the following iterations:

1) We issue the move operation for inode 274;

2) Because inode 262 depended on the move operation of inode 274 (it was
   delayed because 274 is its ancestor in the send snapshot), we issue the
   move operation for inode 262;

3) We issue the move operation for inode 272, because it was delayed by
   inode 274 too (ancestor of 272 in the send snapshot);

4) We issue the move operation for inode 269 (it was delayed by 262);

5) We issue the move operation for inode 257 (it was delayed by 272);

6) We issue the move operation for inode 260 (it was delayed by 272);

7) We issue the move operation for inode 258 (it was delayed by 269);

8) We issue the move operation for inode 264 (it was delayed by 257);

9) We issue the move operation for inode 271 (it was delayed by 258);

10) We issue the move operation for inode 263 (it was delayed by 264);

11) We issue the move operation for inode 268 (it was delayed by 271);

12) We verify if we can issue the move operation for inode 270 (it was
    delayed by 271). We detect a path loop in the current state, because
    inode 267 needs to be moved first before we can issue the move
    operation for inode 270. So we delay again the move operation for
    inode 270, this time we will attempt to do it after inode 267 is
    moved;

13) We issue the move operation for inode 261 (it was delayed by 263);

14) We verify if we can issue the move operation for inode 266 (it was
    delayed by 263). We detect a path loop in the current state, because
    inode 270 needs to be moved first before we can issue the move
    operation for inode 266. So we delay again the move operation for
    inode 266, this time we will attempt to do it after inode 270 is
    moved (its move operation was delayed in step 12);

15) We issue the move operation for inode 267 (it was delayed by 268);

16) We verify if we can issue the move operation for inode 266 (it was
    delayed by 270). We detect a path loop in the current state, because
    inode 270 needs to be moved first before we can issue the move
    operation for inode 266. So we delay again the move operation for
    inode 266, this time we will attempt to do it after inode 270 is
    moved (its move operation was delayed in step 12). So here we added
    again the same delayed move operation that we added in step 14;

17) We attempt again to see if we can issue the move operation for inode
    266, and as in step 16, we realize we can not due to a path loop in
    the current state due to a dependency on inode 270. Again we delay
    inode's 266 rename to happen after inode's 270 move operation, adding
    the same dependency to the empty stack that we did in steps 14 and 16.
    The next iteration will pick the same move dependency on the stack
    (the only entry) and realize again there is still a path loop and then
    again the same dependency to the stack, over and over, resulting in
    an infinite loop.

So fix this by preventing adding the same move dependency entries to the
stack by removing each pending move record from the red black tree of
pending moves. This way the next call to get_pending_dir_moves() will
not return anything for the current parent inode.

A test case for fstests, with this reproducer, follows soon.

Signed-off-by: Robbie Ko <robbieko@synology.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
[Wrote changelog with example and more clear explanation]
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/send.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index ba8950bfd9c7..84cb6e5ef36c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3344,7 +3344,8 @@ static void free_pending_move(struct send_ctx *sctx, struct pending_dir_move *m)
 	kfree(m);
 }
 
-static void tail_append_pending_moves(struct pending_dir_move *moves,
+static void tail_append_pending_moves(struct send_ctx *sctx,
+				      struct pending_dir_move *moves,
 				      struct list_head *stack)
 {
 	if (list_empty(&moves->list)) {
@@ -3355,6 +3356,10 @@ static void tail_append_pending_moves(struct pending_dir_move *moves,
 		list_add_tail(&moves->list, stack);
 		list_splice_tail(&list, stack);
 	}
+	if (!RB_EMPTY_NODE(&moves->node)) {
+		rb_erase(&moves->node, &sctx->pending_dir_moves);
+		RB_CLEAR_NODE(&moves->node);
+	}
 }
 
 static int apply_children_dir_moves(struct send_ctx *sctx)
@@ -3369,7 +3374,7 @@ static int apply_children_dir_moves(struct send_ctx *sctx)
 		return 0;
 
 	INIT_LIST_HEAD(&stack);
-	tail_append_pending_moves(pm, &stack);
+	tail_append_pending_moves(sctx, pm, &stack);
 
 	while (!list_empty(&stack)) {
 		pm = list_first_entry(&stack, struct pending_dir_move, list);
@@ -3380,7 +3385,7 @@ static int apply_children_dir_moves(struct send_ctx *sctx)
 			goto out;
 		pm = get_pending_dir_moves(sctx, parent_ino);
 		if (pm)
-			tail_append_pending_moves(pm, &stack);
+			tail_append_pending_moves(sctx, pm, &stack);
 	}
 	return 0;
 
-- 
2.11.0

