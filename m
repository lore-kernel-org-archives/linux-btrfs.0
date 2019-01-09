Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204C0C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7C1620821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:29:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qSdUYmW/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbfAIB1Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:27:24 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55658 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728403AbfAIB1Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:24 -0500
Received: by mail-wm1-f66.google.com with SMTP id y139so5927899wmc.5;
        Tue, 08 Jan 2019 17:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EPM+PU5B+hUpxk4OBAiw9AqhtjRx/WF1H3KnkENY+T0=;
        b=qSdUYmW/posE95sevZY7n3L7EjGjYcnutk1UqhnZntmZdgVwtwbUJbZ2MsR6X2UTAy
         pHc8ZgxLChGIaDVay+OH0xhyT2fejcvbIli864PU6/AmXenVfyYCgo0gJSfsZZVxibT9
         Tw7iJBk18/6PEoz+LG/igPjOn1xWjHiJJZWVe5AOOvOvTxh/FEY/XGAcY0rQ29zKu+U1
         ECAVZLQwq6ChVTnI+s73fN+NdJ/XuIGeBUhbJWkFLXKGewbYhc5K9GoY2jHTvxIaK6gz
         NpQaK9DwbEFOK+jXw5JrztWgpde3e5GG2JyqenMaPkbXrW8VTFI+UU3J9NJuLKZwfx9O
         ppJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=EPM+PU5B+hUpxk4OBAiw9AqhtjRx/WF1H3KnkENY+T0=;
        b=KKr2lyqiC2HECzsJ7fCYWShq7k5xXMtMWweUdTbnqaJy2v97XUYA5a0gjhFlM5FItF
         XGEEiCskUSD+Hk1eP/ZWIxFGkepaj86bwDuXo4yAr/iwDD5jzdlIaGgZLPy2LTGjjfA4
         kZO4H+5WpoIH8qfrTclRdB27pS2oD/57PJ/e/T4XV8C6dlA6YEyIsp3Z8CwB+7P1Flgl
         GjtIAP2ojKlSaPdoQ5aFSdV11FZ6xul5M7TSyFY1n7geOgQjCwr2JsDrmbw01d4nsl8x
         CWIirjuzM2wPJPh/bgiGQhTPMc6JdOOpHHNN3X8hveRT/xCoe6CKutpt9mKiuvsKV4An
         m/Cg==
X-Gm-Message-State: AJcUukeAOKXGB8o6/WdGmDg6qQ/f/az8OssdPO+kzQ2faugDt9e9+EYt
        0Hv55OCvrf1E2zoYDY2mtFQ=
X-Google-Smtp-Source: ALg8bN4Hxq3B+8CLCD0ne8UuP2jLa4Vv1p1tpIkLc8IJtZzNgZWxfI8f+2SVHEmEyeribOrp7qPXLA==
X-Received: by 2002:a1c:9692:: with SMTP id y140mr3632646wmd.67.1546997242783;
        Tue, 08 Jan 2019 17:27:22 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:22 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 02/19] btrfs: add encryption dependencies to Kconfig
Date:   Wed,  9 Jan 2019 01:26:44 +0000
Message-Id: <20190109012701.26441-2-mark@harmstone.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190109012701.26441-1-mark@harmstone.com>
References: <20190109012701.26441-1-mark@harmstone.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 23537bc8c827..e6b3b51da91f 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -12,6 +12,10 @@ config BTRFS_FS
 	select RAID6_PQ
 	select XOR_BLOCKS
 	select SRCU
+	select KEYS
+	select CRYPTO_AES
+	select CRYPTO_CTR
+	select CRYPTO_RNG
 
 	help
 	  Btrfs is a general purpose copy-on-write filesystem with extents,
-- 
2.19.2

