Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F65C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 05:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A1F5218D0
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 05:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfB0FQI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 00:16:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:56490 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725914AbfB0FQH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 00:16:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B9AEDAE33
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2019 05:16:06 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: gitignore: Ignore hidden files
Date:   Wed, 27 Feb 2019 13:16:02 +0800
Message-Id: <20190227051602.28987-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

A lot of editor/IDE related config files are hidden files, like .vimrc
or .clang_complete.

Instead of adding gitignore entry for each editor/IDE, just ignore all
hidden files like what kernel does.

Signed-off-by: Qu Wenruo <wqu@suse.com>
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

