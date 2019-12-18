Return-Path: <SRS0=fY3M=2I=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106CAC43603
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Dec 2019 01:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E524F21775
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Dec 2019 01:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfLRBTw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 20:19:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:49730 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbfLRBTw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Dec 2019 20:19:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7A563ABCD
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2019 01:19:50 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs-progs: tests: Add --force for repair command
Date:   Wed, 18 Dec 2019 09:19:37 +0800
Message-Id: <20191218011942.9830-2-wqu@suse.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218011942.9830-1-wqu@suse.com>
References: <20191218011942.9830-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since commit e388bf38 ("btrfs-progs: check: warn users about the
possible dangers of --repair") `btrfs check --repair` will wait 10
seconds before really repair the fs.

This hugely slow down the fsck tests. Add --force for check_image()

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/common | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/common b/tests/common
index ca098444..605cf72c 100644
--- a/tests/common
+++ b/tests/common
@@ -331,7 +331,7 @@ check_image()
 	"$TOP/btrfs" check "$image" >> "$RESULTS" 2>&1
 	[ $? -eq 0 ] && _fail "btrfs check should have detected corruption"
 
-	run_check "$TOP/btrfs" check --repair "$image"
+	run_check "$TOP/btrfs" check --repair --force "$image"
 	run_check "$TOP/btrfs" check "$image"
 }
 
-- 
2.24.1

