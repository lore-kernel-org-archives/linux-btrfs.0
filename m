Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CF4C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 07:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFC3020989
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 07:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfCSHus (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 03:50:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:53854 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbfCSHus (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 03:50:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A3F78AEDB
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 07:50:47 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Makefile: Also clean test results
Date:   Tue, 19 Mar 2019 15:50:43 +0800
Message-Id: <20190319075043.4597-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This makes greping a lot easier.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index e25e256f96af..9cefd70d2bd6 100644
--- a/Makefile
+++ b/Makefile
@@ -628,6 +628,7 @@ clean: $(CLEANDIRS)
 		mkfs/*.o mkfs/*.o.d check/*.o check/*.o.d \
 	      ioctl-test quick-test library-test library-test-static \
               mktables btrfs.static mkfs.btrfs.static fssum \
+	      tests/*-results.txt \
 	      $(check_defs) \
 	      $(libs) $(lib_links) \
 	      $(progs_static) \
-- 
2.21.0

