Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46087 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752326AbeENGyw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 02:54:52 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0F50FAD69
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 06:54:51 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: fsck-tests: Add test case for detecting compressed extent without csum
Date: Mon, 14 May 2018 14:54:44 +0800
Message-Id: <20180514065444.26313-4-wqu@suse.com>
In-Reply-To: <20180514065444.26313-1-wqu@suse.com>
References: <20180514065444.26313-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../compressed_extent_without_csum.raw.xz     | Bin 0 -> 21996 bytes
 .../032-compressed-nodatasum/test.sh          |  24 ++++++++++++++++++
 2 files changed, 24 insertions(+)
 create mode 100644 tests/fsck-tests/032-compressed-nodatasum/compressed_extent_without_csum.raw.xz
 create mode 100755 tests/fsck-tests/032-compressed-nodatasum/test.sh

diff --git a/tests/fsck-tests/032-compressed-nodatasum/compressed_extent_without_csum.raw.xz b/tests/fsck-tests/032-compressed-nodatasum/compressed_extent_without_csum.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..72a3bfd8f8b0bf2d610ce84af0abf4003204a9a1
GIT binary patch
literal 21996
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
Vt|BkKz?s>UWy${d3?fHb{2eaBAT9s^

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/032-compressed-nodatasum/test.sh b/tests/fsck-tests/032-compressed-nodatasum/test.sh
new file mode 100755
index 000000000000..ebec74dffdbd
--- /dev/null
+++ b/tests/fsck-tests/032-compressed-nodatasum/test.sh
@@ -0,0 +1,24 @@
+#!/bin/bash
+#
+# Verify that btrfs check can detect compressed extent without csum as an error
+#
+# There is report about nodatasum inode which has compressed extent, and when
+# its compressed data is corrupted, decompress screw up the whole kernel.
+#
+# While btrfs(5) shows that nodatasum will disable data CoW and compression,
+# kernel obviously doesn't follow it well. And in above case, lzo problem
+# can leads to more serious kernel memory corruption since btrfs completely
+# depends its csum to prevent corruption.
+#
+# So btrfs check should report such compressed extent without csum as error.
+
+source "$TEST_TOP/common"
+
+check_prereq btrfs
+
+check_image() {
+	run_mustfail "btrfs fails to detect compressed extent with csum as an error" \
+		"$TOP/btrfs" check "$1"
+}
+
+check_all_images
-- 
2.17.0

