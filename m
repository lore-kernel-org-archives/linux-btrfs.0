Return-Path: <SRS0=uVIb=YJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511E5FA372A
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Oct 2019 14:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 246932067B
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Oct 2019 14:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389096AbfJPOFh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 10:05:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:53660 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726824AbfJPOFh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Oct 2019 10:05:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0C60B038;
        Wed, 16 Oct 2019 14:05:35 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        rbrown@suse.de, Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] btrfs-progs: warn users about the possible dangers of check --repair
Date:   Wed, 16 Oct 2019 16:05:33 +0200
Message-Id: <20191016140533.10583-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The manual page of btrfsck clearly states 'btrfs check --repair' is a
dangerous operation.

Although this warning is in place users do not read the manual page and/or
are used to the behaviour of fsck utilities which repair the filesystem,
and thus potentially cause harm.

Similar to 'btrfs balance' without any filters, add a warning and a
countdown, so users can bail out before eventual corrupting the filesystem
more than it already is.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 check/main.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/check/main.c b/check/main.c
index fd05430c1f51..acded927281a 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9970,6 +9970,23 @@ static int cmd_check(const struct cmd_struct *cmd, int argc, char **argv)
 		exit(1);
 	}
 
+	if (repair) {
+		int delay = 10;
+		printf("WARNING:\n\n");
+		printf("\tDo not use --repair unless you are advised to do so by a developer\n");
+		printf("\tor an experienced user, and then only after having accepted that no\n");
+		printf("\tfsck successfully repair all types of filesystem corruption. Eg.\n");
+		printf("\tsome other software or hardware bugs can fatally damage a volume.\n");
+		printf("\tThe operation will start in %d seconds.\n", delay);
+		printf("\tUse Ctrl-C to stop it.\n");
+		while (delay) {
+			printf("%2d", delay--);
+			fflush(stdout);
+			sleep(1);
+		}
+		printf("\nStarting repair.\n");
+	}
+
 	/*
 	 * experimental and dangerous
 	 */
-- 
2.16.4

