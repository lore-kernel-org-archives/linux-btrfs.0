Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFDBC83020
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Dec 2020 19:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 872E622247
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Dec 2020 19:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389810AbgLBTxX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Dec 2020 14:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389802AbgLBTxW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2020 14:53:22 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C8FC08E85F
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Dec 2020 11:51:59 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id y18so2452122qki.11
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2020 11:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vSfmesQF2fuwkpEDFiVhTe5hdHk1RkRcCl1beuLPJkM=;
        b=LBzWn4wdErAIem+tR3dAiiMnOA61J7fwvP/TvO4BXArEvUbsQC3lWXfIQ5W3YROHSp
         Pidc/4HxPGlA4jZemgHVbCWuefZT/nSCnyYZgpy+/QTxsikB/XtkC0vFq7wA6bfJ+ig2
         OIfobw5TAZV8LAgWkWTRHIG4jxMckOwo0XkyuynvM7RXPgBbW2v/DwDLGe1To8y3XA2O
         eZaPA4nwpY7Kav9Fl6iToCRSxKyfqhh8kz3dLEpjO0f4PV4AgzRTQSwvD8AkOlFhgYai
         I+LnVwcmvTf7Ju7Tw8AGb3uxKFNK5GNnL0gs6SkWT7YUztKarmDFe5/bDCuMDbDhtq7K
         qYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vSfmesQF2fuwkpEDFiVhTe5hdHk1RkRcCl1beuLPJkM=;
        b=iEqHM9K2nFSvB81SlfqyLF3XNQXP8BDxcZ4ck9FuWu54J2j4jgvXLulfj//Xiy4Scp
         /pTe7bE3AmzJAbBQdkeKCjd93vJH7ZEwATECtcP+Di7sI2GFNZyXigux0b4ltTM/oBM0
         /o2Nq47661ypg05jnYahQonbY6TYsKsnmy0KWTPBgQewlXd92rlFJjB9TU/C+bOZxUE5
         oiK8sdttdAdyOeTwfqCkUSGPPmVdxiRnjLx3Px0HJR5e+141eVm75MG7pTobdNF+Qml1
         +aYMSH7wM89Xoxye5mrZClH8KcvkpW71+f8/ErUM1nosyQdU3zwJtkWJW5YqOj7SxxXK
         Idjg==
X-Gm-Message-State: AOAM532bC4Y8LYuKsiagRGMB2+kOq0H6me8Z9e7H2LQvDqkKyZb3vUI4
        ukr73Hcupkd23EMAgdM/G6ye1COURgMOJA==
X-Google-Smtp-Source: ABdhPJyOL3PAGZVyHuIv4xJVG1MKwYjkBXmOVIWL4daon2upvTMGSYKRNVO8L2u0LE7j6jT+Y099HA==
X-Received: by 2002:a37:9282:: with SMTP id u124mr4340880qkd.288.1606938718106;
        Wed, 02 Dec 2020 11:51:58 -0800 (PST)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id m54sm3033878qtc.29.2020.12.02.11.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 11:51:57 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 24/54] btrfs: handle record_root_in_trans failure in qgroup_account_snapshot
Date:   Wed,  2 Dec 2020 14:50:42 -0500
Message-Id: <b42b4e2d067681b11ba85503802e8f3128485be9.1606938211.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1606938211.git.josef@toxicpanda.com>
References: <cover.1606938211.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

record_root_in_trans can fail currently, so handle this failure
properly.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/transaction.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c17ab5194f5a..db676d99b098 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1436,7 +1436,9 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	 * recorded root will never be updated again, causing an outdated root
 	 * item.
 	 */
-	record_root_in_trans(trans, src, 1);
+	ret = record_root_in_trans(trans, src, 1);
+	if (ret)
+		return ret;
 
 	/*
 	 * We are going to commit transaction, see btrfs_commit_transaction()
@@ -1488,7 +1490,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	 * insert_dir_item()
 	 */
 	if (!ret)
-		record_root_in_trans(trans, parent, 1);
+		ret = record_root_in_trans(trans, parent, 1);
 	return ret;
 }
 
-- 
2.26.2

