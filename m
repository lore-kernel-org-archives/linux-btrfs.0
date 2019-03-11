Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE31C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 10:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 247C22077B
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 10:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfCKKU7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 06:20:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:37448 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726826AbfCKKU7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 06:20:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A1CCBAED4
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2019 10:20:58 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs-progs: Remove get_argv0_buf
Date:   Mon, 11 Mar 2019 12:20:56 +0200
Message-Id: <20190311102056.27503-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

get_argv0_buf is used only in two functions in help.c which also has
direct access to the static argv0_buf. All other references to this
buffer are direct. So remove the function. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 help.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/help.c b/help.c
index b10b2b053e13..09e771ef6695 100644
--- a/help.c
+++ b/help.c
@@ -31,11 +31,6 @@
 
 static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
 
-const char *get_argv0_buf(void)
-{
-	return argv0_buf;
-}
-
 void fixup_argv0(char **argv, const char *token)
 {
 	int len = strlen(argv0_buf);
@@ -349,7 +344,7 @@ void usage_command_group(const struct cmd_group *grp, int full, int err)
 __attribute__((noreturn))
 void help_unknown_token(const char *arg, const struct cmd_group *grp)
 {
-	fprintf(stderr, "%s: unknown token '%s'\n", get_argv0_buf(), arg);
+	fprintf(stderr, "%s: unknown token '%s'\n", argv0_buf, arg);
 	usage_command_group(grp, 0, 1);
 	exit(1);
 }
@@ -359,7 +354,7 @@ void help_ambiguous_token(const char *arg, const struct cmd_group *grp)
 {
 	const struct cmd_struct *cmd = grp->commands;
 
-	fprintf(stderr, "%s: ambiguous token '%s'\n", get_argv0_buf(), arg);
+	fprintf(stderr, "%s: ambiguous token '%s'\n", argv0_buf, arg);
 	fprintf(stderr, "\nDid you mean one of these ?\n");
 
 	for (; cmd->token; cmd++) {
-- 
2.7.4

