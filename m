Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9415DC46475
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 07:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 648622054F
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 07:45:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 648622054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbeJYQQf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 12:16:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:58232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726465AbeJYQQf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 12:16:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3395AAE02
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 07:45:01 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs-progs: fsck-tests: Make 026-bad-dir-item-name test case to verify if btrfs-check can also repair it
Date:   Thu, 25 Oct 2018 15:44:49 +0800
Message-Id: <20181025074449.32469-5-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181025074449.32469-1-wqu@suse.com>
References: <20181025074449.32469-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just remove the customized 'test.sh', then generic fsck test will do the
check-repair-check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../026-bad-dir-item-name/description.txt     | 41 +++++++++++++++++++
 .../fsck-tests/026-bad-dir-item-name/test.sh  | 13 ------
 2 files changed, 41 insertions(+), 13 deletions(-)
 create mode 100644 tests/fsck-tests/026-bad-dir-item-name/description.txt
 delete mode 100755 tests/fsck-tests/026-bad-dir-item-name/test.sh

diff --git a/tests/fsck-tests/026-bad-dir-item-name/description.txt b/tests/fsck-tests/026-bad-dir-item-name/description.txt
new file mode 100644
index 000000000000..2bdb0f8179b0
--- /dev/null
+++ b/tests/fsck-tests/026-bad-dir-item-name/description.txt
@@ -0,0 +1,41 @@
+"default_case.img.xz" contains the fs with the following tree dump of fs tree:
+
+  [snip]
+	item 2 key (256 DIR_ITEM 751495445) itemoff 16019 itemsize 92
+		location key (259 INODE_ITEM 0) type FILE
+		transid 9 data_len 0 name_len 13
+		name: foor.WvG1c1Td
+		      ^^^^^^^^^^^^^ Hash doesn't match with key
+		location key (260 INODE_ITEM 0) type FILE
+		transid 12 data_len 0 name_len 19
+		name: user.J3__T_Km3dVsW_
+	item 3 key (256 DIR_INDEX 4) itemoff 15976 itemsize 43
+		location key (259 INODE_ITEM 0) type FILE
+		transid 9 data_len 0 name_len 13
+		name: foor.WvG1c1Td
+	item 4 key (256 DIR_INDEX 5) itemoff 15927 itemsize 49
+		location key (260 INODE_ITEM 0) type FILE
+		transid 12 data_len 0 name_len 19
+		name: user.J3__T_Km3dVsW_
+	item 5 key (259 INODE_ITEM 0) itemoff 15767 itemsize 160
+		generation 9 transid 9 size 0 nbytes 0
+		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
+		sequence 1 flags 0x0(none)
+		atime 1499844359.341125147 (2017-07-12 15:25:59)
+		ctime 1499844359.341125147 (2017-07-12 15:25:59)
+		mtime 1499844359.341125147 (2017-07-12 15:25:59)
+		otime 1499844359.341125147 (2017-07-12 15:25:59)
+	item 6 key (259 INODE_REF 256) itemoff 15744 itemsize 23
+		index 4 namelen 13 name: foor.WvG1c1Td
+	item 7 key (260 INODE_ITEM 0) itemoff 15584 itemsize 160
+		generation 12 transid 12 size 0 nbytes 0
+		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
+		sequence 1 flags 0x0(none)
+		atime 1499844544.931130070 (2017-07-12 15:29:04)
+		ctime 1499844544.931130070 (2017-07-12 15:29:04)
+		mtime 1499844544.931130070 (2017-07-12 15:29:04)
+		otime 1499844544.931130070 (2017-07-12 15:29:04)
+	item 8 key (260 INODE_REF 256) itemoff 15555 itemsize 29
+		index 5 namelen 19 name: user.J3__T_Km3dVsW_
+
+Test case is going to check if btrfs check can detect and repair it.
diff --git a/tests/fsck-tests/026-bad-dir-item-name/test.sh b/tests/fsck-tests/026-bad-dir-item-name/test.sh
deleted file mode 100755
index a38bf045ae82..000000000000
--- a/tests/fsck-tests/026-bad-dir-item-name/test.sh
+++ /dev/null
@@ -1,13 +0,0 @@
-#!/bin/bash
-#
-# confirm whether check detects name and hash mismatch in dir_item
-
-source "$TEST_TOP/common"
-
-check_prereq btrfs
-
-image=$(extract_image "./default_case.img.xz")
-
-run_mustfail "dir_item hash mismatch not found" "$TOP/btrfs" check "$image"
-
-rm -f "$image"
-- 
2.19.1

