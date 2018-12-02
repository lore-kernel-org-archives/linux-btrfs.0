Return-Path: <SRS0=5FUL=OL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DATE_IN_FUTURE_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AED0C04EB8
	for <linux-btrfs@archiver.kernel.org>; Sun,  2 Dec 2018 07:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E64522082F
	for <linux-btrfs@archiver.kernel.org>; Sun,  2 Dec 2018 07:09:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GBiUodcw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E64522082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbeLBHJE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 2 Dec 2018 02:09:04 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43893 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbeLBHJE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Dec 2018 02:09:04 -0500
Received: by mail-pf1-f196.google.com with SMTP id w73so4804168pfk.10
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Dec 2018 23:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jc07g/+TsxcwD3TRcX/tVh53jvEcMcIMNo+fYO+46a4=;
        b=GBiUodcwLyoejSVCdZD8Z2BSIBUMEYCEgE2qlMRkg8V0kN4TYIfKtOKC1qG/Wf04SD
         n4yMgxAsLP6AFNcYjeAGxqME1hfwoRKmx9Txd5uy29QzebTFJbBx/PqDpzq3VokArZkF
         8kAeGDmy0cDbB2S2hymWX/BoPuf/S6EBMRqdDQqgVu/Ji2QzjyZpVPvyI5ZTyBz/u39i
         Nsitla6EdEbYD9bxfdSirIYVa677JFGffZ40g6V9+RGVaUeYzcavGZXQSGIyfaz0+GXq
         HddwOmtDM7Oc5yyyCJL8Pe7vazNDxREk0BzRKsFvMHPxL5DEpPmjXDiw0CGt3S0UGN78
         rZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jc07g/+TsxcwD3TRcX/tVh53jvEcMcIMNo+fYO+46a4=;
        b=FivA8efqpip9/tu72L/zCjfbkCJMYEsfnUcT5DgVZXrvNepoWJO61XtUrjvXYM+33d
         vK4cV2RQfTmUHZHWMHctC4ji1g+9i5QBKOneJjIK6sC+PuJtRS0rGAEpYs4vXj3c4bJA
         LQrWwpvMDZJ/kfHxP8PXaHK/aFa6jbOcCZZaz0MvNRTyoPHT4lcuONKaMuqSXa2RsrS9
         7mljADbIErCDDX9rbNuC/YoeCvTd6Pd9KOFvWK05hcAP16a6z6LpM6yEtE3KT01oeTf6
         jocrBpRv4mW52uVmTZSntykpsEqp6HCcg5/80qOBuS+snRxdt5dJ72Be5eIHoeMZ4Xur
         4YfQ==
X-Gm-Message-State: AA+aEWZtieYSeywwZej1Woi8aiNwdFKghmXLQ0lLrV3NS/7Kvf3E729J
        e1VWya8XLnJXL2231VngA4jEte+h
X-Google-Smtp-Source: AFSGD/VY9fE9K40d9eT5vLAlq8OOcVEboqBmscacZpqdE5US3gJY3B1T2KJQ6pCl3Tmh8ntnhPKhwQ==
X-Received: by 2002:a62:cd44:: with SMTP id o65mr11449689pfg.222.1543734537447;
        Sat, 01 Dec 2018 23:08:57 -0800 (PST)
Received: from cat-arch.lan ([173.82.208.113])
        by smtp.gmail.com with ESMTPSA id g2sm13328443pfi.95.2018.12.01.23.08.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Dec 2018 23:08:56 -0800 (PST)
From:   damenly.su@gmail.com
X-Google-Original-From: suy.fnst@cn.fujitsu.com
To:     linux-btrfs@vger.kernel.org
Cc:     suy.fnst@cn.fujitsu.com
Subject: [PATCH] btrfs-progs: trivial fix about line breaker in repair_inode_nbytes_lowmem()
Date:   Sun,  2 Dec 2018 15:08:36 +0000
Message-Id: <20181202150836.16625-1-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yue <suy.fnst@cn.fujitsu.com>

Move "\n" at end of the sentence to print.

Fixes: 281eec7a9ddf ("btrfs-progs: check: repair inode nbytes in lowmem mode")
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 14bbc9ee6cb6..919cbc2ea0ce 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2142,7 +2142,7 @@ out:
 		error("failed to set nbytes in inode %llu root %llu",
 		      ino, root->root_key.objectid);
 	else
-		printf("Set nbytes in inode item %llu root %llu\n to %llu", ino,
+		printf("Set nbytes in inode item %llu root %llu to %llu\n", ino,
 		       root->root_key.objectid, nbytes);
 
 	/* research path */
-- 
2.19.1

