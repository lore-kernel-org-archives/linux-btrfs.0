Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:62359 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755218AbeCSHda (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 03:33:30 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 3E02DAC005E
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:33:24 +0900 (JST)
Received: from g01jpexchkw34.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 60082BD645A
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:33:23 +0900 (JST)
Subject: [RFC PATCH v3 6/7] btrfs-progs: test: Add helper function to check if
 test user exists
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
Message-ID: <26c17139-7e93-2484-d437-34f5db596ff3@jp.fujitsu.com>
Date: Mon, 19 Mar 2018 16:33:20 +0900
MIME-Version: 1.0
In-Reply-To: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test user 'progs-test' will be used to test the behavior of normal user.

In order to pass this check, add the user by "useradd -M progs-test".
Note that progs-test should not have root privileges.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 tests/common | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tests/common b/tests/common
index fae30f1d..e8f7c061 100644
--- a/tests/common
+++ b/tests/common
@@ -307,6 +307,16 @@ check_global_prereq()
 	fi
 }
 
+check_testuser()
+{
+	id -u progs-test > /dev/null 2>&1
+	if [ $? -ne 0 ]; then
+		_not_run "Need to add user \"progs-test\""
+	fi
+	# Note that progs-test should not have root privileges
+	# otherwise test may not run as expected
+}
+
 check_image()
 {
 	local image
-- 
2.14.3

