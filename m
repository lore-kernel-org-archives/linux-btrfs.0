Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD54C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7B86215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="mXCmbHJZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7B86215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbeI1Rlu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:41:50 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45914 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1Rlu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:41:50 -0400
Received: by mail-qk1-f194.google.com with SMTP id q20-v6so3530868qkc.12
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E8JF94eruCVpfwCQjNtPgc8hW7YmBCNIla9LHGUTiOs=;
        b=mXCmbHJZqUQzvctrq8r5Bph6itvgS3E9G9xxVuoewnEx7t2jMZMb0md+qMrNtwhVVf
         DPFDUYi5WNW/NB0ZrtVyrjU00pp6cOx4UT+bgn7da7+3IM1DjUSoXaoCMlof5mFQOTUN
         AoZz63j6A+PusoTpwFkVMi5tDpDq8IKK9++G+Q1lldJ/fMxkVZdgaNunnhZ2IaQ+BxrT
         AP236z7KgShHCnqOHG1omXrHUlVXdM1pCx7Vv+BJMy//pi/MFaONAET9z2oUJPPfC3hY
         gEo1G1q0A/K9Qh4uuLDq05/Aw6Qp6VAcNl2XuMj1x7maGFLEH0tJ3UhJQgjKrRICKFnc
         vRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E8JF94eruCVpfwCQjNtPgc8hW7YmBCNIla9LHGUTiOs=;
        b=VuSwCS+ousvXadEUBYbIMtzHn35EWdR691cb0tuVenKrqYZKMYYZl35x3b3p2BYt7Q
         3uSZbPcJ5q+XgaoRIMQVKdqzajJCqMwwdUK8xqsMweY8xJpNpwdsIXVRKm5I+EoemV/a
         Tl+U8Yc646FtPBdWCTK4s00ojTHq0Fiat2za/tRzaqGHEFPuhLoXsXxOpCFyCtq4p5Hj
         VEhEPXNBKzdlHENbEnztlNwScj8UvMLe/sXRV5mY2npXQQGa62go7/oZFaUQPFp9gv02
         arszffnvZVWAzQMtb77X/kfK/lni6dbc5Uw0bd28hh58rlF7DSF6KpvMyvsOiLfNfDu0
         URUQ==
X-Gm-Message-State: ABuFfojh6LF5IMp8lwKjxWdfoX9jludQzdCvePaM2ieqe9BT+mpPCP3M
        d6ozlJ0f3nHErZIT4TF7v6d03w==
X-Google-Smtp-Source: ACcGV63l43nAZd/Gn1ePZn8s8YKRkfmukaPHA/xKS7SJtfGisUPW/4p4G/xMpTUh5QSIfK5X1EAnTg==
X-Received: by 2002:a37:31d5:: with SMTP id x204-v6mr10868830qkx.289.1538133512552;
        Fri, 28 Sep 2018 04:18:32 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 80-v6sm2482733qkj.75.2018.09.28.04.18.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:31 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 04/42] btrfs: only track ref_heads in delayed_ref_updates
Date:   Fri, 28 Sep 2018 07:17:43 -0400
Message-Id: <20180928111821.24376-5-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

We use this number to figure out how many delayed refs to run, but
__btrfs_run_delayed_refs really only checks every time we need a new
delayed ref head, so we always run at least one ref head completely no
matter what the number of items on it.  Fix the accounting to only be
adjusted when we add/remove a ref head.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-ref.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 3a9e4ac21794..27f7dd4e3d52 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -234,8 +234,6 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 	ref->in_tree = 0;
 	btrfs_put_delayed_ref(ref);
 	atomic_dec(&delayed_refs->num_entries);
-	if (trans->delayed_ref_updates)
-		trans->delayed_ref_updates--;
 }
 
 static bool merge_ref(struct btrfs_trans_handle *trans,
@@ -460,7 +458,6 @@ static int insert_delayed_ref(struct btrfs_trans_handle *trans,
 	if (ref->action == BTRFS_ADD_DELAYED_REF)
 		list_add_tail(&ref->add_list, &href->ref_add_list);
 	atomic_inc(&root->num_entries);
-	trans->delayed_ref_updates++;
 	spin_unlock(&href->lock);
 	return ret;
 }
-- 
2.14.3

