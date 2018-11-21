Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38360C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3199214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:05:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="DOB7v93H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3199214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732101AbeKVFlW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:41:22 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:34343 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFlW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:41:22 -0500
Received: by mail-yb1-f196.google.com with SMTP id a67-v6so1092020ybg.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=MGS24WHfpQTuQ+5v8FcOJLX4g4kfm56cdKOc1o1JYb8=;
        b=DOB7v93H/16lTdX9XQL3nxNvFv+YZyRPPwTvNV+0necMVqOmnjqMlLQBu/wcteD+0/
         36kmNNASLc3qBu8Q7U/GeBHJabSPRXqRwMio4amTOIWRfKKyNn0Ey+l5ZjtzLucaOnCd
         gyHAK0CAove215oAnSvk3XH7Vp8BBviZ1FO3BXz0a5sY7BXG4fpuRmtvmXHWLuA6qKYf
         pvJ+6kt81aooWoIw33iBN/sFsGCgbtTkzbIopidqESVApcqTA4BwaXfZYSozrEV4yFtp
         2Iy9JjGnGUOsmPV41kRiyYHeEcfLPsjTBylGSZ3TN+uQ7PPDsIAAz0njg7Edqe43Agpx
         y1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=MGS24WHfpQTuQ+5v8FcOJLX4g4kfm56cdKOc1o1JYb8=;
        b=h80yxfUrAIyOr+Tly/3CN1VBZUAyBkpacQCH95dJI7XQPb24C3YAl7Lmc0lcY7uOh+
         jPz4ahOCoFdoiOK0koUf3/HcqOlU6TyJsKPwwkSaW9PkJu3gD9pF2A2NdhfqSEiJuCBF
         oMdnYIDsWY6c4177mj1noCGrayhWv2p75RTn5RvNNI+u4jXFhcqhAOgZZbW1eg8moak8
         ne24+Yeee/FhJ1Y72SweQDRqi92VSmK1BP3PySjMG+OjxLZWEmHK5Z9nI8PRQ6iOwGf7
         GpSHZcqM8fWM5fQHkiitiAeDzjxNTWTjxQnOr1HV/3jWobbj8y8t/qysh20i0WL0+Sbq
         XLtA==
X-Gm-Message-State: AA+aEWZi/yzMnKPWw9xl456PclGJMtoMix0nq0A4Cefn4augxgF8fsNh
        N79SWeIUXNyRaB9ZwczG3OP6qT2NeBk=
X-Google-Smtp-Source: AFSGD/Xs/vMOXpHh/Bv4WVEdcRIsjslBZIDUpKYHDJ9b2yeQg5c4EWqV974eAQPaoEktiUAXHhJbmA==
X-Received: by 2002:a25:7e46:: with SMTP id z67-v6mr7528122ybc.90.1542827149466;
        Wed, 21 Nov 2018 11:05:49 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id s189-v6sm9242422ywg.69.2018.11.21.11.05.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:05:48 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 1/7] btrfs: make btrfs_destroy_delayed_refs use btrfs_delayed_ref_lock
Date:   Wed, 21 Nov 2018 14:05:39 -0500
Message-Id: <20181121190545.24798-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190545.24798-1-josef@toxicpanda.com>
References: <20181121190545.24798-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have this open coded in btrfs_destroy_delayed_refs, use the helper
instead.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index beaa58e742b5..f062fb0487cd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4197,16 +4197,9 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 
 		head = rb_entry(node, struct btrfs_delayed_ref_head,
 				href_node);
-		if (!mutex_trylock(&head->mutex)) {
-			refcount_inc(&head->refs);
-			spin_unlock(&delayed_refs->lock);
-
-			mutex_lock(&head->mutex);
-			mutex_unlock(&head->mutex);
-			btrfs_put_delayed_ref_head(head);
-			spin_lock(&delayed_refs->lock);
+		if (btrfs_delayed_ref_lock(delayed_refs, head))
 			continue;
-		}
+
 		spin_lock(&head->lock);
 		while ((n = rb_first_cached(&head->ref_tree)) != NULL) {
 			ref = rb_entry(n, struct btrfs_delayed_ref_node,
-- 
2.14.3

