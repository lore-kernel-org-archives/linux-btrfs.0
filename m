Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12465 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751544AbeBHGfG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Feb 2018 01:35:06 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v5 3/3] btrfs-progs: Add readme for export testsuits
Date: Thu, 8 Feb 2018 14:34:20 +0800
Message-ID: <1518071660-16878-4-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1518071660-16878-1-git-send-email-gujx@cn.fujitsu.com>
References: <1518071660-16878-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the readme of command for export testsuits.
And add the excute method of exported testsuits.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 tests/README.md | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tests/README.md b/tests/README.md
index 04d2ce2a..23f35cfc 100644
--- a/tests/README.md
+++ b/tests/README.md
@@ -48,6 +48,19 @@ $ TEST=001\* ./fsck-tests.sh
 will run the first test in fsck-tests subdirectory.
 
 
+## Package testsuit
+
+The tests can be export as a btrfs-progs-tests.tar.gz current path. Use:
+
+```shell
+$ make testsuite
+```
+
+
+And, after decompress btrfs-progs-tests.tar.gz, test can be run selectively
+from `tests/` directory introduced above.
+
+
 ## Test structure
 
 *tests/fsck-tests/:*
-- 
2.14.3



