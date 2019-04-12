Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8F4C10F14
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 09:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 666B120850
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 09:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfDLJFk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 05:05:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:43094 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726678AbfDLJFk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 05:05:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 77E55AE62
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 09:05:38 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: misc-tests: Test if dump-tree can handle obviously flipped bit in btrfs item
Date:   Fri, 12 Apr 2019 17:05:30 +0800
Message-Id: <20190412090530.29132-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190412090530.29132-1-wqu@suse.com>
References: <20190412090530.29132-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The crafted image has one bit flipped for one item offset and one item
size.

The test will check if dump-tree can handle it by:
- Detect the bit flip
- Output the correct content for the remaining items

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../misc-tests/036-dump-tree-bit-flip/test.sh |  21 ++++++++++++++++++
 .../two_corrupted_items.raw.xz                | Bin 0 -> 22024 bytes
 2 files changed, 21 insertions(+)
 create mode 100755 tests/misc-tests/036-dump-tree-bit-flip/test.sh
 create mode 100644 tests/misc-tests/036-dump-tree-bit-flip/two_corrupted_items.raw.xz

diff --git a/tests/misc-tests/036-dump-tree-bit-flip/test.sh b/tests/misc-tests/036-dump-tree-bit-flip/test.sh
new file mode 100755
index 000000000000..f3f65c435e58
--- /dev/null
+++ b/tests/misc-tests/036-dump-tree-bit-flip/test.sh
@@ -0,0 +1,21 @@
+#!/bin/bash
+# Test if btrfs ins dump-tree can handle certain bit flip case and output
+# enough info for both the good and bad items
+
+source "$TEST_TOP/common"
+
+check_prereq btrfs
+
+tmp_output=$(mktemp --tmpdir btrfs-progs-test-dump-tree-output.XXXXXX)
+
+check_image() {
+	run_check_stdout "$TOP/btrfs" ins dump-tree -t 5 "$1" \
+		2>&1 > "$tmp_output"
+	if [ $(grep '\!\!\!' "$tmp_output" | wc -l ) -ne 2 ]; then
+		rm "$tmp_output" -rf
+		_fail "bit flipped item not detected"
+	fi
+	rm "$tmp_output" -rf
+}
+
+check_all_images
diff --git a/tests/misc-tests/036-dump-tree-bit-flip/two_corrupted_items.raw.xz b/tests/misc-tests/036-dump-tree-bit-flip/two_corrupted_items.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..6487657f81f3c3d4dca002372011f1cc1cc26f57
GIT binary patch
literal 22024
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
H*xce@+_+3p

literal 0
HcmV?d00001

-- 
2.21.0

