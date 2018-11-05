Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D062CC0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 19:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C7922085A
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 19:07:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/8AHHuD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C7922085A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387629AbeKFE1v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 23:27:51 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43723 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387460AbeKFE1v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2018 23:27:51 -0500
Received: by mail-pg1-f195.google.com with SMTP id n10-v6so4630591pgv.10
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Nov 2018 11:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=23sC8kdtiHWrAvH9E3iiXK6MRXIah97kJUhFH8UMkp8=;
        b=k/8AHHuDH9+j8FyK7qnE4s4AmDHpTNWdXDXaDmwMF01Bix72gyBX9UeAs9BczCuYrY
         naUfdVP/Tz4YIeu7ny8wBNQtRxfyViO2udO3RaGFgmxWi0yTW0GPce2aifrf+5/FvZrW
         pp5Ts7LlkOLpoIGcxEOXUtiPY1zsPc3rztFCqejmUhsnqlKwdD7B4JGiAgoqIP+xEGVS
         V90zO5SlMguuS16mgEsRQjJ3bNGi/f7k3FfeaaV3mFeiW3dQFKQE1fBvcn0S4B3lP4ix
         qrPN3Z1O2fSFbXMofKdoGL0hiOAI40pqH7qJB+CN/dgCTIdMyo8GZVnq54Vp6rW4MtqI
         5eUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=23sC8kdtiHWrAvH9E3iiXK6MRXIah97kJUhFH8UMkp8=;
        b=uocHtbmMn67tjueJ0pyu1dc7AKiIhenby/4pHnFxtcCi5EJI2k2JVrMf0MJ0s84apR
         KqRbMdWJa/lA7Ze4bHjHRnZK2EyWXF4o3veMq6yPqe3d9h2S0dEUJ75hm/Bdw+mEceLo
         6YE+uZxUv8nDDZq9FXM7zZskF6eAX5ukMu7jTKYS64fkRnsIAn/p+174bjaAOj36jSeK
         nCDUhhwIYuI5Ef4R9olBpE24XmbFp4OsI2F4iOIWh4gOrAPgvsHotsEHA2BiAoIcM5hY
         NW/1wIsuM+hqgz7txZemlL4uRmfeA7CZnAxmgAOwGkSb88BuEFJWq83USfg1k6FgYOQ+
         XzaQ==
X-Gm-Message-State: AGRZ1gK1LB8wmr7KHO/sBl2ATJ3BmC3vP1zld01Dw0ZADc+Vmzm7DHkY
        xj/3y94mAySlHQApsEgGwEDcwcBa
X-Google-Smtp-Source: AJdET5fMbBiBiUEI9h0BrcgrpmvxdqWPY0QedT22UlaR88BJL9YRkJ2FQHz0bd3c+2VN0cEG+Xkk9g==
X-Received: by 2002:a62:120b:: with SMTP id a11-v6mr23048996pfj.165.1541444806497;
        Mon, 05 Nov 2018 11:06:46 -0800 (PST)
Received: from desktop.lan (astound-69-42-16-32.ca.astound.net. [69.42.16.32])
        by smtp.gmail.com with ESMTPSA id l129-v6sm55872516pfc.155.2018.11.05.11.06.45
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 11:06:45 -0800 (PST)
From:   Rosen Penev <rosenp@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] bitops: Fix big endian compilation
Date:   Mon,  5 Nov 2018 11:06:41 -0800
Message-Id: <20181105190643.13578-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Replaced bswap with _ variants. While it's a glibc extension, all of the
popular libc implementations (glibc, uClibc, musl, BIONIC) seem to support
it.

Added static inline to two functions to match little endian variants. This
fixes a linking error experienced when compiling.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 kernel-lib/bitops.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel-lib/bitops.h b/kernel-lib/bitops.h
index b1fd6f5..2c51a26 100644
--- a/kernel-lib/bitops.h
+++ b/kernel-lib/bitops.h
@@ -178,9 +178,9 @@ static inline unsigned long find_next_zero_bit(const unsigned long *addr,
 static inline unsigned long ext2_swab(const unsigned long y)
 {
 #if BITS_PER_LONG == 64
-	return (unsigned long) bswap64((u64) y);
+	return (unsigned long) bswap_64((u64) y);
 #elif BITS_PER_LONG == 32
-	return (unsigned long) bswap32((u32) y);
+	return (unsigned long) bswap_32((u32) y);
 #else
 #error BITS_PER_LONG not defined
 #endif
@@ -218,14 +218,14 @@ static inline unsigned long _find_next_bit_le(const unsigned long *addr1,
 	return min(start + __ffs(ext2_swab(tmp)), nbits);
 }
 
-unsigned long find_next_zero_bit_le(const void *addr, unsigned long size,
+static inline unsigned long find_next_zero_bit_le(const void *addr, unsigned long size,
 		unsigned long offset)
 {
 	return _find_next_bit_le(addr, NULL, size, offset, ~0UL);
 }
 
 
-unsigned long find_next_bit_le(const void *addr, unsigned long size,
+static inline unsigned long find_next_bit_le(const void *addr, unsigned long size,
 		unsigned long offset)
 {
 	return _find_next_bit_le(addr, NULL, size, offset, 0UL);
-- 
2.19.1

