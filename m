Return-Path: <SRS0=dx4s=6G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CE0C55181
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 06:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD2220706
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 06:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgDVGvq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 02:51:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:51910 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726003AbgDVGvq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Apr 2020 02:51:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 78F77ABCF;
        Wed, 22 Apr 2020 06:51:44 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        u-boot@lists.denx.de
Cc:     marek.behun@nic.cz
Subject: [PATCH U-BOOT 26/26] MAINTAINERS: Add btrfs mail list
Date:   Wed, 22 Apr 2020 14:50:09 +0800
Message-Id: <20200422065009.69392-27-wqu@suse.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200422065009.69392-1-wqu@suse.com>
References: <20200422065009.69392-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since the current code base is mostly from btrfs-progs, anyone
contributing to U-boot btrfs code could also help us to improve
btrfs-progs and btrfs kernel module.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b50652bd85d0..2bb69aeb72eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -529,6 +529,7 @@ F:	tools/binman/
 
 BTRFS
 M:	Marek Behun <marek.behun@nic.cz>
+L:	linux-btrfs@vger.kernel.org
 S:	Maintained
 F:	cmd/btrfs.c
 F:	fs/btrfs/
-- 
2.26.0

