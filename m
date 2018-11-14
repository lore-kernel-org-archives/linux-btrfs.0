Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47625C07E85
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 107B621780
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="NKZ3zRXk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 107B621780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731921AbeKNRt0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:49:26 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44818 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbeKNRt0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 12:49:26 -0500
Received: by mail-pl1-f195.google.com with SMTP id s5-v6so7361757plq.11
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 23:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CyT4GrLsIsb2XKg3awheGJNcT11Tw3s5nMPvi2KjuDU=;
        b=NKZ3zRXk6BEfOf2KB28iUPQzJryQjwrsfKj+7ZlxzqJFZJ8CoruFS2ahhTZAGyZCvd
         A7bwge7JDmKF7zBOW4UuN5+NC1CcrOR+ic7qs2EjxK+ss3lrEpLdXnlOT/CYp6QKRQ4F
         iGQiUfvSu3z38gTgPDOTuWovmmwpyiL86QEBucUNcb6vKasaJsDHkndAsC+j5YHWBYES
         bGXRb1W1roLByrPPZI/N2Tozyk1NMLe+7/WG5qWiizegTdVQPIcSzBFq5gWguQBc0YXV
         C4i9E5vemT7B0T1Z7gIM99Osj9Ez/11FkXyzuzS6h5Wtj1hIIHb5N6G1oLEciUUQZvy8
         YueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CyT4GrLsIsb2XKg3awheGJNcT11Tw3s5nMPvi2KjuDU=;
        b=dz7e98yJQzPNuJH5dXVEyEO6pLC5FclYK4ArfbtdcToDIxj3x9MAfkJ+hu42GNXg+m
         n3yS53o34gB+Ak8B4le6EMLCklsfXyQv/Yq5yq9WClH1ImkEBtORah33NalMOJlJ5VOj
         O8t/hri44ydfAjtXRu9p6N3D9u2i3KDWDSUEu0vlmx1bGE6Fm41nEJ44cv1B6jiaSlUV
         H/39LK7gzN/mNA0jPzDIGc54VoasQ74/D4rmasbsFw1nqJ73nTyOOZPRPxYX3KggbRCg
         Br5xTAcwvaNuFrnS3N1NLVxd3+Fh9/GGGYeK1/L38V6GVOZbQ7SN07W9STXIpY1nRzEg
         4a5w==
X-Gm-Message-State: AGRZ1gKgXIIZETaNxNhtCxOKdyL5KIcEmq9MvM2uGwk5Ab9rN0kgfHqU
        Uy/nofcVphWqGgIvPRBaKaehVxY/66jNfA==
X-Google-Smtp-Source: AJdET5cygjB7Xtc7G/sznLuKNmiFCSJgWO0DDM+vekXBnQN75/e0dTg8c8rcpBzm25HZchT2qDf21A==
X-Received: by 2002:a17:902:66e5:: with SMTP id e92-v6mr869399plk.92.1542181640709;
        Tue, 13 Nov 2018 23:47:20 -0800 (PST)
Received: from vader.psav.com ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id 18-v6sm34835727pfu.129.2018.11.13.23.47.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 23:47:20 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 09/10] libbtrfsutil: bump version to 1.1.0
Date:   Tue, 13 Nov 2018 23:47:04 -0800
Message-Id: <abe16ddddc57ad6a96cc40b7eccd117c8c3746bd.1542181521.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1542181521.git.osandov@fb.com>
References: <cover.1542181521.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

With the previous few fixes and features, we should bump the minor
version.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index d88c39e5..ad4f043e 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -26,7 +26,7 @@
 #include <sys/time.h>
 
 #define BTRFS_UTIL_VERSION_MAJOR 1
-#define BTRFS_UTIL_VERSION_MINOR 0
+#define BTRFS_UTIL_VERSION_MINOR 1
 #define BTRFS_UTIL_VERSION_PATCH 0
 
 #ifdef __cplusplus
-- 
2.19.1

