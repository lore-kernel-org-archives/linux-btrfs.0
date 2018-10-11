Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF66C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D6A220835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="F/CST1XX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D6A220835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbeJLDY0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:26 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41058 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbeJLDYZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:25 -0400
Received: by mail-qt1-f194.google.com with SMTP id l41-v6so11344519qtl.8
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ja6BEdk2d172wcHDS/gitUITWM0Dn5OfC8ykxBklKgo=;
        b=F/CST1XXZHkqVInWQkziWJQl41RMcWsBLPSdrKigqWw4jo86/k+uWBM7o7jAuzziNF
         BjifsDR6M0TW+wH3Q0iExVAdcTVWTmzLGd/BjMkZEy6e4GYHkUdLQSfEnCxHzhZZMAnR
         HgEJv/5ZfKWaGS/52W4rmdqz3Wk9sDFK7FMW9c8KRTY0BLk1cUEv5oM/BRFKUCPYfTn+
         pjC5xAXHIw9d4JqCbug2fk1afkTESdp7QDuNf8ssQKVIt+E0aK/WXzrPijVFPxEFwULU
         O3OZlSRAI28Ederh/AhCrkdvJgNgWphslSHrbAwQN9HNjp/tghIxnuYkfkAYic/EA5JJ
         iE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=ja6BEdk2d172wcHDS/gitUITWM0Dn5OfC8ykxBklKgo=;
        b=n+w2MCLscpqIcV6ZyndHUHx562lVbqc6LvaCzQNrAEStKDi8a5dyK4wzgt+tbTplWj
         GBYYugVR9GGJjDDPtSrqT2ISe+Qgs5CFCuhdMcvBwfoJpjCYL7wBFXGZFtdB21lCePAp
         XVw/G4T0pOJNZsCXvaD4n91SkCysnWz5fMmz8gPUfn4Ljp+mk/dya356HbCwnkwCzKMD
         4eKTBmF/ipmV/VfqgsQ5nBoSzW0VxQkV62jDsgyOiDsvs4ApTfU3GBijgFIOkypu2Ixq
         ZlWzj92xSac6aJpuFz/q3l3Qun2FSA8B0jzyrzt+eYSIroSDGpAztKvb/rSc4em5LggU
         wImA==
X-Gm-Message-State: ABuFfojsSDnt7lJ3vbMNS/lNCTNkoiXm4hTE4txXffn6Ha0SerohQvh9
        jX1R4MUXwQQwsW88Hz3SYQ3KEoVS7ic=
X-Google-Smtp-Source: ACcGV61xGLhxTMF+f1wCozsREz+YclrMF2OuBR6rsRiD6VtgENnrHAPWLaw4Q9+NhlFs+w5hRXhgBg==
X-Received: by 2002:ac8:b0d:: with SMTP id e13-v6mr2996643qti.375.1539287739191;
        Thu, 11 Oct 2018 12:55:39 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o7-v6sm15101716qkc.67.2018.10.11.12.55.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:38 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 35/42] MAINTAINERS: update my email address for btrfs
Date:   Thu, 11 Oct 2018 15:54:24 -0400
Message-Id: <20181011195431.3441-36-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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

