Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EC1C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0227F215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="qo8cy6r4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0227F215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbeI1Rmu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:50 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45994 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbeI1Rmt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:49 -0400
Received: by mail-qk1-f193.google.com with SMTP id q20-v6so3532355qkc.12
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=v3HuVx6e30n18glhWe6CLEo+SQ0QfuV0FvwRHevY9qI=;
        b=qo8cy6r4VCTYoBYD99WKLdV866gA33LtqlMMBSBihuUBMRfDLDNbdhF5BiIazo6/rE
         y0/os18K0P2rTxhCNgi9Kp6ETQkfFsgELx4BLEn19RXDwl5nV/YwXt7XWoPlWHu7jXpx
         TnSHIHH2orSv326S4JEFK9348LQ0RTcfWzbsnEyx8DalMOXIkq8f3HMpffa4aOhb/eSo
         7mRNyUO1LNJUd1mstd4FqHxmVIBxNcWCNnRZcn0L/a2f3id7Dr+Dqg6QR0FuOFuxZDud
         pa/3m/Z9Q0kOO2ChQWMMq053BKRUSObN4h8UTwW986EWaU1hqPotzFU40RmICzbCmX8u
         8o+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=v3HuVx6e30n18glhWe6CLEo+SQ0QfuV0FvwRHevY9qI=;
        b=VjinpipXIdtkmZeSc5PtkmAqtP+cHxk2Qp40t+umdHzSezc7l8p+s1Z3C2Mg05I0r1
         kBrApgjQTpTHqOC0zryYV3YV/eME/kpXUEzvDr9ijYzmcRX3vLUEJgkHiBdooCNIjWi/
         x1wn2CwpXFBBIdK9biEtLHrDWyaHh6y6D/289iI9AWTm7xTPBDYJyXG1dZToYSp6VeT1
         f5Zw5HwEy2M4+aYmSxO3Z35ZVujd2Roz799l2A++Z90iGVomhdzYuSg3YABq8+mva4kY
         Nb23So0bCkCH5SbaQjkzM9B9ernoX/juH6hObjTwUU2MzCjxpvXUOCyeEMFkQPC2iSQo
         6Qnw==
X-Gm-Message-State: ABuFfoh0qIPyCrY3cAgdSEYVkc7RTFZEgtP+0KmPRkBwSKrMu2BNAVSL
        Bn34YPKB4k/AkRDcp+0qb+/BAg==
X-Google-Smtp-Source: ACcGV63tg/jAXLswVRx0JOAjUfFcjaYJYdNBmYA94WCbHwRxgORLYvRReo256lzLocXdRTGfHcBgng==
X-Received: by 2002:a37:e104:: with SMTP id c4-v6mr11426712qkm.28.1538133571767;
        Fri, 28 Sep 2018 04:19:31 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id n83-v6sm2549515qki.60.2018.09.28.04.19.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:30 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 36/42] btrfs: wait on caching when putting the bg cache
Date:   Fri, 28 Sep 2018 07:18:15 -0400
Message-Id: <20180928111821.24376-37-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

While testing my backport I noticed there was a panic if I ran
generic/416 generic/417 generic/418 all in a row.  This just happened to
uncover a race where we had outstanding IO after we destroy all of our
workqueues, and then we'd go to queue the endio work on those free'd
workqueues.  This is because we aren't waiting for the caching threads
to be done before freeing everything up, so to fix this make sure we
wait on any outstanding caching that's being done before we free up the
block group, so we're sure to be done with all IO by the time we get to
btrfs_stop_all_workers().  This fixes the panic I was seeing
consistently in testing.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 922dd509591a..262e0f7f2ea1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9890,6 +9890,7 @@ void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
 
 		block_group = btrfs_lookup_first_block_group(info, last);
 		while (block_group) {
+			wait_block_group_cache_done(block_group);
 			spin_lock(&block_group->lock);
 			if (block_group->iref)
 				break;
-- 
2.14.3

