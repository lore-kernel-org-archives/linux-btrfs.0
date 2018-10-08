Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E97C00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 10:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB9A320841
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 10:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB9A320841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbeJHR4A (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 13:56:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:40936 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726330AbeJHRz7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 13:55:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 81181AEEF
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2018 10:44:52 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/5] btrfs-progs: fsck-tests: Add test image for dev extents beyond device boundary
Date:   Mon,  8 Oct 2018 18:44:36 +0800
Message-Id: <20181008104436.19267-6-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181008104436.19267-1-wqu@suse.com>
References: <20181008104436.19267-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now two locations can detect such problem, either by device item
used/total bytes check, or by early dev extents check against device
boundary.

The image is hand-crafted image which uses DATA SINGLE chunk to feed
btrfs check.
As expected, as long as block group item, chunk item, device used bytes
matches, older btrfs check can't detect such problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../over_dev_boundary.img.xz                  | Bin 0 -> 1640 bytes
 tests/fsck-tests/036-bad-dev-extents/test.sh  |  20 ++++++++++++++++++
 2 files changed, 20 insertions(+)
 create mode 100644 tests/fsck-tests/036-bad-dev-extents/over_dev_boundary.img.xz
 create mode 100755 tests/fsck-tests/036-bad-dev-extents/test.sh

diff --git a/tests/fsck-tests/036-bad-dev-extents/over_dev_boundary.img.xz b/tests/fsck-tests/036-bad-dev-extents/over_dev_boundary.img.xz
new file mode 100644
index 0000000000000000000000000000000000000000..47cb2a707b0097e369dc088ed0549f847995f136
GIT binary patch
literal 1640
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

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/036-bad-dev-extents/test.sh b/tests/fsck-tests/036-bad-dev-extents/test.sh
new file mode 100755
index 000000000000..fe2d05673bbe
--- /dev/null
+++ b/tests/fsck-tests/036-bad-dev-extents/test.sh
@@ -0,0 +1,20 @@
+#!/bin/bash
+#
+# Due to DUP chunk allocator bugs, we could allocate DUP chunks while its dev
+# extents could exist beyond device boundary.
+# And since all related items (block group, chunk, device used bytes) are all
+# valid, btrfs check won't report any error.
+#
+# This test case contain hand crafted minimal image, to test if btrfs check can
+# detect and report such error.
+
+source "$TEST_TOP/common"
+
+check_prereq btrfs
+
+check_image() {
+	run_mustfail "btrfs check failed to detect invalid dev extents" \
+		"$TOP/btrfs" check "$1"
+}
+
+check_all_images
-- 
2.19.1

