Return-Path: <SRS0=kS6Y=VV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB695C7618B
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jul 2019 12:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 826FA21926
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jul 2019 12:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfGXMBB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Jul 2019 08:01:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:48912 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727483AbfGXMBB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jul 2019 08:01:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7AA98B118
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jul 2019 12:01:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: tests: Avoid debug log populating stdout
Date:   Wed, 24 Jul 2019 20:00:55 +0800
Message-Id: <20190724120055.4131-1-wqu@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When running misc-test/034, we got unexpected log output:
      [TEST/misc]   033-filename-length-limit
      [TEST/misc]   034-metadata-uuid
  Checking btrfstune logic
  Checking dump-super output
  Checking output after fsid change
  Checking for incompat textual representation
  Checking setting fsid back to original
  Testing btrfs-image restore

This is caused by commit 2570cff076b1 ("btrfs-progs: test: cleanup misc-tests/034")
which uses _log facility which also populates stdout.

Just change _log() to echo "$*" >> "$RESULTS" to fix it.
Unlike the initial commit, there is no other user of _log, so it
shouldn't affect other tests.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/common | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/common b/tests/common
index 79a16f1e187d..75e5540155cc 100644
--- a/tests/common
+++ b/tests/common
@@ -51,7 +51,7 @@ _fail()
 # log a message to the results file
 _log()
 {
-	echo "$*" | tee -a "$RESULTS"
+	echo "$*" >> "$RESULTS"
 }
 
 # copy stdout to log and pass to stdout, eg. another stdout consumer, commands
-- 
2.22.0

