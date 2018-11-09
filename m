Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF0CC43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 10:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D227F20818
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 10:43:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="EKade+sT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D227F20818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbeKIUXO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 15:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728112AbeKIUXO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 15:23:14 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF80820818
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 10:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541760192;
        bh=cWc27SRefDUdZYFEEdaDQw6Y0HwJqsfwbvTl5GFlfTI=;
        h=From:To:Subject:Date:From;
        b=EKade+sTktD8NrW48HEB4Xkej+HMoRd1qM8Yct/j0/CigYOb4+c3UD6oS6fP5AH6n
         oVpP0G0HGr+OiM8pZg1nnMUVhec1vtyuLXEOaHaGgg/AFdQE5QOpP9ajwu0khLW1Wt
         w+8LDAgynFiD10ZQdfpawcTc3ESUpCuhVNSnPshM=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: simpler and more efficient cleanup of a log tree's extent io tree
Date:   Fri,  9 Nov 2018 10:43:08 +0000
Message-Id: <20181109104308.13123-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

We currently are in a loop finding each range (corresponding to a btree
node/leaf) in a log root's extent io tree and then clean it up. This is a
waste of time since we are traversing the extent io tree's rb_tree more
times then needed (one for a range lookup and another for cleaning it up)
without any good reason.

We free the log trees when we are in the critical section of a transaction
commit (the transaction state is set to TRANS_STATE_COMMIT_DOING), so it's
of great convenience to do everything as fast as possible in order to
reduce the time we block other tasks from starting a new transaction.

So fix this by traversing the extent io tree once and cleaning up all its
records in one go while traversing it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index d49edd25f2e5..aac3749f697f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3204,8 +3204,6 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *log)
 {
 	int ret;
-	u64 start;
-	u64 end;
 	struct walk_control wc = {
 		.free = 1,
 		.process_func = process_one_buffer
@@ -3216,18 +3214,8 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
 
-	while (1) {
-		ret = find_first_extent_bit(&log->dirty_log_pages,
-				0, &start, &end,
-				EXTENT_DIRTY | EXTENT_NEW | EXTENT_NEED_WAIT,
-				NULL);
-		if (ret)
-			break;
-
-		clear_extent_bits(&log->dirty_log_pages, start, end,
-				  EXTENT_DIRTY | EXTENT_NEW | EXTENT_NEED_WAIT);
-	}
-
+	clear_extent_bits(&log->dirty_log_pages, 0, (u64)-1,
+			  EXTENT_DIRTY | EXTENT_NEW | EXTENT_NEED_WAIT);
 	free_extent_buffer(log->node);
 	kfree(log);
 }
-- 
2.11.0

