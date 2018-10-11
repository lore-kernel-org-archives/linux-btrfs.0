Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CA8C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E286B20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="MSlxF8gf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E286B20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbeJLDYP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:15 -0400
Received: from mail-qt1-f175.google.com ([209.85.160.175]:44596 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDYP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:15 -0400
Received: by mail-qt1-f175.google.com with SMTP id c56-v6so11329632qtd.11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=0W52/LLOm7ykBXZDSlAQ977l0m2qfHMeXXMlb1zP6II=;
        b=MSlxF8gfkZAdET8AymXmSs949eL5Cqo0vITJiKS24/Zavq+47TLlTrb+0+0BFPzD8J
         H80kV/hqyaPw6vltB9jOM8rHMmCrMRdp+zBoyIxhrQ3wau4GLCz3QE/BAhPMoYgD4xja
         eyxITJEZkckVpFLJWDPxpx9PQ4GgnaG62sNd/kISqT010jMQ25XN9dLAc9kzBlyq/RIh
         BtBARZhD4BQxGtpKqEd5sN6Ri1iL+ZGn2JXi4PvDuGpX00LRr7qgoicM14HHKdHvN2rV
         16UyCdkZdpJApiYPh7GOr490jJN6g2GdhYcw5oY7r7P1ya7kqDRAYYsWMEbpChxcLN3m
         L9oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=0W52/LLOm7ykBXZDSlAQ977l0m2qfHMeXXMlb1zP6II=;
        b=eDvW/g2zQNaRZgFZ0sO75z5AeiZfhBq1eRwwRw+z8l2hThvU/QfFbHL/Vad6XYFWlW
         Mc/f6Gk/kwr1KZlu/swJZqFcjWHvU1tmk9Gj2QY+vIo374f3ox2uRaSkLnAzhx5p8L4Y
         iOWZIewsItU9qdcZggsP7wuwgcqk9WSCefsWsb9DW4/48aUAANKq3l7GQJk9+TC8gF1i
         5nhPZwswz8UJB78KkISQNyJN/ghJ9TNy7kMGb7g312CQzwcPCZ22vRJ5wzlZBXzrCNde
         /QEuVD88etj1eTrIjdg7y/TbpKYFfhEK3r0mNKxE+KoVhf+L9o4uqWYN3mShbv7esF2l
         bbUg==
X-Gm-Message-State: ABuFfoiwEbTU8dapepJKKVlDOpq6JXoUgac7nTILk4NajZtt7j0kTgnT
        AKf7rVtQCTXVECzwBfilCwS3EA==
X-Google-Smtp-Source: ACcGV62FBTyI3UpWALCwPqLt+/IpPkPnm0qVdvLWfoj9IOphk39psPQ3Wyvq0gAQO0gjL8RCAgvg5w==
X-Received: by 2002:ac8:1644:: with SMTP id x4-v6mr3058860qtk.67.1539287728318;
        Thu, 11 Oct 2018 12:55:28 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o7-v6sm15101388qkc.67.2018.10.11.12.55.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:27 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 29/42] btrfs: call btrfs_create_pending_block_groups unconditionally
Date:   Thu, 11 Oct 2018 15:54:18 -0400
Message-Id: <20181011195431.3441-30-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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
index 3ca42f4cd462..6fa7d19bcbb1 100644
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

