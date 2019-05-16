Return-Path: <SRS0=Y5xQ=TQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9499AC04E84
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 May 2019 13:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70FD220818
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 May 2019 13:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfEPNMy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 16 May 2019 09:12:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:55094 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726703AbfEPNMx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 May 2019 09:12:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 947FDABF4
        for <linux-btrfs@vger.kernel.org>; Thu, 16 May 2019 13:12:52 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs-progs: tests: Test fs on image files is correctly recognised
Date:   Thu, 16 May 2019 16:12:50 +0300
Message-Id: <20190516131250.26621-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190516131250.26621-1-nborisov@suse.com>
References: <20190516131250.26621-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This ensures that 'btrfs filesystem show' can correctly identify a
filesystem on a newly created local file.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/cli-tests/010-fi-show-on-new-file/test.sh | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100755 tests/cli-tests/010-fi-show-on-new-file/test.sh

diff --git a/tests/cli-tests/010-fi-show-on-new-file/test.sh b/tests/cli-tests/010-fi-show-on-new-file/test.sh
new file mode 100755
index 000000000000..668f0f9b2cfe
--- /dev/null
+++ b/tests/cli-tests/010-fi-show-on-new-file/test.sh
@@ -0,0 +1,16 @@
+#!/bin/bash
+# test for 'filesystem show' on fresh local file
+
+source "$TEST_TOP/common"
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+IMAGE=$(mktemp -u btrfs-XXXXXX.img)
+
+truncate -s3g "$IMAGE"
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$IMAGE"
+run_check $SUDO_HELPER "$TOP/btrfs" filesystem show "$IMAGE"
+
+rm -f "$IMAGE"
+
-- 
2.7.4

