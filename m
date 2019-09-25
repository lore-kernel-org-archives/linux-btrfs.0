Return-Path: <SRS0=zJiL=XU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177AAC4360C
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Sep 2019 13:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBDF22146E
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Sep 2019 13:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406628AbfIYNhp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 09:37:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:35630 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406256AbfIYNhp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Sep 2019 09:37:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BA682AC67;
        Wed, 25 Sep 2019 13:37:43 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v5 1/7] btrfs-progs: add option for checksum type to mkfs
Date:   Wed, 25 Sep 2019 15:37:22 +0200
Message-Id: <20190925133728.18027-2-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190925133728.18027-1-jthumshirn@suse.de>
References: <20190925133728.18027-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add an option to mkfs to specify which checksum algorithm will be used for
the filesystem.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 mkfs/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index 7a7b6417a947..61184c8e7525 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -354,6 +354,7 @@ static void print_usage(int ret)
 	printf("\t--shrink                (with --rootdir) shrink the filled filesystem to minimal size\n");
 	printf("\t-K|--nodiscard          do not perform whole device TRIM\n");
 	printf("\t-f|--force              force overwrite of existing filesystem\n");
+	printf("\t--checksum              checksum algorithm to use (default: crc32c)\n");
 	printf("  general:\n");
 	printf("\t-q|--quiet              no messages except errors\n");
 	printf("\t-V|--version            print the mkfs.btrfs version and exit\n");
-- 
2.16.4

