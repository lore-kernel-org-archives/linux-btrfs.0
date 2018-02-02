Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:5318 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751469AbeBBIeW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 03:34:22 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <quwenruo.btrfs@gmx.com>
Subject: [RFC PATCH v2 4/4] btrfs-progs: Add readme for export testsuits
Date: Fri, 2 Feb 2018 16:34:05 +0800
Message-ID: <1517560445-5712-5-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
References: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the readme of command for export testsuits.
And add the excute method of exported testsuits.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 tests/README.md | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tests/README.md b/tests/README.md
index 04d2ce2a..9f4c01ac 100644
--- a/tests/README.md
+++ b/tests/README.md
@@ -48,6 +48,26 @@ $ TEST=001\* ./fsck-tests.sh
 will run the first test in fsck-tests subdirectory.
 
 
+## Package testsuit
+
+The tests can be export as a tests.tar.gz into path given. Use:
+
+```shell
+$ make EXPORT=PATH package
+```
+
+where `PATH` is a directory where tests.tar.gz be genereated.
+Here comes handy:
+
+```shell
+$ make EXPORT=/home/user/ package
+$ make EXPORT=../../dir/ package
+```
+
+And, after decompress tests.tar.gz, test can be run selectively
+from `tests/` directory introduced above.
+
+
 ## Test structure
 
 *tests/fsck-tests/:*
-- 
2.14.3



