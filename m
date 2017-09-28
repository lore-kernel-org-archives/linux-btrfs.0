Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:41402 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751883AbdI1H0Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 03:26:24 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: tests: arg override in command line
Date: Thu, 28 Sep 2017 15:29:19 +0800
Message-ID: <20170928072919.13610-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lowmem mode only repairs few cases which has a beacon file
".lowmem_repairable" in the case' directory.

However, defining TEST_ENABLE_OVERRIDE=true in command line does work
in above strategy.
Because _skip_spec() in tests/common.local isn't interpreted by shell
in that case.

Solve it by making _skip_spec() always be defined in common.local.

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 tests/common       |  8 ++------
 tests/common.local | 11 +++++------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/tests/common b/tests/common
index eb525a4d..690fee93 100644
--- a/tests/common
+++ b/tests/common
@@ -97,12 +97,8 @@ _get_spec_ins()
 _cmd_spec()
 {
 	if [ "$TEST_ENABLE_OVERRIDE" = 'true' ]; then
-		# if defined via common.local, use it, otherwise pass make
-		# arguments
-		if [ "$(type -t _skip_spec)" = 'function' ]; then
-			if _skip_spec "$@"; then
-				return
-			fi
+		if _skip_spec "$@"; then
+			return
 		fi
 		case "$1" in
 	  		check) echo -n "$TEST_ARGS_CHECK" ;;
diff --git a/tests/common.local b/tests/common.local
index 4864e391..f5e96f5b 100644
--- a/tests/common.local
+++ b/tests/common.local
@@ -3,14 +3,13 @@
 # additional arguments to various commands
 
 # already defined, eg. via make argument
-if [ -n "$TEST_ENABLE_OVERRIDE" ]; then
-	return
-fi
+if [ -z "$TEST_ENABLE_OVERRIDE" ]; then
+    # set to 'true'
+    TEST_ENABLE_OVERRIDE=false
 
-# set to 'true'
-TEST_ENABLE_OVERRIDE=false
+    TEST_ARGS_CHECK=--mode=lowmem
+fi
 
-TEST_ARGS_CHECK=--mode=lowmem
 
 # gets arguments of a current command and can decide if the argument insertion
 # should happen, eg. if some option combination does not make sense or would
-- 
2.14.1



