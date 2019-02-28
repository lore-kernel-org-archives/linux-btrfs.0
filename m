Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E634C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 02:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 133CB218A2
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 02:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbfB1CWN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 21:22:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:60444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730341AbfB1CWM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 21:22:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C5DF1AFBC
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 02:22:11 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: gitignore: Ignore hidden files
Date:   Thu, 28 Feb 2019 10:22:06 +0800
Message-Id: <20190228022206.16356-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

A lot of editor/IDE related config files are dotfiles, like .vimrc
or .clang_complete.

Instead of adding gitignore entry for each editor/IDE, just ignore all
dotfiles.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog
v2:
- Change "hidden files" to "dotfiles" in the commit message.
- No longer mention the kernel gitignore behavior in the commit message.
---
 .gitignore | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index d9f022c48c7d..aadf9ae77d41 100644
--- a/.gitignore
+++ b/.gitignore
@@ -64,7 +64,7 @@
 /cscope.files
 /cscope.in.out
 /cscope.po.out
-.clang_complete
+.*
 
 /Documentation/Makefile
 /Documentation/*.html
-- 
2.21.0

