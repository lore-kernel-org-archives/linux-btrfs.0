Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1D4C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BFED215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="CgOQ0H8u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BFED215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbeI1Rmh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:37 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]:43995 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729513AbeI1Rmh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:37 -0400
Received: by mail-qk1-f170.google.com with SMTP id v18-v6so3545631qka.10
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=P0ipw3j2I3ux8QOjibv1ucfjdjXUNT2FexmyaP5BF3E=;
        b=CgOQ0H8uZs4lZnX19xSAV9Vl/qfNenrBVOn0R9WmTEdsUV5VGSN80/NFPHZPL0lewU
         v0YpGGPmTGz/s2rJpMRF9uT52oPF4In1MKLnqqlfJU9ZIHti4D38+u30tThRH/7zdIuq
         QvON8yTfpE58kXtUyk36OyqzECCQcHYeS+s4KkDrk+etCU0K0y7shSxzRefgiZdwtW6f
         PMmMhJEFyT9n36/DYqpb5v+hs3Tr7xqy/ZfGSC+NkWf8vEQ2a14A2nAky1TQGLCEiJhm
         w2wmWN+XSmLOLS+lDj4PiCb30sjh/P6rTp9NYr3xeiUkA6IZiFSS86LnK1jZwAI3f5l/
         Id7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=P0ipw3j2I3ux8QOjibv1ucfjdjXUNT2FexmyaP5BF3E=;
        b=ORvI4IWAu8rLlRiKMcSdilD05dPm0ksKecrjGgQiSTygaHPQlh4S8BiS0p0tAo5oWo
         asQiQyV+DtK4dfobWyb0AsqnY/Qk/0bBw/hpVAxT31/nHD2LeqIu84zkRwL9sRSw/CE8
         2xz/gQNVo1WKocktbyR8ivby7WWRpQ8ugnSbriGarf48n7ei4jhYVOsNTlA28zIuw/gx
         3F+yfQtu/j2mNdi6ieB1W9xuTZBrD4blsHrpgJyE9oItgOkK6PsN41meQ8w07FYGA9H+
         tENYzneggg++Nx4DnPsilho/G/1qV3KYw4LW9Ypz08P4BU8pNtAozRfOpUx3c6ya52OL
         OwWQ==
X-Gm-Message-State: ABuFfoinohqKCEzndeUavFYwXsEnXDMNAwseu9ASWtrmqBy5w/cPREWz
        014H1cV1gMAwrZwyVIkjlIfycg==
X-Google-Smtp-Source: ACcGV61H+3oNjLJOoVMLRBuFLMMc3Ihd+z09seBjaKXqVnYuMX76PUJw1GLPbhzTtgwm0CWH2Hviuw==
X-Received: by 2002:a37:a84:: with SMTP id 126-v6mr8650627qkk.267.1538133558802;
        Fri, 28 Sep 2018 04:19:18 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u36-v6sm2927608qtc.46.2018.09.28.04.19.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:17 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 29/42] btrfs: call btrfs_create_pending_block_groups unconditionally
Date:   Fri, 28 Sep 2018 07:18:08 -0400
Message-Id: <20180928111821.24376-30-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The first thing we do is loop through the list, this

if (!list_empty())
	btrfs_create_pending_block_groups();

thing is just wasted space.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 3 +--
 fs/btrfs/transaction.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7245a198ad31..91e45cb14d45 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2978,8 +2978,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	}
 
 	if (run_all) {
-		if (!list_empty(&trans->new_bgs))
-			btrfs_create_pending_block_groups(trans);
+		btrfs_create_pending_block_groups(trans);
 
 		spin_lock(&delayed_refs->lock);
 		node = rb_first(&delayed_refs->href_root);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 39a2bddb0b29..46ca775a709e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -846,8 +846,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
+	btrfs_create_pending_block_groups(trans);
 
 	btrfs_trans_release_chunk_metadata(trans);
 
@@ -1934,8 +1933,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	cur_trans->delayed_refs.flushing = 1;
 	smp_wmb();
 
-	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans);
+	btrfs_create_pending_block_groups(trans);
 
 	if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
 		int run_it = 0;
-- 
2.14.3

