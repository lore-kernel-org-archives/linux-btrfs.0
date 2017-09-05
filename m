Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:15551 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdIEFtR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 01:49:17 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 0F41EAC00C9
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Sep 2017 14:49:09 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 61D4D46E77D
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Sep 2017 14:49:08 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: test: fix run_check_stdout() call _fail()
Message-ID: <64ab304a-6b5f-d2ac-3b74-90952371404e@jp.fujitsu.com>
Date: Tue, 5 Sep 2017 14:49:02 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

run_check_stdout() uses "... | tee ... || _fail".  However, since tee
won't fail, _fail() is not called even if first command fails. 

Fix this by checking PIPESTATUS in the end.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 tests/common | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/common b/tests/common
index d0324a6..b7d3436 100644
--- a/tests/common
+++ b/tests/common
@@ -154,9 +154,12 @@ run_check_stdout()
 	echo "############### $@" >> "$RESULTS" 2>&1
 	if [[ $TEST_LOG =~ tty ]]; then echo "CMD(stdout): $@" > /dev/tty; fi
 	if [ "$1" = 'root_helper' ]; then
-		"$@" 2>&1 | tee -a "$RESULTS" || _fail "failed: $@"
+		"$@" 2>&1 | tee -a "$RESULTS"
 	else
-		$INSTRUMENT "$@" 2>&1 | tee -a "$RESULTS" || _fail "failed: $@"
+		$INSTRUMENT "$@" 2>&1 | tee -a "$RESULTS"
+	fi
+	if [ ${PIPESTATUS[0]} -ne 0 ]; then
+		_fail "failed: $@"
 	fi
 }
 
-- 
2.9.5

