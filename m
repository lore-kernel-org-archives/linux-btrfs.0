Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59299 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751225AbdBFFsF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 00:48:05 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <calestyo@scientia.net>, <chris@colorremedies.com>, <dsterba@suse.cz>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH v2 11/12] btrfs-progs: fsck: Fix lowmem mode override to allow it skip repair work
Date: Mon, 6 Feb 2017 13:47:34 +0800
Message-ID: <20170206054735.5227-12-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
References: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Current common.local doesn't handle lowmem mode well.
It passes "--mode=lowmem" alone with "--repair", making it unable to
check lowmem mode.

It's caused by the following bugs:

1) Wrong variable in test/common.local
   We should check TEST_ARGS_CHECK, not TEST_CHECK, which is not defined
   so we never return 1.

2) Wrong parameter passed to _cmd_spec() in test/common
   This prevents us from grepping the correct parameters.

Fix it.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 tests/common       | 8 ++++----
 tests/common.local | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/common b/tests/common
index 51c2e267..7ad436e3 100644
--- a/tests/common
+++ b/tests/common
@@ -106,7 +106,7 @@ run_check()
 	ins=$(_get_spec_ins "$@")
 	spec=$(($ins-1))
 	cmd=$(eval echo "\${$spec}")
-	spec=$(_cmd_spec "$cmd")
+	spec=$(_cmd_spec "${@:$spec}")
 	set -- "${@:1:$(($ins-1))}" $spec "${@: $ins}"
 	echo "############### $@" >> "$RESULTS" 2>&1
 	if [[ $TEST_LOG =~ tty ]]; then echo "CMD: $@" > /dev/tty; fi
@@ -128,7 +128,7 @@ run_check_stdout()
 	ins=$(_get_spec_ins "$@")
 	spec=$(($ins-1))
 	cmd=$(eval echo "\${$spec}")
-	spec=$(_cmd_spec "$cmd")
+	spec=$(_cmd_spec "${@:$spec}")
 	set -- "${@:1:$(($ins-1))}" $spec "${@: $ins}"
 	echo "############### $@" >> "$RESULTS" 2>&1
 	if [[ $TEST_LOG =~ tty ]]; then echo "CMD(stdout): $@" > /dev/tty; fi
@@ -152,7 +152,7 @@ run_mayfail()
 	ins=$(_get_spec_ins "$@")
 	spec=$(($ins-1))
 	cmd=$(eval echo "\${$spec}")
-	spec=$(_cmd_spec "$cmd")
+	spec=$(_cmd_spec "${@:$spec}")
 	set -- "${@:1:$(($ins-1))}" $spec "${@: $ins}"
 	echo "############### $@" >> "$RESULTS" 2>&1
 	if [[ $TEST_LOG =~ tty ]]; then echo "CMD(mayfail): $@" > /dev/tty; fi
@@ -188,7 +188,7 @@ run_mustfail()
 	ins=$(_get_spec_ins "$@")
 	spec=$(($ins-1))
 	cmd=$(eval echo "\${$spec}")
-	spec=$(_cmd_spec "$cmd")
+	spec=$(_cmd_spec "${@:$spec}")
 	set -- "${@:1:$(($ins-1))}" $spec "${@: $ins}"
 	echo "############### $@" >> "$RESULTS" 2>&1
 	if [[ $TEST_LOG =~ tty ]]; then echo "CMD(mustfail): $@" > /dev/tty; fi
diff --git a/tests/common.local b/tests/common.local
index 9f567c27..4f56bb08 100644
--- a/tests/common.local
+++ b/tests/common.local
@@ -17,7 +17,7 @@ TEST_ARGS_CHECK=--mode=lowmem
 # break tests
 _skip_spec()
 {
-	if echo "$TEST_CHECK" | grep -q 'mode=lowmem' &&
+	if echo "$TEST_ARGS_CHECK" | grep -q 'mode=lowmem' &&
 	   echo "$@" | grep -q -- '--repair'; then
 		return 0
 	fi
-- 
2.11.0



