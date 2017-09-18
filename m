Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64231 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751861AbdIRHWE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:22:04 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 12/14] btrfs-progs: tests/common: Detect ungraceful failure case
Date: Mon, 18 Sep 2017 16:21:37 +0900
Message-Id: <20170918072139.6300-13-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

run_mustfail() checks the return value but doesn't check if the failure
is graceful.

Add such ungraceful failure check, for incoming "mkfs.btrfs --rootdir"
test cases, as old "--rootdir" never fail gracefully.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 tests/common | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tests/common b/tests/common
index 242ded1d..b49d9ff3 100644
--- a/tests/common
+++ b/tests/common
@@ -227,6 +227,11 @@ run_mustfail()
 		$INSTRUMENT "$@" >> "$RESULTS" 2>&1
 	fi
 	if [ $? != 0 ]; then
+		if [ $? -gt 128 ]; then
+			"failed (ungracefully): $@" >> "$RESULTS"
+			_fail "unexpected ungraceful failure: $msg"
+			return 1
+		fi
 		echo "failed (expected): $@" >> "$RESULTS"
 		return 0
 	else
-- 
2.14.1

