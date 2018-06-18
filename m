Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:28213 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968215AbeFRIiT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:19 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id DBA4EAC014C
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:11 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 18FB7BD6705
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:11 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 18/20] btrfs-progs: test: Add helper function to check if test user exists
Date: Mon, 18 Jun 2018 17:41:06 +0900
Message-ID: <339c1796299757d1feee11bb5d8faf3a2e93988b.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test user 'progs-test' will be used to test the behavior of normal user.

In order to pass this check, add the user by "useradd -M progs-test".
Note that progs-test should not have root privileges.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 tests/common | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tests/common b/tests/common
index 7e4e09df..7a37a4cd 100644
--- a/tests/common
+++ b/tests/common
@@ -314,6 +314,16 @@ check_global_prereq()
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
2.14.4


