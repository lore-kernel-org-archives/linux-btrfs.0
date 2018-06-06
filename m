Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60375 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932290AbeFFH12 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 03:27:28 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D7287AD8D
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Jun 2018 07:27:26 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs-progs: fsck-tests: Add test case for corrupted inline ram_bytes
Date: Wed,  6 Jun 2018 15:27:17 +0800
Message-Id: <20180606072717.28854-7-wqu@suse.com>
In-Reply-To: <20180606072717.28854-1-wqu@suse.com>
References: <20180606072717.28854-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../035-inline-bad-ram-bytes/offset_by_one.img   | Bin 0 -> 3072 bytes
 .../fsck-tests/035-inline-bad-ram-bytes/test.sh  |  11 +++++++++++
 2 files changed, 11 insertions(+)
 create mode 100644 tests/fsck-tests/035-inline-bad-ram-bytes/offset_by_one.img
 create mode 100755 tests/fsck-tests/035-inline-bad-ram-bytes/test.sh

diff --git a/tests/fsck-tests/035-inline-bad-ram-bytes/offset_by_one.img b/tests/fsck-tests/035-inline-bad-ram-bytes/offset_by_one.img
new file mode 100644
index 0000000000000000000000000000000000000000..2f58208eed71d5e0ee053d825d2780fe6842a3db
GIT binary patch
literal 3072
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

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/035-inline-bad-ram-bytes/test.sh b/tests/fsck-tests/035-inline-bad-ram-bytes/test.sh
new file mode 100755
index 000000000000..6f6e2a5ee850
--- /dev/null
+++ b/tests/fsck-tests/035-inline-bad-ram-bytes/test.sh
@@ -0,0 +1,11 @@
+#!/bin/bash
+# Around 2014, btrfs kernel has a regression that create inline extent
+# with ram_bytes offset by one.
+# This old regression could be caught by tree-check code.
+# This test case will check if btrfs check could detect and repair it.
+
+source "$TEST_TOP/common"
+
+check_prereq btrfs
+
+check_all_images
-- 
2.17.1

