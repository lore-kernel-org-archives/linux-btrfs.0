Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28622 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751780AbaLYBeQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 20:34:16 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBP1XkkR020164
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 09:33:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] btrfs-progs: Move bad root items test cases to its corresponding dir
Date: Thu, 25 Dec 2014 09:32:13 +0800
Message-ID: <1419471135-10878-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now 006-bad-root-items has two cases, one for default case, and one for
skinny metadata case.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .../default_case.tar.xz}                                 | Bin
 .../skinny_case.tar.xz}                                  | Bin
 tests/fsck-tests/006-bad-root-items/test.sh              |  15 +++++++++++++++
 3 files changed, 15 insertions(+)
 rename tests/fsck-tests/{006-bad_root_items_fs.tar.xz => 006-bad-root-items/default_case.tar.xz} (100%)
 rename tests/fsck-tests/{007-bad_root_items_fs_skinny.tar.xz => 006-bad-root-items/skinny_case.tar.xz} (100%)
 create mode 100755 tests/fsck-tests/006-bad-root-items/test.sh

diff --git a/tests/fsck-tests/006-bad_root_items_fs.tar.xz b/tests/fsck-tests/006-bad-root-items/default_case.tar.xz
similarity index 100%
rename from tests/fsck-tests/006-bad_root_items_fs.tar.xz
rename to tests/fsck-tests/006-bad-root-items/default_case.tar.xz
diff --git a/tests/fsck-tests/007-bad_root_items_fs_skinny.tar.xz b/tests/fsck-tests/006-bad-root-items/skinny_case.tar.xz
similarity index 100%
rename from tests/fsck-tests/007-bad_root_items_fs_skinny.tar.xz
rename to tests/fsck-tests/006-bad-root-items/skinny_case.tar.xz
diff --git a/tests/fsck-tests/006-bad-root-items/test.sh b/tests/fsck-tests/006-bad-root-items/test.sh
new file mode 100755
index 0000000..2c0e1c6
--- /dev/null
+++ b/tests/fsck-tests/006-bad-root-items/test.sh
@@ -0,0 +1,15 @@
+#!/bin/bash
+
+source $top/tests/common
+
+echo "extracting image default_case.tar.xz" >> $RESULT
+tar xJf default_case.tar.xz || \
+	_fail "failed to extract default_case.tar.xz"
+check_image test.img
+
+echo "extracting image skinny_case.tar.xz" >> $RESULT
+tar xJf skinny_case.tar.xz || \
+	_fail "failed to extract skinny_case.tar.xz"
+check_image test.img
+
+rm test.img
-- 
2.2.1

