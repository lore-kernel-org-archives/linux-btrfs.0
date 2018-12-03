Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9FFC07E85
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E071920834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="iX8THiQP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E071920834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbeLCPUy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:20:54 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43058 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbeLCPUy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:20:54 -0500
Received: by mail-yw1-f68.google.com with SMTP id l200so5505629ywe.10
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=nJ9I87mj/kf+AeJTopTyg8uLem/EFFwXtsk1rurU9IE=;
        b=iX8THiQP5MV7+42h31xn5CenyfOhiBlR5lxNTro5roWNVQINQnLrV8yn+0Rh26oT1G
         uYs282vLPZW3NEsDbVv0CMcB9dCjOq1V9zGF7YHcKIzFyl03EQuXheVT3LeIrouHjMyS
         QdTcUvzRCG6TKtgHeGrmIq/RAwNormjMXi+RaTzTKVZ27RpI6oDeRdqMqaUcsf7njqse
         84xu6j2bCb5LVyiNiEoqY95VEB+95LfP9pjcVjUld9f8+ZeSpBCpq6rGq2jj8oMXNLRb
         ZwQi4tzFn1nTRl45jWRA0je6Dm4Jrcx58eqy/l3s3gviCfhH1Dl79ilJgHthXbVAS/rl
         ubrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=nJ9I87mj/kf+AeJTopTyg8uLem/EFFwXtsk1rurU9IE=;
        b=F/GS+q8gfgBAzEqRnVXGwZr9+l7L+qcB+q1oeWgDwZF6AJoGllz3fA2/p7C5dTlX7J
         R30gshMnOAXX0gxNvjgng7W8qagRumwULw1psYc5RGXg+xkvjKbbdA05sgfJQQHnjcgu
         wJ+l9+q0OHNxFDX/FYmRA+YgofifmBA2WK3YETHikAzylvi1c1cOeVFqU7wYE4wk4LWm
         CroqU3CmhJNPaWBBTO/S70pRKntXRJOO7T276YDOxRpyKrxKKft2RTr3BKoxKokGzmrA
         yNFEipcJ3qefgLrh7+aXJPeQfFptw5joze5cyzk+vJtC7eRkICiepaZR8IpFHiCEBSVr
         N+iQ==
X-Gm-Message-State: AA+aEWYj2QVLl3YYLigknNATUvXTxGNeYFo8ylEPPDB5x9BOwjMh8QaC
        lSQEc5bD/AoBWSYDaXqUoWLuamdHDEQ=
X-Google-Smtp-Source: AFSGD/W5GCBK2VfH1lStrvwRm98OkiPqyRNTXdQpJkoqks8xooIkYY0VaEAJLcwNsZ3HwSTwuUTPwg==
X-Received: by 2002:a81:6c51:: with SMTP id h78mr16045960ywc.116.1543850452494;
        Mon, 03 Dec 2018 07:20:52 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u2sm5520251ywe.84.2018.12.03.07.20.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:20:51 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 06/10] btrfs: update may_commit_transaction to use the delayed refs rsv
Date:   Mon,  3 Dec 2018 10:20:34 -0500
Message-Id: <20181203152038.21388-7-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152038.21388-1-josef@toxicpanda.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Any space used in the delayed_refs_rsv will be freed up by a transaction
commit, so instead of just counting the pinned space we also need to
account for any space in the delayed_refs_rsv when deciding if it will
make a different to commit the transaction to satisfy our space
reservation.  If we have enough bytes to satisfy our reservation ticket
then we are good to go, otherwise subtract out what space we would gain
back by committing the transaction and compare that against the pinned
space to make our decision.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index aa0a638d0263..63ff9d832867 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4843,8 +4843,10 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 {
 	struct reserve_ticket *ticket = NULL;
 	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_block_rsv;
+	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
 	struct btrfs_trans_handle *trans;
-	u64 bytes;
+	u64 bytes_needed;
+	u64 reclaim_bytes = 0;
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 	if (trans)
@@ -4857,15 +4859,15 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	else if (!list_empty(&space_info->tickets))
 		ticket = list_first_entry(&space_info->tickets,
 					  struct reserve_ticket, list);
-	bytes = (ticket) ? ticket->bytes : 0;
+	bytes_needed = (ticket) ? ticket->bytes : 0;
 	spin_unlock(&space_info->lock);
 
-	if (!bytes)
+	if (!bytes_needed)
 		return 0;
 
 	/* See if there is enough pinned space to make this reservation */
 	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes,
+				   bytes_needed,
 				   BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
 		goto commit;
 
@@ -4877,14 +4879,18 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 		return -ENOSPC;
 
 	spin_lock(&delayed_rsv->lock);
-	if (delayed_rsv->size > bytes)
-		bytes = 0;
-	else
-		bytes -= delayed_rsv->size;
+	reclaim_bytes += delayed_rsv->reserved;
 	spin_unlock(&delayed_rsv->lock);
 
+	spin_lock(&delayed_refs_rsv->lock);
+	reclaim_bytes += delayed_refs_rsv->reserved;
+	spin_unlock(&delayed_refs_rsv->lock);
+	if (reclaim_bytes >= bytes_needed)
+		goto commit;
+	bytes_needed -= reclaim_bytes;
+
 	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes,
+				   bytes_needed,
 				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0) {
 		return -ENOSPC;
 	}
-- 
2.14.3

