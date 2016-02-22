Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63508 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbcBVHCO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 02:02:14 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 5/5] btrfs-progs: misc-test: Add regression test for find-root gives empty result
Date: Mon, 22 Feb 2016 14:59:57 +0800
Message-Id: <1456124397-21403-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add regression test for btrfs-find-root gives empty result even the fs
is OK.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .../first_meta_chunk.btrfs-image                    | Bin 0 -> 4096 bytes
 tests/misc-tests/012-find-root-no-result/test.sh    |  20 ++++++++++++++++++++
 2 files changed, 20 insertions(+)
 create mode 100644 tests/misc-tests/012-find-root-no-result/first_meta_chunk.btrfs-image
 create mode 100644 tests/misc-tests/012-find-root-no-result/test.sh

diff --git a/tests/misc-tests/012-find-root-no-result/first_meta_chunk.btrfs-image b/tests/misc-tests/012-find-root-no-result/first_meta_chunk.btrfs-image
new file mode 100644
index 0000000000000000000000000000000000000000..7bf6c50916f68ed00dae7627e848a91abf5455bb
GIT binary patch
literal 4096
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
Mne-=t|1Sdn0?V+~RR910

literal 0
HcmV?d00001

diff --git a/tests/misc-tests/012-find-root-no-result/test.sh b/tests/misc-tests/012-find-root-no-result/test.sh
new file mode 100644
index 0000000..4951633
--- /dev/null
+++ b/tests/misc-tests/012-find-root-no-result/test.sh
@@ -0,0 +1,20 @@
+#!/bin/bash
+# Regression test for case btrfs-find-root may print no result on a
+# recent fs or balanced fs, whose metadata chunk is the first chunk
+# and the only metadata chunk
+
+source $TOP/tests/common
+
+check_prereq btrfs-find-root
+check_prereq btrfs-image
+
+$TOP/btrfs-image -r first_meta_chunk.btrfs-image test.img || \
+	_fail "failed to extract first_meta_chunk.btrfs-image"
+
+result=$($TOP/btrfs-find-root test.img | sed '/^Superblock/d')
+
+if [ -z "$result" ]; then
+	_fail "btrfs-find-root failed to find tree root"
+fi
+
+rm test.img
-- 
2.7.1



