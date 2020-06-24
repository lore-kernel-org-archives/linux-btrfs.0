Return-Path: <SRS0=nWHZ=AF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5049C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jun 2020 16:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B86062073E
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jun 2020 16:03:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="K+06RASo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404804AbgFXQDf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 12:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404790AbgFXQD3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jun 2020 12:03:29 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AAAC061797
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2020 09:03:28 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 853881409CF;
        Wed, 24 Jun 2020 18:03:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1593014606; bh=sNCrUkHzMeSffkW9ubMu/UbOmJmuH0MVc9Ngep/8TGk=;
        h=From:To:Date;
        b=K+06RASoH6ZZZj8XpzJ8ec/NNaQ4ciGYTo5zqlh0c1nxRBlCbYfQHyp6yK80D82CE
         kt6lJzFUKnN8XYpYpHCupK1SCyWhM7Z28rJgE9O6W+9dk8N567QwR18h+UFc8MUVsA
         hOzAQhHWGKXI75TwQ9ufhVuvYWNhX1lQkh+E0MGo=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     u-boot@lists.denx.de
Cc:     =?UTF-8?q?Alberto=20S=C3=A1nchez=20Molero?= <alsamolero@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Pierre Bourdon <delroth@gmail.com>,
        Simon Glass <sjg@chromium.org>, Tom Rini <trini@konsulko.com>,
        Yevgeny Popovych <yevgenyp@pointgrab.com>,
        linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH U-BOOT v3 30/30] MAINTAINERS: Add btrfs mailing list and myself as reviewer
Date:   Wed, 24 Jun 2020 18:03:16 +0200
Message-Id: <20200624160316.5001-31-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624160316.5001-1-marek.behun@nic.cz>
References: <20200624160316.5001-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

Since the current code base is mostly from btrfs-progs, anyone
contributing to U-Boot btrfs code could also help us to improve
btrfs-progs and btrfs kernel module.

Also add myself as designated reviewer.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Marek Behún <marek.behun@nic.cz>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index db8cecd5e0..0cf04b5063 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -562,6 +562,8 @@ F:	tools/binman/
 
 BTRFS
 M:	Marek Behun <marek.behun@nic.cz>
+R:	Qu Wenruo <wqu@suse.com>
+L:	linux-btrfs@vger.kernel.org
 S:	Maintained
 F:	cmd/btrfs.c
 F:	fs/btrfs/
-- 
2.26.2

