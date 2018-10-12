Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAF1C6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D9D02087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="jDGBbrxy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D9D02087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbeJMDIU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:20 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41008 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbeJMDIU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:20 -0400
Received: by mail-qt1-f194.google.com with SMTP id l41-v6so15054644qtl.8
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ja6BEdk2d172wcHDS/gitUITWM0Dn5OfC8ykxBklKgo=;
        b=jDGBbrxyO5K2LDatw6+hvmpr4HwUbD60+98ZOeDVMZMUCXdBclOeP/e2zIHm5BplEm
         ylNdpu+4bVlgXWjm2z1NvexOE53x2qQg6xyd/aEVqQSoaEbpO+hQEmEODH7buRXQZ2Qu
         GUit+qcEugAM6axUbemshegABkEi/Fij2QHqUorz7cL4ZfAxy2gxb8qEqpU9fZZbZ5No
         POuc6w7o8SDB2f9JNYJOeDtY+NvIjquTzzAr9DNXcfR3AaS4Z4bXWYInIMTHgxOXlP1g
         fnlQDu7xlHZ8kV/gUzxEaGSY5l09FNR8AXgGlcXt3KZYzetaH9NS2XvURKsrBDTSIPZ9
         arqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=ja6BEdk2d172wcHDS/gitUITWM0Dn5OfC8ykxBklKgo=;
        b=sr24EES/3X3EILMQafpto3reakPPi8QVXXILxV8ypppbZnAF0vDEBSHSA7LyymSF9X
         9xY5cpse5WFD7VgfBK4xK3z36R312BdpnU9Ug3ku/TWQBiqEUy80YloBvVZKLQquY4rZ
         7B8/ZyUoI3rdJ0ilf/lTpBL+tKwiHLASO7vZO35vr0Mq9aPkFlE9vJuJhr6bPrCAv4Qx
         XWVcZAnZCP7WxQO5akWDwcuwmb+vjt1Gr09h/zukc+XHTOOWI05qkKCXHnaaiNthTV/7
         zzsQyOudvfuc9IGsyxp/pdoXE4bPWEYObu9OWzsT/qGvG2aeX2Xj+CRsu5THw+HI58Ay
         Ot9Q==
X-Gm-Message-State: ABuFfojJ0HAIJMG8ApGJlwxsZ4i7AMmlaLrBieQyvERxft9rA7zfOMMS
        /PVcNBYgorycFdvkhMsFIq3C4i9jtYA=
X-Google-Smtp-Source: ACcGV61B1GGRUeprZJLoUFbTmbmJ+akAWhKHU/qXQbRhB2BQut2JFqAs/GvOltKkwM4c1sYvzWjeLQ==
X-Received: by 2002:ac8:373a:: with SMTP id o55-v6mr7165115qtb.224.1539372858722;
        Fri, 12 Oct 2018 12:34:18 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id v57-v6sm1350785qtk.51.2018.10.12.12.34.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:17 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 35/42] MAINTAINERS: update my email address for btrfs
Date:   Fri, 12 Oct 2018 15:32:49 -0400
Message-Id: <20181012193256.13735-36-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

My work email is completely useless, switch it to my personal address so
I get emails on a account I actually pay attention to.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 32fbc6f732d4..7723dc958e99 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3095,7 +3095,7 @@ F:	drivers/gpio/gpio-bt8xx.c
 
 BTRFS FILE SYSTEM
 M:	Chris Mason <clm@fb.com>
-M:	Josef Bacik <jbacik@fb.com>
+M:	Josef Bacik <josef@toxicpanda.com>
 M:	David Sterba <dsterba@suse.com>
 L:	linux-btrfs@vger.kernel.org
 W:	http://btrfs.wiki.kernel.org/
-- 
2.14.3

