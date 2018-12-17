Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE10C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 16:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 895A12133F
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 16:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbeLQQhi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 11:37:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:44230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727771AbeLQQhi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 11:37:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93FAAAE1F
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 16:37:36 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>
Subject: [trivial PATCH] btrfs-progs: docs: fix balance -f grammar
Date:   Mon, 17 Dec 2018 17:37:29 +0100
Message-Id: <20181217163729.10991-1-ddiss@suse.de>
X-Mailer: git-send-email 2.13.7
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 Documentation/btrfs-balance.asciidoc | 2 +-
 cmds-balance.c                       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-balance.asciidoc b/Documentation/btrfs-balance.asciidoc
index 536243bc..bfb76742 100644
--- a/Documentation/btrfs-balance.asciidoc
+++ b/Documentation/btrfs-balance.asciidoc
@@ -101,7 +101,7 @@ act on system chunks (requires '-f'), see `FILTERS` section for details about 'f
 -v::::
 be verbose and print balance filter arguments
 -f::::
-force reducing of metadata integrity, eg. when going from 'raid1' to 'single'
+force a reduction of metadata integrity, eg. when going from 'raid1' to 'single'
 --background|--bg::::
 run the balance operation asynchronously in the background, uses `fork`(2) to
 start the process that calls the kernel ioctl
diff --git a/cmds-balance.c b/cmds-balance.c
index 6cc26c35..c1dfe86e 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -508,7 +508,7 @@ static const char * const cmd_balance_start_usage[] = {
 	"-m[filters]    act on metadata chunks",
 	"-s[filters]    act on system chunks (only under -f)",
 	"-v             be verbose",
-	"-f             force reducing of metadata integrity",
+	"-f             force a reduction of metadata integrity",
 	"--full-balance do not print warning and do not delay start",
 	"--background|--bg",
 	"               run the balance as a background process",
-- 
2.13.7

