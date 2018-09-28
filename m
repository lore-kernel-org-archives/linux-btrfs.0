Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4021C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5111215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="oMQjhGq7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5111215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbeI1RmY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:24 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39847 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeI1RmY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:24 -0400
Received: by mail-qk1-f194.google.com with SMTP id q5-v6so595207qki.6
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=vfQB1tHlwUhp446i68IaYEtvkGVFvtWut8g/b3eBAlk=;
        b=oMQjhGq73M/j/vpwJYUcd1s9HO4OGoFYrNBUhr1cBwwMTow0G5dAaJSY4JUv2YoDQ5
         TbFcxWda9/ncAeWNHbheXvIudezGPga5yzc7uRnnQsyUvBQgAN0yCplWIWP3fkVRoNNG
         Tusl+fERqHorz1x7/N0hFCqiAfDLjBU58zTeSrith2rZE/WLhWqSEuPHQy+y7Dq5usK2
         xx03ahS9kaD6OYsH53lNd9v8ESjr4xGPn3M9vxgR0MM+d2xELxvzkxLSp2z3S7mzeRkq
         97m/qbwCwGYOGu1WzjE2Ruc/t4BmmA8CiqhuprgAby8qSmHZLcjSWwTPaU4YSanqnUo9
         I8zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=vfQB1tHlwUhp446i68IaYEtvkGVFvtWut8g/b3eBAlk=;
        b=e5RJoIG/Dc9iOvZdqWD8gEFd1c2MhyI/vlnf3HmPa7vJBMkmBwcS1CPx0fZs17XPzW
         M8ZN9FogK0Kwl/xH/kTxknzdPnoqJFvrgf9pkOr3WqcsNE488qRCxD3CLMdJk51NHrtb
         0qreZrVakMP+KZIQB+LJ9/BTZ6k7neXiX6XNmDGvUked5pJ3QF53tdLINVFnh5rjNm8b
         YUS0FKXHiJZVsj1vbd8Hk6oesGVLt0bEnh0+AWcDiPudtaalQmZsPhz29pe0jEyu3eNo
         N9ic4l9PNu/HVy1x8XXuxHGMpTTd5rlgtQoJEA2MNPuAjoNC9TU6Zm+L+nSrQrBlD6UF
         Alkg==
X-Gm-Message-State: ABuFfojkWVK0uRRBOz1BF6hDQsVYqzsRrX7pMJIGH+nQ2UptNqryWiy7
        5XfW+8QiBhdAPCM2SBF1obWZAw==
X-Google-Smtp-Source: ACcGV60bFU18KpOEOnxw1D9+wYnwqVX/c8DuBEEpN+XPpuOVwovCN19L8mLYsRDCt9CNDfPVMBMShQ==
X-Received: by 2002:a37:28c7:: with SMTP id o68-v6mr11503452qko.350.1538133546109;
        Fri, 28 Sep 2018 04:19:06 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o7-v6sm2211760qtp.75.2018.09.28.04.19.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:05 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 22/42] btrfs: only run delayed refs if we're committing
Date:   Fri, 28 Sep 2018 07:18:01 -0400
Message-Id: <20180928111821.24376-23-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I noticed in a giant dbench run that we spent a lot of time on lock
contention while running transaction commit.  This is because dbench
results in a lot of fsync()'s that do a btrfs_transaction_commit(), and
they all run the delayed refs first thing, so they all contend with
each other.  This leads to seconds of 0 throughput.  Change this to only
run the delayed refs if we're the ones committing the transaction.  This
makes the latency go away and we get no more lock contention.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a0f19ca0bd6c..39a2bddb0b29 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1925,15 +1925,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
-	/* make a pass through all the delayed refs we have so far
-	 * any runnings procs may add more while we are here
-	 */
-	ret = btrfs_run_delayed_refs(trans, 0);
-	if (ret) {
-		btrfs_end_transaction(trans);
-		return ret;
-	}
-
 	cur_trans = trans->transaction;
 
 	/*
@@ -1946,12 +1937,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (!list_empty(&trans->new_bgs))
 		btrfs_create_pending_block_groups(trans);
 
-	ret = btrfs_run_delayed_refs(trans, 0);
-	if (ret) {
-		btrfs_end_transaction(trans);
-		return ret;
-	}
-
 	if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
 		int run_it = 0;
 
@@ -2022,6 +2007,15 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		spin_unlock(&fs_info->trans_lock);
 	}
 
+	/*
+	 * We are now the only one in the commit area, we can run delayed refs
+	 * without hitting a bunch of lock contention from a lot of people
+	 * trying to commit the transaction at once.
+	 */
+	ret = btrfs_run_delayed_refs(trans, 0);
+	if (ret)
+		goto cleanup_transaction;
+
 	extwriter_counter_dec(cur_trans, trans->type);
 
 	ret = btrfs_start_delalloc_flush(fs_info);
-- 
2.14.3

