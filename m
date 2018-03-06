Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:32832 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbeCFIgn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 03:36:43 -0500
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 019BFAC0059
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:36:38 +0900 (JST)
Received: from g01jpexchkw36.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 3453DBD66FF
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:36:37 +0900 (JST)
Subject: [RFC PATCH 6/7] btrfs-progs: test: Add helper function to check if
 test user exists
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
Message-ID: <91cc562a-e44d-0aee-0336-edae0fc7c92b@jp.fujitsu.com>
Date: Tue, 6 Mar 2018 17:36:33 +0900
MIME-Version: 1.0
In-Reply-To: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
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

